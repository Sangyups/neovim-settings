local function apply_project_colorscheme()
    vim.cmd("colorscheme vague")
    vim.cmd("hi statusline guibg=NONE")
end

return {
    {
        "rose-pine/neovim",
        name = "rose-pine",
        lazy = false,
        priority = 1000,
        config = function()
            require("rose-pine").setup({
                disable_background = true,
                disable_float_background = true,
                styles = {
                    italic = false,
                },
            })
            -- vim.cmd("colorscheme rose-pine-moon")
        end,
    },
    {
        "vague2k/vague.nvim",
        lazy = false,
        priority = 1000,
        config = function()
            require("vague").setup({
                transparent = true,
                style = {
                    strings = "bold",
                },
            })
        end,
    },
    {
        "nickkadutskyi/jb.nvim",
        lazy = false,
        priority = 1000,
        config = function()
            vim.api.nvim_create_autocmd("VimEnter", {
                once = true,
                callback = apply_project_colorscheme,
            })
        end,
    },
}
