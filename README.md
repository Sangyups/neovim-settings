# neovim-settings

## Pre-Requisite

You can either backup or delete your old neovim settings before applying this settings.

### Back up your neovim settings

```sh
# required
mv ~/.config/nvim{,.bak}

# optional but recommended
mv ~/.local/share/nvim{,.bak}
mv ~/.local/state/nvim{,.bak}
mv ~/.cache/nvim{,.bak}
```

### Delete your neovim settings

```sh
# required
rm -rf ~/.config/nvim

# optional but recommended
rm -rf ~/.local/share/nvim
rm -rf ~/.local/state/nvim
rm -rf ~/.cache/nvim
```

### Install Required Packages

```sh
# install fzf, lazygit, ripgrep, neovim
brew install fzf lazygit ripgrep neovim
```

## How to Install

First, clone this repository.

```sh
git clone https://github.com/Sangyups/neovim-settings.git ~/.config/nvim
```

### Install Neovim

#### MacOS

```sh
brew install neovim
```

#### Ubuntu

```sh
curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim.appimage
chmod u+x nvim.appimage
./nvim.appimage
```

#### Make Alias for Neovim

```sh
alias vim="nvim"
```
