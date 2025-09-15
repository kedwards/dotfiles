local autocmd = vim.api.nvim_create_autocmd

local function augroup(name)
  return vim.api.nvim_create_augroup(name, { clear = true })
end

-- see `:help vim.highlight.on_yank()`
autocmd("TextYankPost", {
  callback = function()
    vim.highlight.on_yank()
  end,
  desc = "Highlight when yank is active",
  group = augroup("highlight_yank"),
})

-- Go to last loction when opening a buffer
autocmd("BufReadPost", {
  callback = function()
    local mark = vim.api.nvim_buf_get_mark(0, '"')
    local lcount = vim.api.nvim_buf_line_count(0)
    if mark[1] > 0 and mark[1] <= lcount then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
  desc = "Go to last loction when opening a buffer",
  group = augroup("last_location"),
})

-- Don't auto comment new line
autocmd("BufWinEnter", {
  callback = function()
    vim.cmd("set formatoptions-=cro")
  end,
  desc = "Dont auto comment new lines",
  group = augroup("auto_format_options"),
})

-- Auto create dir when saving a file, in case some intermediate directory does not exist
autocmd("BufWritePre", {
  callback = function(event)
    local buf_is_valid_and_listed = vim.api.nvim_buf_is_valid(event.buf) and vim.bo[event.buf].buflisted
    if buf_is_valid_and_listed then
      -- local file = vim.loop.fs_realpath(event.match) or event.match
      local file = vim.uv.fs_realpath(event.match) or event.match
      vim.fn.mkdir(vim.fn.fnamemodify(file, ":p:h"), "p")
    end
  end,
  desc = "Create parent directories if they don't exist when saving a file",
  group = augroup("auto_create_dir"),
})

-- Reload file on focus and external change
autocmd({ "FocusGained", "BufEnter" }, {
  command = 'if &buftype == "nofile" | checktime | endif',
  desc = "Auto load file changes when focus or buffer is entered",
  pattern = "*",
  group = augroup("reload_file_group"),
})
autocmd("FileChangedShellPost", {
  callback = function()
    vim.notify("File changed, reloading the buffer", vim.log.levels.WARN)
  end,
  desc = "Actions when the file is changed outside of Neovim",
  group = augroup("reload_file_group"),
})

-- Open quickfix when it is populated
autocmd({ "QuickFixCmdPost" }, {
  desc = "Open location window on location action",
  pattern = "l*",
  command = "lopen",
  group = augroup("QuickFix"),
})
autocmd({ "QuickFixCmdPost" }, {
  desc = "Open quickfix window on quickfix action",
  pattern = [[[^l]*]],
  command = "copen",
  group = augroup("QuickFix"),
})

-- Custom :lcd behavior: prompt if no args, otherwise normal
vim.api.nvim_create_user_command("Lcd", function(opts)
  if opts.args == "" then
    -- No args → interactive prompt
    local cwd = vim.fn.getcwd(0)
    local dir = vim.fn.input("Local CD to: ", cwd .. "/", "dir")
    if dir ~= "" and vim.fn.isdirectory(dir) == 1 then
      vim.cmd("lcd " .. vim.fn.fnameescape(dir))
      print("Local directory changed to: " .. dir)
    else
      print("Invalid directory: " .. dir)
    end
  else
    -- Args given → run normal lcd command
    vim.cmd("lcd " .. opts.args)
  end
end, {
  nargs = "?",
  complete = "dir", -- Enable dir completion in :lcd directly
  force = true, -- Override the default :lcd
})
