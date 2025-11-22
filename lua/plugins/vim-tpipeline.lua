return {
  "NanShanFish/vim-tpipeline",
  enabled = true,
  event = "User NsfLoad",
  init = function ()
    require("ui.statusline")
  end
}
