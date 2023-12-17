return {
    "zbirenbaum/copilot.lua",
    event = "InsertEnter",
    cmd = "Copilot",
    build = ":Copilot auth",
    opts = {
        suggestion = {
            auto_trigger = true,
            keymap = {
                accept = "<Tab>",
                prev = "“", -- option + [
                next = "‘", -- option + ]
            },
        },
    },
}
