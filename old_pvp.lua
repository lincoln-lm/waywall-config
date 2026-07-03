local waywall = require("waywall")
local helpers = require("waywall.helpers")
local util = require("util")

local base_sens = 5.7

local config = {
    input = {
        layout = "us",
        repeat_rate = 40,
        repeat_delay = 300,

        sensitivity = base_sens,
        confine_pointer = false,
        remaps = {
            ["MB4"] = "HOME",
            ["MB5"] = "END",
            ["LEFTALT"] = "TAB"
        }
    },
    theme = {
        background_png = util.config_folder("castorice.png"),
        cursor_theme = "Castorice",
        ninb_anchor = "topright"
    },
    experimental = {
        debug = false,
        jit = false,
        tearing = false,
        scene_add_text = true
    },
    shaders = {}
}

config.actions = {}

return config
