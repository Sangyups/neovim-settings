return {
    {
        "nvim-treesitter/nvim-treesitter",
        branch = "main",
        lazy = false,
        build = ":TSUpdate",
        dependencies = {
            "windwp/nvim-ts-autotag",
            "nvim-treesitter/nvim-treesitter-textobjects",
        },
        config = function()
            local treesitter = require("nvim-treesitter")
            local parsers = {
                "json",
                "javascript",
                "typescript",
                "tsx",
                "yaml",
                "markdown",
                "markdown_inline",
                "bash",
                "lua",
                "vim",
                "vimdoc",
                "dockerfile",
                "gitignore",
                "go",
            }
            local group = vim.api.nvim_create_augroup("UserTreesitter", { clear = true })

            local function attach(bufnr)
                if not vim.api.nvim_buf_is_loaded(bufnr) or vim.bo[bufnr].buftype ~= "" then
                    return
                end

                local ok, parser = pcall(vim.treesitter.get_parser, bufnr)
                if not ok or not parser then
                    return
                end

                if treesitter.install then
                    vim.treesitter.start(bufnr)
                    if vim.treesitter.query.get(parser:lang(), "indents") then
                        vim.bo[bufnr].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
                    end
                end

                vim.keymap.set({ "n", "x" }, "<C-space>", function()
                    vim.treesitter.select("parent", vim.v.count1)
                end, { buffer = bufnr, desc = "Expand selection to syntax node" })
                vim.keymap.set("x", "<BS>", function()
                    vim.treesitter.select("child", vim.v.count1)
                end, { buffer = bufnr, desc = "Shrink selection to syntax node" })
            end

            if treesitter.install then
                treesitter.setup({})

                local pending = {}
                local available = require("nvim-treesitter.parsers")
                local function install(languages)
                    local missing = vim.tbl_filter(function(lang)
                        return available[lang] ~= nil and not pending[lang]
                    end, languages)
                    if #missing == 0 then
                        return
                    end
                    for _, lang in ipairs(missing) do
                        pending[lang] = true
                    end
                    treesitter.install(missing):await(vim.schedule_wrap(function()
                        for _, lang in ipairs(missing) do
                            pending[lang] = nil
                        end
                        for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
                            attach(bufnr)
                        end
                    end))
                end

                vim.api.nvim_create_autocmd("FileType", {
                    group = group,
                    callback = function(ev)
                        if vim.bo[ev.buf].buftype ~= "" then
                            return
                        end
                        local lang = vim.treesitter.language.get_lang(vim.bo[ev.buf].filetype)
                        if lang then
                            install({ lang })
                        end
                        attach(ev.buf)
                    end,
                })
                install(parsers)
            else
                -- Keep the current lockfile usable until the plugin update is performed.
                require("nvim-treesitter.configs").setup({
                    highlight = { enable = true },
                    indent = { enable = true },
                    auto_install = true,
                    ensure_installed = parsers,
                })
                vim.api.nvim_create_autocmd("FileType", {
                    group = group,
                    callback = function(ev)
                        attach(ev.buf)
                    end,
                })
            end

            for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
                attach(bufnr)
            end

            require("ts_context_commentstring").setup({})
            require("nvim-ts-autotag").setup()
        end,
    },
}
