local rt = require("rust-tools")

rt.setup({
	server = {
		capabilities = require("cmp_nvim_lsp").default_capabilities(),
		on_attach = function(_, bufnr)
			-- Set keybinds here
		end
	}
})
