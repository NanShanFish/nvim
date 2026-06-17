local function get_recent_diary_files(diary_base)
  local agenda_files = {}
  local current_time = os.time()

  for i = -1, 1 do
    local target_time = os.time({
      year = os.date("%Y", current_time),
      month = os.date("%m", current_time) + i,
      day = 1
    })

    local year = os.date("%Y", target_time)
    local month = os.date("%m", target_time)

    table.insert(agenda_files, string.format("%s/%s/%s/*.org", diary_base, year, month))
  end

  return agenda_files
end

return {
  'nvim-orgmode/orgmode',
  ft = { 'org' },
  keys = {
    { "<leader>oc", "<cmd>Org capture<cr>", desc = 'Capture' },
    { "<leader>oa", "<cmd>Org agenda<cr>", desc = 'Agenda' },
  },
  config = function()
    local base_dir = vim.fn.expand('~/doc/notes/2-daily/')
    local todo_file_path = base_dir .. 'Todo/todo.org'
    local file_list = get_recent_diary_files(base_dir )
    table.insert(file_list, base_dir .. 'Todo/birth.org')
    table.insert(file_list, todo_file_path)

    require('orgmode').setup({
      org_agenda_files = file_list,
      org_default_notes_file = base_dir .. '',
      org_startup_folded = 'content',
      org_startup_indented = true,
      org_deadline_warning_days = 30,
      org_archive_location = base_dir .. '%<%Y/%m/%Y-%m-%d>.org::* Archived Tasks',
      org_agenda_skip_scheduled_if_done = true,
      org_agenda_skip_deadline_if_done = true,
      org_capture_templates = {
        j = {
          description = 'Journal',
          template = '\n* %<%H:%M> %?',
          target = base_dir .. '%<%Y/%m/%Y-%m-%d>.org'
        },
        t = {
        description = 'Todo Task',
        template = '* TODO %?\n  SCHEDULED: %^t\n  CREATE_AT: %U',
        target = todo_file_path
      }
      }
    })

    vim.lsp.enable('org')
  end,
}
