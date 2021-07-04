local on_attach = function(client)
    if client.resolved_capabilities.document_formatting then
        vim.cmd [[augroup Format]]
        vim.cmd [[autocmd! * <buffer>]]
        vim.cmd [[autocmd BufWritePost <buffer> lua require'lsp.efm.formatting'.format()]]
        vim.cmd [[augroup END]]
    end
end


local black = require "lsp/efm/black"
local isort = require "lsp/efm/isort"
local flake8 = require "lsp/efm/flake8"
local mypy = require "lsp/efm/mypy"

require "lspconfig".efm.setup {
    on_attach = on_attach,
    init_options = {documentFormatting = true},
    root_dir = vim.loop.cwd,
    settings = {
        rootMarkers = {".git/"},
        languages = {
            python = {black, isort, flake8, mypy}
        }
    }
}
