local wezterm = require("wezterm")

local config = {}

if wezterm.config_builder then
    config = wezterm.config_builder()
end

config.color_scheme = "catppuccin-mocha"
config.window_padding = { left = 0, right = 0, top = 0, bottom = 0 }
config.hide_tab_bar_if_only_one_tab = true
config.font = wezterm.font("JetBrainsMonoNL NFP")

if wezterm.target_triple == "x86_64-pc-windows-msvc" then
    config.default_prog = { "C:\\msys64\\usr\\bin\\fish.exe", "--login", "-i" }
    config.set_environment_variables = {
        ["CHERE_INVOKING"] = "1",
        ["MSYSTEM"] = "UCRT64",
        ["MSYS2_PATH_TYPE"] = "inherit",
    }
end

return config
