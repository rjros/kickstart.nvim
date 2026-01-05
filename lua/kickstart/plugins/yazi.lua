return {
  'mikavilpas/yazi.nvim',
  event = 'VeryLazy',
  keys = {
    {
      '<leader>e',
      '<cmd>Yazi<cr>',
      desc = 'Open yazi file manager',
    },
    {
      '<leader>yw',
      '<cmd>Yazi cwd<cr>',
      desc = 'Open yazi in current working directory',
    },
  },
  opts = {
    open_for_directories = false,
    keymaps = {
      show_help = '<f1>',
    },
  },
}
