return {
    "nvim-telescope/telescope.nvim",
    version = "*",
    dependencies = {
        "nvim-lua/plenary.nvim",
        { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
        "nvim-tree/nvim-web-devicons",
    },
    config = function()
        local telescope = require("telescope")
        local action_state = require("telescope.actions.state")
        local actions = require("telescope.actions")
        local action_set = require("telescope.actions.set")
        local builtin = require("telescope.builtin")

        local last_grep_query

        local function remember_grep_query(query)
            if query and query ~= "" then
                last_grep_query = query
            end
        end

        local function with_query_on_select(opts, get_query)
            local picker_opts = vim.tbl_deep_extend("force", {}, opts or {})
            local original_attach_mappings = picker_opts.attach_mappings

            picker_opts.attach_mappings = function(prompt_bufnr, map)
                local use_default_mappings = true

                if original_attach_mappings then
                    use_default_mappings = original_attach_mappings(prompt_bufnr, map) ~= false
                end

                action_set.select:enhance({
                    pre = function()
                        remember_grep_query(get_query(prompt_bufnr))
                    end,
                })

                return use_default_mappings
            end

            return picker_opts
        end

        local function live_grep_with_last_query(opts)
            local picker_opts = with_query_on_select(opts, function()
                return action_state.get_current_line()
            end)

            if last_grep_query and picker_opts.default_text == nil then
                picker_opts.default_text = last_grep_query
            end

            builtin.live_grep(picker_opts)
        end

        telescope.setup({
            defaults = {
                path_display = { "smart" },
                mappings = {
                    n = {
                        ["<C-c>"] = actions.close,
                        ["<C-p>"] = actions.move_selection_previous,
                        ["<C-n>"] = actions.move_selection_next,
                    },
                },
            },
        })

        telescope.load_extension("fzf")

        -- set keymaps
        local keymap = vim.keymap -- for conciseness

        keymap.set("n", "<leader>ff", "<cmd>Telescope find_files<cr>", { desc = "Fuzzy find files in cwd" })
        keymap.set("n", "<leader>fr", "<cmd>Telescope oldfiles<cr>", { desc = "Fuzzy find recent files" })
        keymap.set("n", "<leader>fg", "<cmd>Telescope git_files<cr>", { desc = "Fuzzy find git files" })
        keymap.set("n", "<leader>fw", live_grep_with_last_query, { desc = "Find string in cwd" })
        keymap.set("n", "<leader>fc", "<cmd>Telescope grep_string<cr>", { desc = "Find string under cursor in cwd" })
        keymap.set("n", "<leader>fh", "<cmd>Telescope help_tags<cr>", { desc = "Fuzzy find help files" })
    end,
}
