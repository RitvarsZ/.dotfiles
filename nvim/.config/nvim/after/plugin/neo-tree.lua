require('neo-tree').setup{
    source_selector = {
        winbar = false,
        statusline = false,
    },
    enable_git_status = true,
    enable_diagnostics = true,
    default_component_configs = {
        modified = {
            symbol = "[+]",
            highlight = "NeoTreeModified",
        },
        name = {
            use_git_status_colors = true,
            highlight = "NeoTreeFileName",
        },
    },
    filesystem = {
        follow_current_file = {
            enabled = true,
            leave_dirs_open = false,
        },
        hijack_netrw_behavior = "open_default",
        filtered_items = {
            visible = true,
            hide_dotfiles = false,
            hide_gitignored = false,
        },
    },
    buffers = {
        follow_current_file = {
            enabled = true,
            leave_dirs_open = false,
        },
    },
}

