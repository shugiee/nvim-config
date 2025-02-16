require('telescope').setup{
    defaults = {
        file_sorter = require('telescope.sorters').get_fuzzy_file,
        file_previewer = require('telescope.previewers').vim_buffer_cat.new,
        generic_sorter = require('telescope.sorters').get_generic_fuzzy_sorter,
        file_ignore_patterns = {  -- Moved inside defaults
            "node_modules",
            "dist",
            ".git",
        }
    },
    pickers = {
        find_files = {
            find_command = { "rg", "--files", "--hidden", "--glob", "!**/.git/*" }
        }
    }
}

-- Define telescope for the keymaps
local telescope = require('telescope.builtin')
vim.keymap.set('n', '<leader>pf', telescope.find_files, {})
vim.keymap.set('n', '<C-p>', telescope.git_files, {})
vim.keymap.set('n', '<leader>ps', function()
    telescope.grep_string({ search = vim.fn.input("Grep > ") });
end)
