return {
  "windwp/nvim-autopairs",
  event = "InsertEnter",
  opts = {
    check_ts = true, 
  },
  config = function(_, opts)
    local npairs = require("nvim-autopairs")
    local Rule = require("nvim-autopairs.rule")
    local cond = require("nvim-autopairs.conds")

    npairs.setup(opts)

    npairs.add_rules({
      Rule("<", ">", "rust")
        :with_pair(cond.before_regex("%w", 1))
        :with_move(function(opts)
          return opts.char == ">"
        end)
    })
  end
}
