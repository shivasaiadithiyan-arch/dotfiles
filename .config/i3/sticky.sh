#!/usr/bin/env bash
# Toggle the sticky note.
#
# The note is an ordinary nvim session in a ghostty window that lives in i3's
# scratchpad: hidden from every workspace but still running, so it reappears
# instantly with its cursor position and undo history intact.
#
# If the window exists, toggle it. If it was closed (or this is the first run
# of the session), launch it -- the for_window rule in the i3 config floats it,
# centres it, and shows it.

set -euo pipefail

CLASS="com.sticky.note"
NOTE="${STICKY_NOTE:-$HOME/notes/sticky.md}"

if i3-msg -t get_tree | grep -q "\"class\":\"$CLASS\""; then
	i3-msg "[class=\"$CLASS\"] scratchpad show" >/dev/null
else
	mkdir -p "$(dirname "$NOTE")"
	# noswapfile: this is a scratch note, and a leftover swap from a crashed or
	# orphaned instance would otherwise greet you with a recovery prompt instead
	# of the note.
	exec ghostty --class="$CLASS" -e nvim --cmd 'set noswapfile' '+normal G$' "$NOTE"
fi
