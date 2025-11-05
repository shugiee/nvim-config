---
-- LSP configuration
---
local capabilities = require('cmp_nvim_lsp').default_capabilities()

-- Configure LSP popup window borders
vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
    border = "rounded",
    max_width = 80,
    max_height = 30,
})

-- Alternative approach - override the default window config
local orig_util_open_floating_preview = vim.lsp.util.open_floating_preview
function vim.lsp.util.open_floating_preview(contents, syntax, opts, ...)
    opts = opts or {}
    opts.border = opts.border or "rounded"
    return orig_util_open_floating_preview(contents, syntax, opts, ...)
end

vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
    border = "rounded",
    max_width = 80,
    max_height = 30,
})

-- Configure diagnostic popups with borders
vim.diagnostic.config({
    float = {
        border = "rounded",
        source = "always",
        header = "",
        prefix = "",
    },
})

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
    vim.keymap.set({ 'n', 'x' }, '<leader>for', '<cmd>lua vim.lsp.buf.format({async = true})<cr>', opts)
    vim.keymap.set('n', '<leader>ca', '<cmd>lua vim.lsp.buf.code_action()<cr>', opts)
end



-- Configure LSP signs
local signs = { Error = "󰅚 ", Warn = "󰀪 ", Hint = "󰌶 ", Info = " " }
for type, icon in pairs(signs) do
    local hl = "DiagnosticSign" .. type
    vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
end

-- C/C++
vim.lsp.config('clangd', {
    capabilities = capabilities,
    on_attach = lsp_attach,
})

-- Python
vim.lsp.config('pyright', {
    capabilities = capabilities,
    on_attach = lsp_attach,
})

-- HTML
vim.lsp.config('html', {
    capabilities = capabilities,
    on_attach = lsp_attach,
})

-- Lua
vim.lsp.config('lua_ls', {
    capabilities = capabilities,
    on_attach = lsp_attach,
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

-- GraphQL
vim.lsp.config('graphql', {
    capabilities = capabilities,
    on_attach = lsp_attach,
    filetypes = { "typescript" },
    root_dir = require("lspconfig.util").root_pattern(".graphqlrc*", "graphql.config.*", "package.json"),
    settings = {
        graphql = {
            introspection = {
                file = "**/*{_fragment_defs,_def}.ts"
            }
        }
    }
})

-- TypeScript/JavaScript
vim.lsp.config('ts_ls', {
    capabilities = capabilities,
    on_attach = function(client, bufnr)
        client.server_capabilities.documentFormattingProvider = false
        lsp_attach(client, bufnr)
    end,
    root_dir = function(fname)
        return "/Users/jonathanolson/sandbox/asana"
    end,
    init_options = {
        maxTsServerMemory = 24576, -- Set memory limit to 24GB
        preferences = {
            preserveSymlinks = true
        },
    },
})

-- CSS
vim.lsp.config('cssls', {
    capabilities = capabilities,
    on_attach = lsp_attach,
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
    window = {
        completion = cmp.config.window.bordered(),
        documentation = cmp.config.window.bordered(),
    },
})
