local uv = vim.uv or vim.loop

local function has_root_file(cwd, filename)
    return uv.fs_stat(cwd .. "/" .. filename) ~= nil
end

local function is_jvm_project(cwd)
    return has_root_file(cwd, "pom.xml")
        or has_root_file(cwd, "build.gradle")
        or has_root_file(cwd, "build.gradle.kts")
end

local function apply_project_colorscheme()
    local cwd = uv.cwd() or vim.fn.getcwd()
    local colorscheme = is_jvm_project(cwd) and "jb" or "vague"

    vim.cmd("colorscheme " .. colorscheme)

    if colorscheme == "vague" then
        vim.cmd("hi statusline guibg=NONE")
    elseif colorscheme == "jb" then
        vim.api.nvim_set_hl(0, "TelescopePreviewLine", { link = "Search" })
    end
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
            -- require("jb").setup({ transparent = true })
            vim.api.nvim_create_autocmd("VimEnter", {
                once = true,
                callback = apply_project_colorscheme,
            })
        end,
    },
}
