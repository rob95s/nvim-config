local M = {}
local path = vim.fn.stdpath("data") .. "/colorscheme_picker.lua"

function M.load()
    local ok, data = pcall(dofile, path)
    if ok and data and data.current then
        return data.current
    end
end

function M.save(name)
    local f = io.open(path, "w")
    if not f then return end
    f:write("return { current = " .. string.format("%q", name) .. " }")
    f:close()
end

return M
