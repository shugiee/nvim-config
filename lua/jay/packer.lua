-- This file can be loaded by calling `lua require('plugins')` from your init.vim

-- Only required if you have packer configured as `opt`
vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function(use)
  -- Packer can manage itself
  use 'wbthomason/packer.nvim'

  use {
	  'nvim-telescope/telescope.nvim', tag = '0.1.8',
	  requires = { {'nvim-lua/plenary.nvim'} }
  }

  use('nvim-treesitter/nvim-treesitter', {run = ':TSUpdate'})
  use('nvim-treesitter/playground')
  use('ThePrimeagen/harpoon')
  use('mbbill/undotree')
  use('tpope/vim-fugitive')

  use({'VonHeikemen/lsp-zero.nvim', branch = 'v4.x'})
  use({'neovim/nvim-lspconfig'})
  use({'hrsh7th/nvim-cmp'})
  use({'hrsh7th/cmp-nvim-lsp'})

  -- Add gutter signs for git
  use {
      'lewis6991/gitsigns.nvim',
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
  }

  -- Split view in git
  use {
      'sindrets/diffview.nvim',
      requires = 'nvim-lua/plenary.nvim',
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
  }

  -- Git blame
  use 'rhysd/git-messenger.vim'

  -- Color Themes
  use 'AlexvZyl/nordic.nvim'
  use 'catppuccin/nvim'

  -- SQLite for smart_history
  use({ "kkharji/sqlite.lua" })
  use({
    'nvim-telescope/telescope-smart-history.nvim',
    requires = 'nvim-telescope/telescope.nvim'
  })
end)
