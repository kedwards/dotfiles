-- add mise shims to PATH
-- vim.env.PATH = vim.env.HOME .. '/.local/share/mise/shims:' .. vim.env.PATH

-- set leaders
vim.g.mapleader = " "
vim.g.maplocalleader = ";"

-- disable providers
vim.g.loaded_python_provider = 0
vim.g.loaded_python3_provider = 0
vim.g.loaded_ruby_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_node_provider = 0

-- sync with system clipboard
vim.opt.clipboard = ""

-- hide command line unless needed
vim.opt.cmdheight = 0

-- enable the use of space to insert a <TAB>
vim.opt.expandtab = true

-- use better grep tools if available
if vim.fn.executable("rg") == 1 then
  vim.opt.grepprg = "rg -H --vimgrep --no-heading" .. (vim.opt.smartcase and " --smart-case" or "") .. " --"
  -- vim.opt.grepformat = "%f:%l:%c:%m,%f:%l:%m"
end

-- case insensitive searching
vim.opt.ignorecase = true

-- preview substitutuions live, as you type
vim.opt.inccommand = "split"

-- show numberline
vim.opt.number = true

-- height of the pop up menu, max number of items
vim.opt.pumheight = 10

-- show relative numberline
vim.opt.relativenumber = true

-- number of lines to leave before/after the cursor when scrolling
-- setting a high value keep the cursor centered
vim.opt.scrolloff = 1000

-- number of space inserted for indentation
vim.opt.shiftwidth = 2

vim.opt.signcolumn = "yes"

-- enable persistent undo
vim.opt.undofile = true

-- path to store the undodir
vim.opt.undodir = vim.fn.stdpath("data") .. "/undodir"

function _G.put(...)
  local objects = {}
  for i = 1, select("#", ...) do
    local v = select(i, ...)
    table.insert(objects, vim.inspect(v))
  end

  print(table.concat(objects, "\n"))
  return ...
end
