local group = vim.api.nvim_create_augroup("dev-environment-dotnet", { clear = true })

vim.api.nvim_create_autocmd("LspAttach", {
  group = group,
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if not client or client.name ~= "roslyn_ls" then
      return
    end

    local opts = { buffer = args.buf }

    vim.keymap.set("n", "gd", vim.lsp.buf.definition, vim.tbl_extend("force", opts, { desc = "Go to definition" }))
    vim.keymap.set("n", "gr", vim.lsp.buf.references, vim.tbl_extend("force", opts, { desc = "List references" }))
    vim.keymap.set("n", "K", vim.lsp.buf.hover, vim.tbl_extend("force", opts, { desc = "Hover" }))
    vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, vim.tbl_extend("force", opts, { desc = "Rename symbol" }))
    vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, vim.tbl_extend("force", opts, { desc = "Code action" }))
  end,
})

return {
  {
    "williamboman/mason.nvim",
    cmd = {
      "Mason",
      "MasonInstall",
      "MasonLog",
      "MasonUninstall",
      "MasonUpdate",
    },
    opts = {
      registries = {
        "github:mason-org/mason-registry",
        "github:Crashdummyy/mason-registry",
      },
    },
  },
  {
    "neovim/nvim-lspconfig",
    ft = "cs",
    config = function()
      if vim.fn.executable("roslyn") ~= 1 then
        vim.schedule(function()
          vim.notify("Roslyn language server is not installed yet. Run :MasonInstall roslyn, then restart Neovim.", vim.log.levels.WARN)
        end)
        return
      end

      local uv = vim.uv or vim.loop

      vim.lsp.config("roslyn_ls", {
        cmd = {
          "roslyn",
          "--logLevel",
          "Information",
          "--extensionLogDirectory",
          vim.fs.joinpath(uv.os_tmpdir(), "roslyn_ls", "logs"),
          "--stdio",
        },
        settings = {
          ["csharp|background_analysis"] = {
            dotnet_analyzer_diagnostics_scope = "openFiles",
            dotnet_compiler_diagnostics_scope = "openFiles",
          },
          ["csharp|code_lens"] = {
            dotnet_enable_references_code_lens = true,
          },
          ["csharp|completion"] = {
            dotnet_show_completion_items_from_unimported_namespaces = true,
          },
        },
      })

      vim.lsp.enable("roslyn_ls")
    end,
  },
}
