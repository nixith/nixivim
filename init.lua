-- enable experimental new loader
vim.loader.enable()

-- default options, may get overridden in plugins/ftplugins (i.e. line wrapping)
local opt = vim.opt
opt.autowrite = true
opt.clipboard = vim.env.SSH_TTY and "" or "unnamedplus"
opt.completeopt = "menu,menuone,noselect"
opt.conceallevel = 2
opt.confirm = true
opt.cursorline = true -- NOTE: might not want this
opt.expandtab = true
opt.fillchars = {
	foldopen = "",
	foldclose = "",
	fold = " ",
	foldsep = " ",
	diff = "╱",
	eob = " ",
}
opt.foldlevel = 99
opt.formatoptions = "jcroqlnt"
opt.grepformat = "%f:%l:%c:%m"
opt.grepprg = "rg --vimgrep"
opt.ignorecase = true
opt.inccommand = "nosplit" -- preview incremental substitute
opt.jumpoptions = "view"
opt.laststatus = 3 -- global statusline
opt.linebreak = true -- Wrap lines at convenient points
opt.list = true -- Show some invisible characters (tabs...
opt.number = true
opt.relativenumber = true -- Relative line numbers
opt.pumblend = 10 -- Popup blend
opt.pumheight = 10 -- Maximum number of entries in a popup
opt.ruler = false -- Disable the default ruler
opt.scrolloff = 4 -- Lines of context
opt.sessionoptions = { "buffers", "curdir", "tabpages", "winsize", "help", "globals", "skiprtp", "folds" }
opt.shiftround = true -- Round indent
opt.shiftwidth = 2 -- Size of an indent
opt.shortmess:append({ W = true, I = true, c = true, C = true })
opt.showmode = false -- Dont show mode since we have a statusline
opt.sidescrolloff = 8 -- Columns of context
opt.signcolumn = "yes" -- Always show the signcolumn, otherwise it would shift the text each time
opt.smartcase = true -- Don't ignore case with capitals
opt.smartindent = true -- Insert indents automatically
opt.spelllang = { "en" }
opt.splitbelow = true -- Put new windows below current
opt.splitkeep = "screen"
opt.splitright = true -- Put new windows right of current
opt.tabstop = 2 -- Number of spaces tabs count for
opt.termguicolors = true -- True color support
opt.timeoutlen = vim.g.vscode and 1000 or 300 -- Lower than default (1000) to quickly trigger which-key
opt.undofile = true
opt.undolevels = 10000
opt.updatetime = 200 -- Save swap file and trigger CursorHold
opt.virtualedit = "block" -- Allow cursor to move where there is no text in visual block mode
opt.wildmode = "longest:full,full" -- Command-line completion mode
opt.winminwidth = 5 -- Minimum window width
opt.wrap = false -- Disable line wrap
vim.g.markdown_recommended_style = 0
opt.smoothscroll = true
opt.foldexpr = "v:lua.require'util'.fold.foldexpr()"
opt.foldmethod = "expr"
opt.foldtext = "" -- TODO: make a nice fold text

vim.g.mapleader = " "
vim.g.maplocalleader = "\\"
vim.o.shell = "fish"

require("config.autocommands")
require("lz.n").load("plugins")

-- set colorscheme
vim.cmd.colorscheme("everforest")

-- Set to `false` to globally disable all snacks animations
vim.g.snacks_animate = true

-- diagnostics
vim.diagnostic.config({
	virtual_lines = { current_line = true },
	underline = true,
})

-- doc window
vim.o.winborder = "rounded"
if vim.fn.exists("&pumborder") == 1 then
	vim.o.pumborder = "rounded"
end

require("lzn-auto-require").enable()
