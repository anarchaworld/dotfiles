local execute = vim.api.nvim_command
local fn = vim.fn
local install_path = fn.stdpath "data" .. "/site/pack/packer/start/packer.nvim"

if fn.empty(fn.glob(install_path)) > 0 then
    fn.system {
        "git",
        "clone",
        "https://github.com/wbthomason/packer.nvim",
        install_path,
    }
    execute "packadd packer.nvim"
end

-- Autocompile
vim.cmd [[autocmd BufWritePost plugins.lua PackerCompile]]

require("packer").startup(function()
    -- Package Manager
    use "wbthomason/packer.nvim"
    -- LSP
    use "neovim/nvim-lspconfig"
    use { "glepnir/lspsaga.nvim", config = require("lspsaga").init_lsp_saga() }
    use {
        "hrsh7th/nvim-compe",
        config = function()
            require("compe").setup {
                enabled = true,
                autocomplete = true,
                debug = false,
                min_length = 1,
                preselect = "enable",
                throttle_time = 80,
                source_timeout = 200,
                incomplete_delay = 400,
                max_abbr_width = 100,
                max_kind_width = 100,
                max_menu_width = 100,
                documentation = true,

                source = {
                    path = true,
                    nvim_lsp = true,
                    nvim_lua = true,
                    buffer = true,
                    treesitter = true,
                    tags = true,
                    calc = true,
                },
            }
        end,
    }
    -- Navigation
    use {
        "kyazdani42/nvim-tree.lua",
        requires = "kyazdani42/nvim-web-devicons",
        config = function()
            local g = vim.g

            g.nvim_tree_side = "right"
            g.nvim_tree_indent_markers = 1
            g.nvim_tree_auto_close = 1
            g.nvim_tree_follow = 1
            g.nvim_tree_ignore = { "git", "node_modules", ".cache" }
            g.nvim_tree_width = "15%"
            g.nvim_tree_show_icons = {
                git = 1,
                folders = 0,
                files = 0,
                folder_arrows = 0,
            }
            g.nvim_tree_icons = {
                default = "",
                symlink = "",
                git = {
                    unstaged = "✗",
                    staged = "✓",
                    unmerged = "",
                    renamed = "➜",
                    untracked = "★",
                    deleted = "",
                    ignored = "◌",
                },
                folder = {
                    arrow_open = "",
                    arrow_closed = "",
                    default = "",
                    open = "",
                    empty = "",
                    empty_open = "",
                    symlink = "",
                    symlink_open = "",
                },
                lsp = {
                    hint = "",
                    info = "",
                    warning = "",
                    error = "",
                },
            }

            vim.cmd [[highlight NvimTreeFolderIcon guibg=blue]]
        end,
    }
    use {
        "nvim-telescope/telescope.nvim",
        requires = { { "nvim-lua/popup.nvim" }, { "nvim-lua/plenary.nvim" } },
    }

    -- Convenience
    use { "folke/which-key.nvim", config = require("which-key").setup() }
    use {
        "folke/trouble.nvim",
        requires = "kyazdani42/nvim-web-devicons",
        config = require("trouble").setup(),
    }
    use {
        "windwp/nvim-autopairs",
        config = function()
            require("nvim-autopairs").setup()
            require("nvim-autopairs.completion.compe").setup {
                map_cr = true, -- map <CR> in insert mode
                map_complete = true, -- auto insert ( after selecting function or method item
            }
        end,
    }
    use { "norcalli/nvim-colorizer.lua", config = require("colorizer").setup() }
    use {
        "lewis6991/gitsigns.nvim",
        requires = "nvim-lua/plenary.nvim",
        config = function()
            require("gitsigns").setup {
                signs = {
                    add = {
                        hl = "GitSignsAdd",
                        text = "│",
                        numhl = "GitSignsAddNr",
                        linehl = "GitSignsAddLn",
                    },
                    change = {
                        hl = "GitSignsChange",
                        text = "│",
                        numhl = "GitSignsChangeNr",
                        linehl = "GitSignsChangeLn",
                    },
                    delete = {
                        hl = "GitSignsDelete",
                        text = "_",
                        numhl = "GitSignsDeleteNr",
                        linehl = "GitSignsDeleteLn",
                    },
                    topdelete = {
                        hl = "GitSignsDelete",
                        text = "‾",
                        numhl = "GitSignsDeleteNr",
                        linehl = "GitSignsDeleteLn",
                    },
                    changedelete = {
                        hl = "GitSignsChange",
                        text = "~",
                        numhl = "GitSignsChangeNr",
                        linehl = "GitSignsChangeLn",
                    },
                },
                numhl = false,
                linehl = false,
                watch_index = {
                    interval = 1000,
                    follow_files = true,
                },
                current_line_blame = false,
                current_line_blame_delay = 1000,
                current_line_blame_position = "eol",
                sign_priority = 6,
                update_debounce = 100,
                status_formatter = nil, -- Use default
                word_diff = false,
                use_decoration_api = true,
                use_internal_diff = true, -- If luajit is present
            }
        end,
    }
    -- Theming
    use "RRethy/vim-illuminate"
    use { "romgrk/barbar.nvim", require = "kyazdani42/nvim-web-devicons" }
    use {
        "nvim-treesitter/nvim-treesitter",
        run = ":TSUpdate",
        config = function()
            require("nvim-treesitter.configs").setup {
                ensure_installed = "maintained",
                highlight = { enable = true },
            }
        end,
    }
    use {
        "folke/tokyonight.nvim",
        config = function()
            local g = vim.g

            g.tokyonight_style = "night"
            g.tokyonight_italic_functions = true
            g.tokyonight_sidebars = { "qf", "vista_kind", "terminal", "packer" }
            g.tokyonight_colors = { hint = "orange", error = "#ff0000" }

            -- Load the colorscheme
            vim.cmd [[colorscheme tokyonight]]
        end,
    }
    use {
        "hoob3rt/lualine.nvim",
        config = function()
            require("lualine").setup {
                options = {
                    theme = "tokyonight",
                },
            }
        end,
    }
    use "lukas-reineke/indent-blankline.nvim"
end)
