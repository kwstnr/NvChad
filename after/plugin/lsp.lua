-- Mason basic setup
require("mason").setup()
require("mason-lspconfig").setup({
  ensure_installed = { "rust_analyzer" },
})

-- Enable nvim-cmp completion capabilities
local capabilities = require("cmp_nvim_lsp").default_capabilities()

-- LSP setup for rust
require("lspconfig").rust_analyzer.setup({
  capabilities = capabilities,
  settings = {
    ["rust-analyzer"] = {
      cargo = { allFeatures = true },
      checkOnSave = {
        command = "clippy"
      },
    }
  }
})
