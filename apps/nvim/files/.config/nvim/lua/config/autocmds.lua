local function augroup(name)
	return vim.api.nvim_create_augroup("lazyvim_" .. name, { clear = true })
end

-- Check if we need to reload the file when it changed
vim.api.nvim_create_autocmd({ "FocusGained", "TermClose", "TermLeave" }, {
	group = augroup("checktime"),
	callback = function()
		if vim.o.buftype ~= "nofile" then
			vim.cmd("checktime")
		end
	end,
})

-- Highlight on yank
vim.api.nvim_create_autocmd("TextYankPost", {
	group = augroup("highlight_yank"),
	callback = function()
		(vim.hl or vim.highlight).on_yank()
	end,
})

-- resize splits if window got resized
vim.api.nvim_create_autocmd({ "VimResized" }, {
	group = augroup("resize_splits"),
	callback = function()
		local current_tab = vim.fn.tabpagenr()
		vim.cmd("tabdo wincmd =")
		vim.cmd("tabnext " .. current_tab)
	end,
})

-- go to last loc when opening a buffer
vim.api.nvim_create_autocmd("BufReadPost", {
	group = augroup("last_loc"),
	callback = function(event)
		local exclude = { "gitcommit" }
		local buf = event.buf
		if vim.tbl_contains(exclude, vim.bo[buf].filetype) or vim.b[buf].lazyvim_last_loc then
			return
		end
		vim.b[buf].lazyvim_last_loc = true
		local mark = vim.api.nvim_buf_get_mark(buf, '"')
		local lcount = vim.api.nvim_buf_line_count(buf)
		if mark[1] > 0 and mark[1] <= lcount then
			pcall(vim.api.nvim_win_set_cursor, 0, mark)
		end
	end,
})

-- close some filetypes with <q>
vim.api.nvim_create_autocmd("FileType", {
	group = augroup("close_with_q"),
	pattern = {
		"PlenaryTestPopup",
		"checkhealth",
		"dbout",
		"gitsigns-blame",
		"grug-far",
		"help",
		"lspinfo",
		"neotest-output",
		"neotest-output-panel",
		"neotest-summary",
		"notify",
		"qf",
		"spectre_panel",
		"startuptime",
		"tsplayground",
	},
	callback = function(event)
		vim.bo[event.buf].buflisted = false
		vim.schedule(function()
			vim.keymap.set("n", "q", function()
				vim.cmd("close")
				pcall(vim.api.nvim_buf_delete, event.buf, { force = true })
			end, {
				buffer = event.buf,
				silent = true,
				desc = "Quit buffer",
			})
		end)
	end,
})

-- make it easier to close man-files when opened inline
vim.api.nvim_create_autocmd("FileType", {
	group = augroup("man_unlisted"),
	pattern = { "man" },
	callback = function(event)
		vim.bo[event.buf].buflisted = false
	end,
})

-- wrap and check for spell in text filetypes
vim.api.nvim_create_autocmd("FileType", {
	group = augroup("wrap_spell"),
	pattern = { "text", "plaintex", "typst", "gitcommit", "markdown" },
	callback = function()
		vim.opt_local.wrap = true
		vim.opt_local.spell = true
	end,
})

-- Fix conceallevel for json files
vim.api.nvim_create_autocmd({ "FileType" }, {
	group = augroup("json_conceal"),
	pattern = { "json", "jsonc", "json5" },
	callback = function()
		vim.opt_local.conceallevel = 0
	end,
})

-- Auto create dir when saving a file, in case some intermediate directory does not exist
vim.api.nvim_create_autocmd({ "BufWritePre" }, {
	group = augroup("auto_create_dir"),
	callback = function(event)
		if event.match:match("^%w%w+:[\\/][\\/]") then
			return
		end
		local file = vim.uv.fs_realpath(event.match) or event.match
		vim.fn.mkdir(vim.fn.fnamemodify(file, ":p:h"), "p")
	end,
})

vim.api.nvim_create_autocmd("FileType", {
	group = augroup("hide_lualine_dashboard"),
	pattern = { "dashboard", "alpha", "snacks_dashboard" },
	callback = function()
		vim.opt.laststatus = 0 -- hide statusline
	end,
})

vim.api.nvim_create_autocmd("BufLeave", {
	group = augroup("show_lualine_dashboard"),
	pattern = { "dashboard", "alpha", "snacks_dashboard" },
	callback = function()
		vim.opt.laststatus = 3 -- restore global statusline
	end,
})

vim.api.nvim_create_autocmd("TermOpen", {
	group = augroup("term_settings"),
	callback = function()
		vim.opt_local.number = false
		vim.opt_local.relativenumber = false
		vim.opt_local.signcolumn = "no"
	end,
})

-- 🎨 Dynamically match Float backgrounds with the theme
local function fix_float_highlights()
	-- get the background color from Normal highlight
	local normal_bg = vim.api.nvim_get_hl(0, { name = "Normal" }).bg
	local border_fg = vim.api.nvim_get_hl(0, { name = "FloatBorder" }).fg or normal_bg

	-- apply the same bg to all float-related groups
	vim.api.nvim_set_hl(0, "NormalFloat", { bg = normal_bg })
	vim.api.nvim_set_hl(0, "FloatBorder", { bg = normal_bg, fg = border_fg })
	vim.api.nvim_set_hl(0, "SnacksWin", { bg = normal_bg })
	vim.api.nvim_set_hl(0, "SnacksBorder", { bg = normal_bg, fg = border_fg })
	vim.api.nvim_set_hl(0, "SnacksBackdrop", { bg = "none" })
	vim.api.nvim_set_hl(0, "FloatShadow", { bg = "none" })
	vim.api.nvim_set_hl(0, "FloatShadowThrough", { bg = "none" })
end

-- Apply once now
fix_float_highlights()

-- Reapply after colorscheme changes
vim.api.nvim_create_autocmd("ColorScheme", {
	callback = fix_float_highlights,
})
