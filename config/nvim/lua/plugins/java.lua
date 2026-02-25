-- jdtls tweaks for browsing Java projects without a build system.
-- Fall back to git root (or file dir) when no Maven/Gradle files present.
-- Diagnostic suppression is handled in config/autocmds.lua via LspAttach.
return {
  {
    "mfussenegger/nvim-jdtls",
    opts = function(_, opts)
      opts.root_dir = function(fname)
        return require("lspconfig.util").root_pattern(
          "pom.xml", "build.gradle", "build.gradle.kts", ".git"
        )(fname) or vim.fn.fnamemodify(fname, ":h")
      end
    end,
  },
}
