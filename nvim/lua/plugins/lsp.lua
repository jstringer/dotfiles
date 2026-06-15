return {
  -- Mason: install and manage LSP servers
  {
    "williamboman/mason.nvim",
    cmd = "Mason",
    keys = { { "<leader>lm", "<cmd>Mason<CR>", desc = "Mason" } },
    opts = {
      ui = {
        icons = {
          package_installed = "✓",
          package_pending   = "➜",
          package_uninstalled = "✗",
        },
      },
    },
  },

  -- lspconfig: provides server definitions (cmd, root_dir, filetypes)
  -- We don't call .setup() on individual servers — mason-lspconfig handles that
  { "neovim/nvim-lspconfig", lazy = true },

  -- mason-lspconfig v2: auto-enables installed servers via vim.lsp.enable()
  {
    "williamboman/mason-lspconfig.nvim",
    event = "VeryLazy",
    dependencies = {
      "williamboman/mason.nvim",
      "neovim/nvim-lspconfig",
      "hrsh7th/cmp-nvim-lsp",
    },
    config = function()
      -- Must require lspconfig early so it populates vim.lsp.config
      -- with server definitions (cmd, root_dir, filetypes, etc.)
      require("lspconfig")

      -- Set capabilities for ALL servers globally (enables nvim-cmp completions)
      local capabilities = require("cmp_nvim_lsp").default_capabilities()
      vim.lsp.config("*", { capabilities = capabilities })

      -- Per-server setting overrides via vim.lsp.config (nvim 0.11+ API)
      vim.lsp.config("lua_ls", {
        settings = {
          Lua = {
            diagnostics = { globals = { "vim" } },
            workspace   = { checkThirdParty = false },
            telemetry   = { enable = false },
          },
        },
      })

      -- Install servers and auto-enable them (automatic_enable = true by default)
      require("mason-lspconfig").setup({
        ensure_installed = {
          "lua_ls", "pyright", "ts_ls",
          "html", "cssls", "jsonls", "yamlls", "bashls",
        },
      })

      -- LSP keymaps — applied whenever any server attaches to a buffer
      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("UserLspConfig", { clear = true }),
        callback = function(ev)
          local map = function(keys, func, desc)
            vim.keymap.set("n", keys, func, { buffer = ev.buf, desc = desc })
          end
          map("gd",         vim.lsp.buf.definition,      "Go to definition")
          map("gD",         vim.lsp.buf.declaration,     "Go to declaration")
          map("gr",         vim.lsp.buf.references,      "References")
          map("gi",         vim.lsp.buf.implementation,  "Go to implementation")
          map("gt",         vim.lsp.buf.type_definition, "Type definition")
          map("K",          vim.lsp.buf.hover,           "Hover docs")
          map("<leader>lr", vim.lsp.buf.rename,          "Rename")
          map("<leader>la", vim.lsp.buf.code_action,     "Code action")
          map("<leader>lf", function()
            vim.lsp.buf.format({ async = true })
          end, "Format")
        end,
      })
    end,
  },
}
