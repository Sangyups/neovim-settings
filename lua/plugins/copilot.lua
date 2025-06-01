return {
    "zbirenbaum/copilot.lua",
    event = "InsertEnter",
    cmd = "Copilot",
    opts = {
        suggestion = {
            auto_trigger = true,
            keymap = {
                accept = "<C-y>",
                prev = "“", -- option + [
                next = "‘", -- option + ]
            },
        },
    },
    config = function(_, opts)
        require("copilot").setup(opts)
        vim.cmd(":Copilot disable")
    end,
}
