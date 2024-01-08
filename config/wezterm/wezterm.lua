local wezterm = require("wezterm")
local act = wezterm.action

local config = {}

if wezterm.config_builder then
	config = wezterm.config_builder()
end

config.color_scheme = "catppuccin-mocha"
config.window_padding = { left = 0, right = 0, top = 0, bottom = 0 }
config.hide_tab_bar_if_only_one_tab = true
config.font = wezterm.font("JetBrainsMono NF")

config.keys = {
	{
		key = "h",
		mods = "CTRL|ALT",
		action = act.ActivatePaneDirection("Left"),
	},
	{
		key = "l",
		mods = "CTRL|ALT",
		action = act.ActivatePaneDirection("Right"),
	},
	{
		key = "j",
		mods = "CTRL|ALT",
		action = act.ActivatePaneDirection("Down"),
	},
	{
		key = "k",
		mods = "CTRL|ALT",
		action = act.ActivatePaneDirection("Up"),
	},
	{
		key = "v",
		mods = "CTRL|ALT",
		action = act.SplitHorizontal({ domain = "CurrentPaneDomain" }),
	},
	{
		key = "s",
		mods = "CTRL|ALT",
		action = act.SplitVertical({ domain = "CurrentPaneDomain" }),
	},
	{
		key = "t",
		mods = "CTRL|ALT",
		action = act.SpawnTab("CurrentPaneDomain"),
	},
	{
		key = "1",
		mods = "CTRL|ALT",
		action = act.ActivateTab(0),
	},
	{
		key = "2",
		mods = "CTRL|ALT",
		action = act.ActivateTab(1),
	},
	{
		key = "3",
		mods = "CTRL|ALT",
		action = act.ActivateTab(2),
	},
	{
		key = "4",
		mods = "CTRL|ALT",
		action = act.ActivateTab(3),
	},
	{
		key = "5",
		mods = "CTRL|ALT",
		action = act.ActivateTab(4),
	},
	{
		key = "6",
		mods = "CTRL|ALT",
		action = act.ActivateTab(5),
	},
	{
		key = "7",
		mods = "CTRL|ALT",
		action = act.ActivateTab(6),
	},
	{
		key = "8",
		mods = "CTRL|ALT",
		action = act.ActivateTab(7),
	},
	{
		key = "9",
		mods = "CTRL|ALT",
		action = act.ActivateTab(-1),
	},
	{
		key = "[",
		mods = "CTRL|ALT",
		action = act.ActivateTabRelative(-1),
	},
	{
		key = "]",
		mods = "CTRL|ALT",
		action = act.ActivateTabRelative(1),
	},
}

if wezterm.target_triple == "x86_64-pc-windows-msvc" then
	config.default_prog = { "C:\\msys64\\usr\\bin\\fish.exe", "--login", "-i" }
	config.set_environment_variables = {
		["CHERE_INVOKING"] = "1",
		["MSYSTEM"] = "UCRT64",
		["MSYS2_PATH_TYPE"] = "inherit",
	}
end

return config
