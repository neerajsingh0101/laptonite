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
    -- Resize panes with Ctrl+Opt+Cmd+Arrow; avoids macOS Ctrl+Opt+Left/Right interception.
    {
      key = 'LeftArrow',
      mods = 'CTRL|OPT|SUPER',
      action = move_vertical_divider('Left', 5),
    },
    {
      key = 'DownArrow',
      mods = 'CTRL|OPT|SUPER',
      action = wezterm.action.AdjustPaneSize { 'Down', 5 },
    },
    {
      key = 'UpArrow',
      mods = 'CTRL|OPT|SUPER',
      action = wezterm.action.AdjustPaneSize { 'Up', 5 },
    },
    {
      key = 'RightArrow',
      mods = 'CTRL|OPT|SUPER',
      action = move_vertical_divider('Right', 5),
    },
    {
      key = 'phys:LeftArrow',
      mods = 'CTRL|OPT|SUPER',
      action = move_vertical_divider('Left', 5),
    },
    {
      key = 'phys:DownArrow',
      mods = 'CTRL|OPT|SUPER',
      action = wezterm.action.AdjustPaneSize { 'Down', 5 },
    },
    {
      key = 'phys:UpArrow',
      mods = 'CTRL|OPT|SUPER',
      action = wezterm.action.AdjustPaneSize { 'Up', 5 },
    },
    {
      key = 'phys:RightArrow',
      mods = 'CTRL|OPT|SUPER',
      action = move_vertical_divider('Right', 5),
    },
    -- Kinesis Advantage emits comma/period for Cmd+Ctrl+Opt+Left/Right.
    {
      key = ',',
      mods = 'CTRL|OPT|SUPER',
      action = move_vertical_divider('Left', 5),
    },
    {
      key = '.',
      mods = 'CTRL|OPT|SUPER',
      action = move_vertical_divider('Right', 5),
    },
    -- Resize panes
    {
      key = 'LeftArrow',
      mods = 'SUPER|OPT',
      action = wezterm.action.AdjustPaneSize { 'Left', 5 },
    },
    {
      key = 'DownArrow',
      mods = 'SUPER|OPT',
      action = wezterm.action.AdjustPaneSize { 'Down', 5 },
    },
    {
      key = 'UpArrow',
      mods = 'SUPER|OPT',
      action = wezterm.action.AdjustPaneSize { 'Up', 5 },
    },
    {
      key = 'RightArrow',
      mods = 'SUPER|OPT',
      action = wezterm.action.AdjustPaneSize { 'Right', 5 },
    },
    -- Clear terminal (Cmd+K)
    {
      key = 'k',
      mods = 'SUPER',
      action = wezterm.action.ClearScrollback 'ScrollbackAndViewport',
    },
    -- 2x2 grid and run commands in each pane (Ctrl+Opt+4)
    {
      key = '4',
      mods = 'CTRL|OPT',
      action = wezterm.action_callback(function(window, pane)
        local act = wezterm.action

        -- 1) Top-left (current)
        pane:send_text("start_server\n")

        -- 2) Split right -> top-right becomes active
        window:perform_action(act.SplitHorizontal { domain = 'CurrentPaneDomain' }, pane)
        local top_right = window:active_pane()
        top_right:send_text("start_ui\n")

        -- 3) Go back to left pane, split down -> bottom-left becomes active
        window:perform_action(act.ActivatePaneDirection 'Left', top_right)
        local top_left = window:active_pane()
        window:perform_action(act.SplitVertical { domain = 'CurrentPaneDomain' }, top_left)
        local bottom_left = window:active_pane()
        bottom_left:send_text("start_bg\n")

        -- 4) Go to top-right pane, split down -> bottom-right becomes active
        window:perform_action(act.ActivatePaneDirection 'Right', bottom_left)
        local top_right_again = window:active_pane()
        window:perform_action(act.SplitVertical { domain = 'CurrentPaneDomain' }, top_right_again)
        local bottom_right = window:active_pane()
        bottom_right:send_text("tunnel2\n")

        -- Optional: focus top-left at the end
        window:perform_action(act.ActivatePaneDirection 'Left', bottom_right)
        window:perform_action(act.ActivatePaneDirection 'Up', window:active_pane())
      end),
    },
    -- Kinesis Advantage sends comma/period for Ctrl+Opt+Left/Right.
    -- Keep this after the tab-switch bindings so the Kinesis arrow chord resizes panes.
    {
      key = '.',
      mods = 'CTRL|OPT',
      action = move_vertical_divider('Right', 5),
    },
    {
      key = ',',
      mods = 'CTRL|OPT',
      action = move_vertical_divider('Left', 5),
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
