vim.keymap.set("n", "<leader>ps", function()
    -- Start the server
    local file_path = vim.fn.expand("%:p") -- Get the full path of the current file
    if not file_path:match("%.puml$") then
        print("Error: Not a .puml file!")
        return
    end

    vim.fn.jobstart("node ~/.config/nvim/plantuml-previewer/server.js " .. file_path, { detach = true })
    print("PlantUML server started at http://localhost:3000")
end, { desc = "Start PlantUML Server" })

vim.keymap.set("n", "<leader>po", function()
    -- Open the browser
    vim.fn.jobstart("open http://localhost:3000") -- macOS; use xdg-open on Linux
end, { desc = "Open PlantUML Preview" })

vim.keymap.set("n", "<leader>pk", function()
    -- Kill the server (you may need to adapt this for your system)
    vim.fn.jobstart("pkill -f node", { detach = true })
    print("PlantUML server stopped.")
end, { desc = "Stop PlantUML Server" })
