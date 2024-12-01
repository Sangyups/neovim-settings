return {
    "ThePrimeagen/refactoring.nvim",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-treesitter/nvim-treesitter",
    },
    config = function()
        require("refactoring").setup()

        local opts = { silent = true }

        vim.keymap.set("x", "<leader>rf", ":Refactor extract<CR>")
        vim.keymap.set("x", "<leader>rv", ":Refactor extract_var<CR>", opts)

        vim.keymap.set({ "n", "x" }, "<leader>ri", ":Refactor inline_var")

        vim.keymap.set("n", "<leader>rI", ":Refactor inline_func")

        vim.keymap.set("n", "<leader>rb", ":Refactor extract_block")
        vim.keymap.set("n", "<leader>rbf", ":Refactor extract_block_to_file")
    end,
}
