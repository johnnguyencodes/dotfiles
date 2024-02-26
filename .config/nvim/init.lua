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
