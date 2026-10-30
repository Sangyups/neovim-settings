return {
    "stevearc/conform.nvim",
    lazy = true,
    event = { "BufReadPre", "BufNewFile" }, -- to disable, comment this out
    config = function()
        local conform = require("conform")

        conform.setup({
            formatters_by_ft = {
                javascript = { "prettier" },
                typescript = { "prettier" },
                javascriptreact = { "prettier" },
                typescriptreact = { "prettier" },
                svelte = { "prettier" },
                css = { "prettier" },
                html = { "prettier" },
                json = { "prettier" },
                yaml = { "prettier" },
                markdown = { "prettier" },
                graphql = { "prettier" },
                lua = { "stylua" },
                python = { "ruff_format", "isort" },
                sh = { "shfmt" },
                cpp = { "clang-format" },
            },
            format_after_save = function(bufnr)
                if vim.bo[bufnr].filetype == "java" then
                    return
                end

                return {
                    lsp_format = "fallback",
                    async = true,
                }
            end,
        })

        vim.keymap.set({ "n", "v" }, "<leader>fm", function()
            conform.format({
                lsp_format = "fallback",
                async = false,
            })
        end, { desc = "Format file or range (in visual mode)" })
    end,
}
