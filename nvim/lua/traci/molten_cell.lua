-- Run ```python ... ``` fenced code blocks with molten-nvim.
-- Designed for jupytext-converted .ipynb (markdown) buffers.
local M = {}

local FENCE = "^%s*```"
local FENCE_OPEN = FENCE .. "%s*[Pp]ython" -- only python cells; skip ```bash etc.

-- Scan the whole buffer and return a list of { s, e } body ranges (1-based,
-- inclusive) for every ```python block. Empty blocks are skipped.
local function find_all_blocks(lines)
  local blocks = {}
  local i = 1
  while i <= #lines do
    if lines[i]:match(FENCE_OPEN) then
      local open = i
      local close = nil
      for j = open + 1, #lines do
        if lines[j]:match(FENCE) then
          close = j
          break
        end
      end
      if not close then break end -- unterminated fence; stop
      if close - open >= 2 then
        table.insert(blocks, { s = open + 1, e = close - 1 })
      end
      i = close + 1
    else
      i = i + 1
    end
  end
  return blocks
end

-- The block whose body contains cursor_line, or nil.
local function block_at(blocks, cursor_line)
  for _, b in ipairs(blocks) do
    if cursor_line >= b.s and cursor_line <= b.e then
      return b
    end
  end
  return nil
end

function M.run()
  local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
  local cursor = vim.api.nvim_win_get_cursor(0)[1]
  local b = block_at(find_all_blocks(lines), cursor)
  if not b then
    vim.notify("No ```python cell under cursor", vim.log.levels.WARN)
    return
  end
  vim.fn.MoltenEvaluateRange(b.s, b.e)
end

-- Evaluate every ```python cell, top to bottom. Molten queues each to the
-- kernel; the kernel runs them sequentially in submission order.
function M.run_all()
  local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
  local blocks = find_all_blocks(lines)
  if #blocks == 0 then
    vim.notify("No ```python cells found in buffer", vim.log.levels.WARN)
    return
  end
  for _, b in ipairs(blocks) do
    vim.fn.MoltenEvaluateRange(b.s, b.e)
  end
  vim.notify(("Molten: queued %d cells"):format(#blocks), vim.log.levels.INFO)
end

-- True if the current buffer has at least one running molten kernel.
local function has_kernel()
  local ok, kernels = pcall(vim.fn.MoltenRunningKernels, true)
  return ok and type(kernels) == "table" and #kernels > 0
end

-- Persist outputs to the .ipynb. jupytext rewrites the file on :w (code only),
-- so we export molten's in-memory outputs into it afterwards. `!` overwrites
-- without the "cells changed" prompt.
function M.export()
  if has_kernel() then
    pcall(vim.cmd, "MoltenExportOutput!")
  end
end

-- Load saved outputs from the .ipynb. Requires a kernel, so this is wired to
-- fire on MoltenInitPost (after :MoltenInit attaches a kernel).
function M.import()
  pcall(vim.cmd, "MoltenImportOutput")
end

-- Wire auto-export-on-save and auto-import-on-init for .ipynb buffers.
-- Idempotent: safe to call once at startup.
function M.setup_persistence()
  local grp = vim.api.nvim_create_augroup("MoltenIpynbPersistence", { clear = true })

  -- export outputs after the .ipynb is written (jupytext writes first)
  vim.api.nvim_create_autocmd("BufWritePost", {
    group = grp,
    pattern = "*.ipynb",
    callback = function() M.export() end,
  })

  -- import outputs once a kernel attaches, if the buffer is an .ipynb
  vim.api.nvim_create_autocmd("User", {
    group = grp,
    pattern = "MoltenInitPost",
    callback = function()
      if vim.fn.expand("%:e") == "ipynb" then
        M.import()
      end
    end,
  })
end

return M
