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
    sections = {
        lualine_c = {
            {
                'filename',
                path = 1,
                newfile_status = true,
            }
        },
    },
}
