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

local mods = "CTRL|ALT"
if string.find(wezterm.target_triple, "apple") ~= nil then
	mods = "CTRL|CMD"
end

config.keys = {
	{
		key = "h",
		mods = mods,
		action = act.ActivatePaneDirection("Left"),
	},
	{
		key = "l",
		mods = mods,
		action = act.ActivatePaneDirection("Right"),
	},
	{
		key = "j",
		mods = mods,
		action = act.ActivatePaneDirection("Down"),
	},
	{
		key = "k",
		mods = mods,
		action = act.ActivatePaneDirection("Up"),
	},
	{
		key = "v",
		mods = mods,
		action = act.SplitHorizontal({ domain = "CurrentPaneDomain" }),
	},
	{
		key = "s",
		mods = mods,
		action = act.SplitVertical({ domain = "CurrentPaneDomain" }),
	},
	{
		key = "t",
		mods = mods,
		action = act.SpawnTab("CurrentPaneDomain"),
	},
	{
		key = "1",
		mods = mods,
		action = act.ActivateTab(0),
	},
	{
		key = "2",
		mods = mods,
		action = act.ActivateTab(1),
	},
	{
		key = "3",
		mods = mods,
		action = act.ActivateTab(2),
	},
	{
		key = "4",
		mods = mods,
		action = act.ActivateTab(3),
	},
	{
		key = "5",
		mods = mods,
		action = act.ActivateTab(4),
	},
	{
		key = "6",
		mods = mods,
		action = act.ActivateTab(5),
	},
	{
		key = "7",
		mods = mods,
		action = act.ActivateTab(6),
	},
	{
		key = "8",
		mods = mods,
		action = act.ActivateTab(7),
	},
	{
		key = "9",
		mods = mods,
		action = act.ActivateTab(-1),
	},
	{
		key = "[",
		mods = mods,
		action = act.ActivateTabRelative(-1),
	},
	{
		key = "]",
		mods = mods,
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
