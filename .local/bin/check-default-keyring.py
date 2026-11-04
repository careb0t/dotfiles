#!/usr/bin/env python3
# Runs before every gnome-keyring-daemon start (ExecStartPre drop-in).
# gnome-keyring's plaintext (blank-password) writer sometimes saves secrets
# containing PEM blocks with raw newlines instead of escaped "\n", which makes
# the file unparseable. The daemon then silently creates an empty replacement
# keyring and steals the "default" alias. This catches that before the daemon
# loads the file: validate with GLib's own parser, repair if broken.
# Never prints secret values. Always exits 0 so the daemon still starts.
import os
import re
import shutil
import subprocess
import sys
import time

import gi
gi.require_version('GLib', '2.0')
from gi.repository import GLib

PATH = os.path.expanduser(
    sys.argv[1] if len(sys.argv) > 1 else '~/.local/share/keyrings/Default_Keyring.keyring')
BACKUP_DIR = os.path.expanduser('~/.local/state/keyring-repair')

# A line is legitimate if it's a group header, blank, a comment, or one of the
# keys gnome-keyring writes. Anything else is a broken continuation line.
VALID_LINE = re.compile(
    r'^(\[[^\]]*\]|#.*|'
    r'(display-name|ctime|mtime|lock-on-idle|lock-after|lock-timeout|'
    r'item-type|secret|binary-secret|name|type|value)=.*|)$')


def log(msg):
    print(f'check-default-keyring: {msg}', file=sys.stderr)


def notify(msg, urgency='normal'):
    try:
        subprocess.run(['notify-send', '-u', urgency, '-a', 'Keyring', 'Keyring check', msg],
                       timeout=5, check=False, capture_output=True)
    except Exception:
        pass


def parse(path):
    kf = GLib.KeyFile.new()
    kf.load_from_file(path, GLib.KeyFileFlags.NONE)
    return sum(1 for g in kf.get_groups()[0] if g.isdigit())


def main():
    if not os.path.isfile(PATH):
        return
    with open(PATH, 'rb') as f:
        if not f.read(9) == b'[keyring]':
            return  # missing or encrypted (password-protected) format; not ours to touch

    try:
        parse(PATH)
        return
    except GLib.Error as e:
        log(f'keyring file is invalid ({e.message.splitlines()[0][:80]}...), repairing')

    with open(PATH, encoding='utf-8') as f:
        lines = f.read().split('\n')
    out = []
    for line in lines:
        if out and not VALID_LINE.match(line):
            out[-1] += '\\n' + line
        else:
            out.append(line)

    tmp = PATH + '.repair-tmp'
    fd = os.open(tmp, os.O_WRONLY | os.O_CREAT | os.O_TRUNC, 0o600)
    with os.fdopen(fd, 'w', encoding='utf-8') as f:
        f.write('\n'.join(out))
    try:
        items = parse(tmp)
    except GLib.Error as e:
        os.unlink(tmp)
        log(f'repair FAILED, left file untouched: {e.message[:120]}')
        notify('Keyring file is corrupted and automatic repair failed. '
               'Secrets are still on disk; see SETUP.md step 13.', 'critical')
        return

    os.makedirs(BACKUP_DIR, mode=0o700, exist_ok=True)
    backup = os.path.join(BACKUP_DIR, time.strftime('Default_Keyring.%Y%m%d-%H%M%S.corrupt'))
    shutil.copy2(PATH, backup)
    os.chmod(backup, 0o600)
    os.replace(tmp, PATH)
    log(f'repaired: {items} items recovered, corrupt copy saved to {backup}')
    notify(f'Keyring file was corrupted and has been repaired automatically ({items} items).')


if __name__ == '__main__':
    try:
        main()
    except Exception as e:
        log(f'unexpected error: {e!r}')
