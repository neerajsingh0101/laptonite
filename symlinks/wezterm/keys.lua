local wezterm = require 'wezterm'

local M = {}

local function ranges_overlap(a_start, a_size, b_start, b_size)
  return a_start < b_start + b_size and b_start < a_start + a_size
end

local function adjacent_pane(active, candidate, direction)
  if direction == 'Left' then
    return candidate.left + candidate.width == active.left
      and ranges_overlap(active.top, active.height, candidate.top, candidate.height)
  end

  if direction == 'Right' then
    return active.left + active.width == candidate.left
      and ranges_overlap(active.top, active.height, candidate.top, candidate.height)
  end

  return false
end

local function has_adjacent_pane(window, direction)
  local active
  local panes = window:active_tab():panes_with_info()

  for _, pane_info in ipairs(panes) do
    if pane_info.is_active then
      active = pane_info
      break
    end
  end

  if not active then
    return false
  end

  for _, pane_info in ipairs(panes) do
    if not pane_info.is_active and adjacent_pane(active, pane_info, direction) then
      return true
    end
  end

  return false
end

-- Neovim encodes Command-c as <D-c> when it receives this sequence. It is the
-- CSI-u form of "c with the super modifier": 99 is the codepoint for "c" and 9
-- is the modifier bitmask (1 + 8, where 8 means super).
local SUPER_C = '\x1b[99;9u'

local function is_neovim(pane)
  local process = pane:get_foreground_process_name()
  if not process then
    return false
  end

  local name = process:match '[^/\\]+$' or process
  return name == 'nvim' or name == 'vim'
end

local function move_vertical_divider(direction, amount)
  return wezterm.action_callback(function(window, pane)
    local act = wezterm.action

    if direction == 'Left' and has_adjacent_pane(window, 'Left') then
      window:perform_action(act.AdjustPaneSize { 'Left', amount }, pane)
      return
    end

    if direction == 'Left' and has_adjacent_pane(window, 'Right') then
      window:perform_action(act.ActivatePaneDirection 'Right', pane)
      local target = window:active_pane()
      window:perform_action(act.AdjustPaneSize { 'Left', amount }, target)
      window:perform_action(act.ActivatePaneDirection 'Left', target)
      return
    end

    if direction == 'Right' and has_adjacent_pane(window, 'Right') then
      window:perform_action(act.AdjustPaneSize { 'Right', amount }, pane)
      return
    end

    if direction == 'Right' and has_adjacent_pane(window, 'Left') then
      window:perform_action(act.ActivatePaneDirection 'Left', pane)
      local target = window:active_pane()
      window:perform_action(act.AdjustPaneSize { 'Right', amount }, target)
      window:perform_action(act.ActivatePaneDirection 'Right', target)
      return
    end

    window:perform_action(act.AdjustPaneSize { direction, amount }, pane)
  end)
end

function M.setup(config)
  config.keys = {
    -- Split (left/right)
    {
      key = '\\',
      mods = 'CTRL|OPT',
      action = wezterm.action.SplitHorizontal { domain = 'CurrentPaneDomain' },
    },
    -- Split (top/bottom)
    {
      key = '-',
      mods = 'CTRL|OPT',
      action = wezterm.action.SplitVertical { domain = 'CurrentPaneDomain' },
    },
    -- Navigate between panes with Ctrl+Opt keys
    {
      key = 'h',
      mods = 'CTRL|OPT',
      action = wezterm.action.ActivatePaneDirection 'Left',
    },
    {
      key = 'j',
      mods = 'CTRL|OPT',
      action = wezterm.action.ActivatePaneDirection 'Down',
    },
    {
      key = 'k',
      mods = 'CTRL|OPT',
      action = wezterm.action.ActivatePaneDirection 'Up',
    },
    {
      key = 'l',
      mods = 'CTRL|OPT',
      action = wezterm.action.ActivatePaneDirection 'Right',
    },
    -- Toggle pane zoom
    {
      key = 'm',
      mods = 'CTRL|OPT',
      action = wezterm.action.TogglePaneZoomState,
    },
    -- Close current pane (Ctrl+Opt+W)
    {
      key = 'w',
      mods = 'CTRL|OPT',
      action = wezterm.action.CloseCurrentPane { confirm = false },
    },
    -- Close current tab without confirmation (Ctrl+Opt+Cmd+W).
    --
    -- SUPER is WezTerm's name for the Command key, so 'CTRL|OPT|SUPER' is
    -- Ctrl+Opt+Cmd. Closing a tab takes the extra Command modifier because it
    -- discards every pane in the tab at once, not just the active one.
    {
      key = 'w',
      mods = 'CTRL|OPT|SUPER',
      action = wezterm.action.CloseCurrentTab { confirm = false },
    },
    -- Leave Command+W free for other uses.
    --
    -- WezTerm binds Command+W to "close tab, with a confirmation prompt" out of
    -- the box, so dropping our own Command+W binding would not free the chord --
    -- it would just fall back to that default. DisableDefaultAssignment is what
    -- actually unbinds it.
    {
      key = 'w',
      mods = 'SUPER',
      action = wezterm.action.DisableDefaultAssignment,
    },
    -- Navigate between tabs (8 = left, 9 = right)
    {
      key = '8',
      mods = 'CTRL|OPT',
      action = wezterm.action.ActivateTabRelative(-1),
    },
    {
      key = '9',
      mods = 'CTRL|OPT',
      action = wezterm.action.ActivateTabRelative(1),
    },
    -- Resize panes with Ctrl+Opt+Arrow
    {
      key = 'LeftArrow',
      mods = 'CTRL|OPT',
      action = move_vertical_divider('Left', 5),
    },
    {
      key = 'DownArrow',
      mods = 'CTRL|OPT',
      action = wezterm.action.AdjustPaneSize { 'Down', 5 },
    },
    {
      key = 'UpArrow',
      mods = 'CTRL|OPT',
      action = wezterm.action.AdjustPaneSize { 'Up', 5 },
    },
    {
      key = 'RightArrow',
      mods = 'CTRL|OPT',
      action = move_vertical_divider('Right', 5),
    },
    {
      key = 'phys:LeftArrow',
      mods = 'CTRL|OPT',
      action = move_vertical_divider('Left', 5),
    },
    {
      key = 'phys:DownArrow',
      mods = 'CTRL|OPT',
      action = wezterm.action.AdjustPaneSize { 'Down', 5 },
    },
    {
      key = 'phys:UpArrow',
      mods = 'CTRL|OPT',
      action = wezterm.action.AdjustPaneSize { 'Up', 5 },
    },
    {
      key = 'phys:RightArrow',
      mods = 'CTRL|OPT',
      action = move_vertical_divider('Right', 5),
    },
    -- Clear terminal (Cmd+K)
    {
      key = 'k',
      mods = 'SUPER',
      action = wezterm.action.ClearScrollback 'ScrollbackAndViewport',
    },
    -- Copy (Cmd+C)
    --
    -- Command-c normally copies whatever was selected in the terminal with the
    -- mouse. A Neovim visual selection is invisible to WezTerm, so pressing
    -- Command-c over one copied nothing at all.
    --
    -- So: if the terminal has a real selection, copy it as before. Otherwise, if
    -- Neovim is the foreground process, hand the key to Neovim as <D-c> and let
    -- it yank its own selection (see vim-keymaps.lua in the dotfiles repo).
    {
      key = 'c',
      mods = 'SUPER',
      action = wezterm.action_callback(function(window, pane)
        local selection = window:get_selection_text_for_pane(pane)

        if (not selection or selection == '') and is_neovim(pane) then
          window:perform_action(wezterm.action.SendString(SUPER_C), pane)
          return
        end

        window:perform_action(wezterm.action.CopyTo 'Clipboard', pane)
      end),
    },
    -- Rename tab
    {
      key = 'r',
      mods = 'CTRL|OPT',
      action = wezterm.action.PromptInputLine {
        description = 'Enter new tab name',
        action = wezterm.action_callback(function(window, pane, line)
          if line then
            window:active_tab():set_title(line)
          end
        end),
      },
    },
  }
end

return M
