return {
  -- File explorer
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    cmd = { "Neotree" },
    init = function()
      vim.api.nvim_create_autocmd("VimEnter", {
        callback = function()
          if vim.fn.argc() == 0 then
            vim.cmd("Neotree show")
          end
        end,
      })
    end,
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
      "MunifTanjim/nui.nvim",
    },
    keys = {
      { "<leader>e", "<cmd>Neotree toggle<CR>", desc = "Toggle file explorer" },
      { "<leader>E", "<cmd>Neotree reveal<CR>", desc = "Reveal current file" },
    },
    opts = {
      filesystem = {
        follow_current_file = { enabled = true },
        hijack_netrw_behavior = "open_current",
        use_libuv_file_watcher = true,
      },
      window = {
        position = "left",
        width = 35,
      },
    },
  },

  -- Fuzzy finder
  {
    "nvim-telescope/telescope.nvim",
    branch = "0.1.x",
    cmd = "Telescope",
    dependencies = {
      "nvim-lua/plenary.nvim",
      { "nvim-telescope/telescope-fzf-native.nvim", build = "cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build" },
    },
    keys = {
      { "<leader>ff", "<cmd>Telescope find_files<CR>", desc = "Find files" },
      { "<leader>fg", "<cmd>Telescope live_grep<CR>", desc = "Live grep" },
      { "<leader>fb", "<cmd>Telescope buffers<CR>", desc = "Buffers" },
      { "<leader>fh", "<cmd>Telescope help_tags<CR>", desc = "Help tags" },
      { "<leader>fr", "<cmd>Telescope oldfiles<CR>", desc = "Recent files" },
      { "<leader>fc", "<cmd>Telescope colorscheme<CR>", desc = "Colorschemes" },
      { "<leader>fk", "<cmd>Telescope keymaps<CR>", desc = "Keymaps" },
      { "<C-p>", "<cmd>Telescope find_files<CR>", desc = "Find files" },
    },
    config = function()
      local telescope = require("telescope")
      local actions = require("telescope.actions")
      telescope.setup({
        defaults = {
          path_display = { "truncate" },
          mappings = {
            i = {
              ["<C-u>"] = actions.move_selection_previous,
              ["<C-d>"] = actions.move_selection_next,
              ["<C-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
              ["<Esc>"] = actions.close,
            },
          },
        },
      })

      -- Replace telescope's previewer treesitter highlighter with one that uses
      -- Neovim 0.11's built-in treesitter API. The old nvim-treesitter API
      -- (parsers.ft_to_lang, configs.is_enabled, etc.) was removed in the rewrite.
      local preview_utils = require("telescope.previewers.utils")
      preview_utils.ts_highlighter = function(bufnr, ft)
        local lang = vim.treesitter.language.get_lang(ft) or ft
        return pcall(vim.treesitter.start, bufnr, lang)
      end

      -- fzf-native needs to be compiled; load it only if the build succeeded
      local ok, _ = pcall(telescope.load_extension, "fzf")
      if not ok then
        vim.notify("telescope-fzf-native not built. Run :Lazy build telescope-fzf-native.nvim", vim.log.levels.WARN)
      end
    end,
  },

  -- Auto pairs
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    opts = { check_ts = true },
  },

  -- Commenting
  {
    "numToStr/Comment.nvim",
    event = "VeryLazy",
    opts = {},
  },

  -- Surround (add/change/delete surrounding chars)
  {
    "kylechui/nvim-surround",
    event = "VeryLazy",
    opts = {},
  },

  -- Better f/t motions
  {
    "folke/flash.nvim",
    event = "VeryLazy",
    keys = {
      { "s", mode = { "n", "x", "o" }, function() require("flash").jump() end, desc = "Flash jump" },
      { "S", mode = { "n", "x", "o" }, function() require("flash").treesitter() end, desc = "Flash treesitter" },
    },
  },

  -- Tmux pane navigation (seamless with ctrl+hjkl)
  {
    "christoomey/vim-tmux-navigator",
    cmd = {
      "TmuxNavigateLeft", "TmuxNavigateDown",
      "TmuxNavigateUp", "TmuxNavigateRight",
    },
    keys = {
      { "<C-h>", "<cmd>TmuxNavigateLeft<CR>" },
      { "<C-j>", "<cmd>TmuxNavigateDown<CR>" },
      { "<C-k>", "<cmd>TmuxNavigateUp<CR>" },
      { "<C-l>", "<cmd>TmuxNavigateRight<CR>" },
    },
  },

  -- Harpoon (quick file bookmarks)
  {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      local harpoon = require("harpoon")
      harpoon:setup()
      local map = vim.keymap.set
      map("n", "<leader>ha", function() harpoon:list():add() end, { desc = "Harpoon add" })
      map("n", "<leader>hh", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end, { desc = "Harpoon menu" })
      map("n", "<leader>1", function() harpoon:list():select(1) end, { desc = "Harpoon 1" })
      map("n", "<leader>2", function() harpoon:list():select(2) end, { desc = "Harpoon 2" })
      map("n", "<leader>3", function() harpoon:list():select(3) end, { desc = "Harpoon 3" })
      map("n", "<leader>4", function() harpoon:list():select(4) end, { desc = "Harpoon 4" })
    end,
  },

  -- Trouble: better diagnostics list
  {
    "folke/trouble.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    keys = {
      { "<leader>xx", "<cmd>Trouble diagnostics toggle<CR>", desc = "Toggle diagnostics" },
      { "<leader>xb", "<cmd>Trouble diagnostics toggle filter.buf=0<CR>", desc = "Buffer diagnostics" },
    },
    opts = {},
  },
}
