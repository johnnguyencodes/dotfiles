local mode_map = {
  ['NORMAL'] = 'NORMAL',
  ['O-PENDING'] = 'OPERATOR PENDING',
  ['INSERT'] = 'INSERT',
  ['VISUAL'] = 'VISUAL',
  ['V-BLOCK'] = 'V-BLOCK',
  ['V-LINE'] = 'V-LINE',
  ['V-REPLACE'] = 'V-REPLACE',
  ['REPLACE'] = 'REPLACE',
  ['COMMAND'] = 'COMMAND',
  ['SHELL'] = 'SHELL',
  ['TERMINAL'] = 'TERMINAL',
  ['EX'] = 'EX',
  ['S-BLOCK'] = 'S-BLOCK',
  ['S-LINE'] = 'S-LINE',
  ['SELECT'] = 'SELECT',
  ['CONFIRM'] = 'CONFIRM?',
  ['MORE'] = 'MORE',
}

require('lualine').setup {
  options = {
    icons_enabled = true,
    theme = 'auto',
    component_separators = { left = '', right = ''},
    section_separators = { left = '', right = ''},
    disabled_filetypes = {
      statusline = {},
      winbar = {},
    },
    ignore_focus = {},
    always_divide_middle = true,
    globalstatus = true,
    refresh = {
      statusline = 100,
      tabline = 100,
      winbar = 100,
    }
  },
  sections = {
    lualine_a = {
      {'mode', icons_enabled = true, icon = "", fmt = function(s) return mode_map[s] or s end }
    },
    lualine_b = {
      {'branch'},
      {'diff'},
      {'diagnostics'}
    },
    lualine_c = {
      {'fancy_cwd', substitute_home = true, icon = "󰝰 " },
    },
    lualine_x = {
      {"fancy_macro"},
      {"fancy_diagnostics"},
      {"fancy_searchcount"},
      {"fancy_filetype", ts_icon = ""},
    },
    lualine_y = {
      {"fancy_location", },
    },
    lualine_z = {
      {'progress'},
    },

  },
  tabline = {},
  winbar = {},
  inactive_winbar = {},
  extensions = {}
}
