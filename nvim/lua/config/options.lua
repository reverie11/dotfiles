-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
--
--
vim.g.mapleader = ","

vim.opt.shiftwidth = 2
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.expandtab = true

vim.g.autoformat = false

vim.opt.textwidth = 105
vim.opt.formatoptions:append("t")
vim.opt.colorcolumn = "106"

vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
vim.opt.foldmethod = "marker"

vim.filetype.add({ 
  extension = { tex = 'tex' },
  pattern = { [".*/tmux/.*%.conf"] = "tmux" },
})

vim.opt.iskeyword:remove("_")

-- Over SSH, yank to the local machine's clipboard with OSC 52.
-- LazyVim turns the system clipboard off when SSH_TTY is set; turn it back on.
-- Paste uses what was last yanked in this nvim, so the terminal never asks to read the clipboard.
if vim.env.SSH_TTY then
  vim.opt.clipboard = "unnamedplus"
  local osc52 = require("vim.ui.clipboard.osc52")
  local last = { ["+"] = { {}, "v" }, ["*"] = { {}, "v" } }
  local function copy(reg)
    local send = osc52.copy(reg)
    return function(lines, regtype)
      last[reg] = { lines, regtype }
      send(lines, regtype)
    end
  end
  local function paste(reg)
    return function()
      return last[reg]
    end
  end
  vim.g.clipboard = {
    name = "OSC 52",
    copy = { ["+"] = copy("+"), ["*"] = copy("*") },
    paste = { ["+"] = paste("+"), ["*"] = paste("*") },
  }
end
