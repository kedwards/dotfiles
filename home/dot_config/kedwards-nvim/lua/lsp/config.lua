local capabilities = require("lsp.capabilities")

local M = {}
local function with_handler_opts(handler, opts)
	return function(err, result, ctx, config)
		return handler(err, result, ctx, vim.tbl_deep_extend("force", config or {}, opts))
	end
end

--- Configure global LSP defaults
function M.setup()
	vim.lsp.config("*", {
		capabilities = capabilities.get_capabilities(),
		root_markers = { ".git", ".hg", ".svn" },

		-- Global settings that apply to all servers
		settings = {},

		-- Default handlers
		handlers = {
			["textDocument/hover"] = with_handler_opts(vim.lsp.handlers.hover, {
				border = "rounded",
				focusable = false,
			}),
			["textDocument/signatureHelp"] = with_handler_opts(vim.lsp.handlers.signature_help, {
				border = "rounded",
				focusable = false,
			}),
		},
	})
end

return M
