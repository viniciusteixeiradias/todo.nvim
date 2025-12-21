local M = {}

local config = require("neovim-todo.config")
local utils = require("neovim-todo.utils")

function M.build_pattern()
  local patterns = config.get().patterns
  local comment_prefixes = "(//|#|--|/\\*|%|;|<!--)"
  return comment_prefixes .. "\\s*(" .. table.concat(patterns, "|") .. "):"
end

function M.build_ignore_args()
  local ignores = config.get().search_ignore
  local args = {}
  for _, pattern in ipairs(ignores) do
    table.insert(args, "--glob=!" .. pattern)
  end
  return table.concat(args, " ")
end

local function extract_match_type(text)
  local patterns = config.get().patterns
  for _, pattern in ipairs(patterns) do
    if text:match(pattern) then
      return pattern
    end
  end
  return patterns[1] or "TODO"
end

function M.search()
  local root = utils.get_project_root()
  local pattern = M.build_pattern()
  local results = {}

  local cmd
  if utils.is_ripgrep_available() then
    local ignore_args = M.build_ignore_args()
    cmd = string.format("rg --vimgrep --no-heading -e '%s' %s %s 2>/dev/null", pattern, ignore_args, root)
  else
    cmd = string.format("grep -rn -E '%s' %s 2>/dev/null", pattern, root)
  end

  local output = vim.fn.systemlist(cmd)

  for _, line in ipairs(output) do
    local file, lnum, col, text = line:match("^(.+):(%d+):(%d+):(.*)$")
    if file and lnum then
      table.insert(results, {
        filename = file,
        lnum = tonumber(lnum),
        col = tonumber(col),
        text = vim.trim(text),
        type = extract_match_type(text),
      })
    end
  end

  return results
end

function M.show_telescope(results)
  local ok, pickers = pcall(require, "telescope.pickers")
  if not ok then
    utils.notify("Telescope not found. Install telescope.nvim", vim.log.levels.ERROR)
    return
  end

  local finders = require("telescope.finders")
  local conf = require("telescope.config").values
  local actions = require("telescope.actions")
  local action_state = require("telescope.actions.state")
  local entry_display = require("telescope.pickers.entry_display")

  local displayer = entry_display.create({
    separator = " ",
    items = {
      { width = 6 },
      { width = 40 },
      { remaining = true },
    },
  })

  local make_display = function(entry)
    return displayer({
      { entry.type, "TelescopeResultsIdentifier" },
      { vim.fn.fnamemodify(entry.filename, ":~:.") .. ":" .. entry.lnum, "TelescopeResultsLineNr" },
      { entry.text, "TelescopeResultsComment" },
    })
  end

  pickers.new({}, {
    prompt_title = "TODO Comments",
    finder = finders.new_table({
      results = results,
      entry_maker = function(entry)
        return {
          value = entry,
          display = make_display,
          ordinal = entry.type .. " " .. entry.filename .. " " .. entry.text,
          filename = entry.filename,
          lnum = entry.lnum,
          col = entry.col,
          text = entry.text,
          type = entry.type,
        }
      end,
    }),
    sorter = conf.generic_sorter({}),
    previewer = conf.grep_previewer({}),
    attach_mappings = function(prompt_bufnr)
      actions.select_default:replace(function()
        actions.close(prompt_bufnr)
        local selection = action_state.get_selected_entry()
        if selection then
          vim.cmd("edit " .. vim.fn.fnameescape(selection.filename))
          vim.api.nvim_win_set_cursor(0, { selection.lnum, selection.col - 1 })
        end
      end)
      return true
    end,
  }):find()
end

function M.show()
  local results = M.search()

  if #results == 0 then
    utils.notify("No TODO comments found")
    return
  end

  M.show_telescope(results)
end

return M
