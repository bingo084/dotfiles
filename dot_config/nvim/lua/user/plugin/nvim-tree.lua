local status_ok, nvim_tree = pcall(require, "nvim-tree")
if not status_ok then
    vim.notify("nvim-tree is not found!")
    return
end

local config_status_ok, nvim_tree_config = pcall(require, "nvim-tree.config")
if not config_status_ok then
    return
end

local icons = require "user.icons"

local tree_cb = nvim_tree_config.nvim_tree_callback

nvim_tree.setup {
    hijack_directories = {
        enable = false,
    },
    ignore_ft_on_setup = {
        "startify",
        "dashboard",
        "alpha",
    },
    filters = {
        dotfiles = true,
        exclude = { ".gitignore" },
    },
    sync_root_with_cwd = true,
    renderer = {
        add_trailing = false,
        group_empty = true,
        full_name = true,
        highlight_git = true,
        highlight_opened_files = "none",
        root_folder_modifier = ":t",
        indent_markers = {
            enable = false,
            icons = {
                corner = "└",
                edge = "│",
                item = "│",
                none = " ",
            },
        },
        icons = {
            webdev_colors = true,
            git_placement = "before",
            padding = " ",
            symlink_arrow = " ➛ ",
            show = {
                file = true,
                folder = true,
                folder_arrow = true,
                git = true,
            },
            glyphs = {
                default = "",
                symlink = "",
                folder = {
                    arrow_open = icons.ui.ArrowOpen,
                    arrow_closed = icons.ui.ArrowClosed,
                    default = "",
                    open = "",
                    empty = "",
                    empty_open = "",
                    symlink = "",
                    symlink_open = "",
                },
                git = {
                    -- unstaged = "",
                    -- staged = "S",
                    -- unmerged = "",
                    -- renamed = "➜",
                    -- untracked = "U",
                    -- deleted = "",
                    -- ignored = "◌",
                    unstaged = "✗",
                    staged = "✓",
                    unmerged = "",
                    renamed = "➜",
                    untracked = "★",
                    deleted = "",
                    ignored = "◌",
                },
            },
        },
    },
    diagnostics = {
        enable = true,
        show_on_dirs = true,
        icons = {
            hint = icons.diagnostics.Hint,
            info = icons.diagnostics.Information,
            warning = icons.diagnostics.Warning,
            error = icons.diagnostics.Error,
        },
    },
    update_focused_file = {
        enable = true,
        update_root = true,
        ignore_list = {},
    },
    git = {
        enable = true,
        ignore = true,
        timeout = 500,
    },
    view = {
        adaptive_size = true,
        width = 30,
        hide_root_folder = false,
        side = "left",
        preserve_window_proportions = true,
        signcolumn = "yes",
        mappings = {
            custom_only = false,
            list = {
                { key = { "l", "<CR>", "o" }, cb = tree_cb "edit" },
                { key = "h", cb = tree_cb "close_node" },
                { key = "<C-h>", cb = tree_cb "split" },
            },
        },
        number = false,
        relativenumber = false,
    },
    trash = {
        cmd = "trash",
        require_confirm = false,
    },
}
vim.keymap.set("n", "<leader>mn", require("nvim-tree.marks.navigation").next)
vim.keymap.set("n", "<leader>mp", require("nvim-tree.marks.navigation").prev)
vim.keymap.set("n", "<leader>ms", require("nvim-tree.marks.navigation").select)
