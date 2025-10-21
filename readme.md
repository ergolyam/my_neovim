# Neovim Configuration

This is a custom Neovim configuration script written in Lua. It includes various settings, key mappings, and functions to enhance your Neovim experience. Below is a detailed guide on how to set it up and use it.

## Initial Setup

1. **Clone the Repository**: Clone this repository using `git clone`.
2. **Install Neovim**: Ensure you have Neovim installed. You can download it from the [official website](https://neovim.io/).
3. **Place the Configuration File**: Place the `init.lua` file in your Neovim configuration directory, typically `~/.config/nvim/`.

### Install Linux/macOS

***Download utils***

- **Arch Linux**: 
  - `sudo pacman -S neovim lazygit nodejs npm gcc base-devel`
- **Alpine Linux**:
  - `apk add neovim lazygit nodejs gcc musl-dev`
- **Debian**: 
  - `sudo apt update && sudo apt install neovim nodejs npm gcc && sudo add-apt-repository ppa:lazygit-team/release && sudo apt update && sudo apt install lazygit`
- **Fedora**: 
  - `sudo dnf install neovim nodejs npm gcc && sudo dnf copr enable atim/lazygit -y && sudo dnf install lazygit`
- **macOS**: 
  - `brew install neovim lazygit node gcc`
- **Termux**: 
  - `pkg install neovim lazygit nodejs gcc`

- Download configs:
    ```bash
    curl -s https://raw.githubusercontent.com/ergolyam/my_neovim/main/install.sh | bash
    ```

- Download with podman:
    ```bash
    mkdir -p \
        $HOME/.config/nvim \
        $HOME/.cache/nvim \
        $HOME/.local/share/nvim \
        $HOME/.config/lazygit &&
    podman run --rm -it \
        -v $HOME/.config/nvim:/root/.config/nvim:Z \
        -v $HOME/.cache/nvim:/root/.cache/nvim:Z \
        -v $HOME/.local/share/nvim:/root/.local/share/nvim:Z \
        -v $HOME/.config/lazygit:/root/.config/lazygit:Z \
            fedora bash -c \
                "dnf install -y neovim gcc git && \
                    curl -s https://raw.githubusercontent.com/ergolyam/my_neovim/main/install.sh | bash"
    ```

### Autocomplete

- Download pyright:
    ```bash
    python -m ensurepip --upgrade &&\
    python -m pip install pyright
    ```

- Download ts lang server:
    ```bash
    sudo npm install typescript-language-server -g
    ```

### Key Features

- **Code Completion**: Code completion in popular programming languages.
- **Syntax Highlighting**: Turns on syntax highlighting for better code readability.
- **Custom Key Mappings**:
  - **Switch Between Normal and Insert Mode**: Use the `INSERT` key.
  - **System Clipboard Integration**: 
    - `Ctrl + C` to copy
    - `Ctrl + V` to paste
    - `Ctrl + X` to cut
    - `Ctrl + Z` to undo
  - **Toggle Highlighting of Current Word**: Press `f` in normal mode.
  - **Open/Close Terminal**: Use `Ctrl + t` in normal mode.
  - **Simple File Manager**: Open with `Ctrl + n`.
    - **File Operations**:
      - **Create File**: Press `tt` and enter the file name.
      - **Create Directory**: Press `td` and enter the directory name.
      - **Rename/Move File or Directory**: Select the file or directory, press `mv`, navigate to the new location, and press `p` to paste. Optionally, you can rename it during the move.
      - **Copy File or Directory**: Select the file or directory, press `cp`, navigate to the destination, and press `p` to paste. Optionally, you can rename it during the copy.
      - **Delete Recursively**: Press `rm` and confirm the deletion of all its contents by typing `y` (default is `N`).
    - **Exit**: Exit whith `q`.
  - **Normal file saving**: Use `Ctrl + s`.
  - **Navigate Tabs**: Use `Tab` and `Shift + Tab` to switch between tabs.
  - **LazyGit**: Use `lg` to open LazyGit in normal mode.
