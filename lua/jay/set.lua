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
vim.opt.isfname:append("@-@")

vim.opt.updatetime = 50

-- Don't include `l` format option since it forces a line wrap
vim.opt.formatoptions = "jcroq"

-- Fold based on syntax
vim.opt.foldmethod = "syntax"
vim.opt.foldlevelstart = 99
vim.opt.foldenable = true

-- Blinking cursor
vim.opt.guicursor = "n-v-c-sm:block,i-ci-ve:ver25,r-cr-o:hor20,a:blinkwait700-blinkoff400-blinkon250-Cursor/lCursor"

-- Copy file's absolute path
vim.api.nvim_create_user_command("CopyAbsolutePath", function()
    local path = vim.fn.expand("%:p")
    vim.fn.setreg("+", path)
    vim.notify('Copied "' .. path .. '" to the clipboard!')
end, {}) 
vim.keymap.set("n", "<leader>cpa", ":CopyAbsolutePath<CR>", { noremap = true, silent = true })

-- Copy file's path, relative to project root
vim.api.nvim_create_user_command('CopyRelativePath', function()
  local path = vim.fn.expand('%:.')
  vim.fn.setreg('+', path)
  print('Copied relative path: ' .. path)
end, {})
vim.keymap.set("n", "<leader>cpr", ":CopyRelativePath<CR>", { noremap = true, silent = true })

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
-- vim.cmd.colorscheme('catppuccin')
-- vim.cmd.colorscheme('nord')

-- Rename variable across files
vim.keymap.set("n", "<leader>r", vim.lsp.buf.rename, { noremap = true, silent = true })

-- Show errors in a floating window
local function show_output(title, lines)
  local buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)

  local width = math.floor(vim.o.columns * 0.8)
  local height = math.floor(vim.o.lines * 0.6)
  local row = math.floor((vim.o.lines - height) / 2)
  local col = math.floor((vim.o.columns - width) / 2)

  local win_opts = {
    style = "minimal",
    relative = "editor",
    width = width,
    height = height,
    row = row,
    col = col,
    border = "rounded",
    title = title,
    title_pos = "center",
  }

  vim.api.nvim_open_win(buf, true, win_opts)
end

-- Generate codegen files
vim.api.nvim_create_user_command("GenerateImports", function()
  local bufnr = vim.api.nvim_get_current_buf()
  local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)

  local generated_dirs = {}

  for _, line in ipairs(lines) do
    local import_path = line:match('%s*from%s+"([^"]+)"')
    if import_path and import_path:match("/generated/") then
      local dir = import_path:match("^(.-)/generated/")
      if dir then
          local dir_relative_to_asana2 = "asana2/" .. dir
          generated_dirs[dir_relative_to_asana2] = true -- use a set to avoid duplicates
      end
    end
  end

  -- Build a single command with all the dirs
  local args = {}
  for dir, _ in pairs(generated_dirs) do
    table.insert(args, vim.fn.shellescape(dir))
  end

  if #args == 0 then
    print("No generated imports found.")
    return
  end

  local cmd = "z editors codegen " .. table.concat(args, " ")
  print("Running: " .. cmd)

  vim.fn.jobstart(cmd, {
    stdout_buffered = true,
    stderr_buffered = true,
  })
end, { desc = "Generated files!" })

-- Generate imports
vim.keymap.set("n", "<leader>gen", ":GenerateImports<CR>", { noremap = true, silent = true })

-- Make pane bigger or smaller
vim.keymap.set("n", "<C-w>>", "20<C-w>>", { noremap = true, silent = true })
vim.keymap.set("n", "<C-w><", "20<C-w><", { noremap = true, silent = true })

-- Format file
vim.keymap.set("n", "<leader>f", function()
  vim.lsp.buf.format({ async = true })
end, { desc = "Format buffer" })

-- Show all marks
vim.keymap.set("n", "<leader>ma", ":MarksListAll<CR>", { noremap = true, silent = true })

-- Run cli command
vim.keymap.set("n", "<leader>r", function()
  local command = vim.fn.input("Command: ")
  if command ~= "" then
    vim.fn.system(command)
    print("Running: " .. command)
  end
end, { noremap = true, silent = true })
