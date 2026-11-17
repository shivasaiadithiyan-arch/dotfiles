# Keyring unlock at login (`/etc/pam.d/login`)

Apply this by hand with sudo on a new machine. It is **deliberately not
symlinked** from this repo: PAM reads `/etc/pam.d/login` as root, so pointing
it at a file inside a user-writable git repo would let any process running as
the user rewrite part of the authentication stack. Copy the lines in, do not
link them.

## Why it is needed

Without it there is no persistent `login` keyring, so anything using the
freedesktop secret service (`gh auth login`, Brave's password store, VPN
clients, Docker credential helpers) either hangs waiting for an unlock prompt
that never appears, or stores secrets in the in-memory `session` collection
where they are lost at logout.

This machine has no display manager: login happens on a TTY and X starts from
`~/.xinitrc`, so `/etc/pam.d/login` is the stack that matters. With a display
manager, add the same two lines to that DM's file instead (e.g.
`/etc/pam.d/lightdm`, `/etc/pam.d/sddm`).

## Apply

```sh
sudo cp /etc/pam.d/login /etc/pam.d/login.bak

sudo sed -i -E \
  -e 's|^(auth[[:space:]]+include[[:space:]]+system-local-login)$|\1\nauth       optional     pam_gnome_keyring.so|' \
  -e 's|^(session[[:space:]]+include[[:space:]]+system-local-login)$|\1\nsession    optional     pam_gnome_keyring.so auto_start|' \
  /etc/pam.d/login

cat /etc/pam.d/login
```

The result should read:

```
#%PAM-1.0

auth       requisite    pam_nologin.so
auth       include      system-local-login
auth       optional     pam_gnome_keyring.so
account    include      system-local-login
session    include      system-local-login
session    optional     pam_gnome_keyring.so auto_start
password   include      system-local-login
```

Check that output before logging out. Both lines are `optional`, so a failure
cannot lock you out, and `login.bak` is the restore.

## The other half

`~/.xinitrc` must not use `dbus-launch`. systemd already provides a user bus at
`$XDG_RUNTIME_DIR/bus`, and `gnome-keyring-daemon` runs as a systemd user unit
on it. `dbus-launch --exit-with-session i3` creates a *second* bus for i3, so
everything i3 starts asks a bus where no secret service is listening and hangs
forever. The tracked `.xinitrc` exports the systemd bus address and `exec i3`
directly.

## Verify after re-login

```sh
ls ~/.local/share/keyrings/     # login.keyring should exist
secret-tool search --all x y    # returns immediately instead of hanging
busctl --user get-property org.freedesktop.secrets \
  /org/freedesktop/secrets/collection/login \
  org.freedesktop.Secret.Collection Locked    # expect: b false
```

The keyring password is set from your login password when it is created. If you
later change the account password with `passwd`, the keyring password does not
follow -- update it in `seahorse` or you will be prompted at login.
