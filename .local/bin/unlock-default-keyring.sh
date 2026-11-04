#!/bin/sh
# Proactively unlocks the real default gnome-keyring collection as soon as
# gnome-keyring-daemon is up, before any other app can race in and trigger
# the "locked -> fabricate a blank replacement" fallback behavior. Then hands
# off to heal-default-keyring.py to fix the alias / any stray keyring.
# Runs as ExecStartPost of gnome-keyring-daemon.service, so it covers boot and
# every crash restart. See SETUP.md step 13.

REAL=/org/freedesktop/secrets/collection/Default_5fKeyring

# --auto-start=no: calling before the daemon owns its bus name must not make
# dbus-broker spawn a second daemon (and must not count as success).
sb() {
    busctl --user --auto-start=no "$@" 2>/dev/null
}

# Unlock returns success even for a collection that doesn't exist (yet), so
# success is only "the Locked property now reads false".
for i in $(seq 1 50); do
    sb call org.freedesktop.secrets /org/freedesktop/secrets \
        org.freedesktop.Secret.Service Unlock ao 1 "$REAL" >/dev/null
    if [ "$(sb get-property org.freedesktop.secrets "$REAL" \
            org.freedesktop.Secret.Collection Locked)" = "b false" ]; then
        unlocked=1
        break
    fi
    sleep 0.2
done
if [ -z "$unlocked" ]; then
    echo "unlock-default-keyring: gave up waiting for the real keyring collection" >&2
    exit 1
fi

# Re-assert the default alias and clean up any stray keyring that already
# got created (e.g. while the daemon was down).
exec "$(dirname "$0")/heal-default-keyring.py"
