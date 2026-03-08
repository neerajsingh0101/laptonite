local wezterm = require 'wezterm'
local mux = wezterm.mux
local keys = require 'keys'
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
config.color_scheme = 'Catppuccin Mocha'
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

-- Dim the inactive pane so that we can detect the active pane
config.inactive_pane_hsb = {
  saturation = 0.5,
  brightness = 0.3,
}

-- Set up key bindings
keys.setup(config)

function basename(s)
	return string.gsub(s, "(.*[/\\])(.*)", "%2")
end

-- Set the tab title to currently running foreground process name
-- If the current directory contains "neeto-", strip that prefix from the tab name
-- e.g. neeto-form-web becomes form-web
wezterm.on("format-tab-title", function(tab, tabs, panes, config, hover, max_width)
	local pane = tab.active_pane
	local tab_title = tab.tab_title
	local title
	if tab_title and #tab_title > 0 then
		title = tab_title .. " " .. (tab.tab_index + 1)
	else
		local cwd = pane.current_working_dir
		if cwd then
			local dir = basename(cwd.path or tostring(cwd))
			dir = dir:gsub("^neeto%-", "")
			title = dir .. " " .. (tab.tab_index + 1)
		else
			title = basename(pane.foreground_process_name) .. " " .. (tab.tab_index + 1)
		end
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
