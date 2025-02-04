return {
  {
    "stevearc/conform.nvim",
    -- event = 'BufWritePre', -- uncomment for format on save
    opts = require "configs.conform",
  },

  -- These are some examples, uncomment them if you want to see them work!
  {
    "neovim/nvim-lspconfig",
    config = function()
      require "configs.lspconfig"
    end,
  },

  { "jose-elias-alvarez/null-ls.nvim" },

  {
    {
        "hrsh7th/nvim-cmp",
        dependencies = {
            "hrsh7th/cmp-nvim-lsp",
            "hrsh7th/cmp-buffer",
            "hrsh7th/cmp-path",
            "hrsh7th/cmp-cmdline",
        },
        config = function()
            local cmp = require("cmp")
            cmp.setup({
                sources = {
                    { name = "nvim_lsp" },
                    { name = "buffer" },
                    { name = "path" },
                },
            })
        end,
    }
  },

  {
    "GustavEikaas/easy-dotnet.nvim",
    dependencies = { "nvim-lua/plenary.nvim", 'nvim-telescope/telescope.nvim', },
    keys = "<leader>dn",
    config = function()
      local function get_secret_path(secret_guid)
        return vim.fn.expand('~') .. "/.microsoft/usersecrets/" .. secret_guid .. "/secrets.json"
      end

      local dotnet = require("easy-dotnet")
      dotnet.setup({
        test_runner = {
          viewmode = "float",
          enable_buffer_test_execution = true,
          noBuild = true,
          noRestore = true,
          icons = {
            passed  = "",  -- nf-fa-check (Check mark)
            skipped = "",  -- nf-fa-circle_o (Empty circle for skipped)
            failed  = "",  -- nf-fa-times_circle (X for failure)
            success = "",  -- nf-fa-trophy (Trophy for success)
            reload  = "",  -- nf-fa-refresh (Reload icon)
            test    = "",  -- nf-seti-test (Test tube icon)
            sln     = "",  -- nf-dev-visualstudio (VS solution file icon)
            project = "",  -- nf-dev-dotnet (C# project icon)
            dir     = "",  -- nf-fa-folder (Folder icon)
            package = ""   -- nf-md-package_variant (Package icon)
          },
          mappings = {
            run_test_from_buffer = { lhs = "<leader>r", desc = "run test from buffer" },
            filter_failed_tests = { lhs = "<leader>fe", desc = "filter failed tests" },
            debug_test = { lhs = "<leader>d", desc = "debug test" },
            go_to_file = { lhs = "g", desc = "got to file" },
            run_all = { lhs = "<leader>R", desc = "run all tests" },
            run = { lhs = "<leader>r", desc = "run test" },
            peek_stacktrace = { lhs = "<leader>p", desc = "peek stacktrace of failed test" },
            expand = { lhs = "o", desc = "expand" },
            expand_node = { lhs = "E", desc = "expand node" },
            expand_all = { lhs = "-", desc = "expand all" },
            collapse_all = { lhs = "W", desc = "collapse all" },
            close = { lhs = "q", desc = "close testrunner" },
            refresh_testrunner = { lhs = "<C-r>", desc = "refresh testrunner" }
          }
        },
        terminal = function(path, action, args)
          local commands = {
            run = function()
              return string.format("dotnet run --project %s %s", path, args)
            end,
            test = function()
              return string.format("dotnet test %s %s", path, args)
            end,
            restore = function()
              return string.format("dotnet restore %s %s", path, args)
            end,
            build = function()
              return string.format("dotnet build %s %s", path, args)
            end
          }

          local command = commands[action]() .. "/r"
          vim.cmd("vsplit")
          vim.cmd("term " .. command)
        end,
        secrets = {
          path = get_secret_path
        },
        csproj_mappings = true,
        auto_bootstrap_namespace = {
          type = "file_scoped",
          enanbled = true
        },
      })

      vim.api.nvim_create_user_command('Secrets', function()
        dotnet.secrets()
      end, {})

      vim.api.nvim_create_user_command('TestRunner', function()
        dotnet.testrunner()
      end, {})

      vim.api.nvim_create_user_command('DotnetNew', function()
        dotnet.new()
      end, {})

      --vim.api.nvim_create_user_command('DotnetNewFile', function(path)
      --  dotnet.creatfile(path)
      --end, {})
    end
  }

  -- {
  -- 	"nvim-treesitter/nvim-treesitter",
  -- 	opts = {
  -- 		ensure_installed = {
  -- 			"vim", "lua", "vimdoc",
  --      "html", "css"
  -- 		},
  -- 	},
  -- },
}
