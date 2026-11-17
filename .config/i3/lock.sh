#!/usr/bin/env bash
# Single source of truth for the lock screen.
# Used both by the $mod+Shift+s keybinding and by xss-lock (suspend/idle).
# --nofork is required so xss-lock can track the locker's lifetime.

exec i3lock \
  --color=000000 \
  --inside-color=1e1e2e00 \
  --ring-color=ffffff \
  --keyhl-color=000000 \
  --line-uses-ring \
  --separator-color=00000000 \
  --time-color=cdd6f4 \
  --date-color=cdd6f4 \
  --layout-color=cdd6f4 \
  --greeter-color=cdd6f4 \
  --verif-color=a6e3a1 \
  --wrong-color=f38ba8 \
  --modif-color=f38ba8 \
  --verif-text='Verifying...' \
  --wrong-text='Wrong!' \
  --clock --indicator --nofork
