-- Set mapleader before loading Lazy.nvim
vim.g.mapleader = " "  -- Space as the leader key
vim.g.maplocalleader = " "  -- Optional, local leader key

-- Default border for all floating windows (LSP hover/signature help, cmp
-- docs, etc). Must be set before Lazy loads plugins: nvim-cmp reads this
-- once at cmp.setup() time (which runs eagerly during Lazy's setup call
-- below), not lazily on each popup, so setting it in settings.lua (loaded
-- after Lazy) would be too late.
vim.opt.winborder = "rounded"

-- Bootstrap Lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable", -- Latest stable release
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

-- Load Lazy.nvim and plugins
require("lazy").setup("johnnyfiive.plugins")

require("johnnyfiive")
-- Command to run 10 ms after startup, to correctly apply catppuccin colorscheme to the vim status bar below.
-- Look into the feline plugin for more statusbar customizations, especially with showing git branch
vim.cmd[[
  autocmd VimEnter * call timer_start(10, {-> execute("lua ColorMyPencils()")})
]]

vim.api.nvim_create_autocmd("VimEnter", {
  once = true,
  callback = function()
    math.randomseed(os.time())
    local fg_color = tostring(math.random(0, 12))
    local hi_setter = "hi AlphaFooter ctermfg="
    vim.cmd(hi_setter .. fg_color)
  end
})

-- No plugin here uses the Node.js remote-plugin host (confirmed: nothing
-- ships an rplugin manifest), and auto-detection can't find the "neovim"
-- npm package anyway since Volta manages global packages outside the
-- normal `npm root -g` lookup path. Disable rather than hardcode a
-- machine-specific path or leave a checkhealth warning for a feature
-- nothing here needs.
vim.g.loaded_node_provider = 0

-- No local Python provider is installed; let Neovim skip provider detection
-- instead of pointing at a venv path that doesn't exist on disk.
vim.g.loaded_python3_provider = 0

-- arduino-language-server (native vim.lsp.start/vim.lsp.config, not
-- lspconfig's old .setup() API -- removed on current nvim-lspconfig).
--
-- nvim-lspconfig ships a base lsp/arduino_language_server.lua (filetypes,
-- root_dir, and a capabilities tweak to disable semanticTokens for an
-- upstream arduino-language-server bug), but its bundled `cmd` is bare
-- {"arduino-language-server"} with no -cli/-cli-config/-fqbn -- that's the
-- crash fixed in an earlier commit, so the custom cmd is still needed.
--
-- vim.lsp.enable() isn't used here: the old on_new_config hook (recomputes
-- -fqbn from vim.g.arduino_board every time a client starts, so
-- :ArduinoChooseBoard takes effect without restarting Neovim) has no
-- equivalent in that model, which configures a server once rather than
-- per-client-start. Instead this starts the client manually via
-- vim.lsp.start() from a FileType autocmd, recomputing cmd fresh each
-- time -- vim.lsp.start() already dedups against a matching running
-- client, so this doesn't spawn duplicates on repeat buffer entry.
--
-- Unlike vim.lsp.enable()'s internal auto-attach machinery, vim.lsp.start()
-- does NOT resolve a function-type root_dir (nvim-lspconfig's bundled
-- config uses the async `fun(bufnr, on_dir)` form) -- it passes it through
-- as-is, which produces an empty rootUri and crashes the arduino-language-
-- server binary with a nil pointer panic. So root_dir is resolved by hand
-- here before starting the client.

-- Default board FQBN (Raspberry Pi Pico 2 W). Without -fqbn, arduino-cli
-- can't compile and the LSP client immediately exits with code 2.
local default_arduino_fqbn = "rp2040:rp2040:rpipico2w"

-- arduino-cli's config dir is ~/Library/Arduino15 on macOS, ~/.arduino15
-- on Linux (and %LOCALAPPDATA%\Arduino15 on Windows, not handled here).
local arduino_cli_config = vim.fn.expand(
  vim.uv.os_uname().sysname == "Darwin"
    and "~/Library/Arduino15/arduino-cli.yaml"
    or "~/.arduino15/arduino-cli.yaml"
)

local function arduino_cmd()
  local cmd = {
    "arduino-language-server",
    "-clangd", "clangd",
    "-cli", "arduino-cli",
    "-cli-config", arduino_cli_config,
    "-fqbn", default_arduino_fqbn,
  }

  -- Pick up a board chosen via vim-arduino's :ArduinoChooseBoard instead of
  -- the hardcoded default, ignoring vim-arduino's own generic uno fallback.
  local board = vim.g.arduino_board
  if board and board ~= "arduino:avr:uno" then
    for i, arg in ipairs(cmd) do
      if arg == "-fqbn" then
        cmd[i + 1] = board
        break
      end
    end
  end

  return cmd
end

vim.api.nvim_create_autocmd("FileType", {
  pattern = "arduino",
  group = vim.api.nvim_create_augroup("johnnyfiive-arduino-lsp", { clear = true }),
  callback = function(args)
    local base = vim.lsp.config.arduino_language_server or {}

    local function start(root_dir)
      local config = vim.tbl_deep_extend("force", base, {
        cmd = arduino_cmd(),
        root_dir = root_dir,
      })

      -- vim.lsp.start()'s default reuse check only matches on name+root_dir,
      -- not cmd -- it would otherwise silently keep reusing a client
      -- started with a stale -fqbn after :ArduinoChooseBoard. Stop any
      -- client whose cmd no longer matches (board changed) before starting
      -- a fresh one, so switching boards doesn't accumulate zombie clients.
      for _, client in ipairs(vim.lsp.get_clients({ name = "arduino_language_server" })) do
        if client.config.root_dir == root_dir and not vim.deep_equal(client.config.cmd, config.cmd) then
          client:stop()
        end
      end

      vim.lsp.start(config, {
        bufnr = args.buf,
        reuse_client = function(client, cfg)
          return client.name == cfg.name and vim.deep_equal(client.config.cmd, cfg.cmd)
        end,
      })
    end

    if type(base.root_dir) == "function" then
      base.root_dir(args.buf, start)
    else
      start(base.root_dir)
    end
  end,
})

-- util function to fade neovim logo on dashboard in and out
local M = {}
local timer = nil

function M.color_fade_start()
  if timer then
    return
  end

  timer = vim.loop.new_timer()
  timer:start(
    50,
    50,
    vim.schedule_wrap(function()
      sat = sat + inc
      if sat >= 40 or sat <= 0 then
        inc = -1 * inc
      end
      local blended = M.blend(color, background, sat / 40)
      vim.api.nvim_set_hl(0, '@alpha.title', { fg = blended })
    end)
  )
end

function M.color_fade_stop()
  if not timer then
    return
  end

  timer:stop()
  timer:close()
  timer = nil
end
return M
