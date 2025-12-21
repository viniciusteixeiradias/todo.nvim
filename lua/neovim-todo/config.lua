local M = {}

local defaults = {
  todo_file = {
    path = nil,
    use_project_local = true,
    global_fallback = "~/.todo.md",
    create_if_missing = true,
  },
  patterns = { "TODO", "FIXME" },
  ui = {
    add_todo_method = "floating",
    search_results = "telescope",
    floating_window = {
      width = 0.6,
      height = 3,
      border = "rounded",
      title = " Add Todo ",
    },
  },
  format = {
    checkbox = true,
    timestamp = false,
    timestamp_format = "%Y-%m-%d",
    prefix = "- ",
  },
  keymaps = {
    add_todo = "<leader>ta",
    search_todos = "<leader>ts",
    open_todo_file = "<leader>to",
  },
  search_ignore = { "node_modules", ".git", "vendor", "dist", "build" },
}

M._config = vim.deepcopy(defaults)

function M.setup(opts)
  M._config = vim.tbl_deep_extend("force", defaults, opts or {})
end

function M.get()
  return M._config
end

return M
