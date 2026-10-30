return {
    "ThePrimeagen/refactoring.nvim",
    lazy = false,
    dependencies = {
        "lewis6991/async.nvim",
    },
    config = function()
        local refactoring = require("refactoring")
        refactoring.setup()

        local function map(lhs, method, desc, mode)
            vim.keymap.set(mode or { "n", "x" }, lhs, function()
                return refactoring[method]()
            end, { expr = true, silent = true, desc = desc })
        end

        map("<leader>rf", "extract_func", "Extract function")
        map("<leader>rv", "extract_var", "Extract variable")
        map("<leader>ri", "inline_var", "Inline variable")
        map("<leader>rI", "inline_func", "Inline function")

        -- Block extraction now uses the function operator followed by a motion/textobject.
        map("<leader>rb", "extract_func", "Extract block using motion", "n")
        map("<leader>rbf", "extract_func_to_file", "Extract block to file using motion", "n")
    end,
}
