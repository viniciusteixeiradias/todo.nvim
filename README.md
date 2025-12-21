# todo.nvim

A lightweight Neovim plugin for quick note-taking and TODO comment searching.

## Features

- **Quick Notes** - Capture todos instantly via floating window or command line, saved to a `TODO.md` file
- **Comment Search** - Find `TODO`, `FIXME`, and custom patterns in your codebase using Telescope
- **Syntax Highlighting** - Highlight TODO comments directly in buffers with customizable colors

## Requirements

- Neovim >= 0.9.0
- [telescope.nvim](https://github.com/nvim-telescope/telescope.nvim)
- [ripgrep](https://github.com/BurntSushi/ripgrep) (optional, for faster search)

## Installation

Using [lazy.nvim](https://github.com/folke/lazy.nvim):

```lua
{
  "viniciusteixeiradias/todo.nvim",
  -- tag = "v1.0.0", -- optional: pin to a specific version
  dependencies = { "nvim-telescope/telescope.nvim" },
  config = function()
    require("todo-nvim").setup()
  end,
}
```

## Usage

### Commands

| Command | Description |
|---------|-------------|
| `:TodoAdd [text]` | Add a quick note. Opens floating input if no text provided |
| `:TodoSearch` | Search for TODO/FIXME comments in your codebase |
| `:TodoOpen` | Open the TODO.md file |

### Default Keymaps

| Keymap | Action |
|--------|--------|
| `<leader>ta` | Add a new todo |
| `<leader>ts` | Search TODO comments |
| `<leader>to` | Open todo file |

## Configuration

```lua
require("todo-nvim").setup({
  todo_file = {
    path = nil,                     -- Custom path (nil = auto-detect)
    use_project_local = true,       -- Look for todo.md in project root
    global_fallback = "~/.todo.md", -- Fallback path
    create_if_missing = true,       -- Create file if it doesn't exist
  },
  patterns = {                       -- Patterns to search (add your own)
    TODO = { fg = "#000000", bg = "#7dd3fc" },   -- Light blue
    FIXME = { fg = "#000000", bg = "#fca5a5" },  -- Light red
    -- NOTE = { fg = "#000000", bg = "#86efac" },  -- Light green
    -- HACK = { fg = "#000000", bg = "#fdba74" },  -- Light orange
  },
  highlight_buffer = true,          -- Highlight patterns in buffers and Telescope
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
    timestamp = false,              -- Add timestamp "YYYY-MM-DD HH:MM"
    timestamp_format = "%Y-%m-%d",
    prefix = "- ",
  },
  keymaps = {
    add_todo = "<leader>ta",
    search_todos = "<leader>ts",
    open_todo_file = "<leader>to",
    -- Set any keymap to false to disable it, e.g.: add_todo = false
  },
  search_ignore = { "node_modules", ".git", "vendor", "dist", "build" },
})
```

## License

MIT License. See (LICENSE)[./LICENSE] file for details.
