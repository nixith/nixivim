local java_path = require("nixCats").cats.javaEnv.content.JDK
local jdt_path = require("nixCats").cats.javaEnv.content.JDT_PATH
local dbg_path = require("nixCats").cats.javaEnv.content.JAVA_DBG
local test_path = require("nixCats").cats.javaEnv.content.JAVA_TEST

local bundles = {
	vim.fn.glob(dbg_path .. "com.microsoft.java.debug.plugin-*.jar", true),
}

vim.list_extend(bundles, vim.split(vim.fn.glob(test_path .. "*.jar", true), "\n"))

local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ":p:h:t")
local workspace_dir = vim.env.HOME .. "/.cache/jdtls/" .. project_name

local config = {
	-- The command that starts the language server
	-- See: https://github.com/eclipse/eclipse.jdt.ls#running-from-the-command-line
	cmd = {

		-- java
		java_path, -- or '/path/to/java21_or_newer/bin/java'
		-- depends on if `java` is in your $PATH env variable and if it points to the right version.

		"-Declipse.application=org.eclipse.jdt.ls.core.id1",
		"-Dosgi.bundles.defaultStartLevel=4",
		"-Declipse.product=org.eclipse.jdt.ls.core.product",
		"-Dlog.protocol=true",
		"-Dlog.level=ALL",
		"-Xmx2g",
		"--add-modules=ALL-SYSTEM",
		"--add-opens",
		"java.base/java.util=ALL-UNNAMED",
		"--add-opens",
		"java.base/java.lang=ALL-UNNAMED",

		-- jdtl jar
		"-jar",
		vim.fn.glob(jdt_path .. "plugins/org.eclipse.equinox.launcher_*.jar"),

		-- config gile
		"-configuration",
		vim.fn.glob(jdt_path .. "config_linux"),
		-- ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^        ^^^^^^
		-- Must point to the                      Change to one of `linux`, `win` or `mac`
		-- eclipse.jdt.ls installation            Depending on your system.

		-- See `data directory configuration` section in the README
		"-data",
		workspace_dir,
	},

	-- 💀
	-- This is the default if not provided, you can remove it. Or adjust as needed.
	-- One dedicated LSP server & client will be started per unique root_dir
	--
	-- vim.fs.root requires Neovim 0.10.
	-- If you're using an earlier version, use: require('jdtls.setup').find_root({'.git', 'mvnw', 'gradlew'}),
	root_dir = vim.fs.root(0, { ".git", "mvnw", "gradlew", ".idea", ".classpath" }),

	-- Here you can configure eclipse.jdt.ls specific settings
	-- See https://github.com/eclipse/eclipse.jdt.ls/wiki/Running-the-JAVA-LS-server-from-the-command-line#initialize-request
	-- for a list of options
	settings = {
		java = {},
	},

	-- Language server `initializationOptions`
	-- You need to extend the `bundles` with paths to jar files
	-- if you want to use additional eclipse.jdt.ls plugins.
	--
	-- See https://github.com/mfussenegger/nvim-jdtls#java-debug-installation
	--
	-- If you don't plan on using the debugger or other eclipse.jdt.ls plugins you can remove this
	init_options = {
		bundles = bundles,
	},
}
-- This starts a new client & server,
-- or attaches to an existing client & server depending on the `root_dir`.
require("jdtls").start_or_attach(config)
local map = function(keys, func, desc)
	vim.keymap.set("n", keys, func, { desc = desc })
end

local vmap = function(keys, func, desc)
	vim.keymap.set("v", keys, func, { desc = desc })
end
--TODO: fix keybinds
map("<A-o>", "<Cmd>lua require'jdtls'.organize_imports()<CR>", "Organize Imports")
map("crv", "<Cmd>lua require('jdtls').extract_variable()<CR>", "[c]ode [r]efactor [v]ariable")
vmap("crv", "<Esc><Cmd>lua require('jdtls').extract_variable(true)<CR>", "[c]ode [r]efactor [v]ariable")
map("crc", "<Cmd>lua require('jdtls').extract_constant()<CR>", "[c]ode [r]efactor [c]onstant")
vmap("crc", "<Esc><Cmd>lua require('jdtls').extract_constant(true)<CR>", "[c]ode [r]efactor [c]onstant")
vmap("crm", "<Esc><Cmd>lua require('jdtls').extract_method(true)<CR>", "[c]ode [r]efactor [m]ethod")
map("<leader>df", "<Cmd>lua require'jdtls'.test_class()<CR>", "[d]ebug [f]ile")
map("<leader>dn", "<Cmd>lua require'jdtls'.test_nearest_method()<CR>", "[d]ebug [n]earest method")
