# Repository Guidelines

## Project Structure & Module Organization
This repository is a Lua-based Neovim configuration.

- `init.lua`: entrypoint; loads `core` settings and Lazy plugin bootstrap.
- `lua/core/`: shared editor behavior (`keymaps.lua`, `options.lua`, `autocmd.lua`).
- `lua/config/lazy.lua`: Lazy.nvim bootstrap and plugin import configuration.
- `lua/plugins/`: plugin specs, mostly one plugin per file (for example `telescope.lua`, `conform.lua`).
- `lua/plugins/lsp/` and `lua/plugins/treesitter/`: domain-specific plugin groups.
- `after/ftplugin/`: filetype-local overrides (for example `go.lua`, `markdown.lua`).
- `lazy-lock.json`: pinned plugin versions; update this when plugin versions change.

## Build, Test, and Development Commands
- `nvim`: launch with this config and allow Lazy to bootstrap/install missing plugins.
- `nvim --headless "+Lazy! sync" +qa`: install/update plugins from the current specs.
- `nvim --headless "+checkhealth" +qa`: run Neovim health checks for dependencies/providers.
- `stylua init.lua lua after`: format Lua config files using repository style rules.

## Coding Style & Naming Conventions
- Indentation is **4 spaces** (`.stylua.toml`).
- Prefer double quotes where practical (`quote_style = "AutoPreferDouble"`).
- Keep modules focused: one concern per file, and one plugin spec per plugin file.
- Core modules should keep concise names in `lua/core/`.
- Plugin specs should use descriptive lowercase filenames that match plugin purpose (for example `nvim-tree.lua`, `lspconfig.lua`).

## Testing Guidelines
There is no dedicated automated test suite in this repo. Validate changes with:

1. Headless smoke checks (`nvim --headless "+qa"` and `+checkhealth`).
2. Plugin sync after spec edits (`+Lazy! sync`).
3. Manual verification of affected keymaps, LSP behavior, formatting, or filetype overrides.

For regressions, include clear reproduction steps in the PR.

## Commit & Pull Request Guidelines
Recent history follows Conventional Commit style:

- `feat: ...`, `fix: ...`, `chore: ...`, `refactor(scope): ...`

Use imperative, scoped messages when useful (for example `fix(lsp): disable gopls parameter hints`).

PRs should include:

1. What changed and why.
2. Any affected plugins/modules (paths).
3. Validation performed (commands + manual checks).
4. Screenshots or short clips when UI-visible behavior changes.
