local vim = vim
local path = require("plenary.path")

local function load_file_into_buffer(file)
	local uri = vim.uri_from_fname(file)
	local new_buff = vim.uri_to_bufnr(uri)
	vim.api.nvim_win_set_buf(0, new_buff)
	vim.fn.execute("edit!")
end

function _G.NgToggleStyle()
	local current_buffer = vim.api.nvim_buf_get_name(0)
	local buf_path = path:new(current_buffer)
	local relative_path = buf_path:make_relative()
	local filename = string.match(relative_path, "([^/]+)$")

	local file_to_open = nil
	if string.match(filename, "^.+%.scss$") then
		file_to_open = buf_path:parent() .. "/" .. string.match(filename, "(.-)%.[a-z]+$") .. ".html"
  end
  if string.match(filename, "^.+%.ts$") or string.match(filename, "^.+%.html$") then
    file_to_open = buf_path:parent() .. "/" .. string.match(filename, "(.-)%.[a-z]+$") .. ".scss"
	end

  if not file_to_open then
    vim.notify("File is not *.ts or *.scss or *.html" .. filename, vim.log.levels.WARN)
    return
  end

	local exists = vim.fn.filereadable(file_to_open)
	if exists == 0 then
		vim.notify("File doesn't exist: " .. file_to_open, vim.log.levels.WARN)
		return
	end

	load_file_into_buffer(file_to_open)
end

function _G.NgToggleTemplate()
	local current_buffer = vim.api.nvim_buf_get_name(0)
	local buf_path = path:new(current_buffer)
	local relative_path = buf_path:make_relative()
	local filename = string.match(relative_path, "([^/]+)$")

	local file_to_open = nil
	if string.match(filename, "^.+%.ts$") then
		file_to_open = buf_path:parent() .. "/" .. string.match(filename, "(.-)%.[a-z]+$") .. ".html"
  end
  if string.match(filename, "^.+%.html$") then
    file_to_open = buf_path:parent() .. "/" .. string.match(filename, "(.-)%.[a-z]+$") .. ".ts"
	end

  if not file_to_open then
    vim.notify("File is not *.ts or *.html" .. filename, vim.log.levels.WARN)
    return
  end

	local exists = vim.fn.filereadable(file_to_open)
	if exists == 0 then
		vim.notify("File doesn't exist: " .. file_to_open, vim.log.levels.WARN)
		return
	end

	load_file_into_buffer(file_to_open)
end

function _G.NgToggleSpec()
	local current_buffer = vim.api.nvim_buf_get_name(0)
	local buf_path = path:new(current_buffer)
	local relative_path = buf_path:make_relative()
	local filename = string.match(relative_path, "([^/]+)$")

	local full_destination = nil
	if string.match(filename, ".spec.ts$") then
		-- if the current file is a spec file, then jump to the file it is testing
		local file_name = string.match(filename, "(.-)%.spec")
		full_destination = buf_path:parent() .. "/" .. file_name .. ".ts"
	else
		-- if the current file is not a spec file, then jump to the spec file
		local filename_without_ext = string.match(filename, "(.-)%.ts$")
    if not filename_without_ext then
      vim.notify("File is not a typescript: " .. filename, vim.log.levels.WARN)
      return
    end
    full_destination = buf_path:parent() .. "/" .. filename_without_ext .. ".spec.ts"
	end

	local exists = vim.fn.filereadable(full_destination)
	-- don't open a buffer if the file doesn't exist since you may end up creating a file without knowing it
	if exists == 0 then
		vim.notify("File doesn't exist: " .. full_destination, vim.log.levels.WARN)
		return
	end

	load_file_into_buffer(full_destination)
end


vim.api.nvim_create_user_command('NgToggleTemplate', NgToggleTemplate, { desc = "Toggle template file for *.ts"})
vim.keymap.set('', '<Leader>at', ': NgToggleTemplate<CR>')

vim.api.nvim_create_user_command('NgToggleStyle', NgToggleStyle, { desc = "Toggle style file for *.html"})
vim.keymap.set('', '<Leader>ac', ':NgToggleStyle<CR>')

vim.api.nvim_create_user_command('NgToggleSpec', NgToggleSpec, { desc = "Toggle spec file for *.ts"})
vim.keymap.set('', '<Leader>as', ':NgToggleSpec<CR>')
