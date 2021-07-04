local execute = vim.api.nvim_command
local fn = vim.fn
local install_path = fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'

if fn.empty(fn.glob(install_path)) > 0 then
    fn.system({
        'git', 'clone', 'https://github.com/wbthomason/packer.nvim',
        install_path
    })
    execute 'packadd packer.nvim'
end

-- Autocompile
vim.cmd [[autocmd BufWritePost "plugins/init.lua" PackerCompile]]


require('packer').startup(function()
    -- Package Manager
    use 'wbthomason/packer.nvim'
    -- LSP
    use 'neovim/nvim-lspconfig'
    use {'glepnir/lspsaga.nvim', config = require('lspsaga').init_lsp_saga()}
    use {'hrsh7th/nvim-compe', config = require('plugins.compe')}
    -- Navigation
    use {
        'kyazdani42/nvim-tree.lua',
        requires = 'kyazdani42/nvim-web-devicons',
        config = require('plugins.tree')
    }
    use {
        'nvim-telescope/telescope.nvim',
        requires = {{'nvim-lua/popup.nvim'}, {'nvim-lua/plenary.nvim'}},
    }
    -- Convenience
    use 'folke/which-key.nvim'
    use {
        'folke/trouble.nvim',
        requires = 'kyazdani42/nvim-web-devicons',
        config = require('trouble').setup()
    }
    use {'windwp/nvim-autopairs', config = require('plugins.autopairs')}
    use {'norcalli/nvim-colorizer.lua', config = require'colorizer'.setup()}
    use {'lewis6991/gitsigns.nvim', requires = 'nvim-lua/plenary.nvim', config = require('plugins.gitsigns')}
    -- Theming
    use 'RRethy/vim-illuminate'
    use {'romgrk/barbar.nvim', require = 'kyazdani42/nvim-web-devicons'}
    use {
        'nvim-treesitter/nvim-treesitter',
        run = ':TSUpdate',
--        config = require('plugins.treesitter')
    }
    use {'folke/tokyonight.nvim', config = require('plugins.tokyonight')}
    use {'hoob3rt/lualine.nvim', config = require('plugins.lualine')}
    use {'lukas-reineke/indent-blankline.nvim'}
end)
