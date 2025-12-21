# neovim-todo

A Neovim plugin for managing todos: add items to a todo.md file and search for TODO/FIXME comments in your codebase.

## Requirements

- Neovim >= 0.9.0
- [telescope.nvim](https://github.com/nvim-telescope/telescope.nvim)
- [ripgrep](https://github.com/BurntSushi/ripgrep) (optional, for faster search)

## Installation

Using [lazy.nvim](https://github.com/folke/lazy.nvim):

```lua
{
  "your-username/neovim-todo",
  dependencies = { "nvim-telescope/telescope.nvim" },
  config = function()
    require("neovim-todo").setup()
  end,
}
```

## Usage

### Commands

| Command | Description |
|---------|-------------|
| `:TodoAdd [text]` | Add a todo item (opens floating input if no text provided) |
| `:TodoSearch` | Search for TODO/FIXME comments with Telescope |
| `:TodoOpen` | Open the todo.md file |

### Default Keymaps

| Keymap | Action |
|--------|--------|
| `<leader>ta` | Add a new todo |
| `<leader>ts` | Search TODO comments |
| `<leader>to` | Open todo file |

## Configuration

```lua
require("neovim-todo").setup({
  todo_file = {
    path = nil,                     -- Custom path (nil = auto-detect)
    use_project_local = true,       -- Look for todo.md in project root
    global_fallback = "~/.todo.md", -- Fallback path
    create_if_missing = true,       -- Create file if it doesn't exist
  },
  patterns = {                       -- Comment patterns with highlight colors
    TODO = { fg = "#000000", bg = "#7dd3fc" },
    FIXME = { fg = "#000000", bg = "#fca5a5" },
  },
  highlight_buffer = true,          -- Highlight TODOs in buffers (set to false to disable)
  ui = {
    floating_window = {
      width = 0.6,
      height = 3,
      border = "rounded",
      title = " Add Todo ",
    },
  },
  format = {
    checkbox = true,                -- Add [ ] checkbox
    timestamp = false,              -- Add timestamp
    timestamp_format = "%Y-%m-%d",
    prefix = "- ",
  },
  keymaps = {
    add_todo = "<leader>ta",        -- Set to false to disable
    search_todos = "<leader>ts",
    open_todo_file = "<leader>to",
  },
  search_ignore = { "node_modules", ".git", "vendor", "dist", "build" },
})
```

## License

MIT
