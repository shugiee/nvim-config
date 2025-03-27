vim.opt.guicursor = ""

vim.opt.nu = true
vim.opt.relativenumber = true

vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

vim.opt.smartindent = true

vim.opt.wrap = false

vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
vim.opt.undofile = true

vim.opt.hlsearch = false
vim.opt.incsearch = true

vim.opt.termguicolors = true

vim.opt.scrolloff = 8
vim.opt.signcolumn = "yes"
vim.opt.isfname:append("@-@")

vim.opt.updatetime = 50

-- Fold based on syntax
vim.opt.foldmethod = "syntax"
vim.opt.foldlevelstart = 99
vim.opt.foldenable = true

--- Blinking cursor
vim.opt.guicursor = "n-v-c-sm:block,i-ci-ve:ver25,r-cr-o:hor20,a:blinkwait700-blinkoff400-blinkon250-Cursor/lCursor"

--- Copy file path
vim.api.nvim_create_user_command("Path", function()
    local path = vim.fn.expand("%:p")
    vim.fn.setreg("+", path)
    vim.notify('Copied "' .. path .. '" to the clipboard!')
end, {}) 

-- Hide the 80-character column indicator
vim.opt.colorcolumn = ""

-- Open file in GitHub; got this from Claude
function OpenGitHubFile()
    local relative_path = vim.fn.expand('%:.')
    
    local url = string.format('https://github.com/Asana/codez/blob/next-master/%s', 
        relative_path
    )
    -- DEBUG
    -- vim.notify("Debug: url = " .. url)
    
    vim.fn.system('open ' .. url)
end

vim.keymap.set('n', '<leader>gh', OpenGitHubFile, { })

-- Color Scheme
-- vim.cmd.colorscheme('nordic')
vim.cmd.colorscheme('catppuccin')
-- vim.cmd.colorscheme('nord')

-- Rename variable across files
vim.keymap.set("n", "<leader>r", vim.lsp.buf.rename, { noremap = true, silent = true })
