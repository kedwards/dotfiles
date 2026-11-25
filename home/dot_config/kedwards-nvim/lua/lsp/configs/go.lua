-- Go Language Configuration
-- https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.md#gopls
-- mise use -g go

return {
	-- LSP
	lsp = {
		gopls = {
			settings = {
				gopls = {
					gofumpt = true,
					codelenses = {
						gc_details = false,
						generate = true,
						regenerate_cgo = true,
						run_govulncheck = true,
						test = true,
						tidy = true,
						upgrade_dependency = true,
						vendor = true,
					},
					hints = {
						assignVariableTypes = true,
						compositeLiteralFields = true,
						compositeLiteralTypes = true,
						constantValues = true,
						functionTypeParameters = true,
						parameterNames = true,
						rangeVariableTypes = true,
					},
					analyses = {
						fieldalignment = true,
						nilness = true,
						unusedparams = true,
						unusedwrite = true,
						useany = true,
					},
					usePlaceholders = true,
					completeUnimported = true,
					staticcheck = true,
					directoryFilters = { "-.git", "-.vscode", "-.idea", "-.vscode-test", "-node_modules" },
					semanticTokens = true,
				},
			},
		},
	},

	-- Formatters
	format = {
		go = { "gofumpt", "goimports-reviser" },
	},

	-- Linters
	lint = {
		go = { "golangcilint" },
	},

	-- Mason package overrides (tool name -> mason package name)
	mason = {
		golangcilint = "golangci-lint",
	},

	-- DAP
	debug = {
		adapters = {
			delve = {
				type = "server",
				port = "${port}",
				executable = {
					command = "dlv",
					args = { "dap", "-l", "127.0.0.1:${port}" },
				},
			},
		},
		configurations = {
			go = {
				{
					type = "delve",
					name = "Debug file",
					request = "launch",
					program = "${file}",
				},
				{
					type = "delve",
					name = "Debug file (with args)",
					request = "launch",
					program = "${file}",
					args = function()
						local args = vim.fn.input("Arguments: ")
						return vim.split(args, " ", { trimempty = true })
					end,
				},
				{
					type = "delve",
					name = "Debug package",
					request = "launch",
					program = "${workspaceFolder}",
				},
				{
					type = "delve",
					name = "Debug package (with args)",
					request = "launch",
					program = "${workspaceFolder}",
					args = function()
						local args = vim.fn.input("Arguments: ")
						return vim.split(args, " ", { trimempty = true })
					end,
				},
				{
					type = "delve",
					name = "Debug test (file)",
					request = "launch",
					mode = "test",
					program = "${workspaceFolder}",
				},
				{
					type = "delve",
					name = "Debug test (single)",
					request = "launch",
					mode = "test",
					program = "${workspaceFolder}",
					args = function()
						local name = vim.fn.input("Test name (e.g. TestFoo): ")
						return vim.trim(name) ~= "" and { "-run", name } or {}
					end,
				},
			},
		},
	},
}
