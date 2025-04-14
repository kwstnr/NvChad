require'nvim-treesitter.configs'.setup {
	ensure_installed = { 
		"c",
		"lua",
		"vim",
		"vimdoc",
		"query",
		"markdown",
		"markdown_inline",
		"javascript",
		"typescript",
		"rust",
		"java"
	},

	sync_install = false,
	auto_install = true,

	highlight = {
		enable = true,
		additional_vim_regex_highlighting = false,
	},
}

-- Register custom parser for C#
local parser_config = require("nvim-treesitter.parsers").get_parser_configs()
parser_config.csharp = {
	install_info = {
		url = "https://github.com/tree-sitter/tree-sitter-c-sharp",
		files = { "src/parser.c", "src/scanner.c" },
		branch = "main", -- just in case the default isn't
	},
	filetype = "cs", -- or "csharp" depending on your ftplugin setup
}
