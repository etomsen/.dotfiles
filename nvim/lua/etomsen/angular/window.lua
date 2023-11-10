local M = {}

local currentBuffer

local buf, win
local matches

local width, height
local disabled_chars = {}
local keybindings = {
  ["<cr>"] = "open_item()",
  ["<esc>"] = "close_window()",
  o = "open_item()",
  t = "open_item_tabnew()",
  q = "close_window()",
  v = "open_item_vs()",
  s = "open_item_sp()",
}
local border = "solid"
local colSeparator = "|"
local newFileIndicator = "(* new *)"

local maxContextLength = 0
local shortcut_chars = {
	"a",
	"d",
	"f",
	"g",
	"w",
	"e",
	"u",
	"o",
	"p",
	"n",
	"m",
	"r",
	"z",
	"b",
	"v",
	"s",
	"c",
	"x",
	"1",
	"2",
	"3",
	"4",
	"5",
	"6",
	"7",
	"8",
	"9",
}

local function _getMaxContextLength(files)
	local result = 0
	for _, file in pairs(files) do
		if file.context ~= nil and #file.context > result then
			result = #file.context
		end
	end
	return result
end

local function openFile(openCommand, filename, shouldOpenInexist)
  local exists = (vim.fn.filereadable(filename) == 1 and true or false)
  local shouldOpenFile = exists ~= 0 or shouldOpenInexist
  if shouldOpenFile then
    vim.api.nvim_command(":" .. openCommand .. " " .. filename)
    vim.g.other_lastopened = filename
  end
end

-- Set the keybindings
local function _set_mappings()
	-- Disable reserved keybindings
	for _, v in ipairs(disabled_chars) do
		vim.api.nvim_buf_set_keymap(buf, "n", v, "", { nowait = true, noremap = false, silent = true })
		vim.api.nvim_buf_set_keymap(buf, "n", v:upper(), "", { nowait = true, noremap = false, silent = true })
		vim.api.nvim_buf_set_keymap(buf, "n", "<c-" .. v .. ">", "", { nowait = true, noremap = false, silent = true })
	end

	-- Add the defaultkeybindings from the config to open, close, splits, etc..
	for k, v in pairs(keybindings) do
		vim.api.nvim_buf_set_keymap(buf, "n", k, ':lua require"etomsen.angular.window".' .. v .. "<cr>", {
			nowait = true,
			noremap = true,
			silent = true,
		})
	end

	-- add shortcut bindings to the files list
	for i, v in ipairs(shortcut_chars) do
		vim.api.nvim_buf_set_keymap(
			buf,
			"n",
			v,
			':lua require"etomsen.angular.window".open_item(' .. i .. ")<cr>",
			{ nowait = true, noremap = true, silent = true }
		)
		vim.api.nvim_buf_set_keymap(
			buf,
			"n",
			v:upper(),
			':lua require"etomsen.angular.window".open_item_sp(' .. i .. ")<cr>",
			{ nowait = true, noremap = true, silent = true }
		)
		vim.api.nvim_buf_set_keymap(
			buf,
			"n",
			"<c-" .. v .. ">",
			':lua require"etomsen.angular.window".open_item_vs(' .. i .. ")<cr>",
			{ nowait = true, noremap = true, silent = true }
		)
	end
end

local function openItemAtPosition(command, position)
	-- Getting the current line number
	local pos = position or vim.api.nvim_win_get_cursor(0)[1]

	-- reading the filename from the matches table
	if matches[pos] ~= nil then
		local filename = matches[pos].filename
		lastfile = filename

		M.close_window()
		vim.api.nvim_set_current_buf(currentBuffer)

		-- actual opening
		openFile(command, filename, true)
	end
end

local function _prepareLines(files)
	matches = files

	local result = {}
	for k, file in pairs(files) do
		local filename = file.filename
		local fileNotExistsMarker = (not file.exists and newFileIndicator .. " " or "")
		filename = filename:gsub(vim.fn.getcwd() .. "/", "")
		filename = fileNotExistsMarker .. filename

		local context = file.context or ""
		local shortcut = shortcut_chars[k] or ""
		if maxContextLength > 0 then
			result[k] = "  "
				.. shortcut
				.. " "
				.. colSeparator
				.. context
				.. string.rep(" ", maxContextLength - #context)
				.. colSeparator

			local fn = ""
			-- cut filename from the right side minus the window width and result[k]
			fn = string.sub(filename, -width + #result[k] + 4, #filename)
			if #fn < #filename then
				fn = ".." .. fn
			end
			result[k] = result[k] .. fn .. "  "
		else
			result[k] = "  " .. shortcut_chars[k] .. " " .. colSeparator .. "../" .. filename
		end
	end
	return result
end

-- Filling the buffer with the files for the given path
local function _update_view(lines)
	vim.api.nvim_buf_set_option(buf, "modifiable", true)
	vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)

	for k, _ in pairs(lines) do
		vim.api.nvim_buf_add_highlight(buf, -1, "Error", k - 1, 2, 3)
		vim.api.nvim_buf_add_highlight(buf, -1, "Underlined", k - 1, 2, 3)
		if not matches[k].exists then
			vim.api.nvim_buf_add_highlight(
				buf,
				-1,
				"Underlined",
				k - 1,
				maxContextLength + 10,
				maxContextLength + 10 + #newFileIndicator
			)
			vim.api.nvim_buf_add_highlight(buf, -1, "Conceal", k - 1, maxContextLength + 10 + #newFileIndicator + 1, -1)
		end
	end

	vim.api.nvim_buf_set_option(buf, "modifiable", false)
end

-- Building the window
local function _buildWindow(linesCount)
	local maxWidth = vim.api.nvim_get_option("columns")
	local maxHeight = vim.api.nvim_get_option("lines")

	if linesCount >= height then
		height = linesCount
	end

	local window_config = {
		relative = "editor",
		width = width,
		height = height,
		col = (maxWidth - width) / 2,
		row = (maxHeight - height) / 2,
		style = "minimal",
		focusable = false,
		border = border,
	}

	-- setup window buffer
	buf = vim.api.nvim_create_buf(false, true)
	vim.api.nvim_buf_set_option(buf, "bufhidden", "wipe")
	vim.api.nvim_buf_set_option(buf, "filetype", "whid")

	win = vim.api.nvim_open_win(buf, true, window_config)
	vim.api.nvim_win_set_option(win, "cursorline", true)
	vim.api.nvim_win_set_option(win, "winhighlight", "Normal:NormalFloat,FloatBorder:NormalFloat")
end

-- -- -- -- -- -- -- -- -- -- PUBLIC -- -- -- -- -- -- -- -- --

-- Closing the window
function M.close_window()
	vim.api.nvim_win_close(win, true)
end

function M.open_item(pos)
	openItemAtPosition(":e", pos)
end

function M.open_item_tabnew(pos)
	openItemAtPosition(":tabnew", pos)
end

function M.open_item_sp(pos)
	openItemAtPosition(":sp", pos)
end

-- Opening the file in a vertical split
function M.open_item_vs(pos)
	openItemAtPosition(":vs", pos)
end

-- Main function to open the window
function M.open_window(files, callerBuffer)
	currentBuffer = callerBuffer

	width = math.floor(0.7 * vim.api.nvim_get_option("columns"))
	height = 2

	maxContextLength = _getMaxContextLength(files)

	_buildWindow(#files)
	_set_mappings()
	_update_view(_prepareLines(files))
end

return M
