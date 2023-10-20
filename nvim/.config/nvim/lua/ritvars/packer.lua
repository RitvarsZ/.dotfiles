-- This file can be loaded by calling `lua require('plugins')` from your init.vim

-- Only required if you have packer configured as `opt`
vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function(use)
    -- Packer can manage itself
    use'wbthomason/packer.nvim'

    use{
        'nvim-telescope/telescope.nvim', tag = '0.1.4',
        requires = {
            {'nvim-lua/plenary.nvim'}
        }
    }

    use({'rose-pine/neovim', as = 'rose-pine'})

    use("nvim-treesitter/nvim-treesitter", {run = ":TSUpdate"})
    use("nvim-treesitter/playground")

    use("theprimeagen/harpoon")
    use("tpope/vim-fugitive")
    use{'lewis6991/gitsigns.nvim'}

    use('nvim-lualine/lualine.nvim')
    use{
        "nvim-neo-tree/neo-tree.nvim",
        branch = "v3.x",
        requires = {
            "nvim-lua/plenary.nvim",
            "nvim-tree/nvim-web-devicons",
            "MunifTanjim/nui.nvim",
        }
    }

    use("lukas-reineke/indent-blankline.nvim")

    use{
        'VonHeikemen/lsp-zero.nvim',
        branch = 'v3.x',
        requires = {
            -- LSP Support
            {'williamboman/mason.nvim'},
            {'williamboman/mason-lspconfig.nvim'},
            {'neovim/nvim-lspconfig'},
            {'j-hui/fidget.nvim', tag = 'legacy'},


            -- Autocompletion
            {'hrsh7th/nvim-cmp'},
            {'hrsh7th/cmp-nvim-lsp'},
            {'hrsh7th/cmp-buffer'},
            {'hrsh7th/cmp-path'},
            {'saadparwaiz1/cmp_luasnip'},
            {'hrsh7th/cmp-nvim-lua'},

            -- Snippets
            {'L3MON4D3/LuaSnip'},
            {'rafamadriz/friendly-snippets'},
        }
    }

    use{'github/copilot.vim'}
    use{'numToStr/Comment.nvim'}
    use{'m4xshen/autoclose.nvim'}
end)
