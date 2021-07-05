-------------------------- HELPERS -----------------------
local cmd = vim.cmd -- to execute Vim commands e.g. cmd('pwd')
local fn = vim.fn -- to call Vim functions e.g. fn.bufnr()
local opt = vim.opt
local g = vim.g

local function map(mode, lhs, rhs, opts)
    local options = { noremap = true }
    if opts then
        options = vim.tbl_extend("force", options, opts)
    end
    vim.api.nvim_set_keymap(mode, lhs, rhs, options)
end

------------------------ OPTIONS -----------------------
opt.number = true
opt.relativenumber = true
opt.cursorline = true
opt.completeopt = "menuone,noselect" -- for autocomplete
opt.timeoutlen = 500 -- for whichkey
opt.emoji = false
opt.showcmd = true
opt.autoindent = true
opt.expandtab = true
opt.smarttab = true
opt.shiftwidth = 4
opt.softtabstop = 2
opt.wildmenu = true
opt.ignorecase = true
opt.smartcase = true
opt.hidden = true
opt.incsearch = true
opt.hlsearch = true
opt.scrolloff = 4
opt.sidescrolloff = 8
opt.foldenable = true
opt.foldlevelstart = 10
opt.foldnestmax = 10
opt.foldmethod = "manual"
opt.foldcolumn = "2"
opt.termguicolors = true -- this variable must be enabled for colors to be applied properly (nvim-tree)

cmd [[autocmd FocusLost * silent! wall]] -- auto save when losing focus
cmd [[
augroup toggle_relative_number
    autocmd InsertEnter * :setlocal norelativenumber
    autocmd InsertLeave * :setlocal relativenumber
augroup END]]
cmd [[autocmd BufWritePre * :%s/\s\+$//e]] -- remove trailing whitespaces automatically

------------------------ PLUGINS -----------------------
require "plugins"

------------------------ PLUGINS MAPPINGS -----------------------
g.mapleader = "," -- set leader to ,

-- compe
local compe_opts = { expr = true, noremap = true, silent = true }
map("i", "<C-Space>", "compe#complete()", compe_opts)
map("i", "<CR>", 'compe#confirm("<CR>")', compe_opts)
map("i", "<C-e>", 'compe#close("<C-e>")', compe_opts)
map("i", "<C-f>", 'compe#scroll({"delta": +4})', compe_opts)
map("i", "<C-d>", 'compe#scroll({"delta": -4})', compe_opts)

-- lspsaga
local saga_opts = { noremap = true, silent = true }
local bmap = vim.api.nvim_buf_set_keymap
bmap(0, "n", "gh", ":Lspsaga lsp_finder<CR>", saga_opts)
bmap(0, "n", "<leader>ca", ":Lspsaga code_action<CR>", saga_opts)
bmap(0, "v", "<leader>ca", ":<C-U>Lspsaga range_code_action<CR>", saga_opts)
bmap(0, "n", "K", ":Lspsaga hover_doc<CR>", saga_opts)
bmap(
    0,
    "n",
    "<C-f>",
    '<cmd>lua require("lspsaga.action").smart_scroll_with_sage(1)<CR>',
    saga_opts
)
bmap(
    0,
    "n",
    "<C-b>",
    '<cmd>lua require("lspsaga.action").smart_scroll_with_sage(-1)<CR>',
    saga_opts
)
bmap(0, "n", "gs", ":Lspsaga signature_help<CR>", saga_opts)
bmap(0, "n", "gr", ":Lspsaga rename<CR>", saga_opts)
bmap(0, "n", "gd", ":Lspsaga preview_definition<CR>", saga_opts)
bmap(0, "n", "<leader>cd", ":Lspsaga show_line_diagnostics<CR>", saga_opts)
bmap(0, "n", "[e", ":Lspsaga diagnostic_jump_next<CR>", saga_opts)
bmap(0, "n", "]e", ":Lspsaga diagnostic_jump_prev<CR>", saga_opts)
bmap(0, "n", "gt", ":update | :Lspsaga open_floaterm<CR>", saga_opts)
map("t", "gc", "<C-\\><C-n>:Lspsaga close_floaterm<CR>", saga_opts)

-- tree (file explorer)
local tree_opts = { noremap = true, silent = true }
map("n", "<C-n>", ":NvimTreeToggle<CR>", tree_opts)
map("n", "<leader>r", ":NvimTreeRefresh<CR>", tree_opts)
map("n", "<leader>n", ":NvimTreeFindFile<CR>", tree_opts)

-- telescope
map("n", "<leader>ff", "<cmd>Telescope find_files<CR>")
map("n", "<leader>fg", "<cmd>Telescope live_grep<CR>")
map("n", "<leader>fb", "<cmd>Telescope buffers<CR>")
map("n", "<leader>fh", "<cmd>Telescope help_tags<CR>")

-- trouble
local trouble_opts = { noremap = true, silent = true }
map("n", "<leader>xx", "<cmd>Trouble<cr>", trouble_opts)
map(
    "n",
    "<leader>xw",
    "<cmd>Trouble lsp_workspace_diagnostics<cr>",
    trouble_opts
)
map(
    "n",
    "<leader>xd",
    "<cmd>Trouble lsp_document_diagnostics<cr>",
    trouble_opts
)
map("n", "<leader>xl", "<cmd>Trouble loclist<cr>", trouble_opts)
map("n", "<leader>xq", "<cmd>Trouble quickfix<cr>", trouble_opts)
map("n", "<leader>xr", "<cmd>Trouble lsp_references<cr>", trouble_opts)

-- barbar
local bar_opts = { noremap = true, silent = true }
map("n", "<C-h>", ":BufferPrevious<CR>", bar_opts)
map("n", "<C-l>", ":BufferNext<CR>", bar_opts)
map("n", "<A-,>", ":BufferMovePrevious<CR>", bar_opts)
map("n", "<A-.>", ":BufferMoveNext<CR>", bar_opts)
map("n", "<C-_>", ":BufferClose<CR>", bar_opts) -- <C-_> == <C-/>
map("n", "<C-s>", ":BufferPick<CR>", bar_opts)

-- gitsigns
local gitsigns_opts = { noremap = true }
map(
    "n",
    "]c",
    '<cmd>lua require"gitsigns.actions".next_hunk()<CR>',
    { expr = true, noremap = true }
)
map(
    "n",
    "[c",
    '<cmd>lua require"gitsigns.actions".prev_hunk()<CR>',
    { expr = true, noremap = true }
)
map(
    "n",
    "<leader>hs",
    '<cmd>lua require"gitsigns".stage_hunk()<CR>',
    gitsigns_opts
)
map(
    "v",
    "<leader>hs",
    '<cmd>lua require"gitsigns".stage_hunk({vim.fn.line("."), vim.fn.line("v")}',
    gitsigns_opts
)
map(
    "n",
    "<leader>hu",
    '<cmd>lua require"gitsigns".undo_stage_hunk()<CR>',
    gitsigns_opts
)
map(
    "n",
    "<leader>hr",
    '<cmd>lua require"gitsigns".reset_hunk()<CR>',
    gitsigns_opts
)
map(
    "v",
    "<leader>hr",
    '<cmd>lua require"gitsigns".reset_hunk({vim.fn.line("."), vim.fn.line("v")})<CR>',
    gitsigns_opts
)
map(
    "n",
    "<leader>hR",
    '<cmd>lua require"gitsigns".reset_buffer()<CR>',
    gitsigns_opts
)
map(
    "n",
    "<leader>hp",
    '<cmd>lua require"gitsigns".preview_hunk()<CR>',
    gitsigns_opts
)
map(
    "n",
    "<leader>hb",
    '<cmd>lua require"gitsigns".blame_line(true)<CR>',
    gitsigns_opts
)
map(
    "o",
    "ih",
    ':<C-U>lua require"gitsigns.actions".select_hunk()<CR>',
    gitsigns_opts
)
map(
    "x",
    "ih",
    ':<C-U>lua require"gitsigns.actions".select_hunk()<CR>',
    gitsigns_opts
)

------------------------ MAPPINGS -----------------------
map("i", "jj", "<Esc>")
map("n", "<leader><leader>", ":LspRestart<CR>")

------------------------ LSP -----------------------
require "lsp"
require "lsp.python"
--
require "lsp.efm"
