-- Set leader keys
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

local map = vim.keymap.set
local opts = { noremap = true, silent = true }

-- ───────────────────────────────────────────────────────────────
--  BASIC QUALITY-OF-LIFE
-- ───────────────────────────────────────────────────────────────

-- Exit insert mode quickly with jk or jj
map("i", "jk", "<Esc>", opts)
map("i", "jj", "<Esc>", opts)

-- ; enters command mode (like VS Code’s Vim extension)
map("n", ";", ":", { desc = "Enter command mode" })

-- Save with Ctrl-S (works in normal, insert, visual)
map({ "n", "i", "v" }, "<C-s>", "<Esc><cmd>w<cr>", { desc = "Save file" })

-- Quit with leader q
map("n", "<leader>q", "<cmd>q<cr>", { desc = "Quit window" })

-- Clear search highlight with Esc
map("n", "<Esc>", "<cmd>noh<cr>", { desc = "Clear search highlight" })

-- ───────────────────────────────────────────────────────────────
--  WINDOW NAVIGATION (like VS Code split movement)
-- ───────────────────────────────────────────────────────────────
map("n", "<C-h>", "<C-w>h", { desc = "Move to left window" })
map("n", "<C-j>", "<C-w>j", { desc = "Move to lower window" })
map("n", "<C-k>", "<C-w>k", { desc = "Move to upper window" })
map("n", "<C-l>", "<C-w>l", { desc = "Move to right window" })

-- Resize splits with Ctrl + Arrows
map("n", "<C-Up>", "<cmd>resize +2<cr>", { desc = "Increase height" })
map("n", "<C-Down>", "<cmd>resize -2<cr>", { desc = "Decrease height" })
map("n", "<C-Left>", "<cmd>vertical resize -2<cr>", { desc = "Narrow width" })
map("n", "<C-Right>", "<cmd>vertical resize +2<cr>", { desc = "Widen width" })

-- ───────────────────────────────────────────────────────────────
--  BUFFER MANAGEMENT
-- ───────────────────────────────────────────────────────────────
map("n", "<S-h>", "<cmd>bprevious<cr>", { desc = "Previous buffer" })
map("n", "<S-l>", "<cmd>bnext<cr>", { desc = "Next buffer" })
map("n", "<leader>bd", "<cmd>bd<cr>", { desc = "Delete current buffer" })

-- ───────────────────────────────────────────────────────────────
--  FILE EXPLORER (YAZI)
-- ───────────────────────────────────────────────────────────────
map("n", "<leader>e", "<cmd>Yazi<cr>", { desc = "Open Yazi (current file)" })
map("n", "<leader>E", "<cmd>Yazi cwd<cr>", { desc = "Open Yazi (cwd)" })
map("n", "<A-e>", "<cmd>Yazi toggle<cr>", { desc = "Resume last Yazi session" })

-- ───────────────────────────────────────────────────────────────
--  TEXT MOVEMENT
-- ───────────────────────────────────────────────────────────────
-- Move selected lines up/down with Alt-j / Alt-k
map("v", "<A-j>", ":m '>+1<cr>gv=gv", { desc = "Move selection down" })
map("v", "<A-k>", ":m '<-2<cr>gv=gv", { desc = "Move selection up" })
-- Same in normal/insert modes
map("n", "<A-j>", "<cmd>m .+1<cr>==", { desc = "Move line down" })
map("n", "<A-k>", "<cmd>m .-2<cr>==", { desc = "Move line up" })
map("i", "<A-j>", "<Esc><cmd>m .+1<cr>==gi", { desc = "Move line down" })
map("i", "<A-k>", "<Esc><cmd>m .-2<cr>==gi", { desc = "Move line up" })

-- ───────────────────────────────────────────────────────────────
--  INDENTING
-- ───────────────────────────────────────────────────────────────
map("v", "<", "<gv", { desc = "Indent left and reselect" })
map("v", ">", ">gv", { desc = "Indent right and reselect" })

-- ───────────────────────────────────────────────────────────────
--  NEW FILE / SPLITS
-- ───────────────────────────────────────────────────────────────
map("n", "<leader>fn", "<cmd>enew<cr>", { desc = "New file" })
map("n", "<leader>-", "<C-w>s", { desc = "Horizontal split" })
map("n", "<leader>|", "<C-w>v", { desc = "Vertical split" })

-- ───────────────────────────────────────────────────────────────
--  DIAGNOSTICS (will work once LSP is set up)
-- ───────────────────────────────────────────────────────────────
map("n", "[d", vim.diagnostic.goto_prev, { desc = "Previous diagnostic" })
map("n", "]d", vim.diagnostic.goto_next, { desc = "Next diagnostic" })
map("n", "<leader>cd", vim.diagnostic.open_float, { desc = "Show diagnostics under cursor" })

-- ───────────────────────────────────────────────────────────────
--  TELESCOPE (we’ll install later)
-- ───────────────────────────────────────────────────────────────
map("n", "<leader>ff", "<cmd>Telescope find_files<cr>", { desc = "Find files" })
map("n", "<leader>fg", "<cmd>Telescope live_grep<cr>", { desc = "Search text" })
map("n", "<leader>fb", "<cmd>Telescope buffers<cr>", { desc = "List buffers" })
map("n", "<leader>fh", "<cmd>Telescope help_tags<cr>", { desc = "Help tags" })

-- Terminal keymaps (Snacks.nvim floating terminal)

-- helper: get project root safely
local function get_root()
	local git_root = vim.fn.systemlist("git rev-parse --show-toplevel")[1]
	if vim.v.shell_error == 0 and git_root ~= "" then
		return git_root
	else
		return vim.fn.getcwd()
	end
end

local function open_terminal_in_root()
	require("snacks.terminal")(nil, { size = { width = 0.85, height = 0.85 }, cwd = get_root() })
end

local function open_terminal_in_cwd()
	require("snacks.terminal")(nil, { size = { width = 0.85, height = 0.85 }, cwd = vim.fn.getcwd() })
end

-- Increment and Decrement
map("n", "+", "<C-a>")
map("n", "-", "<C-x>")

-- keymaps
map("n", "<leader>ft", open_terminal_in_root, { desc = "Terminal (Project Root)" })
map("n", "<leader>fT", open_terminal_in_cwd, { desc = "Terminal (CWD)" })

-- toggle floating terminal (Ctrl+/ or fallback Ctrl-\)
map("n", "<C-/>", open_terminal_in_root, { desc = "Toggle Terminal (Root)" })
map("t", "<C-/>", "<cmd>close<cr>", { desc = "Hide Terminal" })
map("n", "<C-_>", open_terminal_in_root, { desc = "Toggle Terminal (Root)" })
map("t", "<C-_>", "<cmd>close<cr>", { desc = "Hide Terminal" })
map("n", "<C-\\>", open_terminal_in_root, { desc = "Toggle Terminal (Root)" })
map("t", "<C-\\>", "<cmd>close<cr>", { desc = "Hide Terminal" })

-- DAP KEYBINDS
-- map("n", "<leader>db", function()
-- 	require("dap").toggle_breakpoint()
-- end, { desc = "Toggle Breakpoint" })
--
-- map("n", "<leader>dB", function()
-- 	require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: "))
-- end, { desc = "Conditional Breakpoint" })
--
-- map("n", "<leader>du", function()
-- 	require("dapui").toggle({})
-- end, { desc = "Toggle Debug UI" })
