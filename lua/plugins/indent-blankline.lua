local highlights = {
  "@markup.heading.1.markdown",
  "@markup.heading.2.markdown",
  "@markup.heading.3.markdown",
  "@markup.heading.4.markdown",
  "@markup.heading.5.markdown",
  "@markup.heading.6.markdown",
}
return {
  "lukas-reineke/indent-blankline.nvim",
  event = "User NsfLoad",
  main = "ibl",
  opts = {
    indent = {
      highlight = highlights,
      char = "|"
    }
  },
}
