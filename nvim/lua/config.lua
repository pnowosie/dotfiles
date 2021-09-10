
vim.g.material_style = "palenight"

require('material').set()
require('lualine').setup {
  options = {
    theme = 'material-nvim'
  }
}
require('gitsigns').setup()

