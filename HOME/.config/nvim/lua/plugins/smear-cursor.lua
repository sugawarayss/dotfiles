-- カーソル移動を目立たせるプラグイン
return {
  "sphamba/smear-cursor.nvim",
  event = { "BufReadPre" },
  opts = {
    smear_between_buffers = true,
    smear_between_neighbor_lines = true,
    scroll_buffer_space = true,
    legacy_computing_sumbols_support = false,
    smear_insert_mode = true,
  }
}
