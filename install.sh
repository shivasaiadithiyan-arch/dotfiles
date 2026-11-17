#!/usr/bin/env bash
# Link this repo's configs into ~/.config.
#
# Each top-level directory under .config/ becomes a symlink in ~/.config, so
# edits you make land in the repo and show up in `git status`. Anything already
# at the destination is moved aside with a timestamped .bak- suffix rather than
# overwritten.

set -euo pipefail

REPO="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
STAMP="$(date +%Y%m%d-%H%M%S)"

mkdir -p "$HOME/.config"

# Home-level dotfiles, listed explicitly so the repo's own files (README.md,
# install.sh, packages/, system/) are never linked into $HOME.
HOME_FILES=(.xinitrc)

for name in "${HOME_FILES[@]}"; do
	src="$REPO/$name"
	[ -e "$src" ] || continue
	dest="$HOME/$name"

	if [ -L "$dest" ]; then
		rm "$dest"
	elif [ -e "$dest" ]; then
		mv "$dest" "$dest.bak-$STAMP"
		echo "backed up  $dest -> $dest.bak-$STAMP"
	fi

	ln -s "$src" "$dest"
	echo "linked     ~/$name -> $src"
done

for src in "$REPO"/.config/*; do
	[ -e "$src" ] || continue
	name="$(basename "$src")"
	dest="$HOME/.config/$name"

	if [ -L "$dest" ]; then
		rm "$dest"
	elif [ -e "$dest" ]; then
		mv "$dest" "$dest.bak-$STAMP"
		echo "backed up  $dest -> $dest.bak-$STAMP"
	fi

	ln -s "$src" "$dest"
	echo "linked     ~/.config/$name -> $src"
done

echo
echo "Done. Next: see README.md for the package install, the /etc/pam.d/login"
echo "keyring lines, and the post-link steps."
