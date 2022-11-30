local status_ok, alpha = pcall(require, "alpha")
if not status_ok then
    vim.notify('alpha is not found!')
    return
end

local icons = require "user.icons"

local dashboard = require "alpha.themes.dashboard"

local function pick_color()
    local colors = { "String", "Identifier", "Keyword", "Number" }
    return colors[math.random(#colors)]
end

local function info_value()
    local plugins_count = vim.fn.len(vim.fn.globpath("~/.local/share/nvim/site/pack/packer/start", "*", 0, 1))
    local datetime = os.date(" %d-%m-%Y   %H:%M:%S")
    local version = vim.version()
    local nvim_version_info = "   v" .. version.major .. "." .. version.minor .. "." .. version.patch
    return datetime .. "   " .. plugins_count .. " plugins" .. nvim_version_info
end

local logo_value = {
    "                                                     ",
    "  ███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗ ",
    "  ████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║ ",
    "  ██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║ ",
    "  ██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║ ",
    "  ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║ ",
    "  ╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝ ",
    "                                                     ",
}

local fortune_value = require('alpha.fortune')

local logo = {
    type = 'text',
    val = logo_value,
    opts = {
        position = 'center',
        hl = pick_color(),
    },
}

local info = {
    type = 'text',
    val = info_value(),
    opts = {
        position = 'center',
        hl = pick_color(),
    },
}

local fortune = {
    type = 'text',
    val = fortune_value,
    opts = {
        position = 'center',
        hl = pick_color(),
    },
}

local buttons = {
    type = "group",
    val = {
        dashboard.button("f", icons.documents.Files .. " Find file", ":Telescope find_files <CR>"),
         { type = 'padding', val = 1 },
        dashboard.button("e", icons.ui.NewFile .. " New file", ":ene <BAR> startinsert <CR>"),
         { type = 'padding', val = 1 },
        dashboard.button(
            "p",
            icons.git.Repo .. " Find project",
            ":lua require('telescope').extensions.projects.projects()<CR>"
        ),
         { type = 'padding', val = 1 },
        dashboard.button("r", icons.ui.History .. " Recent files", ":Telescope oldfiles <CR>"),
         { type = 'padding', val = 1 },
        dashboard.button("t", icons.ui.List .. " Find text", ":Telescope live_grep <CR>"),
         { type = 'padding', val = 1 },
        dashboard.button("s", icons.ui.SignIn .. " Find Session", ":SearchSession<CR>"),
         { type = 'padding', val = 1 },
        dashboard.button("c", icons.ui.Gear .. " Config", ":e ~/.config/nvim/init.lua <CR>"),
         { type = 'padding', val = 1 },
        dashboard.button("u", icons.ui.CloudDownload .. " Update", ":PackerSync<CR>"),
         { type = 'padding', val = 1 },
        dashboard.button("q", icons.ui.SignOut .. " Quit", ":qa<CR>"),
    },
    position = "center",
}

local config = {
    layout = {
        { type = 'padding', val = 6 },
        logo,
        { type = 'padding', val = 2 },
        info,
        { type = 'padding', val = 2 },
        buttons,
        { type = 'padding', val = 2 },
        fortune,
    }
}
alpha.setup(config)
