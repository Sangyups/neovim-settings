return {
    {
        "neovim/nvim-lspconfig",
        event = { "BufReadPre", "BufNewFile" },
        dependencies = {
            "saghen/blink.cmp",
            { "antosha417/nvim-lsp-file-operations", config = true },
            { "j-hui/fidget.nvim", config = true },
            "mason-org/mason-lspconfig.nvim",
        },
        config = function()
            local keymap = vim.keymap -- for conciseness

            local border = "rounded"

            vim.api.nvim_create_autocmd("LspAttach", {
                group = vim.api.nvim_create_augroup("UserLspConfig", {}),
                callback = function(ev)
                    local opts = { buffer = ev.buf, noremap = true, silent = true }
                    local severity = vim.diagnostic.severity
                    vim.diagnostic.config({
                        float = {
                            border = border,
                            severity_sort = true,
                        },
                        underline = true,
                        severity_sort = true,
                        virtual_text = true,
                        signs = {
                            text = {
                                [severity.ERROR] = " ",
                                [severity.WARN] = " ",
                                [severity.HINT] = "󰠠 ",
                                [severity.INFO] = " ",
                            },
                        },
                    })

                    -- Keep Java inlay hints disabled for the Neovim crash workaround:
                    -- https://github.com/neovim/neovim/issues/36318.
                    local is_java = vim.bo[ev.buf].filetype == "java"
                    vim.lsp.inlay_hint.enable(not is_java, { bufnr = ev.buf })

                    -- set keybinds
                    opts.desc = "Show LSP references"
                    keymap.set("n", "gr", "<cmd>Telescope lsp_references<CR>", opts) -- show definition, references

                    opts.desc = "Go to declaration"
                    keymap.set("n", "gD", vim.lsp.buf.declaration, opts) -- go to declaration

                    opts.desc = "Show LSP definitions"
                    keymap.set("n", "gd", "<cmd>Telescope lsp_definitions<CR>", opts) -- show lsp definitions

                    opts.desc = "Show LSP implementations"
                    keymap.set("n", "gi", "<cmd>Telescope lsp_implementations<CR>", opts) -- show lsp implementations

                    opts.desc = "Show LSP type definitions"
                    keymap.set("n", "gt", "<cmd>Telescope lsp_type_definitions<CR>", opts) -- show lsp type definitions

                    opts.desc = "See available code actions"
                    keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts) -- see available code actions, in visual mode will apply to selection

                    opts.desc = "Smart rename"
                    keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts) -- smart rename

                    opts.desc = "Show buffer diagnostics"
                    keymap.set("n", "<leader>D", "<cmd>Telescope diagnostics bufnr=0<CR>", opts) -- show  diagnostics for file

                    opts.desc = "Show line diagnostics"
                    keymap.set("n", "<leader>d", vim.diagnostic.open_float, opts) -- show diagnostics for line

                    opts.desc = "Go to previous vim.diagnostic"
                    keymap.set("n", "[d", function()
                        vim.diagnostic.jump({ count = -1, float = true })
                    end, opts) -- jump to previous diagnostic in buffer

                    opts.desc = "Go to next vim.diagnostic"
                    keymap.set("n", "]d", function()
                        vim.diagnostic.jump({ count = 1, float = true })
                    end, opts) -- jump to next diagnostic in buffer

                    opts.desc = "Show documentation for what is under cursor"
                    keymap.set("n", "K", function()
                        vim.lsp.buf.hover({ border = border })
                    end, opts) -- show documentation for what is under cursor

                    opts.desc = "Show documentation for what is under cursor(Insert Mode)"
                    keymap.set({ "i", "n" }, "<C-q>", function()
                        vim.lsp.buf.signature_help({ border = border })
                    end, opts) -- show documentation for what is under cursor
                end,
            })

            -- used to enable autocompletion (assign to every lsp server config)
            local capabilities = require("blink.cmp").get_lsp_capabilities()

            vim.lsp.config("*", { capabilities = capabilities })

            vim.lsp.enable("gleam")
        end,
    },
}
