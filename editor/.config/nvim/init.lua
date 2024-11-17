local home_dir = os.getenv("HOME")
package.path = home_dir .. "/.config/nvim/" .. package.path

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
    "nvim-treesitter/nvim-treesitter-context",
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

-- Options
vim.opt.termguicolors = true
vim.opt.signcolumn = "yes" -- Gutter signs
vim.opt.clipboard = "unnamed" -- Copy to clipboard
vim.opt.showmode = false
vim.opt.splitright = true -- Split onto new pane
vim.opt.splitbelow = true
vim.opt.guicursor = "a:blinkon10,i-ci:ver25,r-cr-o:hor20"
vim.opt.cc = "100" -- Ruler
vim.opt.tabstop = 4
vim.opt.softtabstop = 0
vim.opt.expandtab = true
vim.opt.shiftwidth = 4
vim.opt.smarttab = true
vim.opt.number = true
vim.g.mapleader = " "
vim.opt.updatetime = 500 -- CursorHoldI

-- Close brackets automatically, with return:
vim.keymap.set("i", "{<cr>", "{<cr>}<C-O><S-O>", { remap = false })
vim.keymap.set("i", "(<cr>", "(<cr>)<c-o><s-o>", { remap = false })
vim.keymap.set("i", "[<cr>", "[<cr>]<c-o><s-o>", { remap = false })

-- Nops
vim.keymap.set("n", "<SPACE>", "<Nop>", { remap = false })
vim.keymap.set("n", "<C-f>", "<Nop>", { remap = false })
vim.keymap.set("n", "<C-c>", "<Nop>", { remap = false })
vim.keymap.set("", "Q", "<Nop>", { remap = false })
vim.keymap.set("", "q", "<Nop>", { remap = false })
vim.keymap.set("v", "<C-f>", "<Nop>", { remap = false })
vim.keymap.set("n", "<leader><leader>l", "<Plug>NetrwRefresh", { remap = true })

-- Telescope
vim.keymap.set("n", "<leader>f", "<cmd>Telescope find_files<cr>", { remap = false })
vim.keymap.set("n", "<leader>b", "<cmd>Telescope buffers <cr>", { remap = false })
vim.keymap.set("n", "<leader>s", "<cmd>Telescope lsp_document_symbols<cr>", { remap = false })
vim.keymap.set("n", "<leader>S", "<cmd>Telescope lsp_workspace_symbols<cr>", { remap = false })
vim.keymap.set("n", "<leader>d", "<cmd>Telescope diagnostics bufnr=0<cr>", { remap = false })
vim.keymap.set("n", "<leader>D", "<cmd>Telescope diagnostics<cr>", { remap = false })
vim.keymap.set("n", "<leader>/", "<cmd>Telescope live_grep<cr>", { remap = false })
vim.keymap.set("n", "gr", "<cmd>Telescope lsp_references<cr>", { remap = false })
vim.keymap.set("n", "gi", "<cmd>Telescope lsp_implementations<cr>", { remap = false })
vim.keymap.set("n", "gtd", "<cmd>Telescope lsp_type_definitions<cr>", { remap = false })
vim.keymap.set("n", "<space>c", "<cmd>TSContextToggle<cr>", { remap = false })

-- Diagnostics
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev)
vim.keymap.set("n", "]d", vim.diagnostic.goto_next)
vim.keymap.set("n", "<space>e", vim.diagnostic.open_float)

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

-- Signs
vim.fn.sign_define("DiagnosticSignError", {texthl = "DiagnosticSignError", text = "⏺" })
vim.fn.sign_define("DiagnosticSignWarn", {texthl = "DiagnosticSignWarn", text = "⏺" })
vim.fn.sign_define("DiagnosticSignInfo", {texthl = "DiagnosticSignInfo", text = "⏺" })
vim.fn.sign_define("DiagnosticSignHint", {texthl = "DiagnosticSignHint", text = "⏺" })

-- User commands
vim.api.nvim_create_user_command("BufDeleteOthers", "%bd|e#", {})
vim.api.nvim_create_user_command("BufDeleteAll", "%bd", {})
vim.cmd([[
    cnoreabbrev bdo BufDeleteOthers
    cnoreabbrev bda BufDeleteAll
]])

-- Highlight trailing whitespace
local hlwhitespace = vim.api.nvim_create_augroup("hlwhitespace", { clear = true })
vim.api.nvim_create_autocmd({ "BufWinEnter" }, {
    pattern = "*",
    group = hlwhitespace,
    command = [[match ExtraWhitespace /\s\+$/]]
})
vim.api.nvim_create_autocmd({ "InsertEnter" }, {
    pattern = "*",
    group = hlwhitespace,
    command = [[match ExtraWhitespace /\s\+\%#\@<!$/]]
})
vim.api.nvim_create_autocmd({ "InsertLeave" }, {
    pattern = "*",
    group = hlwhitespace,
    command = [[match ExtraWhitespace /\s\+$/]]
})
vim.api.nvim_create_autocmd({ "BufWinLeave" }, {
    pattern = "*",
    group = hlwhitespace,
    command = "call clearmatches()"
})

-- Number toggle
local numbertoggle = vim.api.nvim_create_augroup("numbertoggle", { clear = true })
vim.api.nvim_create_autocmd({ "BufEnter", "FocusGained", "InsertLeave", "WinEnter" }, {
    pattern = "*",
    group = numbertoggle,
    command = "if &nu && mode() != 'i' | set rnu | endif"
})
vim.api.nvim_create_autocmd({ "BufLeave", "FocusLost", "InsertEnter", "WinLeave" }, {
    pattern = "*",
    group = numbertoggle,
    command = "if &nu | set nornu | endif"
})

-- Disable creating comments on new lines
vim.api.nvim_create_autocmd({ "FileType" }, {
    pattern = "*",
    command = "set formatoptions-=ro"
})

-- Weird cursor jumping with luasnip
vim.api.nvim_create_autocmd("ModeChanged", {
  pattern = "*",
  callback = function()
    if ((vim.v.event.old_mode == "s" and vim.v.event.new_mode == "n") or vim.v.event.old_mode == "i")
        and require("luasnip").session.current_nodes[vim.api.nvim_get_current_buf()]
        and not require("luasnip").session.jump_active
    then
      require("luasnip").unlink_current()
    end
  end
})

-- Format on save
local format_sync_grp = vim.api.nvim_create_augroup("Format", {})
vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*.rs,*.go,*.tf,*.c,*.h,*.cpp,*.hs",
  callback = function()
    vim.lsp.buf.format({ timeout_ms = 200 })
  end,
  group = format_sync_grp,
})

vim.diagnostic.config({
  virtual_text = false,
  underline = true,
  severity_sort = true,
})

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
            { "diagnostics", symbols = { error = "⏺ ", warn = "⏺ ", info = "⏺ ", hint = "⏺ " } }
        },
        lualine_c = { { "filename", path = 1 } },
        lualine_x = { "encoding", "filetype" },
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

require"nvim-treesitter.configs".setup {
  ensure_installed = { "c", "cpp", "lua", "vim", "rust", "go", "terraform", "hcl", "typescript",
      "javascript", "json", "yaml", "python", "vue", "tlaplus", "haskell", "ocaml" },
  sync_install = false,
  auto_install = false,
  ignore_install = {},
  highlight = {
    enable = true,
  },
}

require"nvim-treesitter.configs".setup {
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

require'treesitter-context'.setup{
  enable = true,
  multiwindow = true,
  max_lines = 0,
  min_window_height = 0,
  line_numbers = true,
  multiline_threshold = 1,
  trim_scope = 'outer',
  mode = 'cursor',
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
vim.api.nvim_set_hl(0, "@lsp.typemod.variable.callable.rust", { link = "Function" })

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

vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    local opts = { buffer = args.buf }
    local bufnr = args.buf

    -- Prioritise LSP hover over diagnostics:
    local function hover_fixed()
        vim.api.nvim_command("set eventignore=CursorHold")
        vim.lsp.buf.hover()
        vim.api.nvim_command('autocmd CursorMoved <buffer> ++once set eventignore=""')
    end

    vim.lsp.handlers['textDocument/signatureHelp'] = function(_, result, ctx, config)
        if not result or not result.signatures then return end

        -- Remove documentation to display the signature only
        local filtered_result = vim.deepcopy(result)
        for _, signature in ipairs(filtered_result.signatures) do
            signature.documentation = nil
        end

        local opts = { focusable = false }
        vim.lsp.handlers.signature_help(_, filtered_result, ctx, vim.tbl_extend('force', config or {}, opts))
    end

    vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
    vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
    vim.keymap.set("n", "K", hover_fixed, opts)
    vim.keymap.set("i", "<C-k>", vim.lsp.buf.signature_help, opts)
    vim.keymap.set("n", "<space>r", vim.lsp.buf.rename, opts)
    vim.keymap.set({ "n", "v" }, "<space>a", vim.lsp.buf.code_action, opts)
    vim.keymap.set("n", "<space>mm", function()
      vim.lsp.buf.format { async = true }
    end, opts)

    -- Show signature help in insert mode
    -- vim.api.nvim_create_autocmd("CursorHoldI", {
    --     buffer = bufnr,
    --     callback = function()
    --         local params = vim.lsp.util.make_position_params()
    --         vim.lsp.buf_request(0, 'textDocument/signatureHelp', params, function(err, result, ctx, config)
    --             if err or not result then return end
    --             vim.lsp.handlers['textDocument/signatureHelp'](err, result, ctx, config)
    --         end)
    --     end,
    -- })
  end,
})

-- TODO: Disable specific lsp tokens eg @lsp.type.enumMember.rust
local lspconfig = require("lspconfig")
local capabilities = require("cmp_nvim_lsp").default_capabilities()
local servers = { "gopls", "clangd", "terraformls", "hls" }
for _, lsp in ipairs(servers) do
  lspconfig[lsp].setup {
    capabilities = capabilities,
  }
end

-- TODO: create a user command to add features per open project
lspconfig["rust_analyzer"].setup {
    capabilities = capabilities,
    settings = {
        ["rust-analyzer"] = {
            cargo = {
                features = "all"
            }
        }
    }
}

lspconfig["tsserver"].setup {
    capabilities = capabilities,
    on_attach = function(client, bufnr)
        client.server_capabilities.semanticTokensProvider = nil
    end,
}

local is_npm_package_installed = require("util").is_npm_package_installed
lspconfig["volar"].setup {
    capabilities = capabilities,
    filetypes = is_npm_package_installed "vue" and { "vue", "typescript", "javascript" } or { "vue" },
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
