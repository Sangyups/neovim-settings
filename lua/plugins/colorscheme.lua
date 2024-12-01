return {
    {
        "briones-gabriel/darcula-solid.nvim",
        dependencies = { "rktjmp/lush.nvim" },
        lazy = false,
        priority = 1000,
        config = function()
            local lush = require("lush")
            local darcula_solid = require("lush_theme.darcula-solid")

            local spec = lush.extends({ darcula_solid }).with(function()
                return {
                    Visual({ bg = lush.hsl(223, 51, 33) }),
                    String({ fg = lush.hsl(83, 27, 53), gui = "bold" }),
                }
            end)

            lush(spec)
        end,
    },
    {
        "ntk148v/habamax.nvim",
        -- lazy = false,
        -- priority = 1000,
        -- dependencies = {
        --     "rktjmp/lush.nvim",
        -- },
        -- config = function()
        --     vim.cmd("colorscheme habamax")
        -- end,
    },
    {
        "projekt0n/github-nvim-theme",
        -- lazy = false,
        -- priority = 1000,
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
        -- lazy = false,
        -- priority = 1000,
        -- config = function()
        --     require("rose-pine").setup({
        --         disable_background = true,
        --         disable_float_background = true,
        --         styles = {
        --             italic = false,
        --         },
        --     })
        --     vim.cmd("colorscheme rose-pine-moon")
        -- end,
    },
}
