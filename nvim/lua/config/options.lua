local opt = vim.opt

-- Line numbers
opt.number = true
opt.relativenumber = true

-- Tabs & indentation
opt.tabstop = 2
opt.shiftwidth = 2
opt.expandtab = true
opt.autoindent = true
opt.smartindent = true

-- Line wrapping
opt.wrap = false

-- Search
opt.ignorecase = true
opt.smartcase = true
opt.hlsearch = true
opt.incsearch = true

-- Appearance
opt.termguicolors = true
opt.background = "dark"
opt.signcolumn = "yes"
opt.cursorline = true
opt.scrolloff = 8
opt.sidescrolloff = 8
opt.cmdheight = 1
opt.winblend = 10   -- floating window transparency (0=opaque, 100=invisible)
opt.pumblend = 10   -- popup menu transparency

-- Splits
opt.splitright = true
opt.splitbelow = true

-- Clipboard
opt.clipboard = "unnamedplus"

-- Backup / swap
opt.swapfile = false
opt.backup = false
opt.undofile = true
opt.undodir = vim.fn.stdpath("data") .. "/undodir"

-- Performance
opt.updatetime = 250
opt.timeoutlen = 300

-- Completion
opt.completeopt = { "menuone", "noselect" }

-- Mouse
opt.mouse = "a"

-- Hide mode indicator (lualine shows it)
opt.showmode = false

-- Show whitespace characters
opt.list = true
opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }
