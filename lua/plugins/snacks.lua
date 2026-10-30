return {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    opts = {
        input = {
            enabled = true,
            icon = "",
            win = {
                relative = "cursor",
                row = 0,
                col = 0,
                width = 40,
                max_width = 140,
                border = "rounded",
                title_pos = "left",
                keys = {
                    -- Match the global Ctrl-C -> Esc behavior without cancelling the prompt.
                    i_ctrl_c = { "<C-c>", "stopinsert", mode = "i" },
                    n_ctrl_c = { "<C-c>", "cancel", mode = "n" },
                    q = false,
                },
            },
        },
        picker = {
            enabled = true,
            ui_select = true,
            sources = {
                select = {
                    -- Keep vim.ui.select close to Dressing's Telescope dropdown.
                    layout = {
                        preset = "select",
                        layout = {
                            width = 80,
                            min_width = 0,
                            max_width = 80,
                            height = 15,
                            border = "rounded",
                        },
                    },
                    win = {
                        input = {
                            keys = {
                                ["<C-c>"] = { "cancel", mode = { "i", "n" } },
                            },
                        },
                        list = {
                            keys = {
                                ["<C-c>"] = "cancel",
                            },
                        },
                    },
                },
            },
        },
    },
}
