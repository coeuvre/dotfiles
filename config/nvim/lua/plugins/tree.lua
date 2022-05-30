return function(use)
  use {
    "kyazdani42/nvim-tree.lua",
    after = "nvim-web-devicons",

    setup = function()
      local map = require("core.utils").map
      map("n", "<C-n>", "<cmd> :NvimTreeToggle <CR>")
    end,

    config = function()
      require("nvim-tree").setup({
        filters = {
          dotfiles = false,
          exclude = { "custom" },
        },
        disable_netrw = true,
        hijack_netrw = true,
        ignore_ft_on_setup = { "dashboard" },
        open_on_tab = false,
        hijack_cursor = true,
        hijack_unnamed_buffer_when_opening = false,
        update_cwd = true,
        update_focused_file = {
          enable = true,
          update_cwd = false,
        },
        view = {
          side = "left",
          width = 25,
          hide_root_folder = true,
          mappings = {
            list = {
              { key = "<C-n>", action = "close" },
            },
          },
        },
        git = {
          enable = false,
          ignore = true,
        },
        actions = {
          open_file = {
            resize_window = true,
          },
        },
        renderer = {
          indent_markers = {
            enable = false,
          },
          add_trailing = false,
          highlight_git = true,
          highlight_opened_files = "none",
          icons = {
            show = {
              file = true,
              folder = true,
              git = true,
              folder_arrow = true,
            },
            glyphs = {
              default = "",
              symlink = "",
              git = {
                deleted = "",
                ignored = "◌",
                renamed = "➜",
                staged = "✓",
                unmerged = "",
                unstaged = "✗",
                untracked = "★",
              },
              folder = {
                default = "",
                empty = "",
                empty_open = "",
                open = "",
                symlink = "",
                symlink_open = "",
                arrow_open = "",
                arrow_closed = "",
              },
            }
          }
        }
      })
    end,
  }
end
