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
            vim.fn["vsnip#anonymous"](args.body)
        end,
    },
    mapping = cmp.mapping.preset.insert({}),
})


lsp_zero.setup({
    capabilities = require('cmp_nvim_lsp').default_capabilities(),
})

-- Optional: custom server config
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
