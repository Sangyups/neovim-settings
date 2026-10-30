return {
    "nvim-treesitter/nvim-treesitter-textobjects",
    branch = "main",
    lazy = true,
    config = function()
        local textobjects = require("nvim-treesitter-textobjects")
        local mappings = {
            select = {
                -- Automatically jump forward to textobj, similar to targets.vim
                lookahead = true,

                keymaps = {
                    -- You can use the capture groups defined in textobjects.scm
                    ["aa"] = { query = "@parameter.outer", desc = "Select outer part of a parameter/argument" },
                    ["ia"] = { query = "@parameter.inner", desc = "Select inner part of a parameter/argument" },

                    ["ai"] = { query = "@conditional.outer", desc = "Select outer part of a conditional" },
                    ["ii"] = { query = "@conditional.inner", desc = "Select inner part of a conditional" },

                    ["al"] = { query = "@loop.outer", desc = "Select outer part of a loop" },

                    ["af"] = {
                        query = "@function.outer",
                        desc = "Select outer part of a method/function definition",
                    },
                    ["if"] = {
                        query = "@function.inner",
                        desc = "Select inner part of a method/function definition",
                    },

                    ["ac"] = { query = "@class.outer", desc = "Select outer part of a class" },
                    ["ic"] = { query = "@class.inner", desc = "Select inner part of a class" },
                },
            },
            move = {
                set_jumps = true, -- whether to set jumps in the jumplist
                goto_next_start = {
                    ["]f"] = { query = "@function.outer", desc = "Next method/function def start" },
                    ["]c"] = { query = "@class.outer", desc = "Next class start" },
                    ["]i"] = { query = "@conditional.outer", desc = "Next conditional start" },
                    ["]l"] = { query = "@loop.outer", desc = "Next loop start" },
                },
                goto_next_end = {
                    ["]F"] = { query = "@function.outer", desc = "Next method/function def end" },
                    ["]C"] = { query = "@class.outer", desc = "Next class end" },
                    ["]I"] = { query = "@conditional.outer", desc = "Next conditional end" },
                    ["]L"] = { query = "@loop.outer", desc = "Next loop end" },
                },
                goto_previous_start = {
                    ["[f"] = { query = "@function.outer", desc = "Prev method/function def start" },
                    ["[c"] = { query = "@class.outer", desc = "Prev class start" },
                    ["[i"] = { query = "@conditional.outer", desc = "Prev conditional start" },
                    ["[l"] = { query = "@loop.outer", desc = "Prev loop start" },
                },
                goto_previous_end = {
                    ["[F"] = { query = "@function.outer", desc = "Prev method/function def end" },
                    ["[C"] = { query = "@class.outer", desc = "Prev class end" },
                    ["[I"] = { query = "@conditional.outer", desc = "Prev conditional end" },
                    ["[L"] = { query = "@loop.outer", desc = "Prev loop end" },
                },
            },
        }

        if not textobjects.setup then
            -- Keep the current lockfile usable until the plugin update is performed.
            mappings.select.enable = true
            mappings.move.enable = true
            require("nvim-treesitter.configs").setup({ textobjects = mappings })
            return
        end

        textobjects.setup({
            select = { lookahead = mappings.select.lookahead },
            move = { set_jumps = mappings.move.set_jumps },
        })

        for lhs, mapping in pairs(mappings.select.keymaps) do
            vim.keymap.set({ "x", "o" }, lhs, function()
                require("nvim-treesitter-textobjects.select").select_textobject(mapping.query, "textobjects")
            end, { desc = mapping.desc })
        end

        for method, keymaps in pairs(mappings.move) do
            if type(keymaps) == "table" then
                for lhs, mapping in pairs(keymaps) do
                    vim.keymap.set({ "n", "x", "o" }, lhs, function()
                        require("nvim-treesitter-textobjects.move")[method](mapping.query, "textobjects")
                    end, { desc = mapping.desc })
                end
            end
        end
    end,
}
