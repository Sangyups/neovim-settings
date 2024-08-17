return {
    {
        "ntk148v/habamax.nvim",
        lazy = false, -- make sure we load this during startup if it is your main colorscheme
        priority = 1000, -- make sure to load this before all the other start plugins
        dependencies = {
            "rktjmp/lush.nvim",
        },
        -- config = function()
        --     vim.cmd("colorscheme habamax")
        -- end,
    },
    {
        "projekt0n/github-nvim-theme",
        lazy = false, -- make sure we load this during startup if it is your main colorscheme
        priority = 1000, -- make sure to load this before all the other start plugins
        -- config = function()
        --     local specs = {
        --         github_dark_default = {
        --             bg1 = "#333333",
        --         },
        --     }
        --     require("github-theme").setup({ specs = specs })
        --     vim.cmd("colorscheme github_dark_default")
        -- end,
    },
    {
        "rose-pine/neovim",
        name = "rose-pine",
        lazy = false, -- make sure we load this during startup if it is your main colorscheme
        priority = 1000, -- make sure to load this before all the other start plugins
        config = function()
            require("rose-pine").setup({
                disable_background = true,
                disable_float_background = true,
                styles = {
                    italic = false,
                },
            })
            vim.cmd("colorscheme rose-pine-moon")
        end,
    },
}
