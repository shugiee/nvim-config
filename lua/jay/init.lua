vim.g.mapleader = " "

vim.env.FZF_DEFAULT_COMMAND = "fd --type f --hidden --follow --exclude .git --exclude '*bazel*' . $(git rev-parse --show-toplevel 2>/dev/null || echo .)"

require("jay.lazy")
require("jay.remap")
require("jay.set")
-- require("jay.aors")

vim.opt.wildignore = {
  '*/tmp/*',
  '*.so',
  '*.swp',
  '*.zip',
  '*/node_modules/*',
  '*/dist/*',
  '*bazel*',
}


-- FROM ChatGPT for aors.lua
-- Autocmd to run CLI
vim.api.nvim_create_autocmd("BufReadPost", {
  callback = function(args)
    require("jay.aors").on_buf_open(args.buf)
  end,
})

-- Set custom statusline
vim.o.statusline = "%f %h%m%r%=%-14.(%l,%c%V%) %P %{v:lua.require'jay.aors'.statusline_component()}"
