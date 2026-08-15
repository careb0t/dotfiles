#!/bin/bash
# omarchy-font-set uses `sed -i` on ~/.config/ghostty/config. Since that path
# is a stow symlink, sed's rename-based edit escapes the symlink: it writes
# the *new* font into a plain file at the symlink's path, leaving the real
# source in ~/dotfiles untouched. If we just restowed, we'd throw away the
# font-family update sed just made and revert to the stale dotfiles copy.
# So: copy the freshly-written content back into the dotfiles source first
# (this is now the source of truth), then remove the plain file and restow
# to restore the symlink.
target=~/.config/ghostty/config
source=~/dotfiles/.config/ghostty/config
if [[ -f "$target" && ! -L "$target" ]]; then
  cp "$target" "$source"
  rm -f "$target"
fi
cd ~/dotfiles && stow -R -t ~ .
