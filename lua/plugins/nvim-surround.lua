return {
  "kylechui/nvim-surround",
  event = { "BufReadPre", "BufNewFile" },
  config = function()
    require("nvim-surround").setup({
      keymaps = {
        insert = false,
        insert_line = false,
        normal = "ys",           -- ys{motion}{char} - add surround
        normal_cur = "yss",      -- yss{char} - surround line
        normal_line = "yS",      -- yS{motion}{char} - surround line-wise
        normal_cur_line = "ySS", -- ySS{char} - surround whole line
        visual = "S",            -- S{char} - surround selection
        visual_line = "gS",      -- gS{char} - surround linewise
        delete = "ds",           -- ds{char} - delete surround
        change = "cs",           -- cs{old}{new} - change surround
        change_line = "cS",      -- cS{old}{new} - change surround linewise
      },

      surrounds = {
        -- Markdown code blocks
        ["c"] = {
          add = { "```", "```" },
          find = "```.-```",
          delete = "^(...)().-()(...)",
        },
        -- Markdown bold
        ["*"] = {
          add = { "**", "**" },
          find = "%*%*.-%*%*",
          delete = "^(..)().-()(..)",
        },
        -- Markdown italic
        ["_"] = {
          add = { "_", "_" },
          find = "_.-_",
          delete = "^(.)().-(.)()$",
        },
      },
    })
  end,
}

--[[
🎯 HOW TO USE NVIM-SURROUND:

1. ADD SURROUND:
   • Position cursor on word: hello
   • Type: ysiw"
   • Result: "hello"

   • Position cursor anywhere on line: local x = 42
   • Type: yss)
   • Result: (local x = 42)

2. DELETE SURROUND:
   • Position cursor inside: "hello"
   • Type: ds"
   • Result: hello

3. CHANGE SURROUND:
   • Position cursor inside: "hello"
   • Type: cs"'
   • Result: 'hello'

   • Position cursor inside: [hello]
   • Type: cs])
   • Result: (hello)

4. VISUAL MODE:
   • Select text: hello world
   • Type: S"
   • Result: "hello world"

5. ADVANCED EXAMPLES:
   • ysiw}     → {word}
   • ysiwt     → <tag>word</tag> (prompts for tag)
   • yss<p>    → <p>entire line</p>
   • cs"<em>   → "text" becomes <em>text</em>

6. REMEMBER:
   • Open brackets: ( [ { add spaces → ( text )
   • Close brackets: ) ] } no spaces → (text)
   • Most punctuation works: " ' ` ~ + = - *

7. CUSTOM ONES (from config):
   • ysiw*     → **word** (markdown bold)
   • ysiw_     → _word_ (markdown italic)
   • ysiwc     → ```word``` (code block)
--]]
