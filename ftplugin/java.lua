-- local java_path = require("nixCats").cats.javaEnv.content.JDK
-- local jdt_path = require("nixCats").cats.javaEnv.content.JDT_PATH
-- local dbg_path = require("nixCats").cats.javaEnv.content.JAVA_DBG
-- local test_path = require("nixCats").cats.javaEnv.content.JAVA_TEST
--
-- local bundles = {
-- 	vim.fn.glob(dbg_path .. "com.microsoft.java.debug.plugin-*.jar", true),
-- }
--
-- local java_test_bundles = vim.split(vim.fn.glob(test_path .. "*.jar", true), "\n")
-- local excluded = {
-- 	"com.microsoft.java.test.runner-jar-with-dependencies.jar",
-- 	"jacocoagent.jar",
-- }
-- for _, java_test_jar in ipairs(java_test_bundles) do
-- 	local fname = vim.fn.fnamemodify(java_test_jar, ":t")
-- 	if not vim.tbl_contains(excluded, fname) then
-- 		table.insert(bundles, java_test_jar)
-- 	end
-- end
-- --
-- local config = {
-- 	name = "jdtls",
--
-- 	-- `cmd` defines the executable to launch eclipse.jdt.ls.
-- 	-- `jdtls` must be available in $PATH and you must have Python3.9 for this to work.
-- 	--
-- 	-- As alternative you could also avoid the `jdtls` wrapper and launch
-- 	-- eclipse.jdt.ls via the `java` executable
-- 	-- See: https://github.com/eclipse/eclipse.jdt.ls#running-from-the-command-line
-- 	cmd = {
--
-- 		-- java
-- 		java_path, -- or '/path/to/java21_or_newer/bin/java'
-- 		-- depends on if `java` is in your $PATH env variable and if it points to the right version.
--
-- 		"-Declipse.application=org.eclipse.jdt.ls.core.id1",
-- 		"-Dosgi.bundles.defaultStartLevel=4",
-- 		"-Declipse.product=org.eclipse.jdt.ls.core.product",
-- 		"-Dlog.protocol=true",
-- 		"-Dlog.level=ALL",
-- 		"-Xmx2g",
-- 		"--add-modules=ALL-SYSTEM",
-- 		"--add-opens",
-- 		"java.base/java.util=ALL-UNNAMED",
-- 		"--add-opens",
-- 		"java.base/java.lang=ALL-UNNAMED",
--
-- 		-- jdtl jar
-- 		"-jar",
-- 		vim.fn.glob(jdt_path .. "plugins/org.eclipse.equinox.launcher_*.jar"),
--
-- 		-- config file
-- 		"-configuration",
-- 		vim.fn.glob(jdt_path .. "config_linux"),
-- 		-- ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^        ^^^^^^
-- 		-- Must point to the                      Change to one of `linux`, `win` or `mac`
-- 		-- eclipse.jdt.ls installation            Depending on your system.
--
-- 		-- See `data directory configuration` section in the README
-- 	},
--
-- 	-- `root_dir` must point to the root of your project.
-- 	-- See `:help vim.fs.root`
-- 	root_dir = vim.fs.root(0, { "gradlew", ".git", "mvnw", "Makefile" }),
--
-- 	-- Here you can configure eclipse.jdt.ls specific settings
-- 	-- See https://github.com/eclipse/eclipse.jdt.ls/wiki/Running-the-JAVA-LS-server-from-the-command-line#initialize-request
-- 	-- for a list of options
-- 	--
-- 	-- settings = {
-- 	-- 	java = {},
-- 	-- },
--
-- 	-- This sets the `initializationOptions` sent to the language server
-- 	-- If you plan on using additional eclipse.jdt.ls plugins like java-debug
-- 	-- you'll need to set the `bundles`
-- 	--
-- 	-- See https://codeberg.org/mfussenegger/nvim-jdtls#java-debug-installation
-- 	--
-- 	-- If you don't plan on any eclipse.jdt.ls plugins you can remove this
-- 	init_options = {
-- 		bundles = bundles,
-- 	},
-- }
--
-- -- This starts a new client & server,
-- -- or attaches to an existing client & server depending on the `root_dir`.
-- require("jdtls").start_or_attach(config)
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
