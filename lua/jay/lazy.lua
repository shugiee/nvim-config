-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
    local lazyrepo = "https://github.com/folke/lazy.nvim.git"
    local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
    if vim.v.shell_error ~= 0 then
        vim.api.nvim_echo({
            { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
            { out,                            "WarningMsg" },
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
    {
        "ThePrimeagen/harpoon",
        branch = "harpoon2",
        dependencies = { "nvim-lua/plenary.nvim" }
    },
    { "mbbill/undotree" },
    { "tpope/vim-fugitive" },
    { "VonHeikemen/lsp-zero.nvim" },
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
    -- { "github/copilot.vim" }, -- Disabled since it's breaking Lsp
    { "folke/todo-comments.nvim", opts = {} },
    {
        "folke/zen-mode.nvim",
        opts = {
            window = {
                width = 200,
            },
        }
    },

    -- Add gutter signs for git
    {
        "lewis6991/gitsigns.nvim",
        config = function()
            require('gitsigns').setup({
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
                },
                file_panel = {
                    listing_style = "list",
                    win_config = {
                        position = "left",
                        width = 60, -- Instead of width
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
    --    {
    --        'sainnhe/everforest',
    --        lazy = false,
    --        priority = 1000,
    --        config = function()
    --            -- Optionally configure and load the colorscheme
    --            -- directly inside the plugin declaration.
    --            vim.g.everforest_enable_italic = true
    --            vim.o.background = "dark"
    --            -- vim.g.everforest_background = "hard"
    --            vim.g.everforest_better_performance = true
    --            vim.cmd.colorscheme('everforest')
    --        end
    --    },

    -- fzf for fast file search
    {
        {
            "junegunn/fzf",
            build = "./install --bin", -- Ensures the fzf binary is installed
        },
        {
            "junegunn/fzf.vim",
            dependencies = { "junegunn/fzf" },
            config = function()
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
                vim.api.nvim_create_user_command("RgExactExcludingTests", function(opts)
                    local query = opts.args
                    if query == "" then
                        query = vim.fn.input("Rg (exact)> ")
                        if query == "" then return end
                    end

                    local root_dir = get_project_root()
                    local escaped_query = vim.fn.shellescape(query)
                    local escaped_root_dir = vim.fn.shellescape(root_dir)

                    local cmd = string.format(
                        "rg --fixed-strings --color=always --line-number --column --no-heading %s -g '*' --glob '!**/*bazel*/**' --glob '!node_modules' --glob '!**/*git*/**' --glob '!**/*3rdparty*/**' --glob '!**/*.tools*/**' --glob '!**/*demo_files*/**' --glob '!**/*-lock*/**' --glob '!**/*metals*/**' --glob '!**/*_test*' --glob '!**/*.json' %s",
                        escaped_query, escaped_root_dir
                    )

                    vim.fn["fzf#vim#grep"](cmd, 1, vim.fn["fzf#vim#with_preview"](), opts.bang and 1 or 0)
                end, {
                    nargs = "*",
                    bang = true,
                    desc = "Search with ripgrep in exact (literal) mode from project root",
                }
                )

                -- Search for string match with regex
                vim.api.nvim_create_user_command("Rg", function(opts)
                    local query = opts.args
                    if query == "" then
                        query = vim.fn.input("Rg >")
                        if query == "" then return end
                    end

                    local root_dir = get_project_root()
                    local escaped_query = vim.fn.shellescape(query)
                    local escaped_root_dir = vim.fn.shellescape(root_dir)

                    local cmd = string.format(
                        "rg --color=always --line-number --column --no-heading %s -g '*' --glob '!**/*bazel*/**' --glob '!node_modules' --glob '!**/*git*/**' --glob '!**/*3rdparty*/**' --glob '!**/*.tools*/**' --glob '!**/*demo_files*/**' --glob '!**/*-lock*/**' --glob '!**/*metals*/**' %s",
                        escaped_query, escaped_root_dir
                    )
                    vim.fn["fzf#vim#grep"](cmd, 1, vim.fn["fzf#vim#with_preview"](), opts.bang and 1 or 0)
                end, {
                    nargs = "*",
                    bang = true,
                    desc = "Search with ripgrep ignoring case from project root",
                }
                )

                -- Search for exact string match, case-insensitive
                vim.api.nvim_create_user_command("RgIgnoreCaseFixedStrings", function(opts)
                    local query = opts.args
                    if query == "" then
                        query = vim.fn.input("Rg (ignore case)> ")
                        if query == "" then return end
                    end

                    local root_dir = get_project_root()
                    local escaped_query = vim.fn.shellescape(query)
                    local escaped_root_dir = vim.fn.shellescape(root_dir)

                    local cmd = string.format(
                        "rg --ignore-case  --fixed-strings --color=always --line-number --column --no-heading %s -g '*' --glob '!**/*bazel*/**' --glob '!node_modules' --glob '!**/*git*/**' --glob '!**/*3rdparty*/**' --glob '!**/*.tools*/**' --glob '!**/*demo_files*/**' --glob '!**/*-lock*/**' --glob '!**/*metals*/**' %s",
                        escaped_query, escaped_root_dir
                    )

                    vim.fn["fzf#vim#grep"](cmd, 1, vim.fn["fzf#vim#with_preview"](), opts.bang and 1 or 0)
                end, {
                    nargs = "*",
                    bang = true,
                    desc = "Search with ripgrep ignoring case from project root",
                }
                )

                -- Search for exact string match, case-insensitive, excluding test files
                vim.api.nvim_create_user_command("RgIgnoreCaseFixedStringsExcludingTests", function(opts)
                    local query = opts.args
                    if query == "" then
                        query = vim.fn.input("Rg (ignore case and tests)> ")
                        if query == "" then return end
                    end

                    local root_dir = get_project_root()
                    local escaped_query = vim.fn.shellescape(query)
                    local escaped_root_dir = vim.fn.shellescape(root_dir)

                    local cmd = string.format(
                        "rg --ignore-case  --fixed-strings --color=always --line-number --column --no-heading %s -g '*' --glob '!**/*bazel*/**' --glob '!node_modules' --glob '!**/*git*/**' --glob '!**/*3rdparty*/**' --glob '!**/*.tools*/**' --glob '!**/*demo_files*/**' --glob '!**/*-lock*/**' --glob '!**/*metals*/**' --glob '!**/*_test*' %s",
                        escaped_query, escaped_root_dir
                    )

                    vim.fn["fzf#vim#grep"](cmd, 1, vim.fn["fzf#vim#with_preview"](), opts.bang and 1 or 0)
                end, {
                    nargs = "*",
                    bang = true,
                    desc = "Search with ripgrep ignoring case from project root",
                }
                )
            end
        }
    },

    -- Stuff for GraphQL
    {
        "neovim/nvim-lspconfig",
        dependencies = {
            { "williamboman/mason.nvim",           config = true },
            { "williamboman/mason-lspconfig.nvim", config = true },
            { "VonHeikemen/lsp-zero.nvim" },
        },
    },

    -- Formatting
    {
        {
            'stevearc/conform.nvim',
            opts = {},
        }
    },
    {
        "chentoast/marks.nvim",
        event = "VeryLazy",
        opts = {},
    },

    -- Save sessions
    {
        'stevearc/resession.nvim',
        opts = {},
    }
})
