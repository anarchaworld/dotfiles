require'nvim-autopairs'.setup()
require'nvim-autopairs.completion.compe'.setup({
    map_cr = true, -- map <CR> in insert mode
    map_complete = true -- auto insert ( after selecting function or method item
})
