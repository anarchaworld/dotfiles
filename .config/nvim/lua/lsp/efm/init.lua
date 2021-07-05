local on_attach = function(client)
    if client.resolved_capabilities.document_formatting then
        vim.cmd [[augroup Format]]
        vim.cmd [[autocmd! * <buffer>]]
        vim.cmd [[autocmd BufWritePost <buffer> lua require'lsp.efm.formatting'.format()]]
        vim.cmd [[augroup END]]
    end
end

local home = os.getenv "HOME"
local efm_log = "/tmp/efm.log"
local black = require "lsp/efm/black"
local isort = require "lsp/efm/isort"
local flake8 = require "lsp/efm/flake8"
local mypy = require "lsp/efm/mypy"
local stylua = require "lsp/efm/stylua"
local efm_config = home .. "/.config/efm-langserver/config.yaml"

require("lspconfig").efm.setup {
    cmd = { "efm-langserver", "-c", efm_config, "-logfile", efm_log },
    on_attach = on_attach,
    root_dir = vim.loop.cwd,
    init_options = { documentFormatting = true },
    filetype = {
        "python",
        "lua",
    },
    settings = {
        rootMarkers = { ".git/" },
        languages = {
            python = { black, isort, flake8, mypy },
            lua = { stylua },
        },
    },
}
