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
vim.keymap.set({"n", "v"}, "<leader>y", [["+y]])
vim.keymap.set("n", "<leader>Y", [["+Y]])

-- Use tmux to easily jump between projects
vim.keymap.set("n", "<C-f>", "<cmd>silent !tmux neww tmux-sessionizer<CR>")

-- Replace current word
vim.keymap.set("n", "<leader>sr", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])

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

-- Map <leader>fi to invoke the RgIgnoreCase command.
vim.api.nvim_set_keymap("n", "<leader>fi", ":RgIgnoreCase<CR>", { noremap = true, silent = true })

-- Source config init.lua file
vim.api.nvim_set_keymap("n", "<leader>so", ":luafile ~/.config/nvim/init.lua<CR>", { noremap = true, silent = true })

-- See full error message
vim.api.nvim_set_keymap(
  "n",
  "<leader>e",
  "<cmd>lua vim.diagnostic.open_float()<CR>",
  { noremap = true, silent = true }
)
