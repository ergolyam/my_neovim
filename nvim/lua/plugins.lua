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

require('lazy').setup({
  'neovim/nvim-lspconfig', 
  'hrsh7th/nvim-cmp', 
  'hrsh7th/cmp-nvim-lsp', 
  'hrsh7th/cmp-buffer', 
  'hrsh7th/cmp-path', 
  'hrsh7th/cmp-cmdline', 
  { 'j-hui/fidget.nvim', opts = {} }, 
  'L3MON4D3/LuaSnip', 
  'saadparwaiz1/cmp_luasnip', 
  'justinmk/vim-sneak', 
  'windwp/nvim-autopairs', 
  'psliwka/vim-smoothie', 
  { 'nvim-treesitter/nvim-treesitter', build = ":TSUpdate" }, 
  { 'kdheepak/lazygit.nvim',
		cmd = { "LazyGit", "LazyGitConfig", "LazyGitCurrentFile", "LazyGitFilter", "LazyGitFilterCurrentFile", },
		dependencies = { "nvim-lua/plenary.nvim", },
		keys = { { "lg", "<cmd>LazyGit<cr>", desc = "LazyGit" } }
	}, 
  'Mofiqul/vscode.nvim',
  { 'nvim-telescope/telescope-file-browser.nvim', 
    dependencies = { 'nvim-telescope/telescope.nvim',
      'nvim-lua/plenary.nvim',
      'nvim-telescope/telescope-fzf-native.nvim',
      { 'nvim-tree/nvim-web-devicons', enabled = vim.g.have_nerd_font } },
  }, 
})

vim.diagnostic.config({
  virtual_text = {
    prefix = '',
    spacing = 0,
  },
  signs = false,
})

local cmp = require('cmp')
local luasnip = require('luasnip')

cmp.setup({
  snippet = {
    expand = function(args) luasnip.lsp_expand(args.body) end,
  },
  mapping = cmp.mapping.preset.insert({
    ['<C-b>']   = cmp.mapping.scroll_docs(-4),
    ['<C-f>']   = cmp.mapping.scroll_docs(4),
    ['<C-Space>']= cmp.mapping.complete(),
    ['<C-e>']   = cmp.mapping.abort(),
    ['<CR>']    = cmp.mapping.confirm({ select = true }), 
    ['<Tab>']   = cmp.mapping(function(fallback)
      if cmp.visible() then cmp.select_next_item()
      elseif luasnip.expand_or_jumpable() then luasnip.expand_or_jump()
      else fallback() end
    end, { 'i','s' }),
    ['<S-Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then cmp.select_prev_item()
      elseif luasnip.jumpable(-1) then luasnip.jump(-1)
      else fallback() end
    end, { 'i','s' }),
  }),
  sources = cmp.config.sources({
    { name = 'nvim_lsp' },
    { name = 'luasnip'  },
    { name = 'buffer', keyword_length = 3 },
    { name = 'path'     },
  }),
})

require('nvim-autopairs').setup({
  check_ts = true,
  map_cr = false, 
})
local cmp_ap = require('nvim-autopairs.completion.cmp')
cmp.event:on('confirm_done', cmp_ap.on_confirm_done())

local capabilities = require('cmp_nvim_lsp')
  .default_capabilities(vim.lsp.protocol.make_client_capabilities())

local function on_attach(_, bufnr)
  local map = function(mode, lhs, rhs) vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, silent = true }) end
  map('n', 'gd', vim.lsp.buf.definition)
  map('n', 'K',  vim.lsp.buf.hover)
  map('n', 'gi', vim.lsp.buf.implementation)
  map('n', '<C-k>', vim.lsp.buf.signature_help)
  map('n', '<space>rn', vim.lsp.buf.rename)
  map('n', 'gr', vim.lsp.buf.references)
end

local android_sdk = '/home/grisha/.local/share/android-sdk'

vim.lsp.config('pyright', { capabilities = capabilities, on_attach = on_attach })
vim.lsp.config('ts_ls',   { capabilities = capabilities, on_attach = on_attach })
vim.lsp.config('jdtls', {
  capabilities = capabilities,
  on_attach = on_attach,
  settings = {
    java = {
      project = {
        referencedLibraries = { android_sdk .. '/platforms/android-33/android.jar' }
      }
    }
  }
})

for _, name in ipairs({ 'pyright', 'ts_ls', 'jdtls' }) do
  vim.lsp.enable(name)
end

require('nvim-treesitter.configs').setup {
  ensure_installed = {
    "python", "javascript", 
    "typescript", "tsx"
  },
  auto_install = false,
  sync_install = #vim.api.nvim_list_uis() == 0,
  highlight = {
    enable = true,
    additional_vim_regex_highlighting = false,
  },
  indent = {
    enable = true,
  },
}

require('nvim-autopairs').setup({
  check_ts = true,
  map_cr = true,
})

require('telescope').setup({
  extensions = {
    file_browser = {
      hijack_netrw = true,
      sorting_strategy = 'ascending',
      layout_strategy = 'horizontal',
      layout_config = {
        width = 0.99,
        height = 0.99,
        prompt_position = "top",
      },
    },
  },
})

require('telescope').load_extension('file_browser')
local actions = require("telescope.actions")
local fb = require("telescope").extensions.file_browser.file_browser

_G.openFileBrowserInNewTab = function()
  vim.cmd("tabnew") 
  fb({
    attach_mappings = function(prompt_bufnr, map)
      local function closeTelescopeAndTab()
        actions.close(prompt_bufnr)
        vim.cmd("tabclose")
      end

      map("i", "<esc>", closeTelescopeAndTab)
      map("n", "<esc>", closeTelescopeAndTab)

      return true
    end
  })
end

vim.cmd [[
  colorscheme vscode
  let g:vscode_style = 'dark'
  let g:vscode_transparent = 1
  let g:vscode_italic_comment = 1
]]
