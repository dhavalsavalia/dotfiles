-- Read the docs: https://www.lunarvim.org/docs/configuration
-- Example configs: https://github.com/LunarVim/starter.lvim
-- Video Tutorials: https://www.youtube.com/watch?v=sFA9kX-Ud_c&list=PLhoH5vyxr6QqGu0i7tt_XoVK9v-KvZ3m6
-- Forum: https://www.reddit.com/r/lunarvim/
-- Discord: https://discord.com/invite/Xb9B4Ny

lvim.plugins = {
    { "lunarvim/colorschemes" },
    {
        "loctvl842/monokai-pro.nvim",
        config = function()
            require("monokai-pro").setup()
        end
    },
    {
        "zbirenbaum/copilot.lua",
        cmd = "Copilot",
        event = "InsertEnter",
    },
    {
        "zbirenbaum/copilot-cmp",
        after = { "copilot.lua" },
        config = function()
            require("copilot_cmp").setup()
        end
    },
    {
        "folke/todo-comments.nvim",
        dependencies = "nvim-lua/plenary.nvim",
        opts = {},
        cmd = "TodoQuickFix",
    },
    {
        "m4xshen/hardtime.nvim",
        dependencies = { "MunifTanjim/nui.nvim", "nvim-lua/plenary.nvim" },
        opts = {}
    },
}

lvim.colorscheme = "monokai-pro-spectrum"

-- GitHub Copilot
local ok, copilot = pcall(require, "copilot")
if not ok then
    return
end

copilot.setup {
    suggestion = {
        keymap = {
            accept = "<c-l>",
            next = "<c-j>",
            prev = "<c-k>",
            dismiss = "<c-h>",
        },
    },
}

local opts = { noremap = true, silent = true }
vim.api.nvim_set_keymap("n", "<c-s>", "<cmd>lua require('copilot.suggestion').toggle_auto_trigger()<CR>", opts)

-- <leader>| for vsplit
lvim.keys.normal_mode["<leader>|"] = ":vsplit<CR>"

lvim.builtin.bufferline.active = false
lvim.builtin.nvimtree.setup.git = {
    enable = true,
}
lvim.builtin.nvimtree.setup.renderer = {
    highlight_git = true,
    icons = {
        show = {
            git = true,
        },
    },
}
lvim.builtin.nvimtree.setup.view = {
    side = "right",
    width = 50,
    preserve_window_proportions = true, -- maintains window size ratios
    relativenumber = false,
    signcolumn = "yes"
}

vim.opt.wrap = true           -- Enable word wrap
vim.opt.expandtab = true      -- Expand Tabs
vim.opt.tabstop = 4           -- Convert Tabs to Spaces
vim.opt.softtabstop = 4       -- Number of spaces that a <Tab> counts for while performing editing operations
vim.opt.shiftwidth = 4        -- Number of spaces to use for each step of (auto)indent

lvim.format_on_save = true    -- Automatically format code on save
vim.opt.relativenumber = true -- Set relative number
vim.opt.number = true         -- Set line number
