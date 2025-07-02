return {
  "lewis6991/gitsigns.nvim",
  config = function()
    require("gitsigns").setup({
      signs = {
        add = { text = "▎" },
        change = { text = "▎" },
        delete = { text = "" },
        topdelete = { text = "" },
        changedelete = { text = "▎" },
        untracked = { text = "▎" },
      },

      current_line_blame = false,
      current_line_blame_opts = {
        virt_text = true,
        virt_text_pos = "eol",
        delay = 400,
        ignore_whitespace = false,
      },

      on_attach = function(bufnr)
        local gs = package.loaded.gitsigns
        local map = function(mode, key, cmd, desc)
          vim.keymap.set(mode, key, cmd, { buffer = bufnr, silent = true, desc = desc })
        end

        map("n", "]h", gs.next_hunk, "Next Git Hunk")
        map("n", "[h", gs.prev_hunk, "Previous Git Hunk")

        map("n", "gb", gs.toggle_current_line_blame, "Toggle Line Blame")
        map("n", "gB", gs.blame_line, "Blame Line (Full)")
        map("n", "gr", gs.reset_hunk, "Reset Hunk")
        map("n", "gR", gs.reset_buffer, "Reset Buffer")
        map("n", "gs", gs.stage_hunk, "Stage Hunk")
        map("n", "gS", gs.stage_buffer, "Stage Buffer")
        map("n", "gu", gs.undo_stage_hunk, "Undo Stage Hunk")
        map("n", "gd", gs.diffthis, "Diff This")

        map("v", "gs", function()
          gs.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
        end, "Stage Selection")
        map("v", "gr", function()
          gs.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
        end, "Reset Selection")
      end,
    })
  end,
}
