require "nvchad.options"

-- add yours here!

-- local o = vim.o
-- o.cursorlineopt ='both' -- to enable cursorline!

-- Treat each snake_case component as a word for motions and text objects.
vim.opt.iskeyword:remove "_"
vim.api.nvim_create_autocmd("FileType", {
  group = vim.api.nvim_create_augroup("SnakeCaseWords", { clear = true }),
  desc = "Keep underscores outside words after filetype settings load",
  callback = function()
    vim.opt_local.iskeyword:remove "_"
  end,
})
