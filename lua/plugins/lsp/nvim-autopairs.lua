return {
    "windwp/nvim-autopairs",
    event = { "InsertEnter" },
    dependencies = {
        "saghen/blink.cmp",
    },
    config = function()
        local autopairs = require("nvim-autopairs")

        autopairs.setup({
            check_ts = true,
            ts_config = {
                lua = { "string" },
                javascript = { "template_string" },
            },
        })

        local Rule = require("nvim-autopairs.rule")
        local cond = require("nvim-autopairs.conds")

        autopairs.add_rules({
            Rule("<", ">", { "java", "typescript", "typescriptreact", "rust", "go", "kotlin", "cs" })
                :with_pair(cond.before_regex("%a"))
                :with_move(cond.after_text(">")),
        })
    end,
}
