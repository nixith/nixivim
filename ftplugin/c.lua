require("util.lang").setup("c", "clang-format", "clangtidy", "clangd")
require("util.dap").register_lldb()

vim.bo.expandtab = true
vim.bo.shiftwidth = 2
vim.bo.smartindent = true
