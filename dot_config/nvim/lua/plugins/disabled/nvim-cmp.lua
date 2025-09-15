return {
  "hrsh7th/nvim-cmp",
  event = "InsertEnter",
  dependencies = {
    "neovim/nvim-lspconfig",
    "hrsh7th/cmp-nvim-lsp",
    "hrsh7th/cmp-buffer",
    "hrsh7th/cmp-path",
    "hrsh7th/cmp-cmdline",
    "hrsh7th/nvim-cmp",
    "L3MON4D3/LuaSnip",
    "saadparwaiz1/cmp_luasnip",
    "rafamadriz/friendly-snippets",
  },
  config = function()
    local cmp = require("cmp")
    local luasnip = require("luasnip")
    require("luasnip/loaders/from_vscode").lazy_load({})

    -- local neocodeium = require("neocodeium")
    -- local commands = require("neocodeium.commands")
    --
    -- cmp.event:on("menu_opened", function()
    --   neocodeium.clear()
    -- end)
    --
    -- neocodeium.setup({
    --   filter = function()
    --     return not cmp.visible()
    --   end,
    -- })

    local kind_icons = {
      Copilot = "",
      codeium = "", -- "",
      Go = "",
      Text = "",
      Method = "m",
      Function = "󰊕",
      Constructor = "",
      Field = "",
      Variable = "󰫧",
      Class = "󰠱",
      Interface = "",
      Module = "",
      Property = "",
      Unit = "",
      Value = "",
      Enum = "",
      Keyword = "󰌆",
      Snippet = "",
      Color = "",
      File = "󰈙",
      Reference = "",
      Folder = "󰉋",
      EnumMember = "",
      Constant = "",
      Struct = "",
      Event = "",
      Operator = "󰆕",
      TypeParameter = "󰉺",
    }
    vim.api.nvim_set_hl(0, "CmpItemKindCopilot", { fg = "#6CC644" })

    cmp.setup({
      completion = {
        -- completeopt = "menu,menuone,preview,noselect",
        -- autocomplete = false,
      },
      snipopet = {
        expand = function(args)
          luasnip.lsp_expand(args.body)
        end,
      },
      mapping = cmp.mapping.preset.insert({
        ["<C-j>"] = cmp.mapping.select_next_item(),
        ["<C-k>"] = cmp.mapping.select_prev_item(),
        ["<C-b>"] = cmp.mapping.scroll_docs(-4),
        ["<C-f>"] = cmp.mapping.scroll_docs(4),
        ["<C-Space>"] = cmp.mapping.complete(),
        ["<C-e>"] = cmp.mapping.abort(),
        ["<CR>"] = cmp.mapping.confirm({ select = false }),
      }),
      sources = cmp.config.sources({
        { name = "codeium" },
        { name = "luasnip" },
        { name = "buffer" },
        { name = "path" },
      }),
      formatting = {
        expandable_indicator = true,
        fields = { "kind", "abbr", "menu" },
        format = function(entry, vim_item)
          vim_item.kind = string.format("%s %s", kind_icons[vim_item.kind], vim_item.kind)
          vim_item.menu = ({
            nvim_lsp = "[LSP]",
            copilot = "[Copilot]",
            codeium = "[Codeium]",
            luasnip = "[Snippet]",
            buffer = "[Buffer]",
            path = "[Path]",
          })[entry.source.name]
          return vim_item
        end,
      },
      confirm_opts = {
        behavior = cmp.ConfirmBehavior.Replace,
        select = false,
      },
    })

    -- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
    cmp.setup.cmdline({ "/", "?" }, {
      mapping = cmp.mapping.preset.cmdline(),
      sources = {
        { name = "buffer" },
      },
    })

    -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
    cmp.setup.cmdline(":", {
      mapping = cmp.mapping.preset.cmdline(),
      sources = cmp.config.sources({
        { name = "path" },
      }, {
        { name = "cmdline" },
      }),
      matching = {
        disallow_symbol_nonprefix_matching = false,
        disallow_partial_matching = false,
        disallow_partial_fuzzy_matching = false,
        disallow_fullfuzzy_matching = false,
        disallow_fuzzy_matching = false,
        disallow_prefix_unmatching = false,
      },
    })
  end,
}
