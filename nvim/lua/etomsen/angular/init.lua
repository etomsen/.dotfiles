local vim = vim
local M = {}

local path = require("plenary.path")
local window = require("etomsen.angular.window")

local function load_file_into_buffer(file)
	local uri = vim.uri_from_fname(file)
	local new_buff = vim.uri_to_bufnr(uri)
	vim.api.nvim_win_set_buf(0, new_buff)
	vim.fn.execute("edit!")
end

local getBufferFileName = function()
	local current_buffer = vim.api.nvim_buf_get_name(0)
	local buf_path = path:new(current_buffer)
	local relative_path = buf_path:make_relative()
	local filename = string.match(relative_path, "([^/]+)$")
  return filename, buf_path
end

local scanDir = function(dir)
    local result, popen = {}, io.popen
    local pfile = popen('ls -a "' .. dir .. '"')
    if not pfile then
      return {}
    end
    for filename in pfile:lines() do
      table.insert(result, {
        context = 'context',
        filename = filename,
        exists = true
      })
    end
    pfile:close()
    return result
end


local openFile = function(fileExt)
  local filename, buf_path = getBufferFileName()
  local fileExtPattern = string.gsub(fileExt, ".", "%.")
  if string.match(filename, "^.+%" .. fileExtPattern .. "$") then
    return
	end
  local file_to_open = buf_path:parent() .. "/" .. string.match(filename, "(.-)%.[a-z]+$") .. fileExt
	local exists = vim.fn.filereadable(file_to_open)
	if exists == 0 then
		vim.notify(file_to_open .. " doen't exist", vim.log.levels.WARN)
		return
	end
	load_file_into_buffer(file_to_open)
end

M.openStyle = function()
  openFile(".scss")
end

M.openComponent = function() 
  openFile(".ts")
end

M.openTemplate = function() 
  openFile(".html")
end

M.openSpec = function()
  openFile(".spec.ts")
end

M.showDirFiles = function()
  local _, buf_path = getBufferFileName()
  local dir = buf_path:parent():absolute()
  local matches = scanDir(dir)
  local matchesCount = #matches
  if matchesCount > 0 then
    window.open_window(matches, vim.api.nvim_get_current_buf())
  else
    print("No files in the dir")
  end
end

M.setup = function()
  vim.api.nvim_create_user_command('NgOpenComponent', M.openComponent, { desc = "Open component file"})
  vim.api.nvim_create_user_command('NgOpenTemplate', M.openTemplate, { desc = "Open template file"})
  vim.api.nvim_create_user_command('NgOpenStyle', M.openStyle, { desc = "Open style file"})
  vim.api.nvim_create_user_command('NgOpenSpec', M.openSpec, { desc = "Open spec file"})
  vim.api.nvim_create_user_command('NgShowDirFiles', M.showDirFiles, { desc = "Show dir files"})
end

return M;

