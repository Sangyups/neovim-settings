# neovim-settings

A modular and modern Neovim configuration optimized for professional development, featuring high-performance completion and project-aware UI.

## ✨ Key Features

- **Modern Completion**: Ultra-fast completion and snippet support powered by [blink.cmp](https://github.com/Saghen/blink.cmp).
- **Project-Aware UI**: Automatically switches colorschemes based on your workspace context to provide an optimal visual environment.
- **Smart Formatting**: Out-of-the-box formatting for various languages including JS/TS, Python, Go, Lua, and more via [conform.nvim](https://github.com/stevearc/conform.nvim).
- **LSP & Tool Management**: Seamlessly install and manage LSPs, linters, and formatters using [Mason](https://github.com/williamboman/mason.nvim).
- **Optimized Performance**: Lazy-loading and efficient plugin management using `lazy.nvim` for a snappy experience.

## 🛠 Pre-Requisite

### 1. Back up or Delete old settings

Choose one of the following before applying these settings.

#### Back up

```sh
mv ~/.config/nvim{,.bak}
mv ~/.local/share/nvim{,.bak} # optional
mv ~/.local/state/nvim{,.bak} # optional
mv ~/.cache/nvim{,.bak}       # optional
```

#### Delete

```sh
rm -rf ~/.config/nvim
rm -rf ~/.local/share/nvim ~/.local/state/nvim ~/.cache/nvim
```

### 2. Install Required Packages

This configuration requires several external tools for building high-performance plugins and full functionality:

- **Core**: `neovim` (>= 0.10), `git`, `ripgrep`, `fzf`, `lazygit`
- **Build Tools**: Required for compiling native extensions (e.g., `telescope-fzf-native`).
- **Font**: A [Nerd Font](https://www.nerdfonts.com/) is **highly recommended** for icons (e.g., JetBrainsMono Nerd Font).

#### MacOS

```sh
# 1. Install Xcode Command Line Tools (provides make, gcc, etc.)
xcode-select --install

# 2. Install core tools via Homebrew
brew install neovim ripgrep fzf lazygit
```

#### Ubuntu

```sh
# 1. Install build-essential and core tools
sudo apt update
sudo apt install build-essential ripgrep fzf libfuse2

# 2. Install Neovim AppImage
curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim.appimage
chmod u+x nvim.appimage
sudo mv nvim.appimage /usr/local/bin/nvim
```

## 🚀 How to Install

Clone this repository to your Neovim config directory:

```sh
# via HTTPS
git clone https://github.com/Sangyups/neovim-settings.git ~/.config/nvim

# OR via SSH
git clone git@github.com:Sangyups/neovim-settings.git ~/.config/nvim
```

Then, simply run `nvim`. Plugins and LSP servers will be installed automatically on the first run.

### Make Alias

Add this to your `.zshrc` or `.bashrc`:

```sh
alias vim="nvim"
```

## 👨‍💻 Project Development

### Code Style

This project uses [StyLua](https://github.com/JohnnyMorganz/StyLua) as the default Lua formatter to maintain consistent code style across the configuration.

- **Config**: `.stylua.toml`
- **Manual Format**: You can format the Lua files using `<leader>fm` within Neovim.
