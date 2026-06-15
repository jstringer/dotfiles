return {
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    event = "VeryLazy",
    config = function()
      -- New API: setup() only sets install_dir, highlight/indent are now nvim built-ins
      require("nvim-treesitter").setup()

      -- Compatibility shim: telescope calls parsers.ft_to_lang which was removed
      -- in the nvim-treesitter rewrite. Patch it here, where nvim-treesitter is
      -- guaranteed to be on the rtp and the require will succeed.
      local parsers = require("nvim-treesitter.parsers")
      if not parsers.ft_to_lang then
        parsers.ft_to_lang = function(ft)
          return vim.treesitter.language.get_lang(ft) or ft
        end
      end

      -- Install parsers (replaces old ensure_installed)
      require("nvim-treesitter.install").install({
        "lua", "python", "javascript", "typescript", "tsx",
        "html", "css", "json", "yaml", "toml", "markdown",
        "bash", "c", "cpp", "rust", "go", "vim", "vimdoc",
      }, { reinstall = false })
    end,
  },

  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    event = "VeryLazy",
    config = function()
      require("nvim-treesitter-textobjects").setup({
        select = { lookahead = true },
        move   = { set_jumps = true },
      })

      local select = require("nvim-treesitter-textobjects.select")
      local move   = require("nvim-treesitter-textobjects.move")

      -- Select keymaps
      local sel_maps = {
        ["af"] = "@function.outer",
        ["if"] = "@function.inner",
        ["ac"] = "@class.outer",
        ["ic"] = "@class.inner",
        ["aa"] = "@parameter.outer",
        ["ia"] = "@parameter.inner",
      }
      for key, query in pairs(sel_maps) do
        vim.keymap.set({ "x", "o" }, key, function()
          select.select_textobject(query, "textobjects")
        end, { desc = "Select " .. query })
      end

      -- Move keymaps
      local move_maps = {
        ["]f"] = { dir = "next", start = true,  query = "@function.outer" },
        ["]F"] = { dir = "next", start = false, query = "@function.outer" },
        ["[f"] = { dir = "prev", start = true,  query = "@function.outer" },
        ["[F"] = { dir = "prev", start = false, query = "@function.outer" },
        ["]c"] = { dir = "next", start = true,  query = "@class.outer" },
        ["[c"] = { dir = "prev", start = true,  query = "@class.outer" },
      }
      for key, opts in pairs(move_maps) do
        vim.keymap.set("n", key, function()
          if opts.dir == "next" then
            move.goto_next_start(opts.query, "textobjects")
          else
            move.goto_previous_start(opts.query, "textobjects")
          end
        end, { desc = "Move " .. opts.dir .. " " .. opts.query })
      end
    end,
  },
}
