local home_dir = os.getenv("HOME")
package.path = home_dir .. "/.config/nvim/" .. package.path

-- colourscheme
require('darcula').load()

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
    "nvim-lua/plenary.nvim",
    -- {
    --     "nvim-telescope/telescope.nvim", tag = "0.1.2",
    --     dependencies = { "nvim-lua/plenary.nvim" }
    -- },
    "neovim/nvim-lspconfig",
    "hrsh7th/nvim-cmp",
    "hrsh7th/cmp-nvim-lsp",
    "L3MON4D3/LuaSnip",
    "lewis6991/gitsigns.nvim",
    "nvim-lualine/lualine.nvim",
    { "j-hui/fidget.nvim", tag = "legacy" },
    "numToStr/Comment.nvim",
    "christoomey/vim-tmux-navigator", -- Maps <C-w>l to <C-l> etc
    "ibhagwan/fzf-lua",
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
vim.keymap.set("n", "<C-c>", "<Nop>", { remap = false })
 -- TODO: remove later:
vim.keymap.set("v", "<C-f>", "<Nop>", { remap = false })
vim.keymap.set("v", "<C-b>", "<Nop>", { remap = false })
vim.keymap.set("n", "<C-f>", "<Nop>", { remap = false })
vim.keymap.set("n", "<C-b>", "<Nop>", { remap = false })
-- vim.keymap.set("n", "<leader><leader>l", "<Plug>NetrwRefresh", { remap = true }) -- vim-tmux-navigator/pull/393

-- -- Telescope
-- vim.keymap.set("n", "<leader>f", "<cmd>Telescope find_files<cr>", { remap = false })
-- vim.keymap.set("n", "<leader>b", "<cmd>Telescope buffers <cr>", { remap = false })
-- vim.keymap.set("n", "<leader>s", "<cmd>Telescope lsp_document_symbols<cr>", { remap = false })
-- vim.keymap.set("n", "<leader>S", "<cmd>Telescope lsp_workspace_symbols<cr>", { remap = false })
-- vim.keymap.set("n", "<leader>da", "<cmd>Telescope diagnostics bufnr=0 severity_bound=0<cr>", { remap = false })
-- vim.keymap.set("n", "<leader>de", "<cmd>Telescope diagnostics bufnr=0 severity=1<cr>", { remap = false })
-- vim.keymap.set("n", "<leader>DA", "<cmd>Telescope diagnostics severity_bound=0<cr>", { remap = false })
-- vim.keymap.set("n", "<leader>DE", "<cmd>Telescope diagnostics severity=1<cr>", { remap = false })
-- vim.keymap.set("n", "<leader>/", "<cmd>Telescope live_grep<cr>", { remap = false })
-- vim.keymap.set("n", "<leader>tr", "<cmd>Telescope resume<cr>", { remap = false })
-- vim.keymap.set("n", "gr", "<cmd>Telescope lsp_references<cr>", { remap = false })
-- vim.keymap.set("n", "gi", "<cmd>Telescope lsp_implementations<cr>", { remap = false })
-- vim.keymap.set("n", "gtd", "<cmd>Telescope lsp_type_definitions<cr>", { remap = false })

-- FZF
vim.keymap.set("n", "<leader>f", "<cmd>FzfLua files<cr>", { remap = false })
vim.keymap.set("n", "<leader>b", "<cmd>FzfLua buffers <cr>", { remap = false })
vim.keymap.set("n", "<leader>s", "<cmd>FzfLua lsp_document_symbols<cr>", { remap = false })
vim.keymap.set("n", "<leader>S", "<cmd>FzfLua lsp_workspace_symbols<cr>", { remap = false })
vim.keymap.set("n", "<leader>da", "<cmd>FzfLua diagnostics_document<cr>", { remap = false })
vim.keymap.set("n", "<leader>de", "<cmd>FzfLua diagnostics_document severity_only=1<cr>", { remap = false })
vim.keymap.set("n", "<leader>DA", "<cmd>FzfLua diagnostics_workspace<cr>", { remap = false })
vim.keymap.set("n", "<leader>DE", "<cmd>FzfLua diagnostics_workspace severity_only=1<cr>", { remap = false })
vim.keymap.set("n", "<leader>/", "<cmd>FzfLua live_grep<cr>", { remap = false })
vim.keymap.set("n", "<leader>tr", "<cmd>FzfLua resume<cr>", { remap = false })
vim.keymap.set("n", "gr", "<cmd>FzfLua lsp_references<cr>", { remap = false })
vim.keymap.set("n", "gi", "<cmd>FzfLua lsp_implementations<cr>", { remap = false })
vim.keymap.set("n", "gtd", "<cmd>FzfLua lsp_typedefs<cr>", { remap = false })

-- Treesitter
vim.keymap.set("n", "<space>c", "<cmd>TSContextToggle<cr>", { remap = false })

-- Diagnostics
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev)
vim.keymap.set("n", "]d", vim.diagnostic.goto_next)
vim.keymap.set("n", "<space>e", vim.diagnostic.open_float)

-- Quickfix
vim.keymap.set("n", "]q", "<cmd>cne<CR>")
vim.keymap.set("n", "[q", "<cmd>cpr<CR>")

-- User commands
vim.api.nvim_create_user_command("BufDeleteOthers", "%bd|e#", {})
vim.api.nvim_create_user_command("BufDeleteAll", "%bd", {})
vim.cmd([[
    cnoreabbrev bdo BufDeleteOthers
    cnoreabbrev bda BufDeleteAll
]])

local function is_floating_window()
    local window_config = vim.api.nvim_win_get_config(0)
    return window_config.relative ~= ""
end

-- Highlight trailing whitespace
local hlwhitespace = vim.api.nvim_create_augroup("hlwhitespace", { clear = true })
vim.api.nvim_create_autocmd({ "BufWinEnter" }, {
    pattern = "*",
    group = hlwhitespace,
    callback = function()
        if not is_floating_window() then
            vim.cmd([[match ExtraWhitespace /\s\+$/]])
        end
    end
})
vim.api.nvim_create_autocmd({ "InsertEnter" }, {
    pattern = "*",
    group = hlwhitespace,
    callback = function()
        if not is_floating_window() then
            vim.cmd([[match ExtraWhitespace /\s\+\%#\@<!$/]])
        end
    end
})
vim.api.nvim_create_autocmd({ "InsertLeave" }, {
    pattern = "*",
    group = hlwhitespace,
    callback = function()
        if not is_floating_window() then
            vim.cmd([[match ExtraWhitespace /\s\+$/]])
        end
    end
})
vim.api.nvim_create_autocmd({ "BufWinLeave" }, {
    pattern = "*",
    group = hlwhitespace,
    -- command = "call clearmatches()"
    callback = function()
        if not is_floating_window() then
            vim.cmd([[call clearmatches()]])
        end
    end
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

vim.diagnostic.config({
    virtual_text = false,
    underline = true,
    severity_sort = true,
    signs = {
        text = {
            [vim.diagnostic.severity.HINT]  = "⏺",
            [vim.diagnostic.severity.ERROR] = "⏺",
            [vim.diagnostic.severity.INFO]  = "⏺",
            [vim.diagnostic.severity.WARN]  = "⏺"
        }
    }
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
  ensure_installed = {'c', 'lua', 'markdown', 'markdown_inline', 'query', 'vim', 'vimdoc'},
  sync_install = false,
  auto_install = false,
  ignore_install = {},
  highlight = {
    enable = true,
  },
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

-- local actions = require("telescope.actions")
-- require("telescope").setup({
--     defaults = {
--         mappings = {
--             n = {
--                 ["<Esc>"] = function() end,
--                 ["<C-c>"] = actions.close,
--             },
--         },
--         layout_strategy = "horizontal",
--         layout_config = {
--             prompt_position = "top",
--         },
--         sorting_strategy = "ascending",
--     },
-- })

local actions = require("fzf-lua").actions
require("fzf-lua").setup{
  winopts = {
      preview = {
          winopts = { number = false }
      }
  },

  keymap = {
      builtin = {
          ["<C-d>"] = "preview-page-down",
          ["<C-u>"] = "preview-page-up",
          ["<C-e>"] = "preview-down",
          ["<C-y>"] = "preview-up",
      },
      fzf = {
          ["ctrl-d"] = "preview-page-down",
          ["ctrl-u"] = "preview-page-up",
          ["ctrl-q"] = "select-all+accept",
      },
  },

  actions = {
      files = {
          ["default"] = actions.file_edit_or_qf,
          ["ctrl-s"] = actions.file_split,
          ["ctrl-v"] = actions.file_vsplit,
          ["ctrl-h"] = actions.toggle_hidden,
      },
  },

  fzf_opts = {
      ['--cycle'] = true,
  },

  hls = {
      normal = "Normal",
      border = "Normal",
      title  = "Normal",
      help_normal = "Normal",
      help_border = "Normal",
      preview_normal = "Normal",
      preview_border = "Normal",
      preview_title  = "Normal",
      -- builtin preview only:
      cursor = "Cursor",
      cursorline = "Visual",
      cursorlinenr = "Visual",
      search = "CurSearch",
  },

  fzf_colors = {
      ["fg"] = { "fg", "Normal" },
      ["bg"] = { "bg", "Normal" },
      ["hl"] = { "fg", "TelescopeMatching" },
      ["fg+"] = { "fg", "Visual" },
      ["bg+"] = { "bg", "Visual" },
      ["hl+"] = { "fg", "TelescopeMatching" },
      ["info"] = { "fg", "Type" },
      ["border"] = { "fg", "Normal" },
      ["gutter"] = { "bg", "Normal" },
      ["query"] = { "fg", "Normal" },
      ["prompt"] = { "fg", "Identifier" },
      ["pointer"] = { "fg", "Visual" },
      ["marker"] = { "fg", "Visual" },
      ["header"] = { "fg", "Normal" },
  },

  previewers = {
      builtin = {
          syntax = true,
          treesitter = { enabled = true }
      }
  },

  -- Specific command/picker options:
  defaults = {
      git_icons = false,
      file_icons = false,
      no_header = true,
  },
  files = {
      cwd_prompt = true,
      cwd_prompt_shorten_len = 1,
      hidden = false,
      no_ignore = false,
  },
  lsp = {
      symbols = {
          symbol_style = false,
      }
  },
  buffers = {
      keymap = { builtin = { ["<C-d>"] = false } },
      actions = { ["ctrl-x"] = false, ["x"] = { actions.buf_del, actions.resume } },
  },
  grep = {
      no_header = false
  }
}

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

    local signature_help_enabled = false
    local function toggle_signature_help()
        local group_name = "SignatureHelp"

        if signature_help_enabled then
            vim.api.nvim_del_augroup_by_name(group_name)
            signature_help_enabled = false
        else
            vim.api.nvim_create_augroup(group_name, { clear = true })
            vim.api.nvim_create_autocmd("CursorHoldI", {
                group = group_name,
                callback = function()
                    vim.lsp.buf.signature_help()
                end,
            })
            signature_help_enabled = true
        end
    end

    -- Format on save
    local format_on_save_enabled = false
    local function toggle_format_on_save()
        local group_name = "FormatOnSave"

        if format_on_save_enabled then
            vim.api.nvim_del_augroup_by_name(group_name)
            format_on_save_enabled = false
        else
            vim.api.nvim_create_augroup(group_name, { clear = true })
            vim.api.nvim_create_autocmd("BufWritePre", {
              group = group_name,
              callback = function()
                  vim.lsp.buf.format()
              end,
            })
            format_on_save_enabled = true
        end
    end
    toggle_format_on_save()
    vim.api.nvim_create_user_command("ToggleFormatOnSave", toggle_format_on_save, {})

    vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
    vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
    vim.keymap.set("n", "K", hover_fixed, opts)
    vim.keymap.set("i", "<C-k>", toggle_signature_help, opts)
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
local servers = { "gopls", "clangd", "terraformls", "hls", "jdtls" }
for _, lsp in ipairs(servers) do
  lspconfig[lsp].setup {
    capabilities = capabilities,
  }
end

-- https://rust-analyzer.github.io/manual.html#configuration
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

lspconfig["ts_ls"].setup {
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

-- TODO: move to builtin completion (vim.lsp.completion.enable), remove cmp and luasnip
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
