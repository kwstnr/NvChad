require "nvchad.mappings"

-- add yours here

local map = vim.keymap.set

map("n", ";", ":", { desc = "CMD enter command mode" })
map("i", "jk", "<ESC>")
map("i", "<C-c>", "<ESC>")

-- map({ "n", "i", "v" }, "<C-s>", "<cmd> w <cr>")

-- Move between snake_case parts, skipping underscores like whitespace.
local function underscore_word_motion(motion)
  local keyword = vim.bo.iskeyword
  local count = vim.v.count1
  local ok, err = pcall(function()
    vim.opt_local.iskeyword:remove "_"
    for _ = 1, count do
      while true do
        local before = vim.api.nvim_win_get_cursor(0)
        vim.cmd("normal! " .. motion)
        local after = vim.api.nvim_win_get_cursor(0)
        if before[1] == after[1] and before[2] == after[2] then
          break
        end
        local char = vim.api.nvim_get_current_line():sub(after[2] + 1, after[2] + 1)
        if char ~= "_" then
          break
        end
      end
    end
  end)
  vim.bo.iskeyword = keyword
  if not ok then
    error(err)
  end
end

for _, motion in ipairs { "w", "b" } do
  vim.keymap.set({ "n", "x" }, motion, function()
    underscore_word_motion(motion)
  end, { desc = "Word " .. motion .. " across underscores" })
end
