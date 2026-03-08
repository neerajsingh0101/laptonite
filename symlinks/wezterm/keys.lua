local wezterm = require 'wezterm'

local M = {}

function M.setup(config)
  config.keys = {
    -- Split (left/right)
    {
      key = 'i',
      mods = 'SHIFT|OPT',
      action = wezterm.action.SplitHorizontal { domain = 'CurrentPaneDomain' },
    },
    -- Split (top/bottom)
    {
      key = 'u',
      mods = 'SHIFT|OPT',
      action = wezterm.action.SplitVertical { domain = 'CurrentPaneDomain' },
    },
    -- Navigate between panes with Shift+Opt keys
    {
      key = 'h',
      mods = 'SHIFT|OPT',
      action = wezterm.action.ActivatePaneDirection 'Left',
    },
    {
      key = 'l',
      mods = 'SHIFT|OPT',
      action = wezterm.action.ActivatePaneDirection 'Right',
    },
    {
      key = 'k',
      mods = 'SHIFT|OPT',
      action = wezterm.action.ActivatePaneDirection 'Up',
    },
    {
      key = 'j',
      mods = 'SHIFT|OPT',
      action = wezterm.action.ActivatePaneDirection 'Down',
    },
    -- Close current pane
    {
      key = 'w',
      mods = 'SHIFT|OPT',
      action = wezterm.action.CloseCurrentPane { confirm = true },
    },
    -- Resize panes
    {
      key = 'LeftArrow',
      mods = 'SHIFT|OPT',
      action = wezterm.action.AdjustPaneSize { 'Left', 5 },
    },
    {
      key = 'RightArrow',
      mods = 'SHIFT|OPT',
      action = wezterm.action.AdjustPaneSize { 'Right', 5 },
    },
    {
      key = 'UpArrow',
      mods = 'SHIFT|OPT',
      action = wezterm.action.AdjustPaneSize { 'Up', 5 },
    },
    {
      key = 'DownArrow',
      mods = 'SHIFT|OPT',
      action = wezterm.action.AdjustPaneSize { 'Down', 5 },
    },
    -- Clear terminal (Cmd+K)
    {
      key = 'k',
      mods = 'SUPER',
      action = wezterm.action.ClearScrollback 'ScrollbackAndViewport',
    },
    -- 2x2 grid and run commands in each pane (Shift+Opt+4)
    {
      key = '$',
      mods = 'SHIFT|OPT',
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
    -- Switch to tab on the right
    {
      key = '>',
      mods = 'SHIFT|OPT',
      action = wezterm.action.ActivateTabRelative(1),
    },
    -- Switch to tab on the left
    {
      key = '<',
      mods = 'SHIFT|OPT',
      action = wezterm.action.ActivateTabRelative(-1),
    },
    -- Rename tab
    {
      key = 'r',
      mods = 'SHIFT|OPT',
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
