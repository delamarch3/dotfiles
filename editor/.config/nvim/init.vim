filetype plugin indent on

set termguicolors

" LSP diagnostic icon in gutter:
set signcolumn=yes

" Vim commands copy to clipboard
set clipboard=unnamed
set noshowmode

" Split onto new pane
set splitright
set splitbelow

set guicursor=i-ci:ver25-iCursor-blinkwait200-blinkon200-blinkoff150,r-cr-o:hor20

" Disable adding comment on new line
autocmd FileType * set formatoptions-=ro

" Ruler
set cc=100

" Close brackets automatically, with return
inoremap {<cr> {<cr>}<C-O><S-O>
inoremap (<cr> (<cr>)<c-o><s-o>
inoremap [<cr> [<cr>]<c-o><s-o>

set tabstop=4 softtabstop=0 expandtab shiftwidth=4 smarttab
set number

lua <<EOF
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
    "nvim-treesitter/nvim-treesitter",
    "nvim-treesitter/nvim-treesitter-textobjects",
    {
        "nvim-telescope/telescope.nvim", tag = "0.1.2",
        dependencies = { "nvim-lua/plenary.nvim" }
    },
    "neovim/nvim-lspconfig",
    "hrsh7th/nvim-cmp",
    "hrsh7th/cmp-nvim-lsp",
    "L3MON4D3/LuaSnip",
    "lewis6991/gitsigns.nvim",
    "nvim-lualine/lualine.nvim",
    { "j-hui/fidget.nvim", tag = "legacy" },
    "kl4mm/darcula",
    "numToStr/Comment.nvim",
    "christoomey/vim-tmux-navigator", -- Maps <C-w>l to <C-l> etc
})
EOF

nnoremap <SPACE> <Nop>
let mapleader=" "

nnoremap <C-f> <Nop>
nnoremap <leader>f <cmd>Telescope find_files<cr>
nnoremap <leader>b <cmd>Telescope buffers <cr>
nnoremap <leader>s <cmd>Telescope lsp_document_symbols<cr>
nnoremap <leader>S <cmd>Telescope lsp_workspace_symbols<cr>
nnoremap <leader>d <cmd>Telescope diagnostics bufnr=0<cr>
nnoremap <leader>D <cmd>Telescope diagnostics<cr>
nnoremap <leader>/ <cmd>Telescope live_grep<cr>
nnoremap gr <cmd>Telescope lsp_references<cr>
nnoremap gi <cmd>Telescope lsp_implementations<cr>
nnoremap gtd <cmd>Telescope lsp_type_definitions<cr>

vnoremap S <Nop>
nnoremap <C-c> <Nop>
noremap Q <Nop>
noremap q <Nop>
vnoremap <C-f> <Nop>

" Use C-l to switch to right pane in netrw
nmap <leader><leader>l <Plug>NetrwRefresh

command! BufDeleteOthers %bd|e#
cnoreabbrev bdo BufDeleteOthers
command! BufDeleteAll %bd
cnoreabbrev bda BufDeleteAll

sign define DiagnosticSignError text=⏺ texthl=DiagnosticSignError linehl= numhl=
sign define DiagnosticSignWarn text=⏺ texthl=DiagnosticSignWarn linehl= numhl=
sign define DiagnosticSignInfo text=⏺ texthl=DiagnosticSignInfo linehl= numhl=
sign define DiagnosticSignHint text=⏺ texthl=DiagnosticSignHint linehl= numhl=

lua <<EOF
-- TODO: move these inside theme
vim.cmd([[
    colorscheme darcula
    hi Normal guibg=#232525
    hi Delimiter guifg=#a9b7c6
    hi Type guifg=#a9b7c6 gui=NONE
    hi Boolean guifg=#6897bb
    hi PreProc guifg=#cc7832
    hi LineNr guibg=#2b2b2b guifg=#808080
    hi Search guibg=#214283
    hi TelescopeMatching guifg=#d8d8d8
    hi StorageClass guifg=#cc7832
    hi Operator guifg=#a9b7c6
    hi DiffAdd guibg=#2b2b2b guifg=#32cd32
    hi DiffChange guibg=#2b2b2b guifg=#808080
    hi DiffDelete guibg=#2b2b2b guifg=#ff0000
    hi SignColumn guibg=#2b2b2b
    hi ColorColumn guibg=#2b2b2b
    hi ExtraWhitespace ctermbg=131 guibg=#bc3f3c
]])

-- Highlight trailing whitespace
local hlwhitespace = vim.api.nvim_create_augroup('hlwhitespace', { clear = true })
vim.api.nvim_create_autocmd({ 'BufWinEnter' }, {
    pattern = '*',
    group = hlwhitespace,
    command = [[match ExtraWhitespace /\s\+$/]]
})
vim.api.nvim_create_autocmd({ 'InsertEnter' }, {
    pattern = '*',
    group = hlwhitespace,
    command = [[match ExtraWhitespace /\s\+\%#\@<!$/]]
})
vim.api.nvim_create_autocmd({ 'InsertLeave' }, {
    pattern = '*',
    group = hlwhitespace,
    command = [[match ExtraWhitespace /\s\+$/]]
})
vim.api.nvim_create_autocmd({ 'BufWinLeave' }, {
    pattern = '*',
    group = hlwhitespace,
    command = 'call clearmatches()'
})

-- Number toggle
local numbertoggle = vim.api.nvim_create_augroup('numbertoggle', { clear = true })
vim.api.nvim_create_autocmd({ 'BufEnter', 'FocusGained', 'InsertLeave', 'WinEnter' }, {
    pattern = '*',
    group = numbertoggle,
    command = 'if &nu && mode() != "i" | set rnu | endif'
})
vim.api.nvim_create_autocmd({ 'BufLeave', 'FocusLost', 'InsertEnter', 'WinLeave' }, {
    pattern = '*',
    group = numbertoggle,
    command = 'if &nu | set nornu | endif'
})

EOF

lua <<EOF
local home_dir = os.getenv("HOME")
package.path = home_dir .. "/.config/nvim/" .. package.path
local lualine_theme = require"themes.lualine"

require("lualine").setup {
    options = {
        theme  = lualine_theme,
        section_separators = "",
        component_separators = "|",
    },
    sections = {
        lualine_b = {
            "branch", "diff",
            {
                "diagnostics",
                symbols = {error = '⏺ ', warn = '⏺ ', info = '⏺ ', hint = '⏺ '},
            }
        },
        lualine_c = {
            {
                "filename",
                path = 1,
            }
        },
        lualine_x = {'encoding', 'filetype'},
    }
}
require"fidget".setup {}
require("Comment").setup {
    padding = true,
    sticky = true,
    ignore = "^$",
    toggler = { line = "gcc", block = "gbc" },
    opleader = { line = "gc", block = "gb" },
    mappings = { basic = true, extra = false },
    pre_hook = nil,
    post_hook = nil,
}

require'nvim-treesitter.configs'.setup {
  ensure_installed = {
      "c", "cpp", "lua", "vim", "rust",
      "go", "terraform", "hcl", "typescript",
      "javascript", "json", "yaml", "python",
      "vue", "tlaplus", "haskell", "ocaml"
      },
  sync_install = false,
  auto_install = false,
  ignore_install = {},
  highlight = {
    enable = true,
  },
}

require'nvim-treesitter.configs'.setup {
  textobjects = {
    select = {
      enable = true,

      -- Automatically jump forward to textobj
      lookahead = false,

      keymaps = {
        ["af"] = "@function.outer",
        ["if"] = "@function.inner",
        ["ac"] = "@class.outer",
        ["ic"] = "@class.inner",
        ["as"] = { query = "@scope", query_group = "locals" },
      },
    },
  },
}

-- LSP
vim.api.nvim_set_hl(0, "@lsp.type.namespace", { link = "Namespace" })
vim.api.nvim_set_hl(0, "@lsp.type.decorator", { link = "PreProc" })
vim.api.nvim_set_hl(0, "@lsp.mod.constant", { link = "Constant" })
vim.api.nvim_set_hl(0, "@lsp.typemod.variable.static", { link = "Constant" })

-- Treesitter
vim.api.nvim_set_hl(0, "@namespace", { link = "Namespace" })
vim.api.nvim_set_hl(0, "@constructor", { link = "Function" })
vim.api.nvim_set_hl(0, "@type.qualifier", { link = "Keyword" })

-- Language specific:
vim.api.nvim_set_hl(0, "@lsp.type.enumMember.rust", { link = "Type" })
vim.api.nvim_set_hl(0, "@lsp.type.constParameter.rust", { link = "Constant" })
vim.api.nvim_set_hl(0, "@constant.builtin.rust", { link = "Type" })
vim.api.nvim_set_hl(0, "@lsp.type.type.terraform", { link = "Keyword" })
vim.api.nvim_set_hl(0, "@lsp.type.enumMember.terraform", { link = "String" })

vim.api.nvim_set_hl(0, "@lsp.typemod.variable.readonly.cpp", { link = "Constant" })

vim.api.nvim_set_hl(0, "@tag.vue", { link = "htmlTag" })
vim.api.nvim_set_hl(0, "@tag.delimiter.vue", { link = "htmlTag" })
vim.api.nvim_set_hl(0, "@tag.attribute.vue", { link = "NormalFg" })
vim.api.nvim_set_hl(0, "@method.vue", { link = "NormalFg" })
vim.api.nvim_set_hl(0, "@string.vue", { link = "htmlString" })

vim.api.nvim_set_hl(0, "@function.call.haskell", { link = "NormalFg" })
vim.api.nvim_set_hl(0, "@function.haskell", { link = "NormalFg" })

vim.api.nvim_set_hl(0, "@constructor.ocaml", { link = "Type" })

local actions = require("telescope.actions")
require("telescope").setup({
    defaults = {
        mappings = {
            n = {
                ["<Esc>"] = function() end,
                ["<C-c>"] = actions.close,
            },
        },
        layout_strategy = "horizontal",
        layout_config = {
            prompt_position = "top",
        },
        sorting_strategy = "ascending",
    },
})

require("gitsigns").setup({
    signs = {
        add          = { text = "▏" },
        change       = { text = "▏" },
        delete       = { text = "▁" },
        topdelete    = { text = "▔" },
        changedelete = { text = "~" },
        untracked    = { text = "▏" },
    },
})

vim.keymap.set("n", "[d", vim.diagnostic.goto_prev)
vim.keymap.set("n", "]d", vim.diagnostic.goto_next)
vim.keymap.set("n", "<space>e", vim.diagnostic.open_float)

vim.diagnostic.config({
  virtual_text = false,
  underline = true,
  severity_sort = true,
})

-- Prioritise LSP hover over diagnostics:
function hover_fixed()
    vim.api.nvim_command("set eventignore=CursorHold")
    vim.lsp.buf.hover()
    vim.api.nvim_command('autocmd CursorMoved <buffer> ++once set eventignore=""')
end

vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("UserLspConfig", {}),
  callback = function(ev)
    local opts = { buffer = ev.buf }
    vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
    vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
    -- vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts) -- Use telescope
    -- vim.keymap.set("n", "gtd", vim.lsp.buf.type_definition, opts) -- Use telescope
    -- vim.keymap.set("n", "gr", vim.lsp.buf.references, opts) -- Use telescope
    vim.keymap.set("n", "<space>k", hover_fixed, opts)
    vim.keymap.set("n", "K", vim.lsp.buf.signature_help, opts)
    vim.keymap.set("n", "<space>wl", function()
      print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end, opts)
    vim.keymap.set("n", "<space>r", vim.lsp.buf.rename, opts)
    vim.keymap.set({ "n", "v" }, "<space>a", vim.lsp.buf.code_action, opts)
    vim.keymap.set("n", "<space>mm", function()
      vim.lsp.buf.format { async = true }
    end, opts)
  end,
})

-- TODO: Disable specific lsp tokens eg @lsp.type.enumMember.rust
local lspconfig = require("lspconfig")
local capabilities = require("cmp_nvim_lsp").default_capabilities()
local servers = { "rust_analyzer", "gopls", "clangd", "terraformls", "hls" }
for _, lsp in ipairs(servers) do
  lspconfig[lsp].setup {
    capabilities = capabilities,
  }
end

lspconfig["tsserver"].setup {
    capabilities = capabilities,
    on_attach = function(client, bufnr)
        client.server_capabilities.semanticTokensProvider = nil
    end,
}

local is_npm_package_installed = require('util').is_npm_package_installed
lspconfig["volar"].setup {
    capabilities = capabilities,
    filetypes = is_npm_package_installed 'vue' and { 'vue', 'typescript', 'javascript' } or { 'vue' },
}

local luasnip = require "luasnip"
local cmp = require "cmp"
cmp.setup {
  snippet = {
      expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },
  mapping = cmp.mapping.preset.insert({
    ["<C-u>"] = cmp.mapping.scroll_docs(-4), -- Up
    ["<C-d>"] = cmp.mapping.scroll_docs(4), -- Down
    ["<CR>"] = cmp.mapping.confirm {
      behavior = cmp.ConfirmBehavior.Replace,
      select = true,
    },
    ["<Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump()
      else
        fallback()
      end
    end, { "i", "s" }),
    ["<S-Tab>"] = cmp.mapping(function(fallback)
       if cmp.visible() then
         cmp.select_prev_item()
       elseif luasnip.jumpable(-1) then
         luasnip.jump(-1)
       else
         fallback()
       end
     end, { "i", "s" }),
   }),
  -- Must press tab to select first suggestion:
  preselect = cmp.PreselectMode.None,
  sources = {
    { name = "nvim_lsp" },
    { name = "luasnip" },
  },
}

vim.api.nvim_create_autocmd('ModeChanged', {
  pattern = '*',
  callback = function()
    if ((vim.v.event.old_mode == 's' and vim.v.event.new_mode == 'n') or vim.v.event.old_mode == 'i')
        and require('luasnip').session.current_nodes[vim.api.nvim_get_current_buf()]
        and not require('luasnip').session.jump_active
    then
      require('luasnip').unlink_current()
    end
  end
})

local format_sync_grp = vim.api.nvim_create_augroup("Format", {})
vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*.rs,*.go,*.tf,*.c,*.h,*.cpp,*.hs",
  callback = function()
    vim.lsp.buf.format({ timeout_ms = 200 })
  end,
  group = format_sync_grp,
})
EOF
