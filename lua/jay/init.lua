vim.g.mapleader = " "
require("jay.remap")
require("jay.lazy")
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
