return {
    {
        "neovim/nvim-lspconfig",
        event = { "BufReadPre", "BufNewFile" },
        dependencies = {
            "hrsh7th/cmp-nvim-lsp",
            { "antosha417/nvim-lsp-file-operations", config = true },
            { "j-hui/fidget.nvim", config = true },
            "mason-org/mason-lspconfig.nvim",
        },
        config = function()
            local cmp_nvim_lsp = require("cmp_nvim_lsp")

            local keymap = vim.keymap -- for conciseness

            local function set_lsp_float_highlights()
                vim.api.nvim_set_hl(0, "NormalFloat", { bg = "#1f2335" })
                vim.api.nvim_set_hl(0, "FloatBorder", { fg = "white", bg = "#1f2335" })
            end

            vim.api.nvim_create_autocmd("ColorScheme", {
                group = vim.api.nvim_create_augroup("LspFloatHighlights", { clear = true }),
                callback = set_lsp_float_highlights,
            })
            set_lsp_float_highlights()

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

            vim.lsp.config("*", { capabilities = capabilities })

            vim.lsp.enable("gleam")

            vim.lsp.config("lua_ls", {
                settings = {
                    Lua = {
                        diagnostics = { globals = { "vim" } },
                        hint = { enable = true },
                        workspace = {
                            library = {
                                [vim.fn.expand("$VIMRUNTIME/lua")] = true,
                                [vim.fn.stdpath("config") .. "/lua"] = true,
                            },
                        },
                    },
                },
            })
            vim.lsp.config("rust_analyzer", {
                settings = {
                    ["rust-analyzer"] = {
                        check = { command = "clippy" },
                        inlayHints = {
                            bindingModeHints = { enable = false },
                            chainingHints = { enable = true },
                            closingBraceHints = { enable = true, minLines = 25 },
                            closureReturnTypeHints = { enable = "never" },
                            lifetimeElisionHints = { enable = "never", useParameterNames = false },
                            maxLength = 25,
                            parameterHints = { enable = true },
                            reborrowHints = { enable = "never" },
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
            vim.lsp.config("ts_ls", {
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
            vim.lsp.config("gopls", {
                settings = {
                    gopls = {
                        hints = {
                            rangeVariableTypes = true,
                            parameterNames = false,
                            constantValues = true,
                            assignVariableTypes = true,
                            compositeLiteralFields = true,
                            compositeLiteralTypes = true,
                            functionTypeParameters = true,
                        },
                    },
                },
            })
            vim.lsp.config("yamlls", {
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
            vim.cmd("autocmd BufRead,BufNewFile Dockerfile* setfiletype dockerfile")
        end,
    },
    {
        "nvim-java/nvim-java",
        config = function()
            require("java").setup()
            local has_mise = vim.fn.executable("mise") == 1
            if not has_mise then
                vim.notify(
                    "nvim-java: `mise` is not installed (or not in PATH); skipping Java runtime auto-resolution",
                    vim.log.levels.WARN
                )
            end

            local function get_mise_runtime_path(tool)
                if not has_mise then
                    return nil
                end

                local ok, result = pcall(function()
                    return vim.system({ "mise", "where", tool }, { text = true }):wait()
                end)
                if not ok then
                    vim.notify(
                        string.format("nvim-java: error running `mise where %s`: %s", tool, tostring(result)),
                        vim.log.levels.WARN
                    )
                    return nil
                end

                if result.code ~= 0 then
                    local err = vim.trim(result.stderr or "")
                    vim.notify(
                        string.format(
                            "nvim-java: failed to resolve `%s` via mise%s",
                            tool,
                            err ~= "" and ": " .. err or ""
                        ),
                        vim.log.levels.WARN
                    )
                    return nil
                end

                local path = vim.trim(result.stdout or "")
                if path == "" then
                    vim.notify(string.format("nvim-java: empty path from `mise where %s`", tool), vim.log.levels.WARN)
                    return nil
                end

                return path
            end

            local runtime_specs = {
                { name = "JavaSE-1.8", tool = "java@zulu-8" },
                { name = "JavaSE-11", tool = "java@temurin-11" },
                { name = "JavaSE-17", tool = "java@temurin-17" },
                { name = "JavaSE-21", tool = "java@temurin-21" },
            }

            local runtimes = {}
            for _, runtime in ipairs(runtime_specs) do
                local path = get_mise_runtime_path(runtime.tool)
                local default = false
                if runtime.name == "JavaSE-17" then
                    default = true
                end
                if path then
                    table.insert(runtimes, {
                        name = runtime.name,
                        path = path,
                        default = default,
                    })
                end
            end

            vim.lsp.config("jdtls", {
                settings = {
                    java = {
                        configuration = {
                            runtimes = runtimes,
                        },
                    },
                },
            })
            vim.lsp.enable("jdtls")
        end,
    },
}
