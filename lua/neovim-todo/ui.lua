local M = {}

local config = require("neovim-todo.config")

local function create_floating_window()
  local cfg = config.get().ui.floating_window
  local width = math.floor(vim.o.columns * cfg.width)
  local height = cfg.height
  local row = math.floor((vim.o.lines - height) / 2)
  local col = math.floor((vim.o.columns - width) / 2)

  local buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_set_option_value("buftype", "prompt", { buf = buf })

  local win = vim.api.nvim_open_win(buf, true, {
    relative = "editor",
    width = width,
    height = height,
    row = row,
    col = col,
    style = "minimal",
    border = cfg.border,
    title = cfg.title,
    title_pos = "center",
  })

  vim.fn.prompt_setprompt(buf, "Todo: ")

  return buf, win
end

function M.open_add_todo_float(on_submit)
  local buf, win = create_floating_window()

  local function close_window()
    if vim.api.nvim_win_is_valid(win) then
      vim.api.nvim_win_close(win, true)
    end
    if vim.api.nvim_buf_is_valid(buf) then
      vim.api.nvim_buf_delete(buf, { force = true })
    end
  end

  vim.fn.prompt_setcallback(buf, function(text)
    close_window()
    if text and text ~= "" then
      on_submit(text)
    end
  end)

  vim.keymap.set("n", "<Esc>", close_window, { buffer = buf, nowait = true })
  vim.keymap.set("n", "q", close_window, { buffer = buf, nowait = true })

  vim.cmd("startinsert!")
end

return M
