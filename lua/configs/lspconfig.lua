-- Use Neovim's native LSP API while keeping NvChad's UI and callbacks.
local nvlsp = require "nvchad.configs.lspconfig"
local util = require "lspconfig.util"

dofile(vim.g.base46_cache .. "lsp")
require("nvchad.lsp").diagnostic_config()

vim.lsp.config("lua_ls", {
    on_attach = nvlsp.on_attach,
    capabilities = nvlsp.capabilities,
    on_init = nvlsp.on_init,

    settings = {
      Lua = {
        diagnostics = {
          globals = { "vim" },
        },
        workspace = {
          library = {
            vim.fn.expand "$VIMRUNTIME/lua",
            vim.fn.expand "$VIMRUNTIME/lua/vim/lsp",
            vim.fn.stdpath "data" .. "/lazy/ui/nvchad_types",
            vim.fn.stdpath "data" .. "/lazy/lazy.nvim/lua/lazy",
            "${3rd}/luv/library",
          },
          maxPreload = 100000,
          preloadFileSize = 10000,
        },
      },
    },
  })

-- Adapt the filename-based root finder to the native buffer/callback API.
local function project_root(...)
  local find_root = util.root_pattern(...)
  return function(bufnr, on_dir)
    local root = find_root(vim.api.nvim_buf_get_name(bufnr))
    if root then
      on_dir(root)
    end
  end
end

local servers = { "html", "cssls" }

for _, lsp in ipairs(servers) do
  vim.lsp.config(lsp, {
    on_attach = nvlsp.on_attach,
    on_init = nvlsp.on_init,
    capabilities = nvlsp.capabilities,
  })
end

vim.lsp.config("csharp_ls", {
  cmd = { "csharp-ls"},
  filetypes = { "cs" },
  root_dir = project_root("*.sln", "*.csproj", ".git"),
  on_attach = function(_, bufnr)
      local bufopts = { noremap = true, silent = true, buffer = bufnr }
      vim.keymap.set("n", "gd", vim.lsp.buf.definition, bufopts)
      vim.keymap.set("n", "K", vim.lsp.buf.hover, bufopts)
      vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, bufopts)
      vim.keymap.set("n", "<leader>.", function()
        vim.lsp.buf.code_action()
      end, bufopts)
    end
})

vim.lsp.config("ts_ls", {
  on_attach = function(_, bufnr)
    local bufopts = { noremap = true, silent = true, buffer = bufnr }
    vim.keymap.set("n", "gd", vim.lsp.buf.definition, bufopts)
    vim.keymap.set("n", "K", vim.lsp.buf.hover, bufopts)
    vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, bufopts)
    vim.keymap.set("n", "<leader>.", function()
      vim.lsp.buf.code_action()
    end, bufopts)
  end,
})

vim.lsp.config("angularls", {
  on_attach = function(_, bufnr)
    local bufopts = { noremap = true, silent = true, buffer = bufnr }
    vim.keymap.set("n", "gd", vim.lsp.buf.definition, bufopts)
    vim.keymap.set("n", "K", vim.lsp.buf.hover, bufopts)
    vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, bufopts)
    vim.keymap.set("n", "<leader>.", function()
      vim.lsp.buf.code_action()
    end, bufopts)
  end,
  cmd = { "ngserver", "--studio" },
  filetypes = { "typescript", "html", "typescriptreact", "typescript.tsx" },
  root_dir = project_root("angular.json"),
})

vim.lsp.config("clangd", {
  filetypes = { "c" },
})

vim.lsp.config("rust_analyzer", {
  on_attach = function(_, bufnr)
    local bufopts = { noremap = true, silent = true, buffer = bufnr }
    vim.keymap.set("n", "gd", vim.lsp.buf.definition, bufopts)
    vim.keymap.set("n", "K", vim.lsp.buf.hover, bufopts)
    vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, bufopts)
    vim.keymap.set("n", "<leader>.", function()
      vim.lsp.buf.code_action()
    end, bufopts)
  end,
  settings = {
    ["rust-analyzer"] = {
      checkOnSave = {
        command = "clippy",
      },
    },
  },
})

vim.lsp.enable({ "lua_ls", "html", "cssls", "csharp_ls", "ts_ls", "angularls", "clangd", "rust_analyzer" })
