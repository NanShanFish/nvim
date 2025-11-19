return {
  "nvim-lualine/lualine.nvim",
  event = "User NsfLoad",
  init = function()
    vim.g.lualine_laststatus = 0
    vim.o.laststatus = 0
  end,
  opts = {
    options = {
      theme = "tokyonight",
      globalstatus = false,
      component_separators = '|',
      section_separators =  { left = '', right ='' },
    },
    sections = {
      lualine_a = { "mode" },
      lualine_b = {
        {
          'buffers',
          show_filename_only = false,
        },
      },
      lualine_c = {
        {
          "diagnostics",
          symbols = {
            error ="✘",
            warn = "▲",
            info = "»",
            hint = "!",
          },
        },
        function ()
          local recording_register = vim.fn.reg_recording()
          if recording_register == "" then
            return ""
          else
            return "Recording @" .. recording_register
          end
        end,
      },

      lualine_x = {
        {
          "diff",
          symbols = {
            added = "+",
            modified = "~",
            removed = "-",
          },
        },
      },
      lualine_y = {
        'fileformat',
      },
      lualine_z = {
        "branch",
        "progress"
      },
    },
  },
}
