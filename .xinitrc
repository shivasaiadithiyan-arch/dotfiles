# Use the session bus that systemd --user already provides, rather than
# spawning a second one with dbus-launch. gnome-keyring-daemon runs as a
# systemd user unit on this bus, so anything i3 starts can actually reach
# org.freedesktop.secrets.
export DBUS_SESSION_BUS_ADDRESS="unix:path=${XDG_RUNTIME_DIR}/bus"

exec i3
