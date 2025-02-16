vim.g.mapleader = " "
require("jay.remap")
require("jay.set")
require("jay.lazy")
-- require("jay.packer")

vim.opt.wildignore = {
  '*/tmp/*',
  '*.so',
  '*.swp',
  '*.zip',
  '*/node_modules/*',
  '*/dist/*',
  '*bazel*',
}
