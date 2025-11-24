-- Leader
vim.g.mapleader = " "

-- Basics
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.termguicolors = true
vim.opt.expandtab = true
vim.opt.shiftwidth = 2
vim.opt.tabstop = 2
vim.opt.smartindent = true
vim.opt.clipboard = "unnamedplus" -- nutzt unter WSL win32yank

-- File handling
vim.opt.backup = false -- Don't create backup files
vim.opt.writebackup = false -- Don't create backup before writing
vim.opt.swapfile = false -- Don't create swap files
vim.opt.undofile = true -- Persistent undo
vim.opt.undodir = vim.fn.expand("~/.vim/undodir") -- Undo directory
vim.opt.updatetime = 300 -- Faster completion
vim.opt.timeoutlen = 300 -- Key timeout duration
vim.opt.ttimeoutlen = 0 -- Key code timeout
vim.opt.ttimeout = true
vim.opt.autoread = true -- Auto reload files changed outside vim
vim.opt.autowrite = false -- Don't auto save

-- Theme
vim.cmd.colorscheme("catppuccin")

-- WhichKey
require("which-key").setup({})
vim.keymap.set("n", "<leader>-", ":vsplit <CR>", { desc = "Vertical Split" })
vim.keymap.set("n", "<leader>\\", ":split <CR>", { desc = "Horizontal Split" })
vim.keymap.set("n", "<leader>q", ":q <CR>", { desc = "Close Buffer" })
vim.keymap.set("n", "<leader>qq", ":qa <CR>", { desc = "Close Buffer" })

-- Telescope
local tb = require("telescope.builtin")
vim.keymap.set("n", "<leader>ff", tb.find_files, { desc = "Find files" })
vim.keymap.set("n", "<leader>fg", tb.live_grep, { desc = "Live grep" })
vim.keymap.set("n", "<leader>fb", tb.buffers, { desc = "Buffers" })
vim.keymap.set("n", "<leader>fh", tb.help_tags, { desc = "Help tags" })

-- Treesitter: Parser in ein beschreibbares Verzeichnis legen (nicht im Nix-Store)
local parser_path = vim.fn.stdpath("data") .. "/treesitter-parsers"
vim.fn.mkdir(parser_path, "p") -- Ordner sicher anlegen
vim.opt.runtimepath:append(parser_path) -- RTP, damit Neovim dort .so findet

require("nvim-treesitter.install").prefer_git = false
require("nvim-treesitter.install").compilers = {} -- verhindert Build-Versuche auf Systemen ohne Toolchain

require("nvim-treesitter.configs").setup({
	parser_install_dir = parser_path,
	ensure_installed = {}, -- wir verlassen uns auf Nix/Plugins, nicht auf TS-Installer
	auto_install = false, -- keine Auto-Downloads (würden sonst wieder in den Store wollen)
	highlight = { enable = true },
	indent = { enable = true },
})

-- Lualine
require("lualine").setup({
	options = { theme = "auto", globalstatus = true },
})

-- Gitsigns
require("gitsigns").setup({})

-- Completion
local cmp = require("cmp")
local luasnip = require("luasnip")
require("luasnip.loaders.from_vscode").lazy_load()

cmp.setup({
	snippet = {
		expand = function(args)
			luasnip.lsp_expand(args.body)
		end,
	},
	mapping = cmp.mapping.preset.insert({
		["<C-Space>"] = cmp.mapping.complete(),
		["<CR>"] = cmp.mapping.confirm({ select = true }),
		["<Tab>"] = cmp.mapping(function(fallback)
			if cmp.visible() then
				cmp.select_next_item()
			elseif luasnip.expand_or_jumpable() then
				luasnip.expand_or_jump()
			else
				fallback()
			end
		end, { "i", "s" }),
		["<S-Tab>"] = cmp.mapping(function(fallback)
			if cmp.visible() then
				cmp.select_prev_item()
			elseif luasnip.jumpable(-1) then
				luasnip.jump(-1)
			else
				fallback()
			end
		end, { "i", "s" }),
	}),
	sources = cmp.config.sources({
		{ name = "nvim_lsp" },
		{ name = "path" },
		{ name = "buffer" },
		{ name = "luasnip" },
	}),
})

-- LSP
-- ===== Ruhe reinbringen: LSP-Handler runterdrehen =====
-- Nur WARN/ERROR anzeigen, INFO/DEBUG ignorieren:
vim.lsp.set_log_level("ERROR")

-- Server-Logs nicht spammen:
vim.lsp.handlers["window/logMessage"] = function() end
vim.lsp.handlers["$/progress"] = function() end
vim.lsp.handlers["language/status"] = function() end

-- Popups mit Buttons (z.B. "Update project configuration?") automatisch bestätigen:
vim.lsp.handlers["window/showMessageRequest"] = function(_, result)
	local actions = result.actions or {}
	-- wähle die erste Aktion (meist "Always"/"Proceed"/"Yes")
	if #actions > 0 then
		return actions[1]
	end
end

-- ===== LSP UX: Diagnostics, Signs, Keymaps, on_attach =====

-- hübschere Diagnostics
vim.diagnostic.config({
	virtual_text = false, -- weniger Rauschen im Text
	float = { border = "rounded" },
	severity_sort = true,
	signs = true,
	underline = true,
})
-- Zeichen in der Zeichenleiste
local signs = { Error = " ", Warn = " ", Hint = " ", Info = " " }
for type, icon in pairs(signs) do
	local hl = "DiagnosticSign" .. type
	vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
end

-- kleiner Helper für sichere Telescope-Nutzung
local has_telescope, tb = pcall(require, "telescope.builtin")

-- Toggle für Inlay-Hints (Neovim 0.10+)
local function toggle_inlay_hints(bufnr)
	local ih = vim.lsp.inlay_hint
	if type(ih) == "table" and ih.is_enabled then
		ih.enable(not ih.is_enabled({ bufnr = bufnr }), { bufnr = bufnr })
	end
end

-- formatiert mit LSP, wenn unterstützt (sonst still nichts)
local function lsp_format(bufnr)
	if vim.lsp.buf.format then
		vim.lsp.buf.format({ async = true })
	end
end

-- zentrales on_attach für alle Server
local on_attach = function(client, bufnr)
	local map = function(mode, lhs, rhs, desc)
		vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, silent = true, noremap = true, desc = desc })
	end

	-- Navigation
	map("n", "gd", vim.lsp.buf.definition, "Go to definition")
	map("n", "gD", vim.lsp.buf.declaration, "Go to declaration")
	map("n", "gi", has_telescope and tb.lsp_implementations or vim.lsp.buf.implementation, "Go to implementation")
	map("n", "gr", has_telescope and tb.lsp_references      or vim.lsp.buf.references,     "References")
  -- map("n", "gr", vim.lsp.buf.references, "References")
	map("n", "K", vim.lsp.buf.hover, "Hover docs")
	map("n", "<C-k>", vim.lsp.buf.signature_help, "Signature help")

	-- Aktionen
	map("n", "<leader>rn", vim.lsp.buf.rename, "Rename symbol")
	map({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, "Code action")

	-- Format
	map({ "n", "v" }, "<leader>fo", function()
		lsp_format(bufnr)
	end, "Format buffer")

	-- Diagnostics
	map("n", "[d", vim.diagnostic.goto_prev, "Prev diagnostic")
	map("n", "]d", vim.diagnostic.goto_next, "Next diagnostic")
	map("n", "<leader>e", vim.diagnostic.open_float, "Line diagnostics")
	map("n", "<leader>dl", vim.diagnostic.setloclist, "Diagnostics → loclist")

	-- Symbole
	map("n", "<leader>ls", has_telescope and tb.lsp_document_symbols or vim.lsp.buf.document_symbol, "Document symbols")
	map(
		"n",
		"<leader>lS",
		has_telescope and tb.lsp_workspace_symbols or vim.lsp.buf.workspace_symbol,
		"Workspace symbols"
	)

	-- Workspace-Verzeichnisse
	map("n", "<leader>wa", vim.lsp.buf.add_workspace_folder, "Workspace add")
	map("n", "<leader>wr", vim.lsp.buf.remove_workspace_folder, "Workspace remove")
	map("n", "<leader>wl", function()
		print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
	end, "Workspace list")

	-- Inlay Hints togglen
	map("n", "<leader>ti", function()
		toggle_inlay_hints(bufnr)
	end, "Toggle inlay hints")

	-- :LspInfo schnell
	map("n", "<leader>li", "<cmd>LspInfo<CR>", "LSP info")
end

-- Which-Key Labels (optional – du hast which-key)
pcall(function()
	local wk = require("which-key")
	wk.add({
		mode = { "n" },
		{ "<leader>l", group = "LSP" },
		{ "<leader>t", group = "Toggle" },
	})
end)

local lspconfig = require("lspconfig")
local capabilities = require("cmp_nvim_lsp").default_capabilities()
local util = lspconfig.util

-- Lua (Neovim)
lspconfig.lua_ls.setup({
	capabilities = capabilities,
	on_attach = on_attach,
	settings = {
		Lua = {
			diagnostics = { globals = { "vim" } },
			workspace = { checkThirdParty = true },
			telemetry = { enable = false },
		},
	},
})

-- Typescript
lspconfig.ts_ls.setup({
	capabilities = capabilities,
	on_attach = on_attach,
	cmd = { "typescript-language-server", "--stdio" },
	root_dir = util.root_pattern("tsconfig.json", "jsconfig.json", "package.json", ".git"),
	single_file_support = false,
	settings = {
		typescript = {
			preferGoToSourceDefinition = true,
			format = { semicolons = "insert" },
			inlayHints = {
				enumMemberValues = { enabled = true },
				functionLikeReturnTypes = { enabled = true },
				parameterNames = { enabled = "literals" },
				parameterTypes = { enabled = true },
				propertyDeclarationTypes = { enabled = true },
				variableTypes = { enabled = true },
			},
			suggest = {
				completeFunctionCalls = true,
				includeCompletionsForImportStatements = true,
			},
		},
		javascript = {
			preferGoToSourceDefinition = true,
			inlayHints = { enumMemberValues = { enabled = true } },
		},
	},
})
-- ===== ESLint LSP (optional, wenn installiert) =====
-- funktioniert gut parallel zu ts_ls, steuert nur Diagnostics/Fixes von ESLint
if vim.fn.executable("vscode-eslint-language-server") == 1 then
	lspconfig.eslint.setup({
		capabilities = capabilities,
		cmd = { "vscode-eslint-language-server", "--stdio" },
		root_dir = util.root_pattern(
			".eslintrc",
			".eslintrc.js",
			".eslintrc.cjs",
			".eslintrc.json",
			"package.json",
			".git"
		),
		settings = {
			workingDirectory = { mode = "auto" },
			format = true,
		},
	})
end
-- Autoformat via prettierd oder prettier, falls verfügbar
local function format_with_prettier(bufnr)
	local has_prettierd = vim.fn.executable("prettierd") == 1
	local cmd = has_prettierd and "prettierd" or (vim.fn.executable("prettier") == 1 and "prettier" or nil)
	if not cmd then
		return
	end
	local ft = vim.bo[bufnr].filetype
	local exts = {
		typescript = "ts",
		typescriptreact = "tsx",
		javascript = "js",
		javascriptreact = "jsx",
		json = "json",
		css = "css",
		html = "html",
		markdown = "md",
		yaml = "yaml",
	}
	local ext = exts[ft]
	if not ext then
		return
	end
	-- nutze stdin, respektiere Projektconfigs
	vim.cmd("silent write")
	vim.fn.jobstart({ cmd, "--stdin-filepath", vim.api.nvim_buf_get_name(bufnr) }, { stdin = "pipe" })
end

vim.api.nvim_create_autocmd("BufWritePre", {
	pattern = { "*.ts", "*.tsx", "*.js", "*.jsx", "*.json", "*.css", "*.html", "*.md", "*.yaml", "*.yml" },
	callback = function(args)
		format_with_prettier(args.buf)
	end,
})

-- Nix
lspconfig.nixd.setup({
	capabilities = capabilities,
	on_attach = on_attach,
})

-- ======================================
-- Java LSP (Eclipse JDT LS)
-- ======================================
local home = os.getenv("HOME")
local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ":p:h:t")

local workspace_dir = home .. "/.local/share/eclipse/" .. project_name
os.execute("mkdir -p " .. workspace_dir)

lspconfig.jdtls.setup({
	capabilities = capabilities,
	on_attach = on_attach,
	cmd = { "jdtls-lombok" },
	root_dir = lspconfig.util.root_pattern("pom.xml", "build.gradle", ".git"),
	settings = {
		java = {
			signatureHelp = { enabled = true },
			contentProvider = { preferred = "fernflower" },
			completion = {
				favoriteStaticMembers = {
					"org.junit.Assert.*",
					"org.junit.Assume.*",
					"org.junit.jupiter.api.Assertions.*",
					"org.junit.jupiter.api.Assumptions.*",
					"org.mockito.Mockito.*",
				},
			},
			sources = {
				organizeImports = { starThreshold = 9999, staticStarThreshold = 9999 },
			},
			configuration = {
				updateBuildConfiguration = "automatic",
				runtimes = {
					{
						name = "JavaSE-21",
						path = vim.fn.expand("~/.nix-profile/lib/openjdk"),
					},
				},
			},
			project = {
				-- Unterdrückt "Import project?"-Hinweise
				importHint = false,
			},
			import = {
				-- automatisch Maven/Gradle importieren
				maven = { enabled = true },
				gradle = { enabled = true, wrapper = { enabled = true } },
				-- früheres Setting in VSCode: project.importOnFirstTimeStartup=automatic
			},
			eclipse = { downloadSources = true },
			maven = { downloadSources = true },

			-- Weniger “interaktive” Features = weniger Lärm:
			implementationsCodeLens = { enabled = true },
			referencesCodeLens = { enabled = true },
			references = { includeDecompiledSources = true },
			format = { enabled = true }, -- falls Formatter-Prompts nerven
			signatureHelp = { enabled = true },
			completion = {
				guessMethodArguments = false,
				favoriteStaticMembers = {
					"org.junit.Assert.*",
					"org.junit.jupiter.api.Assertions.*",
					"org.mockito.Mockito.*",
				},
			},
			contentProvider = { preferred = "fernflower" }, -- Decompiler
		},
	},
	init_options = {
		workspace = workspace_dir,
		workspaceFolders = { vim.uri_from_fname(vim.fn.getcwd()) },
	},
})
-- vim.keymap.set("n", "<leader>gi", function() vim.lsp.buf.implementation() end, { desc = "Java: Go to implementation" })
-- vim.keymap.set("n", "<leader>gr", function() vim.lsp.buf.references() end, { desc = "Java: Find references" })
-- vim.keymap.set("n", "<leader>go", function() vim.lsp.buf.document_symbol() end, { desc = "Java: Outline" })

-- Format on save (Beispiel: Lua via stylua, Shell via shfmt)
local format_augroup = vim.api.nvim_create_augroup("FormatOnSave", {})
vim.api.nvim_create_autocmd("BufWritePre", {
	group = format_augroup,
	pattern = { "*.lua" },
	callback = function()
		vim.cmd("silent! !stylua %")
	end,
})
vim.api.nvim_create_autocmd("BufWritePre", {
	group = format_augroup,
	pattern = { "*.sh" },
	callback = function()
		vim.cmd("silent! !shfmt -w %")
	end,
})

-- FeMaco: Edit fenced code blocks with LSP
require("femaco").setup({
	-- optional: window opts etc.
})

-- Keymap: Cursor auf Codefence/inline-Block stellen und dann:
vim.keymap.set("n", "<leader>fe", function()
	require("femaco.edit").edit_code_block()
end, { desc = "Edit fenced codeblock (LSP)" })
