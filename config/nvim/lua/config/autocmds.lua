-- Autocmds are set automatically by LazyVim.
-- Add your custom autocmds here.

-- Suppress LSP diagnostics for Java — jdtls produces false positives
-- without a build system (Maven/Gradle), so silence them entirely.
vim.api.nvim_create_autocmd("LspAttach", {
  pattern = "*.java",
  callback = function(args)
    vim.diagnostic.disable(args.buf)
  end,
})
