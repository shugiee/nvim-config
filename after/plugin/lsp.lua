---
-- LSP configuration
---
local lsp_zero = require('lsp-zero')

local lsp_attach = function(client, bufnr)
    local opts = { buffer = bufnr }

    vim.keymap.set('n', 'K', '<cmd>lua vim.lsp.buf.hover()<cr>', opts)
    vim.keymap.set('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<cr>', opts)
    vim.keymap.set('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<cr>', opts)
    vim.keymap.set('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<cr>', opts)
    vim.keymap.set('n', 'go', '<cmd>lua vim.lsp.buf.type_definition()<cr>', opts)
    vim.keymap.set('n', 'gr', '<cmd>lua vim.lsp.buf.references()<cr>', opts)
    vim.keymap.set('n', 'gs', '<cmd>lua vim.lsp.buf.signature_help()<cr>', opts)
    vim.keymap.set('n', '<F2>', '<cmd>lua vim.lsp.buf.rename()<cr>', opts)
    vim.keymap.set({ 'n', 'x' }, '<F3>', '<cmd>lua vim.lsp.buf.format({async = true})<cr>', opts)
    vim.keymap.set('n', '<F4>', '<cmd>lua vim.lsp.buf.code_action()<cr>', opts)
end

require("mason-lspconfig").setup {
    ensure_installed = { "graphql", "cssls", "html", "lua_ls" },
}

lsp_zero.extend_lspconfig({
    sign_text = true,
    lsp_attach = lsp_attach,
    capabilities = require('cmp_nvim_lsp').default_capabilities(),
})

lspconfig = require('lspconfig')
lspconfig.clangd.setup({})
lspconfig.pyright.setup({})
lspconfig.html.setup({})
lspconfig.lua_ls.setup({
    settings = {
        Lua = {
            format = {
                enable = true,
            },
            diagnostics = {
                globals = { "vim" },
            },
        },
    },
})

-- This isn't working yet
require("lspconfig").graphql.setup({
    filetypes = { "graphql", "javascript", "typescript", "typescriptreact" },
    root_dir = require("lspconfig.util").root_pattern(".graphqlrc*", "graphql.config.*", "package.json"),
})

-- Make sure TS uses only one root tsconfig file
lspconfig.ts_ls.setup({
    init_options = {
        maxTsServerMemory = 24576, -- Set memory limit to 24GB
        preferences = {
            preserveSymlinks = true
        },
    },
    on_attach = function(client, bufnr)
        client.server_capabilities.documentFormattingProvider = false
    end,
})

lspconfig.cssls.setup({
    settings = {
        css = { validate = true },
        scss = { validate = true },
        less = { validate = true },
    },
})

-- Per chatgpt, enable diagnostics for debugging
vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
    vim.lsp.diagnostic.on_publish_diagnostics, {
        -- Configure how you want diagnostics to be displayed, e.g., signs, virtual text, etc.
        virtual_text = true,      -- Show diagnostics as virtual text inline with code
        signs = true,             -- Display LSP signs in the sign column
        update_in_insert = false, -- Avoid showing diagnostics while typing
        underline = true,         -- Underline error/warning text
        severity_sort = true,     -- Sort diagnostics by severity
    }
)


---
-- Autocompletion setup
---
local cmp = require('cmp')

cmp.setup({
    sources = {
        { name = 'nvim_lsp' },
    },
    snippet = {
        expand = function(args)
            -- You need Neovim v0.10 to use vim.snippet
            vim.snippet.expand(args.body)
        end,
    },
    mapping = cmp.mapping.preset.insert({}),
})
