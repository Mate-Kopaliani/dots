-- Utilities for creating configurations
local util = require "formatter.util"

-- Provides the Format, FormatWrite, FormatLock, and FormatWriteLock commands
require("formatter").setup {
  -- Enable or disable logging
  logging = true,
  -- Set the log level
  log_level = vim.log.levels.WARN,
  -- All formatter configurations are opt-in
  filetype = {
    -- Formatter configurations for filetype "lua" go here
    -- and will be executed in order
    lua = {
      -- "formatter.filetypes.lua" defines default configurations for the
      -- "lua" filetype
      require("formatter.filetypes.lua").stylua,

      -- You can also define your own configuration
      function()
        -- Supports conditional formatting
        if util.get_current_buffer_file_name() == "special.lua" then
          return nil
        end

        -- Full specification of configurations is down below and in Vim help
        -- files
        return {
          exe = "stylua",
          args = {
            "--search-parent-directories",
            "--stdin-filepath",
            util.escape_path(util.get_current_buffer_file_path()),
            "--",
            "-",
          },
          stdin = true,
        }
      end,
    },

    -- Formatter configurations for C and C++
    c = {
      function()
        return {
          exe = "clang-format",
          args = {
            "--assume-filename",
            util.get_current_buffer_file_name(),
            "-style=file",
          },
          stdin = true,
        }
      end,
    },
    cpp = {
      function()
        return {
          exe = "clang-format",
          args = {
            "--assume-filename",
            util.get_current_buffer_file_name(),
            "-style=file",
          },
          stdin = true,
        }
      end,
    },

    -- Formatter configuration for JavaScript using Prettier
    javascript = {
      function()
        return {
          exe = "prettier",
          args = {
            "--stdin-filepath",
            util.escape_path(util.get_current_buffer_file_path()),
            "--single-quote",
            "true", -- Add any Prettier options you need
          },
          stdin = true,
        }
      end,
    },

    -- Formatter configuration for Python using Black
    python = {
      function()
        return {
          exe = "black",
          args = { "--quiet", "-" }, -- Add any Black options you need
          stdin = true,
        }
      end,
    },

    json = {
      function()
        return {
          exe = "jq",
          args = { ".", "--indent", "2" }, -- You can customize jq options here
          stdin = true,
        }
      end,
    },

    -- any filetype
    ["*"] = {
      -- "formatter.filetypes.any" defines default configurations for any
      -- filetype
      require("formatter.filetypes.any").remove_trailing_whitespace,
    },
  },
}
