local lsp_zero = require('lsp-zero')

lsp_zero.on_attach(function(client, bufnr)
    local opts = { buffer = bufnr }

    vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
    vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
    vim.keymap.set('n', 'go', vim.lsp.buf.type_definition, opts)
    vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
    vim.keymap.set('n', 'gs', vim.lsp.buf.signature_help, opts)
    vim.keymap.set('n', '<F2>', vim.lsp.buf.rename, opts)
    vim.keymap.set({ 'n', 'x' }, '<leader>for', function()
        vim.lsp.buf.format({ async = true })
    end, opts)
    vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, opts)
end)

require('mason-lspconfig').setup({
    ensure_installed = {
        'clangd',
        'pyright',
        'html',
        'lua_ls',
        'graphql',
        'ts_ls',
        'cssls',
    },
    automatic_installation = true,
})

local cmp = require('cmp')

cmp.setup({
    sources = {
        { name = 'nvim_lsp' },
        -- add others if you want
    },
    snippet = {
        expand = function(args)
            -- use your snippet engine here; for example, if using vsnip:
            vim.snippet.expand(args.body)
        end,
    },
    mapping = cmp.mapping.preset.insert({}),
})

lsp_zero.configure('lua_ls', {
    settings = {
        Lua = {
            diagnostics = {
                globals = { 'vim' }
            },
            format = { enable = true }
        }
    }
})

lsp_zero.configure('graphql', {
    filetypes = { "graphql", "javascript", "typescript", "typescriptreact" },
    root_dir = require("lspconfig.util").root_pattern(
        ".graphqlrc*", "graphql.config.*", "package.json"
    ),
})

lsp_zero.configure('ts_ls', {
    init_options = {
        maxTsServerMemory = 24576,
        preferences = { preserveSymlinks = true },
    },
    on_attach = function(client)
        client.server_capabilities.documentFormattingProvider = false
    end,
    root_dir = function(fname)
        local util = require("lspconfig.util")

        -- First: try to find tsconfig.base.json
        local base_root = util.root_pattern("tsconfig.base.json")(fname)
        if base_root then
            -- Force everything to use this single root
            return base_root
        end

        -- Otherwise: use per-package tsconfig/package.json
        return util.root_pattern("tsconfig.json", "package.json", ".git")(fname)
    end,
    single_file_support = false, -- prevents spawning an extra tsserver for loose files
})

lsp_zero.setup({
})
