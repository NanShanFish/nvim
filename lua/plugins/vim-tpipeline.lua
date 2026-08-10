return {
  "NanShanFish/vim-tpipeline",
  event = "User NsfLoad",
  init = function ()
    require("ui.statusline")
  end
}
