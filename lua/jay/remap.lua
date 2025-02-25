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
vim.keymap.set("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])

-- Easily open file's diff view
vim.keymap.set("n", "<leader>d", [[:DiffviewOpen<CR>]])

-- See diff'd files between current branch and next-master
vim.keymap.set("n", "<leader>diffmaster", [[:DiffviewOpen next-master..HEAD<CR>]])

-- See diff'd files between current branch and parent branch
vim.keymap.set('n', '<leader>gd', function()
    local parent = vim.fn.system('gt parent'):gsub('\n', '')
    vim.cmd('DiffviewOpen ' .. parent)
end, { noremap = true, silent = true })

-- Make panes equal width
vim.keymap.set("n", "<leader>eq", "<C-w>=")
