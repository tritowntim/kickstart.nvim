return {
  'nvimtools/none-ls.nvim',
  dependencies = { 'nvim-lua/plenary.nvim' },
  event = { 'BufReadPre', 'BufNewFile' },
  config = function()
    local null_ls = require 'null-ls'

    null_ls.setup {
      sources = {
        null_ls.builtins.formatting.stylua,
        null_ls.builtins.formatting.elm_format.with {
          command = 'npx',
          args = { 'elm-format', '--stdin' },
        },
      },
      on_attach = function(client, bufnr)
        if client.supports_method 'textDocument/formatting' then
          vim.api.nvim_create_autocmd('BufWritePre', {
            group = vim.api.nvim_create_augroup('Format', { clear = true }),
            buffer = bufnr,
            callback = function()
              vim.lsp.buf.format { bufnr = bufnr, timeout_ms = 1000 }
            end,
          })
        end
      end,
    }
  end,
}
