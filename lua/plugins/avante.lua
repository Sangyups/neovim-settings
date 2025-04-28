return {
    "yetone/avante.nvim",
    event = "VeryLazy",
    lazy = false,
    version = "*",
    opts = {
        provider = "openai",
        openai = {
            endpoint = "https://api.openai.com/v1",
            model = "o3-mini",
            timeout = 18000,
            temperature = 0,
            max_completion_tokens = 8192,
            reasoning_effort = "high",
        },
        copilot = {
            model = "claude-3.7-sonnet",
        },
    },
    build = "make",
    dependencies = {
        "nvim-treesitter/nvim-treesitter",
        "stevearc/dressing.nvim",
        "nvim-lua/plenary.nvim",
        "MunifTanjim/nui.nvim",
        "nvim-tree/nvim-web-devicons",
        "zbirenbaum/copilot.lua",
        {
            "HakonHarnes/img-clip.nvim",
            event = "VeryLazy",
            opts = {
                default = {
                    embed_image_as_base64 = false,
                    prompt_for_file_name = false,
                    drag_and_drop = {
                        insert_mode = true,
                    },
                },
            },
        },
        {
            "MeanderingProgrammer/render-markdown.nvim",
            opts = {
                file_types = { "Avante", "markdown" },
            },
            ft = { "Avante", "markdown" },
        },
    },
}
