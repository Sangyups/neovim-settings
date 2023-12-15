return {
    "ggandor/leap.nvim",
    enabled = true,
    keys = {
        { "s", mode = { "n", "x", "o" }, desc = "Leap forward to" },
        { "S", mode = { "n", "x", "o" }, desc = "Leap backward to" },
        { "gs", mode = { "n", "x", "o" }, desc = "Leap from windows" },
    },
    config = function(_, opts)
        local leap = require("leap")
        for k, v in pairs(opts) do
            leap.opts[k] = v
        end
        leap.add_default_mappings(true)
        leap.add_repeat_mappings(";", ",", {
            -- False by default. If set to true, the keys will work like the
            -- native semicolon/comma, i.e., forward/backward is understood in
            -- relation to the last motion.
            relative_directions = true,
            modes = { "n", "x" },
        })
        vim.keymap.del({ "x", "o" }, "x")
        vim.keymap.del({ "x", "o" }, "X")
    end,
}
