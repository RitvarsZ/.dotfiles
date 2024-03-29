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
        window = {
            mappings = {
               -- disable fuzzy finder
               ["/"] = "noop",
            },
        },
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
    event_handlers = {
        {
            event = "neo_tree_window_after_open",
            handler = function(args)
                -- @see remap.lua
                Neotree_last_source = args.source
            end,
        }
    }
}

