local status_ok, indent_blankline = pcall(require, 'indent_blankline')
if not status_ok then
    vim.notify('indent_blankline is not found!')
    return
end

vim.cmd [[highlight IndentBlanklineChar1 guifg=#E06C75 gui=nocombine]]
vim.cmd [[highlight IndentBlanklineChar2 guifg=#E5C07B gui=nocombine]]
vim.cmd [[highlight IndentBlanklineChar3 guifg=#98C379 gui=nocombine]]
vim.cmd [[highlight IndentBlanklineChar4 guifg=#56B6C2 gui=nocombine]]
vim.cmd [[highlight IndentBlanklineChar5 guifg=#61AFEF gui=nocombine]]
vim.cmd [[highlight IndentBlanklineChar6 guifg=#C678DD gui=nocombine]]

vim.cmd [[highlight IndentBlanklineContextChar1 guifg=#E06C75 gui=nocombine]]
vim.cmd [[highlight IndentBlanklineContextChar2 guifg=#E5C07B gui=nocombine]]
vim.cmd [[highlight IndentBlanklineContextChar3 guifg=#98C379 gui=nocombine]]
vim.cmd [[highlight IndentBlanklineContextChar4 guifg=#56B6C2 gui=nocombine]]
vim.cmd [[highlight IndentBlanklineContextChar5 guifg=#61AFEF gui=nocombine]]
vim.cmd [[highlight IndentBlanklineContextChar6 guifg=#C678DD gui=nocombine]]

indent_blankline.setup {
    char = '▏',
    -- context_char = '▎',
    -- char = ' ',
    -- context_char = '▏',
    show_current_context = true,
    show_trailing_blankline_indent = false,
    show_first_indent_level = false,
    use_treesitter = true,
    use_treesitter_scope = false,
    filetype_exclude = {
        'help',
        'startify',
        'dashboard',
        'packer',
        'neogitstatus',
        'nvimtree',
        'trouble',
        'text',
    },
    -- char_highlight_list = {
    --     'IndentBlanklineChar1',
    --     'IndentBlanklineChar2',
    --     'IndentBlanklineChar3',
    --     'IndentBlanklineChar4',
    --     'IndentBlanklineChar5',
    -- },
    -- context_highlight_list = {
    --     'IndentBlanklineContextChar1',
    --     'IndentBlanklineContextChar2',
    --     'IndentBlanklineContextChar3',
    --     'IndentBlanklineContextChar4',
    --     'IndentBlanklineContextChar5',
    -- }
}
