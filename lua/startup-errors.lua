-- root/lua/startup-errors.lua
local M = {}

M.items = {}
M._orig_notify = nil
M._orig_err = nil
M._orig_echo = nil
M._shown = false

local function parse_file_line(msg)
  if type(msg) ~= "string" then return nil, nil end

  -- /Users/rob/.config/nvim/lua/plugins/telescope.lua:31: ...
  local file, lnum = msg:match("([%a]?[:/\\][^%s]+%.%w+):(%d+):")
  if file and lnum then return file, tonumber(lnum) end

  -- fallback: kažkas.lua:31:
  file, lnum = msg:match("([^%s]+%.%w+):(%d+):")
  if file and lnum then return file, tonumber(lnum) end

  return nil, nil
end

local function push_if_error(msg)
  local file, lnum = parse_file_line(msg)
  if file and lnum then
    table.insert(M.items, { msg = msg, file = file, lnum = lnum })
    return true
  end
  return false
end

local function goto_source(item)
  if not item or not item.file or not item.lnum then return end

  local dir = vim.fn.fnamemodify(item.file, ":h")
  if dir and dir ~= "" then
    pcall(vim.cmd, "lcd " .. vim.fn.fnameescape(dir))
  end

  vim.cmd("edit " .. vim.fn.fnameescape(item.file))
  vim.api.nvim_win_set_cursor(0, { math.max(1, item.lnum), 0 })
end

function M.show_picker()
  if M._shown or #M.items == 0 then return end
  M._shown = true

  local choices = {}
  for i, it in ipairs(M.items) do
    choices[i] = string.format("%d) %s", i, vim.fn.fnamemodify(it.file, ":~") .. ":" .. it.lnum)
  end

  vim.ui.select(choices, { prompt = "Startup error(s) found — go to source?" }, function(choice)
    if not choice then return end
    local idx = tonumber(choice:match("^(%d+)"))
    goto_source(M.items[idx])
  end)
end

function M.install()
  if M._orig_notify then return end

  -- 1) hook vim.notify
  M._orig_notify = vim.notify
  vim.notify = function(msg, level, opts)
    if level == vim.log.levels.ERROR then
      push_if_error(msg)
    end
    return M._orig_notify(msg, level, opts)
  end

  -- 2) hook nvim_err_writeln (hit-enter tipo klaidoms)
  M._orig_err = vim.api.nvim_err_writeln
  vim.api.nvim_err_writeln = function(msg)
    push_if_error(msg)
    return M._orig_err(msg)
  end

  -- 3) hook nvim_echo (kai kurie pluginai meta klaidas per echo)
  M._orig_echo = vim.api.nvim_echo
  vim.api.nvim_echo = function(chunks, history, opts)
    -- chunks = { {text, hl}, ... }
    local combined = {}
    if type(chunks) == "table" then
      for _, c in ipairs(chunks) do
        if type(c) == "table" and type(c[1]) == "string" then
          table.insert(combined, c[1])
        end
      end
    end
    if #combined > 0 then
      push_if_error(table.concat(combined, ""))
    end
    return M._orig_echo(chunks, history, opts)
  end

  -- Parodom pasirinkimą kai UI jau yra (kad nebūtų per anksti)
  vim.api.nvim_create_autocmd("UIEnter", {
    once = true,
    callback = function()
      -- defer, kad “hit-enter” ir pluginų init spėtų susigeneruoti klaidas
      vim.defer_fn(function()
        if #M.items > 0 then
          M.show_picker()
        end
      end, 50)
    end,
  })
end

return M
