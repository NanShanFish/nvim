
return {
  'nanshanfish/orgmode',
  branch = 'dev',
  ft = { 'org' },
  event = "User NsfLoad",
  config = function()
    local base_dir = vim.fn.expand('~/org/')
    local todo_file_path = base_dir .. 'gtd.org'
    local event_file_path = base_dir .. 'event.org'
    local file_list = { todo_file_path }

    require('orgmode').setup({
      org_todo_keywords = { 'PROJ(p)', 'TODO(t)', 'NEXT(n)', 'WAIT(w)', '|', 'DONE(d)' },
      org_todo_keyword_faces = {
        PROJ = ':foreground #b4befe :weight bold',
        TODO = ':foreground #f5a97f',
        NEXT = ':foreground #8bd5ca',
        WAIT = ':foreground #ed8796',
        DONE = ':foreground #a6e3a1',
      },
      org_agenda_files = file_list,
      org_agenda_skip_scheduled_if_done = true,
      org_agenda_skip_deadline_if_done = true,
      org_agenda_show_future_repeats = false,
      org_agenda_start_on_weekday = false,
      org_agenda_hide_empty_blocks = true,

      org_archive_location = base_dir .. "archive.org::",
      org_log_repeat = false,
      org_todo_repeat_to_state = 'NEXT',
      org_default_notes_file = todo_file_path,
      org_deadline_warning_days = 14,
      use_date_parse = true,
      org_startup_folded = 'content',
      org_agenda_tags_todo_honor_scheduled_and_deadline = true,
      org_startup_indented = true,
      org_capture_templates = {
        j = {
          description = 'Journal',
          template = '\n* %<%H:%M> %?',
          target = base_dir .. '%<%Y/%m/%Y-%m-%d>.org'
        },
        t = {
          description = 'Todo Task',
          template = '* TODO %?\nCREATED: %U\n',
          target = todo_file_path,
          headline = 'Inbox'
        },
        l = {
          description = 'Projects List',
          template = '*** PROJ %?\n    :PROPERTIES:\n    :CATEGORY: %^{项目短标签}\n    :END:\n    CREATED: %U',
          target = todo_file_path,
          headline = 'Projects List'
        },
        e = {
          description = 'Event',
          template = '* %^{Event Name: |}\nDEADLINE: %^{Event day}t\nCREATED: %U\n',
          target = event_file_path,
          headline = 'Event'
        },
        s = {
          description = 'Someday',
          template = '* %?\nCREATED: %U\n',
          target = todo_file_path,
          headline = 'Someday'
        }
      },
      mappings = {
        org = {
          org_todo = "<leader>t"
        }
      },

      org_agenda_custom_commands = {
        o = {
          description = 'Today Focus',
          types = {
            {
              type = 'agenda',
              org_agenda_overriding_header = 'Next Actions (Today Timeline)',
              org_agenda_span = 'day',
              org_agenda_entry_types = { 'scheduled', 'deadline' },
            },
            {
              type = 'agenda',
              org_agenda_span = 'day',
              org_agenda_overriding_header = 'Event list',
              org_agenda_files = { event_file_path, base_dir .. 'references/birth.org' },
            },
            {
              type = 'tags_todo',
              match = 'TODO="NEXT"-prj',
              org_agenda_overriding_header = 'Unscheduled Next Actions',
              org_agenda_todo_ignore_scheduled = 'all',
              org_agenda_todo_ignore_deadlines = 'all',
            },
            {
              type = 'tags_todo',
              match = 'TODO="TODO"-prj',
              org_agenda_overriding_header = 'Inbox / Unplanned Tasks (TODO)',
              org_agenda_todo_ignore_scheduled = 'all',
            },
          },
        },
      }
    })
    vim.keymap.set(
      "n",
      "<leader>op",
      function()
        local Menu = require('orgmode.ui.menu')

        local function move_current_subtree_to(target_headline, is_sub_heading, todo_transform_mode, target_file_path)
          if target_file_path == nil then target_file_path = todo_file_path end

          local src_buf = vim.api.nvim_get_current_buf()
          local target_buf = vim.fn.bufadd(target_file_path)
          vim.fn.bufload(target_buf)

          local cursor_pos = vim.api.nvim_win_get_cursor(0)
          local cursor_line = cursor_pos[1]
          local src_total = vim.api.nvim_buf_line_count(src_buf)

          local start_line = nil
          local current_level = 0

          for i = cursor_line - 1, 0, -1 do
            local lines_fetched = vim.api.nvim_buf_get_lines(src_buf, i, i + 1, false)
            local line_text = lines_fetched[1] or ""
            local stars = line_text:match("^(%*+)%s+")
            if stars then
              start_line = i
              current_level = #stars
              break
            end
          end

          if not start_line then
            vim.notify("No valid org item found at cursor", vim.log.levels.WARN)
            return
          end

          local end_line = src_total
          for i = start_line + 1, src_total - 1 do
            local lines_fetched = vim.api.nvim_buf_get_lines(src_buf, i, i + 1, false)
            local line_text = lines_fetched[1] or ""
            local stars = line_text:match("^(%*+)%s+")
            if stars then
              if #stars <= current_level then
                end_line = i
                break
              end
            end
          end

          local heading_line = nil
          local target_total = vim.api.nvim_buf_line_count(target_buf)
          local dest_level = is_sub_heading and 2 or 1

          for i = 0, target_total - 1 do
            local lines_fetched = vim.api.nvim_buf_get_lines(target_buf, i, i + 1, false)
            local line_text = lines_fetched[1] or ""
            if is_sub_heading then
              if line_text:match("^%*%*%s+") and string.find(line_text, target_headline, 1, true) then
                heading_line = i
                break
              end
            else
              if line_text:match("^%*%s+") and string.find(line_text, target_headline, 1, true) then
                heading_line = i
                break
              end
            end
          end

          if not heading_line then
            vim.notify("Error: Target heading '" .. target_headline .. "' not found in gtd.org! Aborted.", vim.log.levels.ERROR)
            return
          end

          local insert_line = target_total
          for i = heading_line + 1, target_total - 1 do
            local lines_fetched = vim.api.nvim_buf_get_lines(target_buf, i, i + 1, false)
            local line_text = lines_fetched[1] or ""
            local stars = line_text:match("^(%*+)%s+")
            if stars then
              if #stars <= dest_level then
                insert_line = i
                break
              end
            end
          end

          local lines = vim.api.nvim_buf_get_lines(src_buf, start_line, end_line, false)

          local target_required_level = dest_level + 1
          local level_shift = target_required_level - current_level

          for idx, line in ipairs(lines) do
            local stars = line:match("^(%*+)%s+")
            if stars then
              local final_stars = #stars

              if idx == 1 then
                final_stars = target_required_level

                local plain_title = line:gsub("^(%*+)%s+", "")
                local kw_patterns = { "^PROJ%s+", "^TODO%s+", "^NEXT%s+", "^WAIT%s+", "^DONE%s+" }
                for _, pat in ipairs(kw_patterns) do
                  plain_title = plain_title:gsub(pat, "")
                end

                if todo_transform_mode == "PROJ" then
                  lines[idx] = string.rep("*", final_stars) .. " PROJ " .. plain_title
                elseif todo_transform_mode == "TODO" then
                  lines[idx] = string.rep("*", final_stars) .. " TODO " .. plain_title
                elseif todo_transform_mode == "WAIT" then
                  lines[idx] = string.rep("*", final_stars) .. " WAIT " .. plain_title
                elseif todo_transform_mode == "NEXT" then
                  lines[idx] = string.rep("*", final_stars) .. " NEXT " .. plain_title
                elseif todo_transform_mode == "STRIP" then
                  lines[idx] = string.rep("*", final_stars) .. " " .. plain_title
                else
                  lines[idx] = string.rep("*", final_stars) .. " " .. plain_title
                end
              else
                if level_shift ~= 0 then
                  local new_stars_count = #stars + level_shift
                  if new_stars_count < 1 then new_stars_count = 1 end
                  lines[idx] = string.rep("*", new_stars_count) .. " " .. line:gsub("^(%*+)%s+", "")
                end
              end
            end
          end

          vim.api.nvim_buf_set_lines(target_buf, insert_line, insert_line, false, lines)

          if src_buf == target_buf and insert_line < start_line then
            local inserted_count = #lines
            start_line = start_line + inserted_count
            end_line = end_line + inserted_count
          end

          vim.api.nvim_buf_set_lines(src_buf, start_line, end_line, false, {})
        end

        local menu = Menu:new({
          title = 'Refile Subtree to gtd.org',
          prompt = 'Select destination bucket: ',
          items = {
            { key = 'i', label = 'Inbox (set TODO)', action = function() move_current_subtree_to('Inbox', false, 'TODO') end },
            { key = 'c', label = 'Actions -> @computer (set NEXT)', action = function() move_current_subtree_to('@computer', true, 'NEXT') end },
            { key = 'p', label = 'Actions -> @phone (set NEXT)', action = function() move_current_subtree_to('@phone', true, 'NEXT') end },
            { key = 'h', label = 'Actions -> @home (set NEXT)', action = function() move_current_subtree_to('@home', true, 'NEXT') end },
            { key = 'o', label = 'Actions -> @out (set NEXT)', action = function() move_current_subtree_to('@out', true, 'NEXT') end },
            { key = 'l', label = 'Projects List (set PROJ)', action = function() move_current_subtree_to('Projects List', false, 'PROJ') end },
            { key = 'w', label = 'Wait List (set WAIT)', action = function() move_current_subtree_to('Wait List', false, 'WAIT') end },
            { key = 's', label = 'Someday (set PROJ)', action = function() move_current_subtree_to('Someday', false, 'PROJ') end },
            { key = 'e', label = 'Event (strip state)', action = function() move_current_subtree_to('Event', false, 'STRIP', event_file_path) end },
          }
        })
        menu:open()
      end,
      { desc = "Refile current subtree to gtd.org buckets" }
    )

    vim.api.nvim_set_hl(0, '@org.agenda.day',          { fg = '#a6adc8', bold = true })
    vim.api.nvim_set_hl(0, '@org.agenda.today',        { fg = '#eed49f', bold = true, underline = true })
    vim.api.nvim_set_hl(0, '@org.agenda.time_grid',    { fg = '#5b6078' })
    vim.api.nvim_set_hl(0, '@org.agenda.scheduled',    { fg = '#a6e3a1' })
    vim.api.nvim_set_hl(0, '@org.agenda.scheduled_past',{ fg = '#f5bde6', italic = true })
    vim.api.nvim_set_hl(0, '@org.agenda.deadline',     { fg = '#ee99a0', italic = true })
    vim.api.nvim_set_hl(0, '@org.agenda.deadline.upcoming', { fg = '#ee99a0' })
  end,
}
