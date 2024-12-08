require('telescope').setup{
  defaults = {
    history = {
      path = '~/.local/share/nvim/databases/telescope_history.sqlite3',
      limit = 100,
    }
  }
}
require('telescope').load_extension('smart_history')

-- Define telescope for the keymaps
local telescope = require('telescope.builtin')
vim.keymap.set('n', '<leader>pf', telescope.find_files, {})
vim.keymap.set('n', '<C-p>', telescope.git_files, {})
vim.keymap.set('n', '<leader>ps', function()
	telescope.grep_string({ search = vim.fn.input("Grep > ") });
end)
