#!/usr/bin/env bash
# Toggle the budget sheet.
#
# Same shape as sticky.sh: an nvim session in a ghostty window parked in i3's
# scratchpad, so it keeps its cursor, undo history and unsaved edits between
# toggles instead of reloading every time.
#
# The ledger is a markdown table (see ~/.config/nvim/lua/budget.lua) -- plain
# text, so it survives this script, nvim, and the next distro.

set -euo pipefail

CLASS="com.budget.sheet"
LEDGER="${BUDGET_FILE:-$HOME/notes/budget/ledger.md}"

if i3-msg -t get_tree | grep -q "\"class\":\"$CLASS\""; then
	i3-msg "[class=\"$CLASS\"] scratchpad show" >/dev/null
else
	mkdir -p "$(dirname "$LEDGER")"
	if [ ! -s "$LEDGER" ]; then
		cat >"$LEDGER" <<'TBL'
# Budget ledger. Type is income, spend or invest.
# Set a monthly cap for any spend category with a line like these:
# budget groceries 10000
# budget rent 18000
# budget eating-out 4000
#
# <leader>ba add one      <leader>bi add many at once
# <leader>bs month        <leader>by year        <leader>bt all time
# <leader>br repeat today <leader>bd delete      <leader>bx export CSV
# Columns realign and sort themselves on save.

| Date | Type | Category | Amount | Note |
| ---- | ---- | -------- | -----: | ---- |
TBL
	fi
	# noswapfile: the sheet is a single-writer file and a stale swap from a
	# crashed instance would greet you with a recovery prompt instead of the
	# numbers.
	exec ghostty --class="$CLASS" -e nvim --cmd 'set noswapfile' "$LEDGER"
fi
