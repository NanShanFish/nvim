local function smart_tmux_jump()
  local raw_list = vim.fn.systemlist({ "tmux", "list-panes", "-a", "-F", "#{pane_id}:#{pane_current_command}" })

  local target_pane = nil

  for _, line in ipairs(raw_list) do
    local pane_id, command = line:match("([^:]+):(.+)")
    if command and command:find("opencode") then
      target_pane = pane_id
      break
    end
  end

  if target_pane then
    vim.fn.system({ "tmux", "select-pane", "-t", target_pane })
  end
end


return {
  "nickjvandyke/opencode.nvim",
  version = "*",
  keys = {
    {
      "<C-a>",
      function()
        require("opencode").ask("@buffer: "):next(function(input)
          if input and input ~= "" then
            vim.schedule(smart_tmux_jump)
          end
        end)
      end,
      mode = "n",
      desc = "Ask OpenCode & Smart Jump",
    },
    {
      "<C-a>",
      function()
        require("opencode").ask("@this: "):next(function(input)
          if input and input ~= "" then
            vim.schedule(smart_tmux_jump)
          end
        end)
      end,
      mode = "v",
      desc = "Ask OpenCode (Selection) & Smart Jump",
    },
  },

  config = function()
    local opencode_window = "opencode"
    local opencode_cmd = "opencode --port"

    local function tmux_window_exists()
      local windows = vim.fn.systemlist({ "tmux", "list-windows", "-F", "#W" })
      return vim.tbl_contains(windows, opencode_window)
    end

    vim.g.opencode_opts = {
      server = {
        start = function()
          if not tmux_window_exists() then
            vim.fn.system({ "tmux", "new-window", "-d", "-n", opencode_window, opencode_cmd })
          end
        end,
        stop = function()
          if tmux_window_exists() then
            vim.fn.system({ "tmux", "kill-window", "-t", opencode_window })
          end
        end,
        toggle = function()
          if tmux_window_exists() then
            vim.fn.system({ "tmux", "select-window", "-t", opencode_window })
          else
            vim.fn.system({ "tmux", "new-window", "-n", opencode_window, opencode_cmd })
          end
        end,
      },
    }

    vim.o.autoread = true
  end,
}
