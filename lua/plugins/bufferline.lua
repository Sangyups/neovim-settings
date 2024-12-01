return {
    "akinsho/bufferline.nvim",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = { "nvim-tree/nvim-web-devicons" },
    version = "*",
    opts = {
        options = {
            separator_style = "slant",
        },
    },
}
