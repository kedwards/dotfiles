return {
    "L3MON4D3/LuaSnip",
    lazy = false,
    keys = {
      {
        "<leader><leader>;",
        function() require("luasnip").jump(1) end,
        desc = "Jump forward a snippet placement",
        mode = "i",
        noremap = true,
        silent = true
      },
      {
        "<leader><leader>,",
        function() require("luasnip").jump(-1) end,
        desc = "Jump backward a snippet placement",
        mode = "i",
        noremap = true,
        silent = true
      }
    },
    config = function()
      require("luasnip.loaders.from_lua").load({ paths = "~/.snippets" })
    end
  
}
