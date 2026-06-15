return {
  {
    "ellisonleao/gruvbox.nvim",
    lazy = false,
    priority = 1000,
    opts = {
      contrast = "hard",       -- hard | soft | "" (medium)
      transparent_mode = true,
      italic = {
        strings = false,
        emphasis = true,
        comments = true,
        operators = false,
        folds = true,
      },
      overrides = {},
    },
    config = function(_, opts)
      require("gruvbox").setup(opts)
      vim.o.background = "dark"
      vim.cmd.colorscheme("gruvbox")
    end,
  },
}
