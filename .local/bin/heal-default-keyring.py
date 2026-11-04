#!/usr/bin/env python3
# Undoes the gnome-keyring "orphaned default keyring" failure whenever it
# happens, whatever caused it: points the "default" alias back at the real
# Default_Keyring collection, moves anything apps saved into a stray
# "Default keyring"/"Login" collection over to the real one, and deletes the
# stray. Run after every daemon start (via unlock-default-keyring.sh) and on
# every change in ~/.local/share/keyrings (heal-default-keyring.path).
# Never prints secret values. See SETUP.md step 13.
import glob
import os
import shutil
import subprocess
import sys
import time

import gi
gi.require_version('Secret', '1')
from gi.repository import Gio, GLib, Secret

REAL = '/org/freedesktop/secrets/collection/Default_5fKeyring'
STRAY_LABELS = {'default keyring', 'default', 'login'}
KEYRING_DIR = os.path.expanduser('~/.local/share/keyrings')
BACKUP_DIR = os.path.expanduser('~/.local/state/keyring-repair')
# Encryption keys (browser "Safe Storage", portal app keys): an app that got a
# stray keyring generated a *new* random key there. The real one must win or
# the app's existing encrypted data becomes unreadable.
KEY_SCHEMAS = {'chrome_libsecret_os_crypt_password_v2', 'org.freedesktop.portal.Secret'}


def log(msg):
    print(f'heal-default-keyring: {msg}', file=sys.stderr)


def notify(msg):
    try:
        subprocess.run(['notify-send', '-a', 'Keyring', 'Keyring check', msg],
                       timeout=5, check=False, capture_output=True)
    except Exception:
        pass


def is_key(item):
    attrs = item.get_attributes()
    return attrs.get('xdg:schema') in KEY_SCHEMAS or 'Safe Storage' in item.get_label()


def secrets_call(bus, method, args, iface='org.freedesktop.Secret.Service'):
    return bus.call_sync('org.freedesktop.secrets', '/org/freedesktop/secrets', iface, method,
                         args, None, Gio.DBusCallFlags.NO_AUTO_START, -1, None).unpack()


def collection_paths(bus):
    return secrets_call(bus, 'Get', GLib.Variant('(ss)', (
        'org.freedesktop.Secret.Service', 'Collections')),
        iface='org.freedesktop.DBus.Properties')[0]


def fix_alias(bus, actions):
    # Raw D-Bus: libsecret's alias helpers either fail on a dangling alias or
    # are broken in the Python bindings.
    if REAL not in collection_paths(bus):
        return
    if secrets_call(bus, 'ReadAlias', GLib.Variant('(s)', ('default',)))[0] != REAL:
        secrets_call(bus, 'SetAlias', GLib.Variant('(so)', ('default', REAL)))
        if 'reset the default alias' not in actions:
            actions.insert(0, 'reset the default alias')


def main():
    bus = Gio.bus_get_sync(Gio.BusType.SESSION, None)
    owner = bus.call_sync('org.freedesktop.DBus', '/org/freedesktop/DBus',
                          'org.freedesktop.DBus', 'NameHasOwner',
                          GLib.Variant('(s)', ('org.freedesktop.secrets',)),
                          None, Gio.DBusCallFlags.NONE, -1, None)
    if not owner.unpack()[0]:
        return  # daemon not running; nothing to heal, and don't start one

    actions = []
    # A dangling alias (pointing at a deleted collection) makes LOAD_COLLECTIONS
    # fail outright, so fix the alias by raw path before loading anything.
    fix_alias(bus, actions)
    # Load collections one by one: after a delete the daemon can keep listing
    # dead paths, which makes libsecret's bulk LOAD_COLLECTIONS fail.
    svc = Secret.Service.get_sync(Secret.ServiceFlags.OPEN_SESSION, None)
    cols = {}
    for path in collection_paths(bus):
        try:
            # secret_collection_new_for_dbus_path_sync() isn't in the bindings.
            col = Secret.Collection(
                g_connection=svc.get_connection(), g_name='org.freedesktop.secrets',
                g_object_path=path, g_interface_name='org.freedesktop.Secret.Collection',
                g_flags=Gio.DBusProxyFlags.NONE, service=svc)
            col.init(None)
            cols[path] = col
        except GLib.Error:
            pass
    real = cols.get(REAL)
    if real is None:
        log('real Default_Keyring collection is not loaded; leaving everything alone')
        return
    if real.get_locked():
        svc.unlock_sync([real], None)

    try:
        merge_strays(svc, real, cols, actions)
    finally:
        fix_alias(bus, actions)  # again, in case it changed meanwhile
        if actions:
            log('; '.join(actions))
            notify('Keyring: ' + '; '.join(actions) +
                   '. Restart any app that just showed a keyring error.')


def merge_strays(svc, real, cols, actions):
    strays = [c for p, c in cols.items()
              if p != REAL and c.get_label().strip().lower() in STRAY_LABELS]
    if not strays:
        return

    # Back up stray keyring files before touching anything.
    os.makedirs(BACKUP_DIR, mode=0o700, exist_ok=True)
    stamp = time.strftime('%Y%m%d-%H%M%S')
    for f in glob.glob(os.path.join(KEYRING_DIR, '*.keyring')):
        if os.path.basename(f) != 'Default_Keyring.keyring':
            dst = os.path.join(BACKUP_DIR, f'{os.path.basename(f)}.{stamp}.stray')
            shutil.copy2(f, dst)
            os.chmod(dst, 0o600)

    real.load_items_sync(None)
    real_items = {frozenset(i.get_attributes().items()): i for i in real.get_items()}
    moved = kept = 0
    for stray in strays:
        stray.load_items_sync(None)
        if stray.get_locked():
            svc.unlock_sync([stray], None)
        for item in stray.get_items():
            attrs = item.get_attributes()
            match = real_items.get(frozenset(attrs.items()))
            if match is not None and (is_key(item) or match.get_modified() >= item.get_modified()):
                kept += 1  # real copy wins
                continue
            item.load_secret_sync(None)
            value = item.get_secret()
            if value is None:
                log(f'could not read stray item {item.get_label()!r}; leaving stray in place')
                return
            if match is not None:
                match.set_secret_sync(value, None)
            else:
                Secret.Item.create_sync(real, None, attrs, item.get_label(), value,
                                        Secret.ItemCreateFlags.NONE, None)
            moved += 1
        stray.delete_sync(None)
    actions.append(f'removed a stray "Default keyring" ({moved} item(s) moved to the real one, '
                   f'{kept} duplicate(s) dropped; backup in ~/.local/state/keyring-repair)')

if __name__ == '__main__':
    try:
        main()
    except Exception as e:
        log(f'unexpected error: {e!r}')
