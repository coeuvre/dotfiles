local wezterm = require("wezterm")

local config = {}

if wezterm.config_builder then
    config = wezterm.config_builder()
end

config.color_scheme = "catppuccin-mocha"
config.hide_tab_bar_if_only_one_tab = true
config.window_padding = { left = 0, right = 0, top = 0, bottom = 0 }
config.font = wezterm.font("JetBrainsMonoNL NFP")
config.use_dead_keys = false

local mods = "CTRL | ALT"
if string.find(wezterm.target_triple, "darwin") then
    mods = "CTRL | CMD"
end

config.keys = {
    {
        key = "x",
        mods = mods,
        action = wezterm.action.ActivateCopyMode,
    },
    {
        key = "z",
        mods = mods,
        action = wezterm.action.TogglePaneZoomState,
    },

    -- panes
    {
        key = "s",
        mods = mods,
        action = wezterm.action.SplitVertical({ domain = "CurrentPaneDomain" }),
    },
    {
        key = "v",
        mods = mods,
        action = wezterm.action.SplitHorizontal({ domain = "CurrentPaneDomain" }),
    },
    {
        key = "h",
        mods = mods,
        action = wezterm.action.ActivatePaneDirection("Left"),
    },
    {
        key = "j",
        mods = mods,
        action = wezterm.action.ActivatePaneDirection("Down"),
    },
    {
        key = "k",
        mods = mods,
        action = wezterm.action.ActivatePaneDirection("Up"),
    },
    {
        key = "l",
        mods = mods,
        action = wezterm.action.ActivatePaneDirection("Right"),
    },

    -- tabs
    {
        key = "t",
        mods = mods,
        action = wezterm.action.SpawnTab("CurrentPaneDomain"),
    },
    {
        key = "p",
        mods = mods,
        action = wezterm.action.ActivateTabRelative(-1),
    },
    {
        key = "n",
        mods = mods,
        action = wezterm.action.ActivateTabRelative(1),
    },

    {
        key = "[",
        mods = mods,
        action = wezterm.action.ActivateCopyMode,
    },
}

for i = 1, 9 do
    table.insert(config.keys, { key = tostring(i), mods = mods, action = wezterm.action.ActivateTab(i - 1) })
end

if wezterm.target_triple == "x86_64-pc-windows-msvc" then
    config.default_prog = { "C:\\msys64\\usr\\bin\\fish.exe", "--login", "-i" }
    config.set_environment_variables = {
        ["CHERE_INVOKING"] = "1",
        ["MSYSTEM"] = "UCRT64",
        ["MSYS2_PATH_TYPE"] = "inherit",
    }
end

return config
