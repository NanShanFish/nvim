return {
	'git@github.com:NanShanFish/competitest.nvim.git',
	branch = "runner-ui/all-in-one-ops",
	enable = true,
	dependencies = 'MunifTanjim/nui.nvim',
	keys = {
		{ "\\r", "<cmd>CompetiTest run<cr>", desc = "Run testcase" },
		{ "\\c", "<cmd>CompetiTest run_no_compile<cr>", desc = "Run without compile" },
		{ "\\d", "<cmd>CompetiTest delete_testcase<cr>", desc = "Delete testcase" },
		{ "\\<space>", "<cmd>CompetiTest show_ui<cr>", desc = "Show last ui" },
	},
	config = function() require('competitest').setup {
		floating_border = 'single',
		compile_directory = "./output/",
		compile_command = {
			c = { exec = "gcc", args = { "-Wall", "$(FNAME)", "-o", "output/$(FNOEXT)" } },
			cpp = { exec = "g++", args = { "-Wall", "$(FABSPATH)", "-o", "$(ABSDIR)/output/$(FNOEXT)" } },
		},
		runner_ui = {
			-- interface = "split",
			show_nu = false,
		},
		running_directory = ".",
		run_command = {
			c = { exec = "./output/$(FNOEXT)" },
			cpp = { exec = "$(ABSDIR)/output/$(FNOEXT)" },
			python = { exec = "python", args = { "$(FNAME)" } },
		},
		testcases_directory = ".test/",
		testcases_use_single_file = false,
		testcases_auto_detect_storage = true,
		testcases_input_file_format = "$(FNOEXT)_input$(TCNUM).txt",
		testcases_output_file_format = "$(FNOEXT)_output$(TCNUM).txt",
	} end,
}
