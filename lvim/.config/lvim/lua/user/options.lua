lvim.log.level = "warn"
lvim.format_on_save = false

lvim.builtin.treesitter.ensure_installed = {
  "bash",
  "javascript",
  "typescript",
  "json",
  "lua",
  "python",
  "yaml",
}

lvim.builtin.terminal.active = true

lvim.builtin.treesitter.ignore_install = {}
lvim.builtin.treesitter.highlight.enabled = true

lvim.builtin.project.detection_methods = { "lsp", "pattern" }
lvim.builtin.project.patterns = {
  ".git",
  "package-lock.json",
  "yarn.lock",
  "package.json",
  "requirements.txt",
}

vim.opt.shell = "/bin/zsh"

vim.o.linebreak = true
vim.o.wrap = true
vim.o.sessionoptions = "blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions"

lvim.builtin.telescope = {
  defaults = {
    path_display = {
      shorten = 4,
    },
    layout_strategy = "horizontal",
    layout_config = {
      horizontal = {
        preview_width = 0.55,
        results_width = 0.8,
      },
      width = 0.87,
      height = 0.80,
      preview_cutoff = 120,
    },
    file_ignore_patterns = { ".git/" },
    respect_gitignore = false
  },
  pickers = {
    find_files = {
      hidden = true
    }
  }
}

lvim.builtin.nvimtree.setup.view = {
  side = "right",
  width = 50,
  preserve_window_proportions = true, -- maintains window size ratios
  relativenumber = false,
  signcolumn = "yes"
}

lvim.builtin.nvimtree.setup.renderer.icons.show.git = true
lvim.builtin.nvimtree.setup.filters.custom = {}

-- enable relative numbers
vim.wo.relativenumber = true

-- enable dap
lvim.builtin.dap.active = true
