return {
    "justinmk/vim-sneak",
    keys = {
        { "s", mode = { "n", "x", "o" }, desc = "Sneak Forward to" },
        { "S", mode = { "n", "x", "o" }, desc = "Sneak Backward to" },
        { "gs", mode = { "n", "x", "o" }, desc = "Sneak from Windows" },
    },
    init = function()
        vim.g["sneak#use_ic_scs"] = true
    end,
}
