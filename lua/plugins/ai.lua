local function smart_tmux_jump()
  vim.notify("enter smart jump")
  local raw_list = vim.fn.systemlist({ "tmux", "list-panes", "-a", "-F", "#{pane_id}:#{pane_tty}" })

  local target_pane = nil

  for _, line in ipairs(raw_list) do
    local pane_id, pane_tty = line:match("([^:]+):(.+)")

    if pane_id and pane_tty then
      local ps_lines = vim.fn.systemlist({ "ps", "-t", pane_tty, "-o", "args=" })

      if #ps_lines > 0 then
        local last_command = ps_lines[#ps_lines]

        if last_command:find("opencode") then
          target_pane = pane_id
          break
        end
      end
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
      "<leader>aa",
      function()
          local context = require("opencode.context").new()

          require("opencode.ui.ask").ask("@buffer: ", context)
          :next(function(input)
            vim.schedule(function()
              smart_tmux_jump()
            end)

            return require("opencode.api.prompt").prompt(input, { context = context })
          end)
          :catch(function(err)
            context:resume()
            if err then
              vim.notify(err, vim.log.levels.ERROR, { title = "opencode" })
            end
          end)
        end,
        mode = "n",
        desc = "Ask OpenCode & Smart Jump",
      },
      {
        "<leader>aa",
        function()
          local context = require("opencode.context").new()

          require("opencode.ui.ask").ask("@this: ", context)
          :next(function(input)
            vim.schedule(function()
              smart_tmux_jump()
            end)
            return require("opencode.api.prompt").prompt(input, { context = context })
          end)
          :catch(function(err)
            context:resume()
            if err then
              vim.notify(err, vim.log.levels.ERROR, { title = "opencode" })
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
        port = 4096,
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
