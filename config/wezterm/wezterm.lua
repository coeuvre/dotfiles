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

config.leader = { key = "a", mods = "CTRL", timeout_milliseconds = 1000 }

local function is_vim(pane)
    -- this is set by the plugin, and unset on ExitPre in Neovim
    return pane:get_user_vars().IS_NVIM == "true"
end

local direction_keys = {
    h = "Left",
    j = "Down",
    k = "Up",
    l = "Right",
}

local function split_nav(key)
    return {
        key = key,
        mods = "CTRL",
        action = wezterm.action_callback(function(win, pane)
            if is_vim(pane) then
                -- pass the keys through to vim/nvim
                win:perform_action({
                    SendKey = { key = key, mods = "CTRL" },
                }, pane)
            else
                win:perform_action({ ActivatePaneDirection = direction_keys[key] }, pane)
            end
        end),
    }
end

config.keys = {
    {
        mods = "LEADER",
        key = "a",
        action = wezterm.action.SendKey({ key = "a", mods = "CTRL" }),
    },
    {
        mods = "LEADER|CTRL",
        key = "a",
        action = wezterm.action.SendKey({ key = "a", mods = "CTRL" }),
    },
    {
        mods = "LEADER",
        key = "l",
        action = wezterm.action.SendKey({ key = "l", mods = "CTRL" }),
    },
    {
        mods = "LEADER|CTRL",
        key = "l",
        action = wezterm.action.SendKey({ key = "l", mods = "CTRL" }),
    },

    -- splitting
    {
        mods = "LEADER",
        key = "s",
        action = wezterm.action.SplitVertical({ domain = "CurrentPaneDomain" }),
    },
    {
        mods = "LEADER|CTRL",
        key = "s",
        action = wezterm.action.SplitVertical({ domain = "CurrentPaneDomain" }),
    },
    {
        mods = "LEADER",
        key = "v",
        action = wezterm.action.SplitHorizontal({ domain = "CurrentPaneDomain" }),
    },
    {
        mods = "LEADER|CTRL",
        key = "v",
        action = wezterm.action.SplitHorizontal({ domain = "CurrentPaneDomain" }),
    },

    -- move between split panes
    split_nav("h"),
    split_nav("j"),
    split_nav("k"),
    split_nav("l"),

    {
        mods = "LEADER",
        key = "c",
        action = act.SpawnTab("CurrentPaneDomain"),
    },
    {
        mods = "LEADER|CTRL",
        key = "c",
        action = act.SpawnTab("CurrentPaneDomain"),
    },
    {
        mods = "LEADER",
        key = "p",
        action = act.ActivateTabRelative(-1),
    },
    {
        mods = "LEADER|CTRL",
        key = "p",
        action = act.ActivateTabRelative(-1),
    },
    {
        mods = "LEADER",
        key = "n",
        action = act.ActivateTabRelative(1),
    },
    {
        mods = "LEADER|CTRL",
        key = "n",
        action = act.ActivateTabRelative(1),
    },
    {
        mods = "LEADER",
        key = "1",
        action = act.ActivateTab(0),
    },
    {
        mods = "LEADER",
        key = "2",
        action = act.ActivateTab(1),
    },
    {
        mods = "LEADER",
        key = "3",
        action = act.ActivateTab(2),
    },
    {
        mods = "LEADER",
        key = "4",
        action = act.ActivateTab(3),
    },
    {
        mods = "LEADER",
        key = "5",
        action = act.ActivateTab(4),
    },
    {
        mods = "LEADER",
        key = "6",
        action = act.ActivateTab(5),
    },
    {
        mods = "LEADER",
        key = "7",
        action = act.ActivateTab(6),
    },
    {
        mods = "LEADER",
        key = "8",
        action = act.ActivateTab(7),
    },
    {
        mods = "LEADER",
        key = "9",
        action = act.ActivateTab(-1),
    },
    {
        mods = "LEADER",
        key = "/",
        action = act.Search({ CaseSensitiveString = "" }),
    },
    {
        mods = "LEADER",
        key = "[",
        action = wezterm.action.ActivateCopyMode,
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
