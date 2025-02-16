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

-- Setup lazy.nvim
require("lazy").setup({
    -- automatically check for plugin updates
    checker = { enabled = true },
    { "nvim-lua/plenary.nvim" },
    { "nvim-telescope/telescope.nvim" },
    { 
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
    },
    { "nvim-treesitter/playground" },
    { "ThePrimeagen/harpoon", depenencies = { "nvim-lua/plenary.nvim" } },
    { "mbbill/undotree" },
    { "tpope/vim-fugitive" },
    { "VonHeikemen/lsp-zero.nvim" },
    { "neovim/nvim-lspconfig" },
    { "hrsh7th/nvim-cmp" },
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
                    add          = { text = '+' },
                    change       = { text = '│' },
                    delete       = { text = '-' },
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
    { "catppuccin/nvim", name = "catppuccin" }

    -- SQLite for smart_history
    -- "kkharji/sqlite.lua",
    -- {
        --  'nvim-telescope/telescope-smart-history.nvim',
        --  requires = 'nvim-telescope/telescope.nvim'
        --})
    })

