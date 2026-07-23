return {
  "lukas-reineke/indent-blankline.nvim",
  event = "User NsfLoad",
  main = "ibl",
  cond = function ()
    return vim.bo.filetype ~= 'org'
  end,
  config = function ()
    require("ibl").setup({
      indent = {
        char = "|"
      },
      scope = {
        show_start = true,
      }
    })
  end
}
