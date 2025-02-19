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
    { "ThePrimeagen/harpoon" },
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
                -- Create a custom command 'RgExact' that takes arguments.
                vim.api.nvim_create_user_command("RgExact", function(opts)
                    -- Build the ripgrep command with --fixed-strings for literal matching.
                    local query = opts.args
                    local cmd = "rg --fixed-strings --color=always --line-number --column --no-heading " .. vim.fn.shellescape(query)
                    -- Call fzf#vim#grep with the command.
                    vim.fn["fzf#vim#grep"](cmd, 1, vim.fn["fzf#vim#with_preview"](), opts.bang and 1 or 0)
                end, {
                nargs = "*",
                bang = true,
                desc = "Search with ripgrep in exact (literal) mode",
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
                -- If no argument is provided, prompt the user.
                local query = opts.args
                if query == "" then
                    query = vim.fn.input("Rg (ignore case)> ")
                end
                if query == "" then return end

                -- Build the ripgrep command with --ignore-case.
                local cmd = "rg --ignore-case --color=always --line-number --column --no-heading " .. vim.fn.shellescape(query)
                vim.fn["fzf#vim#grep"](cmd, 1, vim.fn["fzf#vim#with_preview"](), opts.bang and 1 or 0)
            end, {
            nargs = "*", -- Accepts arguments (if provided)
            bang = true,
            desc = "Search with ripgrep ignoring case",
        })

        -- Map <leader>fi to invoke the RgIgnoreCase command.
        vim.api.nvim_set_keymap("n", "<leader>fi", ":RgIgnoreCase<CR>", { noremap = true, silent = true })
            end
        }
    }

    -- SQLite for smart_history
    -- "kkharji/sqlite.lua",
    -- {
        --  'nvim-telescope/telescope-smart-history.nvim',
        --  requires = 'nvim-telescope/telescope.nvim'
        --})
    })


