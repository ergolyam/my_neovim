#!/usr/bin/env bash

set -e

if [[ -n "$BASH_SOURCE" && "$BASH_SOURCE" != "/dev/stdin" ]]; then
    script_path="$BASH_SOURCE"
elif [[ -n "$0" && "$0" != "bash" ]]; then
    script_path="$0"
else
    script_path=""
fi

if [[ -n "$script_path" ]]; then
    script_dir=$(dirname "$(realpath "$script_path")")
else
    script_dir=$(pwd)
fi

if [ -d "$script_dir/.git" ]; then
  echo "Script dir: $script_dir"
  expected_url="github.com:ergolyam/my_neovim.git"
  remote_short_url=""
  if git -C "$script_dir" remote get-url origin &>/dev/null; then
    remote_url="$(git -C "$script_dir" remote get-url origin)"
    remote_short_url="$(echo "$remote_url" | sed -E 's#(git@|https://)github\.com(:|/)#github.com:#')"
  fi
fi

use_local_repo=false
if [ -d "$script_dir/.git" ] && [ "$remote_short_url" = "$expected_url" ]; then
  use_local_repo=true
fi

if ! $use_local_repo; then
  if command -v wget >/dev/null 2>&1; then
    download_cmd='wget -q -O'
  elif command -v curl >/dev/null 2>&1; then
    download_cmd='curl -sSf -o'
  else
    echo "Error: wget or curl not found." >&2
    exit 1
  fi
fi

base_config="$HOME/.config"
base_url="https://raw.githubusercontent.com/ergolyam/my_neovim/main"

mkdir -pv ~/.config/nvim/lua
mkdir -pv ~/.config/lazygit

lua_modules=(
  "funcs.lua"
  "gpt.lua"
  "highlight.lua"
  "plugins.lua"
  "settings.lua"
  "tabs.lua"
  "terminal.lua"
  "autosave.lua"
  )

if [ -d "$script_dir/.git" ]; then
  ln -sfv "$script_dir/nvim/init.lua" "$base_config/nvim/init.lua"
  ln -sfv "$script_dir/lazygit/config.yml" "$base_config/lazygit/config.yml"
else
  echo "Download init.lua..."
  $download_cmd "$base_config/nvim/init.lua" "$base_url/nvim/init.lua"
  echo "Download config.yml..."
  $download_cmd "$base_config/lazygit/config.yml" "$base_url/lazygit/config.yml"
fi

for i in "${lua_modules[@]}"; do
  if $use_local_repo; then
    ln -sfv "$script_dir/nvim/lua/$i" "$base_config/nvim/lua/$i"
  else
    echo "Download $i..."
    $download_cmd "$base_config/nvim/lua/$i" "$base_url/nvim/lua/$i"
  fi
done

nvim --headless +qa
