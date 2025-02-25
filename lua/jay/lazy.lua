-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

-- Make sure to setup `mapleader` and `maplocalleader` before
-- loading lazy.nvim so that mappings are correct.
-- This is also a good place to setup other settings (vim.opt)
-- vim.g.maplocalleader = "\\"

local map = vim.keymap.set
local fn = vim.fn


-- Setup lazy.nvim
require("lazy").setup({
    -- automatically check for plugin updates
    checker = { enabled = true },
    { "nvim-treesitter" },
    { "nvim-lua/plenary.nvim" },
    { "nvim-telescope/telescope.nvim" },
    { 
        "nvim-treesitter/nvim-treesitter",
    },
    -- Icons for file explorer
    { "nvim-tree/nvim-web-devicons", opts = {} },
    { "nvim-treesitter/playground" },
    { "ThePrimeagen/harpoon" },
    { "mbbill/undotree" },
    { "tpope/vim-fugitive" },
    { "VonHeikemen/lsp-zero.nvim" },
    { "neovim/nvim-lspconfig" },
    {
        "hrsh7th/nvim-cmp",
        event = "InsertEnter",
        dependencies = {
            { "hrsh7th/cmp-nvim-lsp" },
            { "hrsh7th/cmp-vsnip" },
            { "hrsh7th/vim-vsnip" }
        },
        opts = function()
            local cmp = require("cmp")
            local conf = {
                sources = {
                    { name = "nvim_lsp" },
                    { name = "vsnip" },
                },
                snippet = {
                    expand = function(args)
                        -- Comes from vsnip
                        fn["vsnip#anonymous"](args.body)
                    end,
                },
                mapping = cmp.mapping.preset.insert({
                    -- None of this made sense to me when first looking into this since there
                    -- is no vim docs, but you can't have select = true here _unless_ you are
                    -- also using the snippet stuff. So keep in mind that if you remove
                    -- snippets you need to remove this select
                    ["<CR>"] = cmp.mapping.confirm({ select = true })
                })
            }
            return conf
        end
    },
    { "hrsh7th/cmp-nvim-lsp" },
    { "github/copilot.vim" },
    { "folke/todo-comments.nvim", opts = {} },

    -- Add gutter signs for git
    {
        "lewis6991/gitsigns.nvim",
        config = function()
            require('gitsigns').setup({
                -- Default config
                signs = {
                    add          = { text = '│' },
                    change       = { text = '│' },
                    delete       = { text = '_' },
                    topdelete    = { text = '‾' },
                    changedelete = { text = '~' },
                }
            })
        end
    },

    -- Split view in git
    {
        "sindrets/diffview.nvim",
        requires = "nvim-lua/plenary.nvim",
        config = function()
            require('diffview').setup({
                enhanced_diff_hl = true,
                view = {
                    default = {
                        layout = "diff2_horizontal",
                        winbar_info = false,
                    },
                    merge_tool = {
                        layout = "diff3_horizontal",
                        disable_diagnostics = true,
                        winbar_info = true,
                    },
                    file_history = {
                        layout = "diff2_horizontal",
                        winbar_info = false,
                    },
                    file_panel = {
                        width = 40,  -- Change this number to your preferred width
                    },
                },
                signs = {
                    fold_closed = "",
                    fold_open = "",
                    done = "✓",
                },
                signs_placement = "left",
            })
        end
    },

    -- Git blame
    { "rhysd/git-messenger.vim" },

    -- Color Themes
    { "AlexvZyl/nordic.nvim" },
    { "catppuccin/nvim" }, 

    -- fzf for fast file search
    {
        {
            "junegunn/fzf",
            build = "./install --bin",  -- Ensures the fzf binary is installed
        },
        {
            "junegunn/fzf.vim",
            dependencies = { "junegunn/fzf" },
            config = function()
                -- Keybindings for FZF commands
                vim.api.nvim_set_keymap('n', '<leader>ff', ':Files<CR>', { noremap = true, silent = true })

                -- Function to determine project root
                local function get_project_root()
                    local git_root = vim.fn.systemlist("git rev-parse --show-toplevel")
                    if vim.v.shell_error == 0 and #git_root > 0 then
                        return git_root[1]
                    else
                        return vim.fn.getcwd() -- Fallback to current working directory
                    end
                end

                -- Create a custom command 'RgExact' that takes arguments.
                vim.api.nvim_create_user_command("RgExact", function(opts)
                    local query = opts.args
                    if query == "" then
                        query = vim.fn.input("Rg (exact)> ")
                        if query == "" then return end
                    end

                    local root_dir = get_project_root()
                    local escaped_query = vim.fn.shellescape(query)
                    local escaped_root_dir = vim.fn.shellescape(root_dir)

                    local cmd = string.format(
                    "rg --fixed-strings --color=always --line-number --column --no-heading %s -g '*' --glob '!bazel/**' --glob '!node_modules/**' %s",
                    escaped_query, escaped_root_dir
                    )

                    vim.fn["fzf#vim#grep"](cmd, 1, vim.fn["fzf#vim#with_preview"](), opts.bang and 1 or 0)
                end, {
                nargs = "*",
                bang = true,
                desc = "Search with ripgrep in exact (literal) mode from project root",
            })

            -- Map <leader>fg to run RgExact with the word under the cursor.
            vim.api.nvim_set_keymap(
            "n",
            "<leader>fg",
            ":RgExact <C-R>=expand('<cword>')<CR><CR>",
            { noremap = true, silent = true }
            )

            -- Search for exact string match, case-insensitive
            vim.api.nvim_create_user_command("RgIgnoreCase", function(opts)
                local query = opts.args
                if query == "" then
                    query = vim.fn.input("Rg (ignore case)> ")
                    if query == "" then return end
                end

                local root_dir = get_project_root()
                local escaped_query = vim.fn.shellescape(query)
                local escaped_root_dir = vim.fn.shellescape(root_dir)

                local cmd = string.format(
                "rg --ignore-case --color=always --line-number --column --no-heading %s -g '*' %s",
                escaped_query, escaped_root_dir
                )

                vim.fn["fzf#vim#grep"](cmd, 1, vim.fn["fzf#vim#with_preview"](), opts.bang and 1 or 0)
            end, {
            nargs = "*",
            bang = true,
            desc = "Search with ripgrep ignoring case from project root",
        })

        -- Map <leader>fi to invoke the RgIgnoreCase command.
        vim.api.nvim_set_keymap("n", "<leader>fi", ":RgIgnoreCase<CR>", { noremap = true, silent = true })
    end
}
},
    {
       "scalameta/nvim-metals",
        dependencies = {
            "nvim-lua/plenary.nvim",
            {
                "j-hui/fidget.nvim",
                opts = {},
            },
            {
                "mfussenegger/nvim-dap",
                config = function(self, opts)
                    -- Debug settings if you're using nvim-dap
                    local dap = require("dap")

                    dap.configurations.scala = {
                        {
                            type = "scala",
                            request = "launch",
                            name = "RunOrTest",
                            metals = {
                                runType = "runOrTestFile",
                                --args = { "firstArg", "secondArg", "thirdArg" }, -- here just as an example
                            },
                        },
                        {
                            type = "scala",
                            request = "launch",
                            name = "Test Target",
                            metals = {
                                runType = "testTarget",
                            },
                        },
                    }
                end
            },
        },
        ft = { "scala", "sbt", "java" },
        opts = function()
            local metals_config = require("metals").bare_config()

            -- Example of settings
            metals_config.settings = {
                showImplicitArguments = true,
                excludedPackages = { "akka.actor.typed.javadsl", "com.github.swagger.akka.javadsl" },
            }

            -- *READ THIS*
            -- I *highly* recommend setting statusBarProvider to either "off" or "on"
            --
            -- "off" will enable LSP progress notifications by Metals and you'll need
            -- to ensure you have a plugin like fidget.nvim installed to handle them.
            --
            -- "on" will enable the custom Metals status extension and you *have* to have
            -- a have settings to capture this in your statusline or else you'll not see
            -- any messages from metals. There is more info in the help docs about this
            metals_config.init_options.statusBarProvider = "off"

            -- Example if you are using cmp how to make sure the correct capabilities for snippets are set
            metals_config.capabilities = require("cmp_nvim_lsp").default_capabilities()

            metals_config.on_attach = function(client, bufnr)
                require("metals").setup_dap()

                -- LSP mappings
                map("n", "gD", vim.lsp.buf.definition)
                map("n", "K", vim.lsp.buf.hover)
                map("n", "gi", vim.lsp.buf.implementation)
                map("n", "gr", vim.lsp.buf.references)
                map("n", "gds", vim.lsp.buf.document_symbol)
                map("n", "gws", vim.lsp.buf.workspace_symbol)
                map("n", "<leader>cl", vim.lsp.codelens.run)
                map("n", "<leader>sh", vim.lsp.buf.signature_help)
                map("n", "<leader>rn", vim.lsp.buf.rename)
                map("n", "<leader>f", vim.lsp.buf.format)
                map("n", "<leader>ca", vim.lsp.buf.code_action)

                map("n", "<leader>ws", function()
                    require("metals").hover_worksheet()
                end)

                -- all workspace diagnostics
                map("n", "<leader>aa", vim.diagnostic.setqflist)

                -- all workspace errors
                map("n", "<leader>ae", function()
                    vim.diagnostic.setqflist({ severity = "E" })
                end)

                -- all workspace warnings
                map("n", "<leader>aw", function()
                    vim.diagnostic.setqflist({ severity = "W" })
                end)

                -- buffer diagnostics only
                map("n", "<leader>d", vim.diagnostic.setloclist)

                map("n", "[c", function()
                    vim.diagnostic.goto_prev({ wrap = false })
                end)

                map("n", "]c", function()
                    vim.diagnostic.goto_next({ wrap = false })
                end)

                -- Example mappings for usage with nvim-dap. If you don't use that, you can
                -- skip these
                map("n", "<leader>dc", function()
                    require("dap").continue()
                end)

                map("n", "<leader>dr", function()
                    require("dap").repl.toggle()
                end)

                map("n", "<leader>dK", function()
                    require("dap.ui.widgets").hover()
                end)

                map("n", "<leader>dt", function()
                    require("dap").toggle_breakpoint()
                end)

                map("n", "<leader>dso", function()
                    require("dap").step_over()
                end)

                map("n", "<leader>dsi", function()
                    require("dap").step_into()
                end)

                map("n", "<leader>dl", function()
                    require("dap").run_last()
                end)
            end

            return metals_config
        end,
        config = function(self, metals_config)
            local nvim_metals_group = vim.api.nvim_create_augroup("nvim-metals", { clear = true })
            vim.api.nvim_create_autocmd("FileType", {
                pattern = self.ft,
                callback = function()
                    require("metals").initialize_or_attach(metals_config)
                end,
                group = nvim_metals_group,
            })
        end

    }
    })
