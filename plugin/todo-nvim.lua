if vim.g.loaded_todo_nvim == 1 then
    return
end
vim.g.loaded_todo_nvim = 1

if vim.fn.has("nvim-0.9.0") == 0 then
    vim.api.nvim_err_writeln("todo.nvim requires Neovim >= 0.9.0")
    return
end

vim.api.nvim_create_user_command("TodoAdd", function(opts)
    require("todo-nvim").add_todo(opts.args ~= "" and opts.args or nil)
end, { nargs = "?", desc = "Add a todo item" })

vim.api.nvim_create_user_command("TodoSearch", function()
    require("todo-nvim").search_todos()
end, { desc = "Search for TODO comments" })

vim.api.nvim_create_user_command("TodoOpen", function()
    require("todo-nvim").open_todo_file()
end, { desc = "Open todo.md file" })
