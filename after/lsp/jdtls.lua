local mise_java = vim.fn.expand("~/.local/share/mise/installs/java/")
local java_home = mise_java .. "temurin-25"
local jdtls = vim.fn.stdpath("data") .. "/mason/packages/jdtls"

-- JDT LS returns library definitions as virtual documents, not filesystem paths.
vim.api.nvim_create_autocmd("BufReadCmd", {
    group = vim.api.nvim_create_augroup("JdtlsClassFile", { clear = true }),
    pattern = "jdt://*",
    callback = function(ev)
        -- Prefer the client of the source buffer when multiple projects are open.
        local client = vim.lsp.get_clients({ name = "jdtls", bufnr = vim.fn.bufnr("#") })[1]
            or vim.lsp.get_clients({ name = "jdtls" })[1]
        assert(client, "No jdtls client available to open " .. ev.match)

        local response, err = client:request_sync("java/classFileContents", { uri = ev.match }, 10000, ev.buf)
        assert(response, "Could not load Java library source: " .. tostring(err))
        assert(not response.err, vim.inspect(response.err))
        assert(type(response.result) == "string", "JDT LS returned no source for " .. ev.match)

        local buf = vim.bo[ev.buf]
        buf.modifiable = true
        buf.swapfile = false
        buf.buftype = "nofile"
        vim.api.nvim_buf_set_lines(ev.buf, 0, -1, false, vim.split(response.result, "\n", { plain = true }))
        buf.modified = false
        buf.modifiable = false
        buf.readonly = true
        buf.filetype = "java"
        vim.lsp.buf_attach_client(ev.buf, client.id)
    end,
})

local settings = {
    java = {
        import = {
            gradle = {
                java = { home = mise_java .. "temurin-21" },
            },
        },
        configuration = {
            runtimes = {
                { name = "JavaSE-11", path = mise_java .. "temurin-11" },
                { name = "JavaSE-17", path = mise_java .. "temurin-17" },
                { name = "JavaSE-21", path = mise_java .. "temurin-21", default = true },
                { name = "JavaSE-25", path = mise_java .. "temurin-25" },
            },
        },
    },
}

return {
    cmd = function(dispatchers, config)
        -- Projects with the same directory name must have separate workspaces.
        local root = config.root_dir or vim.fn.getcwd()
        root = vim.uv.fs_realpath(root) or root
        local workspace = vim.fn.stdpath("cache") .. "/jdtls/" .. vim.fn.sha256(root)
        local cmd = {
            jdtls .. "/jdtls",
            "--java-executable=" .. java_home .. "/bin/java",
            "--jvm-arg=-javaagent:" .. jdtls .. "/lombok.jar",
            "-data",
            workspace,
        }

        for arg in (vim.env.JDTLS_JVM_ARGS or ""):gmatch("%S+") do
            table.insert(cmd, "--jvm-arg=" .. arg)
        end

        return vim.lsp.rpc.start(cmd, dispatchers, {
            cwd = config.cmd_cwd,
            env = config.cmd_env,
            detached = config.detached,
        })
    end,
    cmd_env = { JAVA_HOME = java_home },
    init_options = {
        settings = settings,
        extendedClientCapabilities = { classFileContentsSupport = true },
    },
    settings = settings,
}
