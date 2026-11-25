return {
	-- npm install -g tree-sitter-cli
	"nvim-treesitter/nvim-treesitter",
	branch = "main",
	lazy = false,
	build = ":TSUpdate",
	dependencies = {
		"nvim-treesitter/nvim-treesitter-textobjects",
	},
	config = function()
		local langs = {
			"bash",
			"c",
			"lua",
			"vim",
			"vimdoc",
			"query",
			"markdown",
			"markdown_inline",
			"python",
			"go",
			"typescript",
			"javascript",
			"html",
			"css",
			"json",
			"yaml",
			"regex",
		}

		require("nvim-treesitter").install(langs)

		-- highlight: main branch has no `highlight` module; start the parser per buffer.
		vim.api.nvim_create_autocmd("FileType", {
			callback = function(ev)
				-- ponytail: skip big files (was the old highlight.disable guard)
				local max_filesize = 100 * 1024 -- 100 KB
				local ok, stats = pcall((vim.uv or vim.loop).fs_stat, vim.api.nvim_buf_get_name(ev.buf))
				if ok and stats and stats.size > max_filesize then
					return
				end
				pcall(vim.treesitter.start, ev.buf)
			end,
		})

		-- textobjects: main branch sets keymaps manually (no `textobjects` module).
		require("nvim-treesitter-textobjects").setup({
			select = { lookahead = true },
		})
		local select = require("nvim-treesitter-textobjects.select")
		for key, obj in pairs({
			["af"] = "@function.outer",
			["if"] = "@function.inner",
			["ac"] = "@class.outer",
			["ic"] = "@class.inner",
		}) do
			vim.keymap.set({ "x", "o" }, key, function()
				select.select_textobject(obj, "textobjects")
			end)
		end
		-- ponytail: dropped incremental_selection (<C-space>) — no main-branch module.
		-- Re-add only if you actually used it.
	end,
}
