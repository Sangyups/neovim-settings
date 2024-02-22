return {
    "lukas-reineke/indent-blankline.nvim",
    event = { "BufReadPre", "BufNewFile" },
    opts = {
        indent = {
            char = "│",
            tab_char = "│",
        },
        scope = { enabled = true },
        exclude = {
            filetypes = {
                "help",
                "alpha",
                "dashboard",
                "neo-tree",
                "lazy",
                "mason",
                "notify",
                "toggleterm",
                "lazyterm",
            },
        },
    },
    main = "ibl",
}
