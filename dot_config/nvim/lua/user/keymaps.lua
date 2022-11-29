local opts = { noremap = true, silent = true }
-- shorten function name
local keymap = vim.api.nvim_set_keymap
-- remap space as leader key
vim.g.mapleader = ' '
keymap('', '<Space>', '<Nop>', opts)
-- clear hlight search
keymap('n', '<CR>', ':nohlsearch<CR><CR>', opts)
-- tab
-- keymap('n', '<leader>c', ':tabc<CR>', opts)
-- keymap('n', '<leader>o', ':tabo<CR>', opts)
-- keymap('n', '<leader>j', 'gT', opts)
-- keymap('n', '<leader>k', 'gt', opts)
-- keymap('n', '<leader>1', '1gt', opts)
-- keymap('n', '<leader>2', '2gt', opts)
-- keymap('n', '<leader>3', '3gt', opts)
-- keymap('n', '<leader>4', '4gt', opts)
-- keymap('n', '<leader>5', '5gt', opts)
-- keymap('n', '<leader>6', '6gt', opts)
-- keymap('n', '<leader>7', '7gt', opts)
-- keymap('n', '<leader>8', '8gt', opts)
-- keymap('n', '<leader>9', '9gt', opts)
-- Better window navigation
keymap("n", "<C-h>", ":KittyNavigateLeft<cr>", opts)
keymap("n", "<C-j>", ":KittyNavigateDown<cr>", opts)
keymap("n", "<C-k>", ":KittyNavigateUp<cr>", opts)
keymap("n", "<C-l>", ":KittyNavigateRight<cr>", opts)
-- Resize with arrows
keymap('n', '<C-Up>', ':resize +2<CR>', opts)
keymap('n', '<C-Down>', ':resize -2<CR>', opts)
keymap('n', '<C-Left>', ':vertical resize -2<CR>', opts)
keymap('n', '<C-Right>', ':vertical resize +2<CR>', opts)
-- Navigate buffers
keymap('n', '<S-k>', ':BufferLineCycleNext<CR>', opts)
keymap('n', '<S-j>', ':BufferLineCyclePrev<CR>', opts)
keymap('n', '<leader>c', ':Bdelete<CR>', opts)
keymap('n', '<leader>1', ':BufferLineGoToBuffer 1<CR>', opts)
keymap('n', '<leader>2', ':BufferLineGoToBuffer 2<CR>', opts)
keymap('n', '<leader>3', ':BufferLineGoToBuffer 3<CR>', opts)
keymap('n', '<leader>4', ':BufferLineGoToBuffer 4<CR>', opts)
keymap('n', '<leader>5', ':BufferLineGoToBuffer 5<CR>', opts)
keymap('n', '<leader>6', ':BufferLineGoToBuffer 6<CR>', opts)
keymap('n', '<leader>7', ':BufferLineGoToBuffer 7<CR>', opts)
keymap('n', '<leader>8', ':BufferLineGoToBuffer 8<CR>', opts)
keymap('n', '<leader>9', ':BufferLineGoToBuffer 9<CR>', opts)
keymap('n', '<leader>$', ':BufferLineGoToBuffer -1<CR>', opts)
-- Press jk fast to enter
keymap('i', 'jk', '<ESC>', opts)
-- Easier move header and tail
keymap('n', '<S-h>', '^', opts)
keymap('v', '<S-h>', '^', opts)
keymap('n', '<S-l>', '$', opts)
keymap('v', '<S-l>', '$', opts)
-- Easier indent
keymap('v', '>', '>gv', opts)
keymap('v', '<', '<gv', opts)
-- Paste without replace clipboard
keymap('v', 'p', '"_dP', opts)
-- Move text up and down
keymap('v', '<C-A-j>', ':m \'>+1<CR>gv=gv', opts)
keymap('v', '<C-A-k>', ':m \'<-2<CR>gv=gv', opts)
keymap('n', '<C-A-j>', ':m .+1<CR>==', opts)
keymap('n', '<C-A-k>', ':m .-2<CR>==', opts)
keymap('i', '<C-A-j>', '<Esc>:m .+1<CR>==gi', opts)
keymap('i', '<C-A-k>', '<Esc>:m .-2<CR>==gi', opts)
