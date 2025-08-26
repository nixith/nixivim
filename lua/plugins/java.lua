local java_path = require("nixCats").cats.javaEnv.content.JDK
local jdt_path = require("nixCats").cats.javaEnv.content.JDT_PATH
local dbg_path = require("nixCats").cats.javaEnv.content.JAVA_DBG
local test_path = require("nixCats").cats.javaEnv.content.JAVA_TEST

local lz = require("lz.n")

lz.trigger_load("nvim-dap")

-- debugging support
local bundles = {
	vim.fn.glob(dbg_path .. "com.microsoft.java.debug.plugin-*.jar", true),
}

local java_test_bundles = vim.split(vim.fn.glob(test_path .. "*.jar", true), "\n")
local excluded = {
	"com.microsoft.java.test.runner-jar-with-dependencies.jar",
	"jacocoagent.jar",
}
for _, java_test_jar in ipairs(java_test_bundles) do
	local fname = vim.fn.fnamemodify(java_test_jar, ":t")
	if not vim.tbl_contains(excluded, fname) then
		table.insert(bundles, java_test_jar)
	end
end
local config = {}

-- testing support
config["init_options"] = {
	bundles = bundles,
	settings = {
		signatureHelp = { enabled = true },
	},
}

config["cmd"] = {}
vim.lsp.config("jdtls", {
	settings = config,
})
vim.lsp.enable("jdtls")

return {}
