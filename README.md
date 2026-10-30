# neovim-settings

A modular and modern Neovim configuration optimized for professional development, featuring high-performance completion and project-aware UI.

## ✨ Key Features

- **Modern Completion**: Ultra-fast completion and snippet support powered by [blink.cmp](https://github.com/Saghen/blink.cmp).
- **Project-Aware UI**: Automatically switches colorschemes based on your workspace context to provide an optimal visual environment.
- **Smart Formatting**: Out-of-the-box formatting for various languages including JS/TS, Python, Go, Lua, and more via [conform.nvim](https://github.com/stevearc/conform.nvim).
- **LSP & Tool Management**: Seamlessly install and manage LSPs, linters, and formatters using [Mason](https://github.com/mason-org/mason.nvim).
- **Syntax-Aware Editing**: Treesitter highlighting, indentation, text objects, and native Neovim syntax-node selection.
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

- **Core**: `neovim` (>= 0.12.5; verified with 0.12.6), `git`, `ripgrep`, `fzf`, `lazygit`
- **Treesitter**: `tree-sitter-cli` (>= 0.26.1), `tar`, `curl`, and a C compiler. Install the CLI through a package manager rather than npm; the `tree-sitter` library package alone does not provide the CLI. See the [upstream requirements](https://github.com/nvim-treesitter/nvim-treesitter#requirements).
- **Build Tools**: Required for compiling native extensions (e.g., `telescope-fzf-native`).
- **Font**: A [Nerd Font](https://www.nerdfonts.com/) is **highly recommended** for icons (e.g., JetBrainsMono Nerd Font).

#### MacOS

```sh
# 1. Install Xcode Command Line Tools (provides make, gcc, etc.)
xcode-select --install

# 2. Install core tools via Homebrew
brew install neovim ripgrep fzf lazygit tree-sitter-cli
```

#### Ubuntu

```sh
# 1. Install build-essential and core tools
sudo apt update
sudo apt install build-essential git curl tar ripgrep fzf libfuse2

# 2. Install Neovim AppImage
curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim.appimage
chmod u+x nvim.appimage
sudo mv nvim.appimage /usr/local/bin/nvim
```

Also install `tree-sitter-cli` >= 0.26.1 using a package manager available on your system. Verify both versions before starting Neovim:

```sh
nvim --version
tree-sitter --version
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

## Treesitter Migration and Updates

The configuration and `lazy-lock.json` use the `main` branches of `nvim-treesitter` and `nvim-treesitter-textobjects`.

The migrated configuration:

- Loads Treesitter at startup with `lazy = false`.
- Uses the new installation API for the configured parser list and automatically installs supported parsers when opening other filetypes.
- Enables highlighting with `vim.treesitter.start()` and Treesitter indentation when an indentation query is available.
- Configures textobjects through its independent API while preserving the existing selection and movement keys.
- Uses Neovim 0.12's native `vim.treesitter.select()` for expanding and shrinking selections.

| Keys                     | Mode                               | Action                                            |
| ------------------------ | ---------------------------------- | ------------------------------------------------- |
| `<C-space>`              | Normal / Visual                    | Select a syntax node or expand to its parent      |
| `<BS>`                   | Visual                             | Shrink to a child syntax node                     |
| `af` / `if`              | Visual / Operator-pending          | Select the outer / inner function                 |
| `ac` / `ic`              | Visual / Operator-pending          | Select the outer / inner class                    |
| `aa` / `ia`              | Visual / Operator-pending          | Select the outer / inner parameter                |
| `ai` / `ii`, `al`        | Visual / Operator-pending          | Select conditional parts or an outer loop         |
| `]f` / `[f`, `]F` / `[F` | Normal / Visual / Operator-pending | Jump to the next / previous function start or end |

Movement keys also use `c`, `i`, and `l` for classes, conditionals, and loops; uppercase variants target their ends.

### Updating Plugins and Parsers

1. Back up the configuration, including `lazy-lock.json`, and verify the prerequisites above.
2. Update plugins together from Neovim:

   ```vim
   :Lazy update
   ```

3. Wait for Lazy's `:TSUpdate` build hook and parser downloads to finish, then restart Neovim. Run `:TSUpdate` again if parser updates need to be retried.
4. Run `:checkhealth nvim-treesitter` and open representative files to check highlighting, indentation, `<C-space>`, `af`, and `]f`. Review the resulting `lazy-lock.json` changes before committing.

Keep parsers aligned with the plugin's queries: new queries with old parsers can produce query errors. Restoring the lockfile alone does not restore parser binaries or Mason-managed tools.

## Refactoring

The current `refactoring.nvim` requires Neovim >= 0.12.5 and uses `async.nvim` on Neovim 0.12. The keymaps use its operator API:

| Keys          | Mode            | Action                                                                     |
| ------------- | --------------- | -------------------------------------------------------------------------- |
| `<leader>rf`  | Normal / Visual | Extract a function from a motion or selection                              |
| `<leader>rv`  | Normal / Visual | Extract a variable from a motion or selection                              |
| `<leader>ri`  | Normal / Visual | Inline a variable                                                          |
| `<leader>rI`  | Normal / Visual | Inline a function                                                          |
| `<leader>rb`  | Normal          | Extract a function from the following motion or textobject                 |
| `<leader>rbf` | Normal          | Extract a function to another file from the following motion or textobject |

The old `extract_block` commands were removed upstream. For example, `<leader>rb al` now extracts the loop selected by the `al` textobject. In Visual mode, select the desired code and use `<leader>rf`.

## 👨‍💻 Project Development

### Code Style

This project uses [StyLua](https://github.com/JohnnyMorganz/StyLua) as the default Lua formatter to maintain consistent code style across the configuration.

- **Config**: `.stylua.toml`
- **Manual Format**: You can format the Lua files using `<leader>fm` within Neovim.
