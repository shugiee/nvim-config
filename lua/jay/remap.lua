-- Go to file tree
vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)

-- Move highlighted lines up and down
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

-- Keep cursor in the middle when using ctrl d and u
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")

-- Keep cursor in the middle when searching
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

-- Preserve buffer after pasting
vim.keymap.set("x", "<leader>p", "\"_dP")

-- Apparently you never want to use Q
vim.keymap.set("n", "Q", "<nop>")

-- Easily copy to real clipboard
vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]])
vim.keymap.set("n", "<leader>Y", [["+Y]])

-- Use tmux to easily jump between projects
vim.keymap.set("n", "<C-f>", "<cmd>silent !tmux neww tmux-sessionizer<CR>")

-- Replace current word
vim.keymap.set("v", "<leader>sr", function()
    vim.cmd([[normal! "zy]])
    local search = vim.fn.escape(vim.fn.getreg("z"), [[\/]])
    local cmd = string.format([[:%%s/\V%s/%s/gI]], search, search)
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(cmd, true, false, true), 'c', true)
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<Left><Left><Left>', true, false, true), 'n', true)
end, { desc = "Substitute selected text", silent = true })

-- Make panes equal width
vim.keymap.set("n", "<leader>eq", "<C-w>=")

-- See history of recent files
vim.keymap.set("n", "<leader>h", [[:History<CR>]])

-- Ignore case with fzf
vim.env.FZF_DEFAULT_OPTS = "--ignore-case"

-- See commits affecting current file
vim.api.nvim_set_keymap("n", "<leader>bc", ":BCommits<CR>", { noremap = true, silent = true })

-- Keybindings for FZF commands
vim.api.nvim_set_keymap('n', '<leader>ff', ':Files<CR>', { noremap = true, silent = true })


-- Map <leader>fg to run RgExact with the word under the cursor.
vim.api.nvim_set_keymap(
    "n",
    "<leader>fg",
    ":RgExact <C-R>=expand('<cword>')<CR><CR>",
    { noremap = true, silent = true }
)

-- Search for text, project-wide, with regex
vim.api.nvim_set_keymap("n", "<leader>fir", ":Rg<CR>", { noremap = true, silent = true })

-- Search for text, project-wide, without regex, with tests included
vim.api.nvim_set_keymap("n", "<leader>fit", ":RgIgnoreCaseFixedStrings<CR>", { noremap = true, silent = true })

-- Search for text, project-wide, without regex, with tests excluded
vim.api.nvim_set_keymap("n", "<leader>fif", ":RgIgnoreCaseFixedStringsExcludingTests<CR>",
    { noremap = true, silent = true })

-- Source config init.lua file
vim.api.nvim_set_keymap("n", "<leader>so", ":luafile ~/.config/nvim/init.lua<CR>", { noremap = true, silent = true })

-- See full error message
vim.api.nvim_set_keymap(
    "n",
    "<leader>e",
    "<cmd>lua vim.diagnostic.open_float()<CR>",
    { noremap = true, silent = true }
)

-- Add tab
vim.keymap.set('n', '<leader>ta', ':tabnew<CR>', { silent = true })

-- Use tab and shift-tab to move between tabs
vim.keymap.set('n', '<leader>tp', ':tabp<CR>', { silent = true })
vim.keymap.set('n', '<leader>tn', ':tabn<CR>', { silent = true })

-- Zen mode
vim.keymap.set('n', '<leader>z', ':ZenMode<CR>', { silent = true })

-- Copy entire file's contents to clipboard
vim.keymap.set("n", "<leader>Y", [[gg"+yG]])

-- Paste from clipboard, replacing entire file's contents
vim.keymap.set("n", "<leader>P", [[gg"_dG"+p]])
