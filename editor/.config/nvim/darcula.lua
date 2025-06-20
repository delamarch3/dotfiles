local M = {}

local c = {
    bg = "#1E1F22",
    bg2 = "#3D3F41", -- panels
    bg3 = "#2B2D30", -- line hl
    bg4 = "#2B2D30", -- menus
    fg = "#A9B7C5",
    red = "#FF0000",
    red2 = "#BC5460", -- errors
    orange = "#FFA500", -- functions
    orange2 = "#BBB529", -- decorators
    redorange = "#CC7832", -- keywords
    green = "#32CD32",
    darkgreen = "#6A8759", -- strings
    grey = "#808080", -- comments
    blue = "#6897BB",
    yellow = "#FFC66D",
    yellow2 = "#AC9148", -- warnings
    white = "#FFFFFF",
    purple = "#9876AA",
    cyan = "#4EADE5",
    cyan2 = "#20999D",
    lilac = "#658CC9"
}

local highlights = {
    Normal = { fg = c.fg, bg = c.bg },
    Comment = { fg = c.grey },
    Variable = { fg = c.fg },
    Directory = { fg = c.fg },
    Operator = { fg = c.fg },
    Delimiter = { fg = c.fg },
    Type = { fg = c.fg },
    Error = { fg = c.red2 },
    Warning = { fg = c.orange },
    Identifier = { fg = c.fg },
    Statement = { fg = c.redorange },
    PreProc = { fg = c.cyan },
    Function = { fg = c.yellow },
    Keyword = { fg = c.redorange },
    Special = { fg = c.redorange },
    String = { fg = c.darkgreen },
    Constant = { fg = c.purple },
    Number = { fg = c.blue },
    Namespace = { fg = c.fg },

    SignColumn = { bg = c.bg, fg = c.grey },
    LineNr = { bg = c.bg, fg = c.grey },
    ColorColumn = { bg = c.bg }, -- The ruler line
    StatusLine = { bg = c.bg4, fg = c.fg },
    CursorLine = { bg = c.bg3 },
    CursorLineNr = { bg = c.bg3 },

    DiagnosticError = { fg = c.red2, bg = c.bg },
    DiagnosticWarn = { fg = c.yellow2, bg = c.bg },
    DiagnosticInfo = { fg = c.lilac, bg = c.bg },
    DiagnosticHint = { fg = c.lilac, bg = c.bg },

    DiagnosticFloatingError = { fg = c.red2, bg = c.bg2 },
    DiagnosticFloatingWarn = { fg = c.yellow2, bg = c.bg2 },
    DiagnosticFloatingInfo = { fg = c.lilac, bg = c.bg2 },
    DiagnosticFloatingHint = { fg = c.lilac, bg = c.bg2 },

    GitSignsAdd    = { fg = c.green, bg = c.bg },
    GitSignsChange = { fg = c.grey, bg = c.bg },
    GitSignsDelete = { fg = c.red, bg = c.bg },

    NormalFloat = { fg = c.fg, bg = c.bg2 },
    Pmenu = { fg = c.fg, bg = c.bg4 },
    PmenuSel = { bg = "#525457" }, -- new blue
    PmenuSbar = { fg = c.bg4, bg = c.bg4 },
    PmenuThumb = { fg = "#5D5E5F", bg = "#5D5E5F" }, -- new grey
    PmenuKind = { fg = c.redorange, bg = c.bg4 },

    Visual = { bg = "#214283" }, -- another new blue
    Search = { bg = "#32593D" },

    ExtraWhitespace = { bg = "#BC3F3C" }, -- new red

    MatchParen = { fg = "#FFEF28", bg = "#3B514D" },

    TelescopeMatching = { fg = "#D8D8D8" }, -- new light grey
    QuickFixLine = { fg = "#D8D8D8" }, -- new light grey

    HTMLTag = { fg = "#E8BF6A" }, -- new orange/yellow
    HTMLString = { fg = "#A5C261" }, -- new lightgreen

    Todo = { fg = "#A5C261" }, -- new lightgreen

    TypeParam = { fg = c.cyan2 },
    Decorator = { fg = c.orange2 }
}

local links = {
    Function = {
        "@constructor",
        "@lsp.typemod.variable.callable",
        "@lsp.typemod.method",
        "@lsp.typemod.function"
    },
    Type = {
        "@type",
        "@type.builtin",
        "@lsp.typemod.typeAlias",

        "@constructor.ocaml"
    },
    PreProc = {
        "@function.macro",
        "@lsp.type.macro",
    },
    Variable = {
        "htmlArg",

        "@variable",
        "@variable.builtin",
        "@lsp.typemod.variable",
        "@lsp.mod.declaration"
    },
    Namespace = {
        "@namespace",
        "@lsp.type.namespace"
    },
    Normal = {
        "Question",
        "@tag.attribute.vue"
    },
    Keyword = {
        "@type.qualifier",
        "@lsp.typemod.keyword",

        "@lsp.type.type.terraform"
    },
    String = {
        "Character",
        "@lsp.type.enumMember.terraform"
    },
    Constant = {
        "@lsp.mod.constant",
        "@lsp.typemod.variable.static",
        "@lsp.type.constParameter.rust",
        "@lsp.typemod.variable.readonly.cpp",
        "@lsp.typemod.enumMember"
    },
    HTMLTag = {
        "htmlTagName",
        "htmlEndTag",
        "@tag.vue",
        "@tag.delimiter.vue"
    },
    HTMLString = {
        "@string.vue"
    },
    Special = {
        "Title"
    },
    TelescopeMatching = {
        "netrwMarkFile"
    },
    TypeParam = {
        "@lsp.type.typeParameter",
        "@lsp.typemod.typeParameter",
        "@lsp.type.lifetime"
    },
    Decorator = {
        "@lsp.type.decorator",
        "@lsp.type.toolModule",

        "@lsp.type.attributeBracket.rust",
        "@lsp.type.builtinAttribute.rust"
    },
    Number = {
        "@boolean"
    },
    Search = {
        "CurSearch"
    },
    Statement = {
        "@lsp.type.label",
        "@lsp.typemod.label"
    }
}

local unset = {
    "SnippetTabstop"
}

local function set_highlights()
    for group, opts in pairs(highlights) do
        local gui_opts = {}

        if opts.bold then table.insert(gui_opts, "bold") end
        if opts.italic then table.insert(gui_opts, "italic") end
        if opts.underline then table.insert(gui_opts, "underline") end

        vim.api.nvim_set_hl(0, group, {
            fg = opts.fg,
            bg = opts.bg,
            bold = opts.bold,
            italic = opts.italic,
            underline = opts.underline,
        })
    end
end

local function unset_highlights()
    for _, group in ipairs(unset) do
        vim.api.nvim_set_hl(0, group, {})
    end
end

local function set_links()
    for linkto, groups in pairs(links) do
        for _, group in ipairs(groups) do
            vim.api.nvim_set_hl(0, group, {
                link = linkto,
            })
        end
    end
end

function M.load()
    unset_highlights()
    set_highlights()
    set_links()
end

return M
