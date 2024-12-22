local null_ls = require("null-ls")

null_ls.setup({
  sources = {
    null_ls.builtins.formatting.csharpier
  }
})

-- commented out due to incorrect formatting in xappido projects
-- TODO: add formattin on command to be used for other csharp projects
-- vim.cmd([[autocmd BufWritePre *.cs lua vim.lsp.buf.format()]])
