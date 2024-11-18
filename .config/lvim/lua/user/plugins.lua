lvim.plugins = {{
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    event = "InsertEnter",
    config = function()
        require("copilot").setup({
            suggestions = {
                enabled = false
            },
            panel = {
                enabled = false
            }
        })
    end
}, {'jose-elias-alvarez/typescript.nvim'}, {
    "loctvl842/monokai-pro.nvim",
    config = function()
        require("monokai-pro").setup({
            filter = "spectrum",
            styles = {
                comment = {
                    italic = true
                },
                keyword = {
                    italic = true
                }, -- any other keyword
                type = {
                    italic = true
                }, -- (preferred) int, long, char, etc
                storageclass = {
                    italic = true
                }, -- static, register, volatile, etc
                structure = {
                    italic = true
                }, -- struct, union, enum, etc
                parameter = {
                    italic = true
                }, -- parameter pass in function
                annotation = {
                    italic = true
                },
                tag_attribute = {
                    italic = true
                } -- attribute of tag in reactjs
            },
            devicons = true
        })
    end
}, {
    "folke/trouble.nvim",
    cmd = "TroubleToggle"
}, {
    "folke/todo-comments.nvim",
    event = "BufRead",
    config = function()
        require("todo-comments").setup()
    end
}, {
    "folke/persistence.nvim",
    event = "BufReadPre",
    config = function()
        require("persistence").setup({
            dir = vim.fn.expand(vim.fn.stdpath "state" .. "/sessions/"),
            options = {"buffers", "curdir", "tabpages", "winsize"}
        })
    end
}, {"christoomey/vim-tmux-navigator"}, {"tpope/vim-surround"}, {
    "felipec/vim-sanegx",
    event = "BufRead"
}, {
    "windwp/nvim-ts-autotag",
    config = function()
        require("nvim-ts-autotag").setup()
    end
}, {"tpope/vim-repeat"}, {"ThePrimeagen/harpoon"}, {
    'phaazon/hop.nvim',
    branch = 'v2',
    config = function()
        require('hop').setup()
    end
}, {
    'nvim-telescope/telescope-frecency.nvim',
    dependencies = {'nvim-telescope/telescope.nvim', 'kkharji/sqlite.lua'}
}, {
    'AckslD/nvim-trevJ.lua',
    config = 'require("trevj").setup()',
    init = function()
        vim.keymap.set('n', '<leader>j', function()
            require('trevj').format_at_cursor()
        end)
    end
}}

table.insert(lvim.plugins, {
    "zbirenbaum/copilot-cmp",
    event = "InsertEnter",
    dependencies = {"zbirenbaum/copilot.lua"},
    config = function()
        local ok, cmp = pcall(require, "copilot_cmp")
        if ok then
            cmp.setup({})
        end
    end
})

lvim.builtin.telescope.on_config_done = function(telescope)
    pcall(telescope.load_extension, "frecency")
end
