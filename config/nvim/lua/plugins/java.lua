-- jdtls tweaks for browsing Java projects without a build system:
-- 1. Fall back to git root (or file dir) when no Maven/Gradle files present
-- 2. Suppress diagnostics — useful when reading code you don't own
return {
  {
    "mfussenegger/nvim-jdtls",
    opts = function(_, opts)
      -- Root detection: build system > git root > file directory
      opts.root_dir = function(fname)
        return require("lspconfig.util").root_pattern(
          "pom.xml", "build.gradle", "build.gradle.kts", ".git"
        )(fname) or vim.fn.fnamemodify(fname, ":h")
      end

      -- Silence diagnostics — keep hover/go-to-def without error noise
      opts.handlers = vim.tbl_extend("force", opts.handlers or {}, {
        ["textDocument/publishDiagnostics"] = function() end,
      })
    end,
  },
}
