-- root/lua/live-messages.lua
local M = {}

local installed = false
local buf, win
local orig_notify = vim.notify
local orig_err = vim.api.nvim_err_writeln

local function ensure_window()
  if buf and vim.api.nvim_buf_is_valid(buf) and win and vim.api.nvim_win_is_valid(win) then
    return
  end

  buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_name(buf, "[LiveMessages]")
  vim.bo[buf].buftype = "nofile"
  vim.bo[buf].bufhidden = "hide"
  vim.bo[buf].swapfile = false
  vim.bo[buf].modifiable = false
  vim.bo[buf].wrapmargin = 2
  -- vim.bo[buf].wrap = true
  -- vim.bo[buf].wrapmargin = 2

  vim.cmd("vsplit")
  win = vim.api.nvim_get_current_win()
  vim.api.nvim_win_set_buf(win, buf)
  vim.api.nvim_win_set_width(win, 35)
  vim.wo[win].wrap = true
end

local function append(tag, msg)
  ensure_window()
  local text = tostring(msg or ""):gsub("\r\n", "\n")

  -- local ts = os.date("%H:%M:%S") .. " "
  -- local prefix = ts .. tag .. " "

  local prefix = tag .. " "

  local lines = {}
  local first = true
  for line in (text .. "\n"):gmatch("(.-)\n") do
    if first then
      table.insert(lines, prefix .. line)
      first = false
    else
      table.insert(lines, string.rep(" ", #prefix) .. line)
    end
  end

  if #lines > 0 and lines[#lines]:match("^%s*$") then
    table.remove(lines, #lines)
  end
  if #lines == 0 then return end

  vim.bo[buf].modifiable = true
  vim.api.nvim_buf_set_lines(buf, -1, -1, false, lines)
  vim.bo[buf].modifiable = false

  if win and vim.api.nvim_win_is_valid(win) then
    local last = vim.api.nvim_buf_line_count(buf)
    pcall(vim.api.nvim_win_set_cursor, win, { last, 0 })
  end
end

function M.open()
  ensure_window()
end

function M.is_enabled()
  return installed
end

function M.is_open()
  return buf and vim.api.nvim_buf_is_valid(buf)
end

function M.close()
  if M.is_open() then
    pcall(vim.api.nvim_buf_delete, buf, { force = true })
  else
    M.uninstall()
  end
end

function M.toggle()
  if M.is_enabled() then
    M.close()
    vim.notify("LiveNotify: OFF", vim.log.levels.INFO)
  else
    M.install()
    M.open()
    vim.notify("LiveNotify: ON", vim.log.levels.INFO)
  end
end

function M.install()
  if installed then return end
  installed = true

  vim.notify = function(msg, level, opts)
    append("[notify]", msg)
    return orig_notify(msg, level, opts)
  end

  -- optional: jei nori matyti hit-enter klaidas irgi
  vim.api.nvim_err_writeln = function(msg)
    append("[error]", msg)
    return orig_err(msg)
  end

  append("[live]", "installed")
end

return M
