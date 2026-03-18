return {
    "saghen/blink.cmp",
    version = "1.*",
    event = { "InsertEnter", "CmdlineEnter" },
    dependencies = {
        "rafamadriz/friendly-snippets",
    },
    opts = {
        enabled = function()
            return not vim.list_contains({ "DressingInput" }, vim.bo.filetype)
                and vim.bo.buftype ~= "prompt"
                and vim.b.completion ~= false
        end,
        keymap = {
            preset = "default",
            ["<Tab>"] = { "select_and_accept", "snippet_forward", "fallback" },
            ["<C-k>"] = { "select_prev", "fallback" },
            ["<C-j>"] = { "select_next", "fallback" },
            ["<CR>"] = { "accept", "fallback" },
        },
        appearance = {
            nerd_font_variant = "mono",
        },
        completion = {
            list = {
                selection = { preselect = false, auto_insert = true },
            },
            documentation = {
                auto_show = true,
                auto_show_delay_ms = 150,
                window = { border = "rounded" },
            },
            menu = {
                border = "rounded",
                draw = {
                    columns = { { "kind_icon" }, { "label", "label_description", gap = 1 } },
                },
            },
        },
        sources = {
            default = { "lsp", "buffer", "snippets", "path" },
        },
        cmdline = {
            keymap = {
                preset = "none",
                ["<Tab>"] = { "show_and_insert_or_accept_single", "select_next", "fallback" },
                ["<S-Tab>"] = { "show_and_insert_or_accept_single", "select_prev", "fallback" },
                ["<C-e>"] = { "cancel", "fallback" },
            },
        },
        fuzzy = { implementation = "prefer_rust_with_warning" },
    },
    opts_extend = { "sources.default" },
}
