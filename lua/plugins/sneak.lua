return {
    "justinmk/vim-sneak",
    keys = {
        { "s", mode = { "n", "x", "o" }, desc = "Sneak Forward to" },
        { "S", mode = { "n", "x", "o" }, desc = "Sneak Backward to" },
        { "gs", mode = { "n", "x", "o" }, desc = "Sneak from Windows" },
        { "dz", mode = { "n" }, desc = "Delete with sneak" },
        { "cz", mode = { "n" }, desc = "Change with sneak" },
        { "yz", mode = { "n" }, desc = "Yank with sneak" },
    },
    init = function()
        vim.g["sneak#use_ic_scs"] = true
    end,
}
