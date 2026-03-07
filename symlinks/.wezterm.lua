local wezterm = require 'wezterm'
local mux = wezterm.mux
local config = wezterm.config_builder()

config.initial_cols = 120
config.initial_rows = 28
config.font = wezterm.font_with_fallback({
  "JetBrains Mono",
  "Symbols Nerd Font Mono",
  "Noto Color Emoji",
})
config.font_size = 18.0
config.line_height = 1.1
config.color_scheme = 'Catppuccin Mocha'  -- Choose one color scheme
config.window_decorations = "RESIZE"
config.hide_tab_bar_if_only_one_tab = true
config.use_fancy_tab_bar = true
config.tab_bar_at_bottom = true
config.window_padding = {
  left = 10,
  right = 10,
  top = 8,
  bottom = 8,
}

-- maximize all displayed windows on launch of wezterm
wezterm.on("gui-attached", function(domain)
	local workspace = mux.get_active_workspace()
	for _, window in ipairs(mux.all_windows()) do
		if window:get_workspace() == workspace then
			window:gui_window():maximize()
		end
	end
end)

-- Disable quit confirmation
config.window_close_confirmation = 'NeverPrompt'

-- Default (generic) bindings
local pane_resize_keys = {
  left  = "LeftArrow",
  right = "RightArrow",
}

-- Local override by trying to load wezterm_local.lua
-- local ok, local_overrides = pcall(require, "wezterm_local")
-- if ok and type(local_overrides) == "table" and type(local_overrides.pane_resize_keys) == "table" then
--   pane_resize_keys.left  = local_overrides.pane_resize_keys.left  or pane_resize_keys.left
--   pane_resize_keys.right = local_overrides.pane_resize_keys.right or pane_resize_keys.right
-- end

-- Key bindings for splitting panes
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
    key = pane_resize_keys.left,
    mods = 'SHIFT|OPT',
    action = wezterm.action.AdjustPaneSize { 'Left', 5 },
  },
  {
    key = pane_resize_keys.right,
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

-- Dim the inactive pane so that we can detect the active pane
config.inactive_pane_hsb = {
  saturation = 0.5,
  brightness = 0.3,
}

function basename(s)
	return string.gsub(s, "(.*[/\\])(.*)", "%2")
end

-- Set the tab title to currently running foreground process name
wezterm.on("format-tab-title", function(tab, tabs, panes, config, hover, max_width)
	local pane = tab.active_pane
	local tab_title = tab.tab_title
	local title
	if tab_title and #tab_title > 0 then
		title = tab_title .. " " .. (tab.tab_index + 1)
	else
		title = basename(pane.foreground_process_name) .. " " .. (tab.tab_index + 1)
	end
	local color = "#0f1419"
	if tab.is_active then
		color = "darkblue"
	end
	return {
		{ Background = { Color = color } },
		{ Text = " " .. title .. " " },
	}
end)


return config
