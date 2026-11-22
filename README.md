# dotfiles

Arch Linux + i3 setup: neovim, i3wm, i3status, ghostty.

Clone it on a new machine, install the packages, run `install.sh`, and the
configs are linked into place.

## What's here

```
.config/nvim/        neovim (kickstart.nvim fork, single init.lua)
.config/i3/          i3wm config + lock.sh + sticky.sh + budget.sh
.config/i3status/    status bar
.config/ghostty/     terminal
.xinitrc             starts i3 on the systemd user bus (no dbus-launch)
packages/            package lists captured from a working machine
system/              root-owned files to apply by hand (keyring PAM lines)
install.sh           symlinks the configs and .xinitrc into place
```

## Fresh machine

```sh
# 1. packages
sudo pacman -S --needed - < packages/pacman-explicit.txt
sudo pacman -S --needed - < packages/extra-required.txt

# 2. an AUR helper, then the AUR packages
#    (yay is itself in the AUR list, so bootstrap it first)
git clone https://aur.archlinux.org/yay.git /tmp/yay && (cd /tmp/yay && makepkg -si)
yay -S --needed - < packages/aur-explicit.txt

# 3. link the configs
git clone https://github.com/shivasaiadithiyan-arch/dotfiles.git ~/dotfiles
~/dotfiles/install.sh

# 4. enable display hotplug switching
sudo systemctl enable --now autorandr.service

# 5. keyring unlock at login -- see system/keyring-pam.md, applied by hand
#    (not symlinked: PAM must not read config from a user-writable repo)
```

Then start i3 and launch `nvim` once: lazy.nvim bootstraps itself and installs
every plugin, and mason pulls the language servers, formatters, linters and
debug adapters listed in `init.lua`. Give it a minute and check `:Lazy` and
`:Mason` are clean.

## Not portable — redo these per machine

- **autorandr profiles** are matched by monitor EDID, so they are deliberately
  not committed. Recreate them: arrange your screens, then
  `autorandr --save docked`, and `autorandr --save undocked` with nothing
  plugged in.
- **Output names** in `.config/i3/config` (`HDMI-1`, `eDP-1`) are specific to
  this laptop. Run `xrandr --query` on the new machine and fix the
  `workspace N output ...` lines to match.
- **Wallpaper**: the `feh` line points at `~/Documents/wallpapers/punisher.jpg`.
- **GPU**: this machine is an ASUS laptop with Intel + NVIDIA hybrid graphics
  (`supergfxctl`, `nvidia-open-dkms`). On different hardware, drop
  `supergfxctl` and `rog-control-center-x11` from the AUR list.
- **Video decode**: `intel-media-driver` is for Intel iGPUs. On AMD use
  `libva-mesa-driver`; on pure NVIDIA use `libva-nvidia-driver`.

## Keys worth knowing

`$mod` is Super.

| Key | Does |
| --- | --- |
| `$mod+n` | sticky note (nvim scratchpad, toggles in and out of view) |
| `$mod+minus` | cycle windows parked in the i3 scratchpad |
| `$mod+Shift+minus` | park the focused window in the scratchpad |
| `$mod+e` | budget sheet (nvim scratchpad, same toggle as the note) |
| `<space>e` / `\` (nvim) | file explorer / reveal current file |
| `<space>g...` (nvim) | git hunks: `gd` diff, `gp` preview, `gs` stage, `gr` reset |
| `<space>d...` (nvim) | debugger: `db` breakpoint, `dc` start/continue, `du` UI |
| `<space>b...` (budget) | `ba` add one, `bi` add many, `bs` month summary, `by` year, `br` repeat today |
| `<space>u` (nvim) | undo tree |
| `<space>rn` (nvim) | LSP rename across the project |
