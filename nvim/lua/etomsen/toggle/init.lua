local M = {
    toggles_by_filetype = {},
    popup_id = nil
}

local path = require("plenary.path")
local popup = require("plenary.popup")

local function load_file_into_buffer(file)
	local uri = vim.uri_from_fname(file)
	local new_buff = vim.uri_to_bufnr(uri)
	vim.api.nvim_win_set_buf(0, new_buff)
	vim.fn.execute("edit!")
end

local get_buffer_file_name = function(buffer)
    local current_buffer = buffer or vim.api.nvim_buf_get_name(0)
    local buf_path = path:new(current_buffer)
    local relative_path = buf_path:make_relative()
    local filename = string.match(relative_path, "([^/]+)$")
    return filename, buf_path
end


local toggle_file = function(buffer, from, to)
    local filename, buf_path = get_buffer_file_name(buffer)

    local from_pattern = string.gsub(from, ".", "%.")

    if not string.match(filename, "^.+%" .. from_pattern .. "$") then
        vim.notify(filename .. " does not match neither from='" .. from .. "' nor to='" .. to "'", vim.log.levels.WARN)
        return
    end

    local file_to_open  = string.gsub(filename, "(%w+)" .. from_pattern .. "$", "%1") .. to

    local open_full_path = buf_path:parent() .. "/" .. file_to_open
    local exists = vim.fn.filereadable(open_full_path )
    if exists == 0 then
        vim.notify(open_full_path .. " doen't exist", vim.log.levels.WARN)
        return
    end
    load_file_into_buffer(open_full_path)
end

M.add_toggle = function(filetype, from, to, name)
    M.toggles_by_filetype[filetype] = M.toggles_by_filetype[filetype] or {}
    local toggles = M.toggles_by_filetype[filetype];
    toggles[#toggles+1] = {
        name = name,
        to = to,
        callback = function(buffer)
            toggle_file(buffer, from, to)
        end
    }
end

M.close_menu = function ()
  vim.api.nvim_win_close(M.popup_id, true)
end

M.select_toggle = function(toggles)
    local buffer = vim.api.nvim_buf_get_name(0)
    local filename,buf_path = get_buffer_file_name(buffer)
    local height = #toggles
    local width = 40
    local borderchars = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" }

    local on_toggle_select = function(i, toggle_name)
        for _,toggle in pairs(toggles) do
            if toggle.name == toggle_name then
                M.close_menu()
                toggle.callback(buffer)
                break
            end
        end

    end

    local options = {}

    for i, toggle in ipairs(toggles) do
        options[#options+1] = toggle.name
    end

    M.popup_id = popup.create(options, {
        title = filename,
        highlight = "MyProjectWindow",
        line = math.floor(((vim.o.lines - height) / 2) - 1),
        col = math.floor((vim.o.columns - width) / 2),
        minwidth = width,
        minheight = height,
        borderchars = borderchars,
        callback = on_toggle_select,
    })
end

M.toggle_to = function(to)
    local buffer = vim.api.nvim_buf_get_name(0)
    local buff_file_type = vim.bo.filetype;
    local toggles = M.toggles_by_filetype[buff_file_type]

    if not toggles or #toggles == 0 then
        vim.notify("No toggles registered for filetype='" .. buff_file_type .. "'", vim.log.levels.WARN)
        return
    end

    for _,toggle in pairs(toggles) do
        if toggle.to == to then
            toggle.callback(buffer)
            return
        end
    end
    vim.notify("No toggles registered for filetype='" .. buff_file_type .. "' and to='" .. to .."'", vim.log.levels.ERROR)
end

M.toggle = function()
    local buff_file_type = vim.bo.filetype;
    local toggles = M.toggles_by_filetype[buff_file_type]

    if not toggles then
        vim.notify("No toggles registered for filetype='" .. buff_file_type .. "'", vim.log.levels.WARN)
        return
    end

    if #toggles == 1 then
        toggles[1].callback()
        return
    end
    M.select_toggle(toggles)
end

-- example {{filetype = "typescript", from = ".ts", to = ".spec.ts", name = "spec <=> ts"}} - will configure the spec <-> ts toggle for all the typescript files
M.setup = function(toggles)
    toggles = toggles or {}
    for i, toggle in ipairs(toggles) do
        M.add_toggle(toggle.filetype, toggle.from, toggle.to, toggle.name)
    end
    vim.api.nvim_create_user_command('ToggleFile', M.toggle, { desc = "Toggle file"})
    vim.api.nvim_create_user_command('ToggleFileTo', function(opts)
        M.toggle_to(opts.args)
    end, { nargs= '?', desc = "Toggle file to"})
end

return M;

