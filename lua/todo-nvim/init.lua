local M = {}

local ui = require("todo-nvim.ui")
local search = require("todo-nvim.search")
local config = require("todo-nvim.config")
local todo_file = require("todo-nvim.todo-file")

local function setup_highlights()
  local patterns = config.get().patterns
  for name, hl in pairs(patterns) do
    vim.api.nvim_set_hl(0, "NeovimTodo" .. name, { fg = hl.fg, bg = hl.bg, bold = true })
  end
end

local comment_prefix_pattern = "\\(//\\|#\\|--\\|/\\*\\|%\\|;\\|<!--\\)\\s*\\zs"

local function apply_buffer_highlights()
  local patterns = config.get().patterns

  for _, win in ipairs(vim.api.nvim_list_wins()) do
    for name, _ in pairs(patterns) do
      local match_pattern = comment_prefix_pattern .. name .. ":"
      pcall(vim.fn.matchadd, "NeovimTodo" .. name, match_pattern, 10, -1, { window = win })
    end
  end
end

function M.setup(opts)
  config.setup(opts)
  setup_highlights()

  if config.get().highlight_buffer then
    local group = vim.api.nvim_create_augroup("NeovimTodoHighlight", { clear = true })

    vim.api.nvim_create_autocmd({ "BufWinEnter", "WinEnter", "BufReadPost", "FileType" }, {
      group = group,
      callback = apply_buffer_highlights,
    })

    vim.api.nvim_create_autocmd("User", {
      group = group,
      pattern = "TelescopePreviewerLoaded",
      callback = apply_buffer_highlights,
    })
  end

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
