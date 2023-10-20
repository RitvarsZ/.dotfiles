require('lualine').setup {
    options = {
        icons_enabled = true,
        theme = 'horizon',
        component_separators = '|',
        section_separators = '',
        disabled_filetypes = {
            'neo-tree',
            'packer',
        },
    },
    extensions = {
        'neo-tree',
    },
    sections = {
        lualine_c = {
            {
                'filename',
                path = 1,
                newfile_status = true,
                color = {
                    fg = '#fefefe',
                },
            }
        },
    },
    inactive_sections = {
        lualine_a = {
            {
                'filename',
                path = 1,
                color = {
                    fg = '#b0b0b0',
                },
            }
        },
    },
    winbar = {
        lualine_b = {
            {
                'filename',
                path = 0,
                newfile_status = true,
            }
        },
        lualine_c = {
            {
                'diagnostics',
                sources = {'nvim_lsp'},
                sections = {'error', 'warn', 'info', 'hint'},
                always_visible = true,
            }
        }
    },
    inactive_winbar = {
        lualine_b = {
            {
                'filename',
                path = 0,
                newfile_status = true,
            }
        },
        lualine_c = {
            {
                'diagnostics',
                sources = {'nvim_lsp'},
                sections = {'error', 'warn', 'info', 'hint'},
                always_visible = true,
            }
        }
    }
}
