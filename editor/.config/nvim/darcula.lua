local M = {}

local c = {
    bg = "#232525",
    bg2 = "#2B2B2B",
    fg = "#A9B7C6",
    fg2 = "#606366",
    red = "#FF0000",
    orange = "#FFA500",
    redorange = "#CC7832",
    green = "#32CD32",
    darkgreen = "#6A8759",
    grey = "#808080",
    darkgrey = "#46484A",
    darkgrey2 = "#606366",
    bluegrey = "#A9B7C6",
    lightgrey = "#BBBBBB",
    blue = "#6897BB",
    yellow = "#FFC66D",
    white = "#FFFFFF",
    purple = "#9876AA",
}

local highlights = {
    Normal = { fg = c.fg, bg = c.bg },
    Comment = { fg = c.grey },
    Variable = { fg = c.fg },
    Directory = { fg = c.fg },
    Operator = { fg = c.fg },
    Delimiter = { fg = c.fg },
    Type = { fg = c.fg },
    Error = { fg = c.red },
    Warning = { fg = c.orange },
    Identifier = { fg = c.fg },
    Statement = { fg = c.redorange },
    PreProc = { fg = c.redorange },
    Function = { fg = c.yellow },
    Keyword = { fg = c.redorange },
    Special = { fg = c.redorange },
    String = { fg = c.darkgreen },
    Constant = { fg = c.blue },
    Number = { fg = c.blue },
    Namespace = { fg = c.purple },

    SignColumn = { bg = c.bg2, fg = c.grey },
    LineNr = { bg = c.bg2, fg = c.grey },
    ColorColumn = { bg = c.bg2 },
    StatusLine = { bg = c.bg2, fg = c.fg },

    DiagnosticError = { fg = c.red, bg = c.bg2 },
    DiagnosticWarn = { fg = c.orange, bg = c.bg2 },
    DiagnosticInfo = { fg = c.white, bg = c.bg2 },
    DiagnosticHint = { fg = c.white, bg = c.bg2 },

    DiagnosticFloatingError = { fg = c.red, bg = c.darkgrey },
    DiagnosticFloatingWarn = { fg = c.orange, bg = c.darkgrey },
    DiagnosticFloatingInfo = { fg = c.white, bg = c.darkgrey },
    DiagnosticFloatingHint = { fg = c.white, bg = c.darkgrey },

    GitSignsAdd    = { fg = c.green, bg = c.bg2 },
    GitSignsChange = { fg = c.grey, bg = c.bg2 },
    GitSignsDelete = { fg = c.red, bg = c.bg2 },

    NormalFloat = { fg = c.lightgrey, bg = c.darkgrey },
    Pmenu = { fg = c.lightgrey, bg = c.darkgrey },
    PmenuSel = { fg = c.lightgrey, bg = "#113A5C" }, -- new blue
    PmenuSbar = { fg = c.darkgrey, bg = c.darkgrey },
    -- PmenuThumb = { fg = "#616263", bg = "#616263" },

    Visual = { bg = "#214283" }, -- another new blue
    Search = { bg = "#214283" },

    ExtraWhitespace = { bg = "#BC3F3C" }, -- new red

    MatchParen = { fg = "#FFEF28", bg = "#3B514D" },

    TelescopeMatching = { fg = "#D8D8D8" }, -- new light grey
    QuickFixLine = { fg = "#D8D8D8" }, -- new light grey

    HTMLTag = { fg = "#E8BF6A" }, -- new orange/yellow
    HTMLString = { fg = "#A5C261" } -- new lightgreen
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

        "@lsp.type.enumMember.rust",
        "@lsp.typemod.typeAlias"
    },
    PreProc = {
        "@function.macro",
        "@lsp.type.macro",
        "@lsp.type.decorator"
    },
    Variable = {
        "htmlArg",

        "@variable",
        "@variable.builtin",
    },
    Namespace = {
        -- "@module",
        "@namespace",
        "@lsp.type.namespace"
    },
    Normal = {
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
        "@lsp.typemod.variable.readonly.cpp"
    },
    HTMLTag = {
        "htmlTagName",
        "htmlEndTag",

        "@tag.vue",
        "@tag.delimiter.vue"
    },
    HTMLString = {
        "@string.vue"
    }
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
    set_highlights()
    set_links()
end

return M
