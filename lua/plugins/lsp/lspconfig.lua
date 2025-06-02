return {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
        "hrsh7th/cmp-nvim-lsp",
        { "antosha417/nvim-lsp-file-operations", config = true },
        { "j-hui/fidget.nvim", config = true },
        "williamboman/mason-lspconfig.nvim",
    },
    config = function()
        local mason_lspconfig = require("mason-lspconfig")
        local cmp_nvim_lsp = require("cmp_nvim_lsp")

        local keymap = vim.keymap -- for conciseness

        vim.cmd([[autocmd! ColorScheme * highlight NormalFloat guibg=#1f2335]])
        vim.cmd([[autocmd! ColorScheme * highlight FloatBorder guifg=white guibg=#1f2335]])

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

                vim.lsp.inlay_hint.enable()

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
        local capabilities = cmp_nvim_lsp.default_capabilities()

        local handlers = {
            ["textDocument/hover"] = vim.lsp.buf.hover,
            ["textDocument/signatureHelp"] = vim.lsp.buf.signature_help,
        }

        local function setup_and_start(server_name, opts)
            vim.lsp.config(server_name, opts)
            vim.lsp.enable(server_name)
        end

        setup_and_start("gleam", {
            capabilities = capabilities,
            handlers = handlers,
        })

        mason_lspconfig.setup_handlers({
            function(lsp_server)
                setup_and_start(lsp_server, {
                    capabilities = capabilities,
                    handlers = handlers,
                })
            end,

            ["lua_ls"] = function()
                setup_and_start("lua_ls", {
                    capabilities = capabilities,
                    handlers = handlers,
                    settings = { -- custom settings for lua
                        Lua = {
                            -- make the language server recognize "vim" global
                            diagnostics = {
                                globals = { "vim" },
                            },
                            hint = {
                                enable = true, -- necessary
                            },
                            workspace = {
                                -- make language server aware of runtime files
                                library = {
                                    [vim.fn.expand("$VIMRUNTIME/lua")] = true,
                                    [vim.fn.stdpath("config") .. "/lua"] = true,
                                },
                            },
                        },
                    },
                })
            end,

            ["rust_analyzer"] = function()
                setup_and_start("rust_analyzer", {
                    settings = {
                        ["rust-analyzer"] = {
                            check = {
                                command = "clippy",
                            },
                            inlayHints = {
                                bindingModeHints = {
                                    enable = false,
                                },
                                chainingHints = {
                                    enable = true,
                                },
                                closingBraceHints = {
                                    enable = true,
                                    minLines = 25,
                                },
                                closureReturnTypeHints = {
                                    enable = "never",
                                },
                                lifetimeElisionHints = {
                                    enable = "never",
                                    useParameterNames = false,
                                },
                                maxLength = 25,
                                parameterHints = {
                                    enable = true,
                                },
                                reborrowHints = {
                                    enable = "never",
                                },
                                renderColons = true,
                                typeHints = {
                                    enable = true,
                                    hideClosureInitialization = false,
                                    hideNamedConstructor = false,
                                },
                            },
                        },
                    },
                })
            end,

            ["ts_ls"] = function()
                setup_and_start("ts_ls", {
                    settings = {
                        typescript = {
                            inlayHints = {
                                includeInlayParameterNameHints = "literals",
                                includeInlayParameterNameHintsWhenArgumentMatchesName = true,
                                includeInlayFunctionParameterTypeHints = true,
                                includeInlayVariableTypeHints = true,
                                includeInlayVariableTypeHintsWhenTypeMatchesName = true,
                                includeInlayPropertyDeclarationTypeHints = true,
                                includeInlayFunctionLikeReturnTypeHints = true,
                                includeInlayEnumMemberValueHints = true,
                            },
                        },
                        javascript = {
                            inlayHints = {
                                includeInlayParameterNameHints = "literals",
                                includeInlayParameterNameHintsWhenArgumentMatchesName = true,
                                includeInlayFunctionParameterTypeHints = true,
                                includeInlayVariableTypeHints = true,
                                includeInlayVariableTypeHintsWhenTypeMatchesName = true,
                                includeInlayPropertyDeclarationTypeHints = true,
                                includeInlayFunctionLikeReturnTypeHints = true,
                                includeInlayEnumMemberValueHints = true,
                            },
                        },
                    },
                })
            end,

            ["gopls"] = function()
                setup_and_start("gopls", {
                    settings = {
                        gopls = {
                            hints = {
                                rangeVariableTypes = true,
                                parameterNames = true,
                                constantValues = true,
                                assignVariableTypes = true,
                                compositeLiteralFields = true,
                                compositeLiteralTypes = true,
                                functionTypeParameters = true,
                            },
                        },
                    },
                })
            end,

            ["yamlls"] = function()
                setup_and_start("yamlls", {
                    capabilities = capabilities,
                    handlers = handlers,
                    settings = {
                        yaml = {
                            schemas = {
                                kubernetes = "*.yaml",
                                ["http://json.schemastore.org/github-workflow"] = ".github/workflows/*",
                                ["http://json.schemastore.org/github-action"] = ".github/action.{yml,yaml}",
                                ["http://json.schemastore.org/ansible-stable-2.9"] = "roles/tasks/*.{yml,yaml}",
                                ["http://json.schemastore.org/prettierrc"] = ".prettierrc.{yml,yaml}",
                                ["http://json.schemastore.org/kustomization"] = "kustomization.{yml,yaml}",
                                ["http://json.schemastore.org/ansible-playbook"] = "*play*.{yml,yaml}",
                                ["http://json.schemastore.org/chart"] = "Chart.{yml,yaml}",
                                ["https://json.schemastore.org/dependabot-v2"] = ".github/dependabot.{yml,yaml}",
                                ["https://json.schemastore.org/gitlab-ci"] = "*gitlab-ci*.{yml,yaml}",
                                ["https://raw.githubusercontent.com/OAI/OpenAPI-Specification/main/schemas/v3.1/schema.json"] = "*api*.{yml,yaml}",
                                ["https://raw.githubusercontent.com/compose-spec/compose-spec/master/schema/compose-spec.json"] = "*docker-compose*.{yml,yaml}",
                                ["https://raw.githubusercontent.com/argoproj/argo-workflows/master/api/jsonschema/schema.json"] = "*flow*.{yml,yaml}",
                            },
                        },
                    },
                })
            end,
        })

        vim.cmd("autocmd BufRead,BufNewFile Dockerfile* setfiletype dockerfile")
    end,
}
