return {
  "nvim-neo-tree/neo-tree.nvim",
  -- branch = "v3.x",
  tag = "3.26",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
    "MunifTanjim/nui.nvim",
    -- "3rd/image.nvim", -- Optional image support in preview window: See `# Preview Mode` for more information
  },
  config = function()
    -- Open sidebar if hidden, focus if visible and close if active.
    vim.keymap.set("n", "\\", function()
      local current_buf_name = vim.api.nvim_buf_get_name(0)
      if string.match(current_buf_name, "/neo%-tree ") then
        print(Neotree_last_source)
        vim.cmd(":Neotree toggle source=" .. (Neotree_last_source or "filesystem"))
      else
        vim.cmd(":Neotree focus source=" .. (Neotree_last_source or "filesystem"))
      end
    end)
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
  end
}
