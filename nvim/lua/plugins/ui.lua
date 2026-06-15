return {
  -- Status line
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {
      options = {
        theme = "gruvbox",
        component_separators = { left = "", right = "" },
        section_separators = { left = "", right = "" },
        globalstatus = true,
      },
      sections = {
        lualine_a = { "mode" },
        lualine_b = { "branch", "diff", "diagnostics" },
        lualine_c = { { "filename", path = 1 } },
        lualine_x = { "encoding", "fileformat", "filetype" },
        lualine_y = { "progress" },
        lualine_z = { "location" },
      },
    },
  },

  -- Tabline / buffer tabs
  {
    "akinsho/bufferline.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    version = "*",
    opts = {
      options = {
        mode = "buffers",
        diagnostics = "nvim_lsp",
        separator_style = "slant",
        show_buffer_close_icons = true,
        show_close_icon = false,
        color_icons = true,
      },
    },
  },

  -- Indent guides
  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    opts = {
      indent = { char = "│" },
      scope = { enabled = true },
    },
  },

  -- Dashboard
  {
    "nvimdev/dashboard-nvim",
    event = "VimEnter",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {
      theme = "hyper",
      config = {
        week_header = { enable = true },
        shortcut = {
          { desc = " Find File", group = "Label", action = "Telescope find_files", key = "f" },
          { desc = " Recent Files", group = "Label", action = "Telescope oldfiles", key = "r" },
          { desc = " Find Text", group = "Label", action = "Telescope live_grep", key = "g" },
          { desc = " Config", group = "Label", action = "e " .. vim.fn.stdpath("config") .. "/init.lua", key = "c" },
          { desc = " Quit", group = "Label", action = "qa", key = "q" },
        },
      },
    },
  },

  -- Better notifications
  {
    "rcarriga/nvim-notify",
    opts = {
      timeout = 3000,
      render = "compact",
    },
    init = function()
      vim.notify = require("notify")
    end,
  },

  -- Which-key: show keybinding hints
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
      spec = {
        { "<leader>f", group = "Find" },
        { "<leader>g", group = "Git" },
        { "<leader>l", group = "LSP" },
        { "<leader>s", group = "Split" },
        { "<leader>t", group = "Tab" },
        { "<leader>b", group = "Buffer" },
        { "<leader>x", group = "Diagnostics" },
      },
    },
  },
}
