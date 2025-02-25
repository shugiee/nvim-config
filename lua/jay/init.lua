vim.g.mapleader = " "

vim.env.FZF_DEFAULT_COMMAND = "fd --type f --hidden --follow --exclude .git --exclude '*bazel*' . $(git rev-parse --show-toplevel 2>/dev/null || echo .)"

require("jay.lazy")
require("jay.remap")
require("jay.set")

vim.opt.wildignore = {
  '*/tmp/*',
  '*.so',
  '*.swp',
  '*.zip',
  '*/node_modules/*',
  '*/dist/*',
  '*bazel*',
}
