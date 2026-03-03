local function has_root_file(cwd, filename)
    return vim.fn.filereadable(cwd .. "/" .. filename) == 1
end

local function is_jvm_project(cwd)
    return has_root_file(cwd, "pom.xml") or has_root_file(cwd, "build.gradle") or has_root_file(cwd, "build.gradle.kts")
end

local function set_highlight_without_underline(target, source)
    local ok, source_hl = pcall(vim.api.nvim_get_hl, 0, { name = source, link = false })
    if not ok or type(source_hl) ~= "table" or next(source_hl) == nil then
        return
    end

    ---@type vim.api.keyset.highlight
    local hl = {
        fg = source_hl.fg,
        bg = source_hl.bg,
        sp = source_hl.sp,
        blend = source_hl.blend,
        bold = source_hl.bold,
        standout = source_hl.standout,
        strikethrough = source_hl.strikethrough,
        italic = source_hl.italic,
        reverse = source_hl.reverse,
        nocombine = source_hl.nocombine,
        ctermfg = source_hl.ctermfg,
        ctermbg = source_hl.ctermbg,
        underline = false,
        undercurl = false,
        underdouble = false,
        underdotted = false,
        underdashed = false,
    }

    vim.api.nvim_set_hl(0, target, hl)
end

local function apply_project_colorscheme()
    local cwd = vim.fn.getcwd()
    local colorscheme = is_jvm_project(cwd) and "jb" or "vague"

    vim.cmd("colorscheme " .. colorscheme)

    if colorscheme == "vague" then
        vim.cmd("hi statusline guibg=NONE")
    elseif colorscheme == "jb" then
        set_highlight_without_underline("TelescopePreviewLine", "Search")
        set_highlight_without_underline("TelescopePreviewMatch", "Search")
        set_highlight_without_underline("TelescopeMatching", "TelescopeMatching")
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
            vim.api.nvim_create_autocmd("VimEnter", {
                once = true,
                callback = apply_project_colorscheme,
            })
        end,
    },
}
