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
    { "nvim-treesitter/nvim-treesitter", tag = "v0.9.3"  },
    "nvim-treesitter/nvim-treesitter-textobjects",
    "nvim-treesitter/nvim-treesitter-context",
    "nvim-lua/plenary.nvim",
    { "neovim/nvim-lspconfig", tag = "v2.1.0" },
    { "lewis6991/gitsigns.nvim", tag = "v1.0.2" },
    "nvim-lualine/lualine.nvim",
    { "j-hui/fidget.nvim", tag = "legacy" },
    { "numToStr/Comment.nvim", tag = "v0.8.0" },
    "christoomey/vim-tmux-navigator", -- Maps <C-w>l to <C-l> etc
    "ibhagwan/fzf-lua",
    { "saghen/blink.cmp", tag = "v1.2.0" }
})

-- Options
vim.opt.termguicolors = true
vim.opt.signcolumn = "yes" -- Gutter signs
vim.opt.clipboard = "unnamed" -- Copy to clipboard
vim.opt.showmode = false
vim.opt.splitright = true -- Split onto new pane
vim.opt.splitbelow = true
vim.opt.guicursor = "a:blinkon10,i-ci:ver25,r-cr-o:hor20"
vim.opt.colorcolumn = "100"
vim.opt.tabstop = 4
vim.opt.softtabstop = 0
vim.opt.expandtab = true
vim.opt.shiftwidth = 4
vim.opt.smarttab = true
vim.opt.number = true
vim.g.mapleader = " "
vim.opt.updatetime = 500 -- CursorHoldI
vim.g.netrw_liststyle = 1
vim.g.netrw_banner = 0
vim.g.netrw_sizestyle = "H"
vim.g.netrw_localrmdir = "rm -r"
vim.g.netrw_localmkdir = "mkdir -p"
vim.g.netrw_localcopydircmd = "cp -r"

-- Close brackets automatically, with return:
vim.keymap.set("i", "{<cr>", "{<cr>}<C-O><S-O>", { remap = false })
vim.keymap.set("i", "(<cr>", "(<cr>)<c-o><s-o>", { remap = false })
vim.keymap.set("i", "[<cr>", "[<cr>]<c-o><s-o>", { remap = false })

-- Nops
vim.keymap.set("n", "<SPACE>", "<Nop>", { remap = false })
vim.keymap.set("n", "<C-c>", "<Nop>", { remap = false })
vim.keymap.set("n", "grr", "<Nop>", { remap = false }) -- Default in nvim 11
vim.keymap.set("n", "grn", "<Nop>", { remap = false }) -- Default in nvim 11
vim.keymap.set("n", "gri", "<Nop>", { remap = false }) -- Default in nvim 11
vim.keymap.set("n", "gO", "<Nop>", { remap = false })  -- Default in nvim 11
vim.keymap.set("n", "gra", "<Nop>", { remap = false }) -- Default in nvim 11

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
vim.keymap.set("n", "[d", function() vim.diagnostic.jump({ count = -1, float = true }) end)
vim.keymap.set("n", "]d", function() vim.diagnostic.jump({ count = 1, float = true }) end)
vim.keymap.set("n", "<space>e", vim.diagnostic.open_float)

-- Quickfix
-- vim.keymap.set("n", "]q", "<cmd>cne<CR>") -- Default in nvim 11
-- vim.keymap.set("n", "[q", "<cmd>cpr<CR>") -- Default in nvim 11

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
    pattern = "*.*",
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
  enable = false,
  multiwindow = true,
  max_lines = 0,
  min_window_height = 0,
  line_numbers = true,
  multiline_threshold = 1,
  trim_scope = 'outer',
  mode = 'cursor',
}

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
      -- keymap = { builtin = { ["<C-d>"] = "preview-page-down" } },
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
    -- vim.keymap.set("i", "<C-k>", toggle_signature_help, opts) -- Use <ctrl-S> in nvim 11
    vim.keymap.set("n", "<space>r", vim.lsp.buf.rename, opts)
    vim.keymap.set({ "n", "v" }, "<space>a", vim.lsp.buf.code_action, opts)
    vim.keymap.set("n", "<space>mm", function()
        vim.lsp.buf.format { async = true }
    end, opts)
  end,
})

vim.lsp.config('*', {
    capabilities = require("blink.cmp").get_lsp_capabilities()
})

vim.lsp.config("rust_analyzer", {
    settings = {
        -- TODO: create a user command to add features per open project
        -- https://rust-analyzer.github.io/manual.html#configuration
        ["rust-analyzer"] = {
            cargo = {
                features = "all"
            }
        }
    }
})

vim.lsp.config("ts_ls", {
    on_attach = function(client, bufnr)
        client.server_capabilities.semanticTokensProvider = nil
    end,
})

local is_npm_package_installed = require("util").is_npm_package_installed
vim.lsp.config("volar", {
    filetypes = is_npm_package_installed "vue" and { "vue", "typescript", "javascript" } or { "vue" },
})

vim.lsp.enable({
    "rust_analyzer",
    "gopls",
    "clangd",
    "terraformls",
    "hls",
    "jdtls"
})

require("blink.cmp").setup({
    keymap = {
        preset = "none",
        ["<Tab>"] = { "select_next", "fallback" },
        ["<S-Tab>"] = { "select_prev", "fallback" },
        ["<CR>"] = { "select_and_accept", "fallback" },
        ["<C-d>"] = { "scroll_documentation_down", "fallback" },
        ["<C-u>"] = { "scroll_documentation_up", "fallback" }
    },
    completion = {
        trigger = {
            show_on_keyword = true
        },
        list = {
            selection = {
                preselect = false,
                auto_insert = true
            }
        },
        documentation = {
            auto_show = true,
            auto_show_delay_ms = 0
        },
        menu = {
            auto_show = true,
            draw = {
                columns = {
                    { "label", "kind", gap = 1 },
                    { "label_description" }
                }
            }
        }
    },
    sources = {
      default = { "lsp" },
      transform_items = function(_, items)
          local cmp_types = require("blink.cmp.types")
          return vim.tbl_filter(function(item)
              return item.kind ~= cmp_types.CompletionItemKind.Keyword
          end, items)
      end,
    }
})
