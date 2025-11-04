-- Configure vim.ui.select to use a floating window
vim.ui.select = function(items, opts, on_choice)
  local choices = {}
  for i, item in ipairs(items) do
    table.insert(choices, string.format("%d: %s", i, opts.format_item and opts.format_item(item) or tostring(item)))
  end

  -- Calculate window size
  local width = 60
  local height = math.min(#choices + 2, 15)

  for _, choice in ipairs(choices) do
    width = math.max(width, #choice + 4)
  end
  width = math.min(width, vim.o.columns - 4)

  -- Create buffer
  local buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, choices)
  vim.api.nvim_buf_set_option(buf, 'modifiable', false)

  -- Calculate window position (center of screen)
  local win_opts = {
    relative = 'editor',
    width = width,
    height = height,
    col = math.floor((vim.o.columns - width) / 2),
    row = math.floor((vim.o.lines - height) / 2),
    style = 'minimal',
    border = 'rounded',
    title = opts.prompt or 'Select',
    title_pos = 'center',
  }

  local win = vim.api.nvim_open_win(buf, true, win_opts)

  -- Set highlighting
  vim.api.nvim_win_set_option(win, 'cursorline', true)

  -- Keymaps for selection
  local function close_and_select(idx)
    vim.api.nvim_win_close(win, true)
    if idx and idx > 0 and idx <= #items then
      on_choice(items[idx], idx)
    else
      on_choice(nil, nil)
    end
  end

  -- Select with Enter
  vim.keymap.set('n', '<CR>', function()
    local line = vim.api.nvim_win_get_cursor(win)[1]
    close_and_select(line)
  end, { buffer = buf, nowait = true })

  -- Cancel with ESC or q
  vim.keymap.set('n', '<Esc>', function() close_and_select(nil) end, { buffer = buf, nowait = true })
  vim.keymap.set('n', 'q', function() close_and_select(nil) end, { buffer = buf, nowait = true })

  -- Select with number keys
  for i = 1, math.min(#items, 9) do
    vim.keymap.set('n', tostring(i), function() close_and_select(i) end, { buffer = buf, nowait = true })
  end
end
