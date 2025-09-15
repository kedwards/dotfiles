local keymap = function(mode, lhs, rhs, opts)
  opts = vim.tbl_extend("keep", opts, { noremap = true, silent = true })
  vim.keymap.set(mode, lhs, rhs, opts)
end

-- Source NVIM
keymap("n", "<space><space>x", "<cmd>source %<cr>", { desc = "Source file" })
keymap("n", "<space><space>y", ":.lua<cr>", { desc = "Source line" })
keymap("v", "<space><space>z", ":lua<cr>", { desc = "Source visual selection" })

-- Clear highlight on search on pressing <Esc> in normal mode
keymap("n", "<Esc>", "<cmd>nohlsearch<CR>", { desc = "Clear search highlighting" })

-- Window navigation
keymap("n", "<C-h>", "<C-w>h", { desc = "Goto window left" })
keymap("n", "<C-l>", "<C-w>l", { desc = "Goto window right" })
keymap("n", "<C-j>", "<C-w>j", { desc = "Goto window up" })
keymap("n", "<C-k>", "<C-w>k", { desc = "Goto window down" })

-- write buffer(s)
keymap("n", "<leader>bw", "<cmd>w<cr>", { desc = "Write" })
keymap("n", "<leader>bW", "<cmd>wall<cr>", { desc = "Write all" })

-- quitting
keymap("n", "<leader>q", "<cmd>confirm q<cr>", { desc = "Quit" })
keymap("n", "<leader>Q", "<cmd>confirm qall<cr>", { desc = "Quit all" })
keymap("n", "<C-q>", "<cmd>qa!<cr>", { desc = "Force quit" })

-- open current buffer in new split
keymap("n", "|", "<cmd>vsplit<cr>", { desc = "Vertical Split" })
keymap("n", "\\", "<cmd>split<cr>", { desc = "Horizontal Split" })

-- create blank lines wo leaving normal mode
keymap("n", "[o", "O<Esc>j", { desc = " Create empty line above" })
keymap("n", "]o", "o<Esc>k", { desc = " Create empty line below" })

-- disable ex mode
keymap("n", "Q", "<Nop>", { desc = "Disable ex mode" })

-- Diagnostic movement
local diagnostic_goto = function(next, severity)
  -- local go = next and vim.diagnostic.goto_next or vim.diagnostic.goto_prev
  local go = next and vim.diagnostic.get_prev or vim.diagnostic.get_next
  local severity_int = severity and vim.diagnostic.severity[severity] or nil
  return function()
    go({ severity = severity_int })
  end
end

keymap("n", "<leader>cd", vim.diagnostic.open_float, { desc = "Line Diagnostics" })
keymap("n", "]d", diagnostic_goto(true), { desc = "Next Diagnostic" })
keymap("n", "[d", diagnostic_goto(false), { desc = "Prev Diagnostic" })
keymap("n", "]e", diagnostic_goto(true, "ERROR"), { desc = "Next Error" })
keymap("n", "[e", diagnostic_goto(false, "ERROR"), { desc = "Prev Error" })
keymap("n", "]w", diagnostic_goto(true, "WARN"), { desc = "Next Warning" })
keymap("n", "[w", diagnostic_goto(false, "WARN"), { desc = "Prev Warning" })

-- Copy entire file to clipboard
keymap("n", "Y", ":%y+<cr>", { desc = "Copy file to clipboard" })

-- Copy file path to clipboard
keymap(
  "n",
  "<leader>cfp",
  [[:let @+ = expand('%')<cr>:echo   "Copied relative file path " . expand('%')<cr>]],
  { desc = "Copy relative file path" }
)
keymap(
  "n",
  "<leader>cfa",
  [[:let @+ = expand('%:p')<cr>:echo "Copied full file path " . expand('%:p')<cr>]],
  { desc = "Copy full file path" }
)
keymap(
  "n",
  "<leader>cfd",
  [[:let @+ = expand('%:p:h')<cr>:echo "Copied file directory path " . expand('%:p:h')<cr>]],
  { desc = "Copy file dir path" }
)
keymap(
  "n",
  "<leader>cfn",
  [[:let @+ = expand('%:t')<cr>:echo "Copied file path " . expand('%:t')<cr>]],
  { desc = "Copy file dir path" }
)

-- Grep --
vim.cmd([[
  " Set grepprg as RipGrep or ag (the_silver_searcher), fallback to grep
  if executable('rg')
    let &grepprg="rg --vimgrep --no-heading --smart-case --hidden --follow -g '!{" . &wildignore . "}' -uu $*"
    let g:grep_literal_flag="-F"
    set grepformat=%f:%l:%c:%m,%f:%l:%m
  else
    let &grepprg='grep -n -r --exclude=' . shellescape(&wildignore) . ' . $*'
    let g:grep_literal_flag="-F"
  endif

  function! RipGrepCWORD(bang, visualmode, ...) abort
    let search_word = a:1

    " Handle visual selection
    if a:visualmode
      let search_word = GetMotion('gv')
    endif
    " Default to <cword> if nothing passed
    if search_word ==? ''
      let search_word = expand('<cword>')
    endif

    " Handle literal searches (bang)
    let qf_title = 'Search'
    if a:bang == "!" || a:bang == v:true
      let qf_title = 'Literal search'
      let search_word = get(g:, 'grep_literal_flag', "") . ' -- ' . shellescape(search_word)
    else
      let search_word = shellescape(search_word)
    endif

    " Run grepprg manually
    let grepcmd = &grepprg
    let results = systemlist(grepcmd . ' ' . search_word)

    " If no results or command error
    if v:shell_error != 0 || empty(results)
      echohl WarningMsg | echon "No matches found" | echohl None
      return
    endif

    " Respect &grepformat and set quickfix title
    call setqflist([], 'r', {
          \ 'lines': results,
          \ 'efm': &grepformat,
          \ 'title': qf_title . ': ' . a:1
          \ })

    " Open quickfix
    " copen
  endfunction
]])

vim.api.nvim_create_user_command("RipGrepCWORD", function(f_opts)
  vim.fn.RipGrepCWORD(f_opts.bang, false, f_opts.args)
end, { bang = true, range = true, nargs = "?", complete = "file_in_path" })

vim.api.nvim_create_user_command("RipGrepCWORDVisual", function(f_opts)
  vim.fn.RipGrepCWORD(f_opts.bang, true, f_opts.args)
end, { bang = true, range = true, nargs = "?", complete = "file_in_path" })

vim.keymap.set({ "n", "v" }, "<C-f>", function()
  return vim.fn.mode() == "v" and ":RipGrepCWORDVisual!<cr>" or ":RipGrepCWORD!<Space>"
end)

-- Movement display linewise linewise, unless a count is given
keymap({ "n", "x" }, "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, desc = "Move cursor linewise down" })
keymap({ "n", "x" }, "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, desc = "Move cursor linewise up" })

-- move line up and down
keymap("n", "<leader>k", "<cmd>move-2<CR>==", { desc = "Move line up" })
keymap("n", "<leader>j", "<cmd>move+<CR>==", { desc = "Move line down" })

-- move block of text in visual mode
keymap("v", "K", ":m '<-2<cr>gv=gv", { desc = "Move selection up" })
keymap("v", "J", ":m '>+1<cr>gv=gv", { desc = "Move selection down" })

-- paste, no copy
keymap("x", "<leader>p", '"_dp', { desc = "Paste without overwriting register" })

-- yank to clipboard
keymap({ "n", "v" }, "<leader>y", '"+y', { desc = "Yank to clipboard" })

-- delete without overwriting register
keymap({ "n", "v" }, "<leader>d", '"_d', { desc = "Delete without overwriting register" })

-- find & replace
keymap("n", "<leader>r", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]], { desc = "Search and replace" })
keymap(
  "v",
  "<leader>r",
  [["hy:%s/<C-r>h/<C-r>h/gI<Left><Left><left>]],
  { desc = "Search and replace visual selection" }
)

-- uppercase typed word in insert mode
keymap("i", "<C-u>", "<esc>mzgUiw`za", { desc = "Upper case word in 'i' mode" })

-- visual shifting does not exit visual mode
keymap("v", "<", "<gv", { desc = "Visual shift does not exit visual mode" })
keymap("v", ">", ">gv", { desc = "Visual shift does not exit visual mode" })
keymap("v", "<S-Tab>", "<gv", { desc = "Visual shift does not exit visual mode" })
keymap("v", "<Tab>", ">gv", { desc = "Visual shift does not exit visual mode" })

-- resize windows
keymap("n", "<C-Left>", ":vertical resize +1<cr>", { desc = "Vertical resize +" })
keymap("n", "<C-Right>", ":vertical resize -1<cr>", { desc = "Vertical resize -" })
keymap("n", "<C-Up>", ":resize -1<cr>", { desc = "Resize -" })
keymap("n", "<C-Down>", ":resize +1<cr>", { desc = "Resize +" })

-- -- navigate buffers|tabs|quickfix|loclist
-- -- for k, v in pairs({
-- --   b = { cmd = 'b', desc = 'buffer' },
-- --   t = { cmd = 'tab', desc = 'tab' },
-- --   q = { cmd = 'c', desc = 'quickfix' },
-- --   l = { cmd = 'l', desc = 'location' },
-- -- }) do
-- --   keymap('n', '[' .. k:lower(), '<cmd>' .. v.cmd .. 'previous<cr>', { desc = 'Previous ' .. v.desc })
-- --   keymap('n', ']' .. k:lower(), '<cmd>' .. v.cmd .. 'next<cr>', { desc = 'Next ' .. v.desc })
-- --   keymap('n', '[' .. k:upper(), '<cmd>' .. v.cmd .. 'first<cr>', { desc = 'First ' .. v.desc })
-- --   keymap('n', ']' .. k:upper(), '<cmd>' .. v.cmd .. 'last<cr>', { desc = 'Last ' .. v.desc })
-- -- end
--
-- -- improved terminal navigation
-- -- keymap('t', '<C-h>', '<cmd>wincmd h<cr>', { desc = 'Terminal left window navigation' })
-- -- keymap('t', '<C-j>', '<cmd>wincmd j<cr>', { desc = 'Terminal down window navigation' })
-- -- keymap('t', '<C-k>', '<cmd>wincmd k<cr>', { desc = 'Terminal up window navigation' })
-- -- keymap('t', '<C-l>', '<cmd>wincmd l<cr>', { desc = 'Terminal right window navigation' })
--
