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
config.tab_max_width = 30
config.tab_bar_at_bottom = true
config.window_frame = {
  font_size = config.font_size + 1,
}
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

-- Enable scrollbar for mouse scrolling
config.enable_scroll_bar = true

-- Dim the inactive pane so that we can detect the active pane
config.inactive_pane_hsb = {
  saturation = .2,
  brightness = 0.9,
}


-- Set up key bindings
keys.setup(config)

function basename(s)
	return string.gsub(s, "(.*[/\\])(.*)", "%2")
end

-- Read Claude Code status from /tmp/claude-wezterm-<pane_id>
-- Hook commands write "permission_prompt" or "done" to this file
local function read_claude_status(pane_id)
	local f = io.open("/tmp/claude-wezterm-" .. tostring(pane_id), "r")
	if f then
		local status = f:read("*l")
		f:close()
		return status
	end
	return nil
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
			if dir ~= "neeto-website" and dir ~= "bigbinary-website" then
				dir = dir:gsub("^neeto%-", "")
			end
			title = dir .. " " .. (tab.tab_index + 1)
		else
			title = basename(pane.foreground_process_name) .. " " .. (tab.tab_index + 1)
		end
	end

	-- Check Claude Code status for all panes in this tab
	local claude_status = nil
	for _, p in ipairs(tab.panes) do
		local status = read_claude_status(p.pane_id)
		if status == "permission_prompt" then
			claude_status = "permission_prompt"
			break
		elseif status == "done" then
			claude_status = claude_status or "done"
		end
	end

	-- Clear status when user switches to this tab
	if tab.is_active and (claude_status == "done" or claude_status == "permission_prompt") then
		for _, p in ipairs(tab.panes) do
			os.remove("/tmp/claude-wezterm-" .. tostring(p.pane_id))
		end
		claude_status = nil
	end

	local bg_color = "#0f1419"
	local fg_color = "white"
	if claude_status == "permission_prompt" then
		bg_color = "#cc3333"
	elseif claude_status == "done" then
		bg_color = "#33cc33"
		fg_color = "black"
	elseif tab.is_active then
		bg_color = "darkblue"
	end
	return {
		{ Background = { Color = bg_color } },
		{ Foreground = { Color = fg_color } },
		{ Text = " " .. title .. " " },
	}
end)

return config
