local M = {}

local config = require("neovim-todo.config")
local todo_file = require("neovim-todo.todo-file")
local search = require("neovim-todo.search")
local ui = require("neovim-todo.ui")

function M.setup(opts)
  config.setup(opts)

  local keymaps = config.get().keymaps
  if keymaps.add_todo then
    vim.keymap.set("n", keymaps.add_todo, M.add_todo, { desc = "Add todo" })
  end
  if keymaps.search_todos then
    vim.keymap.set("n", keymaps.search_todos, M.search_todos, { desc = "Search todos" })
  end
  if keymaps.open_todo_file then
    vim.keymap.set("n", keymaps.open_todo_file, M.open_todo_file, { desc = "Open todo file" })
  end
end

function M.add_todo(text)
  if text then
    todo_file.add(text)
  else
    ui.open_add_todo_float(function(input)
      todo_file.add(input)
    end)
  end
end

function M.search_todos()
  search.show()
end

function M.open_todo_file()
  todo_file.open()
end

return M
