-- Initialize lazy.nvim package manager
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- Set leader key to semicolon
vim.g.mapleader = ";"

-- Plugin specifications
require("lazy").setup({
  "nvim-lua/plenary.nvim",
  { "nvim-telescope/telescope.nvim", branch = "0.1.x" },
  "tpope/vim-vinegar",
  "itchyny/lightline.vim",
  "rebelot/kanagawa.nvim",
  "christoomey/vim-tmux-navigator",
  { "nvim-treesitter/nvim-treesitter", build = ":TSUpdate" },
  "neovim/nvim-lspconfig",
  "prettier/vim-prettier",
})

-- General settings
vim.opt.number = true
vim.opt.relativenumber = true

-- Configure diagnostic display
vim.diagnostic.config({
  virtual_text = {
    prefix = '●',
    spacing = 2,
  },
  signs = false,
  severity_sort = true,
})

-- Highlight settings
local highlightColor = "#3a3a3a"
vim.opt.cursorline = true
vim.cmd("hi CursorLine cterm=none ctermbg=235 guibg=" .. highlightColor)
vim.cmd("hi CursorColumn cterm=none ctermbg=235 guibg=" .. highlightColor)
vim.cmd("hi CursorLineNr cterm=none ctermfg=250 ctermbg=235 guibg=" .. highlightColor)

-- Column marker
vim.opt.colorcolumn = "81"
vim.cmd("hi ColorColumn cterm=none ctermbg=235 guibg="..highlightColor)

-- Indentation settings
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

-- Search settings
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Encoding settings
vim.opt.encoding = "utf-8"
vim.opt.fileencoding = "utf-8"

-- Clipboard settings
vim.opt.clipboard = "unnamed,unnamedplus"

-- Auto reload files
vim.opt.autoread = true
vim.api.nvim_create_autocmd({ "FocusGained" }, {
  callback = function() vim.cmd("checktime") end,
})

-- Disable mouse
vim.opt.mouse = ""

-- Telescope keymaps
vim.keymap.set("n", "<C-p>", require("telescope.builtin").find_files)
vim.keymap.set("n", "<C-F>", require("telescope.builtin").live_grep)

-- Theme settings
vim.cmd("colorscheme kanagawa-dragon")

-- Lightline settings
vim.opt.showmode = false

-- Tree-sitter configuration
require("nvim-treesitter.configs").setup({
  ensure_installed = "all",
  auto_install = false,
  highlight = {
    enable = true,
  },
})

-- LSP configurations
local lspconfig = require("lspconfig")

lspconfig.psalm.setup({
  cmd = { "vendor/bin/psalm-language-server", "--use-baseline=baseline.xml", "--show-diagnostic-warnings=false" },
})

lspconfig.ts_ls.setup({
  cmd = { "npx", "typescript-language-server", "--stdio" },
})

lspconfig.golangci_lint_ls.setup({})
lspconfig.phpactor.setup({})

-- LSP keybindings
vim.keymap.set("n", "<space>e", vim.diagnostic.open_float)
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev)
vim.keymap.set("n", "]d", vim.diagnostic.goto_next)
vim.keymap.set("n", "<space>q", vim.diagnostic.setloclist)

-- LSP attach configuration
vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("UserLspConfig", {}),
  callback = function(ev)
    vim.bo[ev.buf].omnifunc = "v:lua.vim.lsp.omnifunc"

    local opts = { buffer = ev.buf }
    vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
    vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
    vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
    vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
    vim.keymap.set("n", "<space>wa", vim.lsp.buf.add_workspace_folder, opts)
    vim.keymap.set("n", "<space>wr", vim.lsp.buf.remove_workspace_folder, opts)
    vim.keymap.set("n", "<space>wl", function()
      print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end, opts)
    vim.keymap.set("n", "<space>D", vim.lsp.buf.type_definition, opts)
    vim.keymap.set("n", "<space>rn", vim.lsp.buf.rename, opts)
    vim.keymap.set("n", "<space>ca", vim.lsp.buf.code_action, opts)
    vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
    vim.keymap.set("n", "<space>f", function()
      vim.lsp.buf.format({ async = true })
    end, opts)
  end,
})

-- Prettier configuration
vim.g["prettier#config#tab_width"] = 2
vim.g["prettier#config#trailing_comma"] = "all"

-- Prettier autoformat
vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = { "*.js", "*.ts", "*.json", "*.html.twig", "*.html", "*.jsx", "*.tsx", "*.css", "*.scss", "*.php" },
  command = "PrettierAsync",
}) 
