local M = {}

local config = require("neovim-todo.config")
local utils = require("neovim-todo.utils")

function M.get_path()
  local cfg = config.get().todo_file

  if cfg.path then
    return utils.expand_path(cfg.path)
  end

  if cfg.use_project_local then
    local root = utils.get_project_root()
    local candidates = { "TODO.md", "todo.md" }
    for _, name in ipairs(candidates) do
      local path = root .. "/" .. name
      if utils.file_exists(path) then
        return path
      end
    end
    return root .. "/TODO.md"
  end

  return utils.expand_path(cfg.global_fallback)
end

function M.ensure_file_exists()
  local path = M.get_path()
  local cfg = config.get().todo_file

  if not utils.file_exists(path) and cfg.create_if_missing then
    utils.ensure_parent_dir(path)
    local file = io.open(path, "w")
    if file then
      file:write("# TODOs\n\n")
      file:close()
    end
  end

  return path
end

function M.format_todo(text)
  local cfg = config.get().format
  local line = cfg.prefix

  if cfg.checkbox then
    line = line .. "[ ] "
  end

  if cfg.timestamp then
    line = line .. os.date(cfg.timestamp_format) .. " "
  end

  return line .. text
end

function M.add(text)
  local path = M.ensure_file_exists()
  local formatted = M.format_todo(text)

  local file = io.open(path, "a")
  if file then
    file:write(formatted .. "\n")
    file:close()
    utils.notify("Todo added: " .. text)
  else
    utils.notify("Failed to write to " .. path, vim.log.levels.ERROR)
  end
end

function M.open()
  local path = M.ensure_file_exists()
  vim.cmd("edit " .. vim.fn.fnameescape(path))
end

return M
