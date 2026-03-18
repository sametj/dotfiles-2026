-- ───────────────────────────────────────────────────────────────
-- Leader keys
-- ───────────────────────────────────────────────────────────────
vim.g.mapleader = " " -- Space as the leader key (for shortcuts like <leader>e)
vim.g.maplocalleader = "\\" -- Local leader (used in some plugins)

-- ───────────────────────────────────────────────────────────────
-- General behavior
-- ───────────────────────────────────────────────────────────────
local opt = vim.opt

opt.autowrite = true -- Automatically save before running commands like :next and :make
opt.confirm = true -- Ask for confirmation when closing unsaved files
opt.clipboard = "unnamedplus" -- Use the system clipboard for copy/paste
opt.mouse = "a" -- Enable mouse support
opt.undofile = true -- Persistent undo history between sessions
opt.updatetime = 200 -- Faster diagnostics and CursorHold events
opt.timeoutlen = 300 -- Quicker key sequence timeout (good for which-key)
opt.termguicolors = true -- Enable true color support in terminal
opt.virtualedit = "block" -- Allow cursor beyond text in visual block mode

-- ───────────────────────────────────────────────────────────────
-- UI & Display
-- ───────────────────────────────────────────────────────────────
opt.number = true -- Show absolute line numbers
opt.relativenumber = true -- Show relative line numbers (great for motions)
opt.cursorline = true -- Highlight the current line
opt.signcolumn = "yes" -- Always show the sign column (prevents text shifting)
opt.laststatus = 3 -- Global statusline across all windows
opt.showmode = false -- Don't show mode (handled by statusline)
opt.scrolloff = 4 -- Keep 4 lines visible above/below cursor
opt.sidescrolloff = 8 -- Keep 8 columns visible left/right of cursor
opt.winminwidth = 5 -- Minimum window width
opt.pumheight = 10 -- Max items in popup menu
opt.pumblend = 0 -- Add transparency to popup menus

-- ───────────────────────────────────────────────────────────────
-- Indentation & Tabs
-- ───────────────────────────────────────────────────────────────
opt.expandtab = true -- Use spaces instead of tabs
opt.shiftwidth = 2 -- Indent size
opt.tabstop = 2 -- Tabs count for 2 spaces
opt.smartindent = true -- Auto-indent new lines intelligently
opt.shiftround = true -- Round indent to nearest multiple of shiftwidth

-- ───────────────────────────────────────────────────────────────
-- Searching
-- ───────────────────────────────────────────────────────────────
opt.ignorecase = true -- Ignore case when searching
opt.smartcase = true -- But make search case-sensitive if uppercase is used
opt.inccommand = "nosplit" -- Preview substitutions incrementally (e.g. :%s/foo/bar/)

-- ───────────────────────────────────────────────────────────────
-- Line wrapping & formatting
-- ───────────────────────────────────────────────────────────────
opt.linebreak = true -- Wrap lines at word boundaries
opt.wrap = false -- Disable line wrap (scroll horizontally instead)
opt.conceallevel = 2 -- Conceal markdown formatting symbols like * or _
opt.smoothscroll = true -- Smooth scrolling
vim.g.markdown_recommended_style = 0 -- Use normal indenting for markdown

-- ───────────────────────────────────────────────────────────────
-- Splits
-- ───────────────────────────────────────────────────────────────
opt.splitbelow = true -- Horizontal splits open below
opt.splitright = true -- Vertical splits open to the right
opt.splitkeep = "screen" -- Keep the text stable when splitting

-- ───────────────────────────────────────────────────────────────
-- Folding (optional aesthetic)
-- ───────────────────────────────────────────────────────────────
opt.foldmethod = "indent" -- Fold based on indentation
opt.foldlevel = 99 -- Keep all folds open by default
opt.foldtext = "" -- Simplify folded text display

-- ───────────────────────────────────────────────────────────────
-- File sessions, search, etc.
-- ───────────────────────────────────────────────────────────────
opt.sessionoptions = { "buffers", "curdir", "tabpages", "winsize" }
opt.wildmode = "longest:full,full" -- Tab completion in command-line mode

-- ───────────────────────────────────────────────────────────────
-- Aesthetics / Icons / End of buffer cleanup
-- ───────────────────────────────────────────────────────────────
opt.fillchars = {
	foldopen = "", -- Icon for open fold
	foldclose = "", -- Icon for closed fold
	fold = " ", -- No line for folded text
	foldsep = " ",
	diff = "╱", -- Diff filler character
	eob = " ", -- Remove ~ lines at the end of buffer
}

-- ───────────────────────────────────────────────────────────────
-- Misc
-- ───────────────────────────────────────────────────────────────
opt.autowrite = true -- Auto save before :next, :make etc.
opt.sessionoptions = { "buffers", "curdir", "tabpages", "winsize" } -- Session persistence
