#!/bin/bash

# `set | grep WSL` returns envivonment variables that only exist within WSL.
# `WSL_DISTRO_NAME` is one such variable. Simply check for this variable to
# determine if we're in WSL.
if [[ -z $WSL_DISTRO_NAME ]]; then
  exit 0
fi

# `wslvar` resolves Windows environment variables within WSL. `wslpath` converts
# a Windows path to a WSL path, e.g., `C:\Users` becomes `/mnt/c/Users`.
APPDATA_DIR=$(wslpath "$(wslvar APPDATA)")

# Alacritty checks for a config file at `%APPDATA%\alacritty\alacritty.yml`.
ALACRITTY_CONFIG_DIR="$APPDATA_DIR/alacritty"

mkdir -p "$ALACRITTY_CONFIG_DIR" && \
  cp tochka/alacritty.win.yml "$ALACRITTY_CONFIG_DIR/alacritty.yml"
