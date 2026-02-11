require("conform").setup({
    format_on_save = {
        -- These options will be passed to conform.format()
        lsp_format = "fallback",
    },
    formatters_by_ft = {
        javascript = { "biome" },
        typescript = { "biome" },
        javascriptreact = { "biome" },
        typescriptreact = { "biome" },
        json = { "biome" },
        css = { "biome" },
        yaml = { "prettier" },
        html = { "prettier" },
        markdown = { "prettier" },
        lua = { "lsp" },
    },
})
