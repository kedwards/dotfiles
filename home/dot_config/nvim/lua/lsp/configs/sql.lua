-- Docker Language Configuration
-- https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.md#docker_language_server
-- go install github.com/docker/docker-language-server/cmd/docker-language-server@latest

return {
	-- LSP
	lsp = {
		["postgres-language-server"] = {
			settings = {},
		},
	},

	-- Formatters
	format = {
		sql = { "pg_format" },
	},

	-- Linters
	lint = {
		sql = { "postgres-language-server" },
	},

	-- Mason package overrides (tool name -> mason package name)
	mason = {
		pg_format = "pgformatter",
	},

	-- DAP
	dap = {},
}
