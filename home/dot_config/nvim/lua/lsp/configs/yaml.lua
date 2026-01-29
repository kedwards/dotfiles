-- Yaml Language Configuration
-- https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.md#yamlls
-- npm install -g yaml-language-server

return {
	-- LSP
	lsp = {
		yamlls = {
			name = "yaml-language-server",
			settings = {
				yaml = {
					customTags = {
						"!And sequence",
						"!Base64 scalar",
						"!Cidr sequence",
						"!Equals sequence",
						"!FindInMap sequence",
						"!GetAtt scalar",
						"!GetAtt sequence",
						"!GetAZs scalar",
						"!If sequence",
						"!ImportValue scalar",
						"!Join sequence",
						"!Not sequence",
						"!Or sequence",
						"!Ref scalar",
						"!Select sequence",
						"!Split sequence",
						"!Sub scalar",
						"!Sub sequence",
						"!Condition scalar",
					},
				},
			},
		},
	},

	-- Formatters
	format = {
		yaml = { "prettier" },
	},

	-- Linters
	lint = {
		yaml = { "yamllint" },
	},

	-- DAP
	dap = {},
}
