return {
  { "mason-org/mason.nvim", opts = {} },
  {
    'ray-x/go.nvim',
    requires = {
      'ray-x/guihua.lua'
    },
    config = function()
      require("config/go")
    end
  },
  {
    "mason-org/mason-lspconfig.nvim",
    opts = {
      automatic_enable = {
        exclude = {
          "jdtls",
        },
      },
    },
    dependencies = {
      { "mason-org/mason.nvim", opts = {} },
      "neovim/nvim-lspconfig",
    },
    config = function()
      require("mason-lspconfig").setup({
        ensure_installed = { "lua_ls", "clangd", "gopls" },
      })
    end,
  },
  {
    "mfussenegger/nvim-jdtls",
  },
  {
    "neovim/nvim-lspconfig",
    config = function()
      local capabilities = require("cmp_nvim_lsp").default_capabilities()
      local lspconfig = require("lspconfig")
      lspconfig.lua_ls.setup({
        capabilities = capabilities,
      })
      lspconfig.clangd.setup({
        capabilities = capabilities,
      })
      vim.keymap.set("n", "K", vim.lsp.buf.hover, {})
      vim.keymap.set("n", "gd", vim.lsp.buf.definition, {})
      vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, {})
      lspconfig.gopls.setup({
        cmd = { "gopls" },
        capabilities = capabilities,
        -- for postfix snippets and analyzers
        settings = {
          gopls = {
            buildFlags = { "-tags=wireinject" },
            experimentalPostfixCompletions = true,
            analyses = {
              unusedparams = true,
              shadow = true,
              nilness = true,
              unusedwrite = true,
              useany = true,
            },
            codelenses = {
              gc_details = false,
              generate = true,
              regenerate_cgo = true,
              run_govulncheck = true,
              test = true,
              tidy = true,
              upgrade_dependency = true,
              vendor = true,
            },
            staticcheck = true,
            semanticTokens = true,
            ["ui.inlayhint.hints"] = {
              compositeLiteralFields = true,
              constantValues = true,
              parameterNames = true,
              functionTypeParameters = true,
              compositeLiteralTypes = true,
              assignVariableTypes = true,
            },
            directoryFilters = { "-.git", "-.vscode", "-.idea", "-.vscode-test", "-node_modules" },
            usePlaceholders = true,
          },
        },
      })

      local format_sync_grp = vim.api.nvim_create_augroup("GoFormat", {})
      vim.api.nvim_create_autocmd("BufWritePre", {
        pattern = "*.go",
        callback = function()
          require("go.format").goimports()
        end,
        group = format_sync_grp,
      })

      vim.api.nvim_create_autocmd("FileType", {
        pattern = "java",
        callback = function()
          require("config.jdtls").start()
        end,
      })

      vim.diagnostic.config({
        virtual_text = true,
        signs = true,
        underline = false,
        update_in_insert = false,
        severity_sort = true,
      })
    end,
},}
