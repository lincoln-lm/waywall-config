local waywall = require("waywall")
local helpers = require("waywall.helpers")
local util = require("util")
local ninbot = require("ninbot")
local standard_settings = require("standard_settings")

local colors = {
    soft_pink = "#f28dff",
    pink = "#f681f6",
    magenta = "#9e4cc8",
    purple = "#6e1c98",
    white = "#ffffff",
    black = "#000000",

    base_f3_text = "#dddddd",
    base_entities = "#e446c4",
    base_prepare = "#464c46",
    base_unspecified = "#46ce66",

    base_unspecified_percent = "#45cb65",
    base_blockentities = "#ec6e4e",
    base_blockentities_percent = "#e96d4d",
    base_destroyProgress = "#cc6c46"
}

local all_portals = false

local ninjabrain_bot_path = util.config_folder("Ninjabrain-Bot-1.5.1.jar")
local ninjabrain_bot_prefs_path = os.getenv("HOME") .. "/.java/.userPrefs/ninjabrainbot/prefs.xml"
local standard_settings_path = os.getenv("HOME") ..
                                   "/.local/share/PrismLauncher/instances/1.16.1/minecraft/config/mcsr/standardsettings.json"
local measuring_overlay_path = util.config_folder("overlay.png")
local circle_overlay_path = util.config_folder("circle_ovl.png")
local oneshot_overlay_path = util.config_folder("oneshot.png")
local browser_source_path = util.config_folder("waywall-browser-source")
local ninjabrain_bot_overlay_path = util.config_folder("ninjabrain-bot-overlay")
local all_portals_overlay_path = util.config_folder("all-portals-overlay")
local canvas_overlay_path = util.config_folder("waywall-canvas")

local thin_key = "*-Caps_Lock"
local wide_key = "*-Tab"
local tall_key = "*-J"
local show_ninbot_key = "*-apostrophe"
local startup_programs_key = "Shift-P"
local enable_oneshot_overlay_key = "H"

local ninbot_prefs = {
    custom_themes = {{
        name = "Castorice",

        title_bar = "#220248",
        header_background = "#460374",
        result_background = "#721EAA",
        throws_background = "#460374",
        dividers = "#220248",
        header_dividers = "#220248",
        text = "#E2E0F6",
        title_text = "#E2E0F6",
        throws_text = "#E2E0F6",
        divine_text = "#E2E0F6",
        version_text = "#E2E0F6",
        header_text = "#E2E0F6",
        subpixel_increase = "#8FD485",
        subpixel_decrease = "#DD7E70",
        certainty_100 = "#9CCFD8",
        certainty_50 = "#F6C177",
        certainty_0 = "#EB6F92"
    }},
    angle_adjustment_display_type = "1",
    angle_adjustment_type = "1",
    auto_reset = "true",
    color_negative_coords = "true",
    default_boat_type = "2",
    direction_help_enabled = "true",
    enable_http_server = "true",
    hotkey_boat_code = "43",
    hotkey_boat_modifier = "0",
    hotkey_decrement_code = "57419",
    hotkey_decrement_modifier = "0",
    hotkey_increment_code = "57421",
    hotkey_increment_modifier = "0",
    hotkey_lock_code = "26",
    hotkey_lock_modifier = "0",
    hotkey_minimize_code = "42",
    hotkey_minimize_modifier = "0",
    hotkey_reset_code = "51",
    hotkey_reset_modifier = "0",
    hotkey_undo_code = "52",
    hotkey_undo_modifier = "0",
    language_v2 = "en-US",
    mismeasure_warning_enabled = "true",
    sensitivity = "0.02291165",
    settings_version = "2",
    show_angle_errors = "true",
    show_angle_updates = "true",
    sigma = "0.0229",
    sigma_boat = "7.0E-4",
    size = "0",
    theme = "-1",
    translucent = "false",
    use_precise_angle = "true",
    view = "1"
}

local settings = {
    [".apiVersion"] = "2.2+1.16-1.16.1",
    [".modVersion"] = "2.3+1.16-1.16.1",
    [".dataVersion"] = 0,
    ["fov"] = 110.0,
    ["realmsNotifications"] = true,
    ["fullscreenResolution"] = "null",
    ["biomeBlendRadius"] = 2.0,
    ["graphicsMode"] = 0,
    ["renderDistance"] = all_portals and 32.0 or 8.0,
    ["ao"] = 2,
    ["maxFps"] = 200.0,
    ["enableVsync"] = false,
    ["bobView"] = false,
    ["guiScale"] = 5,
    ["attackIndicator"] = 1,
    ["gamma"] = 5.0,
    ["renderClouds"] = 0,
    ["fullscreen"] = false,
    ["particles"] = 0,
    ["mipmapLevels"] = 4.0,
    ["entityShadows"] = true,
    ["entityDistanceScaling"] = all_portals and 5.0 or 0.5,
    ["entityCulling"] = false,
    ["modelPart_cape"] = true,
    ["modelPart_jacket"] = true,
    ["modelPart_left_sleeve"] = true,
    ["modelPart_right_sleeve"] = true,
    ["modelPart_left_pants_leg"] = true,
    ["modelPart_right_pants_leg"] = true,
    ["modelPart_hat"] = true,
    ["mainHand"] = 1,
    ["soundCategory_master"] = 0.61755955,
    ["soundCategory_music"] = 0.0,
    ["soundCategory_record"] = 1.0,
    ["soundCategory_weather"] = 1.0,
    ["soundCategory_block"] = 1.0,
    ["soundCategory_hostile"] = 0.45475027,
    ["soundCategory_neutral"] = 1.0,
    ["soundCategory_player"] = 1.0,
    ["soundCategory_ambient"] = 1.0,
    ["soundCategory_voice"] = 1.0,
    ["showSubtitles"] = true,
    ["language"] = "en_us",
    ["forceUnicodeFont"] = false,
    ["mouseSensitivity"] = 0.02291165,
    ["invertYMouse"] = false,
    ["mouseWheelSensitivity"] = 1.0,
    ["discrete_mouse_scroll"] = false,
    ["touchscreen"] = false,
    ["rawMouseInput"] = false,
    ["autoJump"] = false,
    ["key_key.jump"] = "key.keyboard.space",
    ["key_key.sneak"] = "key.keyboard.left.shift",
    ["key_key.sprint"] = "key.keyboard.semicolon",
    ["key_key.left"] = "key.keyboard.a",
    ["key_key.right"] = "key.keyboard.d",
    ["key_key.back"] = "key.keyboard.s",
    ["key_key.forward"] = "key.keyboard.w",
    ["key_key.attack"] = "key.mouse.left",
    ["key_key.pickItem"] = "key.mouse.middle",
    ["key_key.use"] = "key.mouse.right",
    ["key_key.drop"] = "key.keyboard.o",
    ["key_key.hotbar.1"] = "key.keyboard.end",
    ["key_key.hotbar.2"] = "key.keyboard.2",
    ["key_key.hotbar.3"] = "key.keyboard.3",
    ["key_key.hotbar.4"] = "key.keyboard.4",
    ["key_key.hotbar.5"] = "key.keyboard.r",
    ["key_key.hotbar.6"] = "key.keyboard.c",
    ["key_key.hotbar.7"] = "key.keyboard.x",
    ["key_key.hotbar.8"] = "key.keyboard.z",
    ["key_key.hotbar.9"] = "key.keyboard.home",
    ["key_key.inventory"] = "key.keyboard.e",
    ["key_key.swapOffhand"] = "key.keyboard.g",
    ["key_key.loadToolbarActivator"] = "key.keyboard.left.bracket",
    ["key_key.saveToolbarActivator"] = "key.keyboard.unknown",
    ["key_key.playerlist"] = "key.keyboard.tab",
    ["key_key.chat"] = "key.keyboard.t",
    ["key_key.command"] = "key.keyboard.slash",
    ["key_key.advancements"] = "key.keyboard.l",
    ["key_key.spectatorOutlines"] = "key.keyboard.unknown",
    ["key_key.screenshot"] = "key.keyboard.f2",
    ["key_key.smoothCamera"] = "key.keyboard.unknown",
    ["key_key.fullscreen"] = "key.keyboard.f11",
    ["key_key.togglePerspective"] = "key.keyboard.f",
    ["key_Create New World"] = "key.keyboard.f6",
    ["key_speedrunigt.controls.start_timer"] = "key.keyboard.u",
    ["key_speedrunigt.controls.stop_timer"] = "key.keyboard.i",
    ["chatVisibility"] = 0,
    ["chatColors"] = true,
    ["chatLinks"] = true,
    ["chatLinksPrompt"] = true,
    ["chatOpacity"] = 1.0,
    ["textBackgroundOpacity"] = 0.5,
    ["chatScale"] = 1.0,
    ["chatLineSpacing"] = 0.0,
    ["chatWidth"] = 1.0,
    ["chatHeightFocused"] = 1.0,
    ["chatHeightUnfocused"] = 0.44366195797920227,
    ["narrator"] = 0,
    ["autoSuggestions"] = true,
    ["reducedDebugInfo"] = false,
    ["backgroundForChatOnly"] = 1,
    ["chatDelay"] = 0.0,
    ["toggleCrouch"] = 0,
    ["toggleSprint"] = 1,
    ["pauseOnLostFocus"] = true,
    ["advancedItemTooltips"] = false,
    ["hitboxes"] = true,
    ["chunkborders"] = true,
    ["pieDirectory"] = all_portals and "root.tick.level.entities.blockEntities" or "root.gameRenderer.level.entities",
    ["perspective"] = {
        ["enabled"] = false,
        ["value"] = 0
    },
    ["f1"] = {
        ["enabled"] = false,
        ["value"] = false
    },
    ["sneaking"] = {
        ["enabled"] = false,
        ["value"] = false
    },
    ["sprinting"] = true,
    ["fovOnWorldJoin"] = {
        ["enabled"] = false,
        ["value"] = 70.0
    },
    ["renderDistanceOnWorldJoin"] = {
        ["enabled"] = false,
        ["value"] = 12.0
    },
    ["entityDistanceScalingOnWorldJoin"] = {
        ["enabled"] = false,
        ["value"] = 1.0
    },
    ["guiScaleOnWorldJoin"] = {
        ["enabled"] = false,
        ["value"] = 0
    },
    ["toggleStandardSettings"] = true,
    ["toggleAll"] = true,
    ["autoF3Esc"] = true,
    ["firstAutoF3EscDelay"] = 22,
    ["triggerOnResize"] = false
}

local thin_res = {350, 1600}

-- 2560x1600
local pie_src = {
    x = 10,
    y = 1190,
    w = 340,
    h = 178
}
local percent_src = {
    x = 257,
    y = 1379,
    w = 33,
    h = 25
}
local block_coords_src = {
    x = 170,
    y = 505,
    w = 460,
    h = 38
}

local thin_pie = {
    x = 1490,
    y = 645,
    size = 1
}
local thin_percent = {
    x = 1490,
    y = 1050,
    size = 8
}
local block_coords = {
    x = 896,
    y = 835,
    size = 1.66666666
}

local images = {
    measuring_overlay = util.make_image(measuring_overlay_path, {
        dst = {
            x = 94,
            y = 470,
            w = 900,
            h = 500
        }
    }),
    circle_overlay = helpers.res_image(circle_overlay_path, {
        dst = {
            x = 0,
            y = 0,
            w = 2560,
            h = 1600
        }
    }, thin_res[1], thin_res[2]),
    oneshot_overlay = util.make_image(oneshot_overlay_path, {
        dst = {
            x = 0,
            y = 0,
            w = 2560,
            h = 1600
        }
    })
}

local text_configs = {
    preemptive = {
        value = "51 pure\n61 chest front\n67 chest back",
        -- value = "29 pure\n47 chest front\n61 chest back",
        x = 1490,
        y = 1250,
        outline_size = 2,
        size = 6,
        color = colors.soft_pink,
        outline_color = colors.magenta
    }
}

local texts = {
    preemptive = util.make_outlined_text(text_configs.preemptive)
}

local browser_sources = {
    spotify = {
        url = "https://lastfm.aiden.tv/linc_m",
        preload = util.config_folder("preload-spotify.js")
    },
    chat = {
        url = "https://chatis.is2511.com/v2/?channel=lincoln_lm&fade=30&size=2&font=0&fontCustom=Maple%20Mono&shadow=1",
        preload = util.config_folder("preload-chat.js"),
        width = 2560,
        height = 1600
    },
    ninjabrain_bot_overlay = {
        url = "https://lincoln-lm.github.io/ninjabrain-bot-overlay/",
        preload = util.config_folder("preload-ninjabrain-bot.js"),
        width = 2560,
        height = 1600,
        exec_before = function()
            waywall.exec('uv run --project ' .. ninjabrain_bot_overlay_path .. ' ' .. ninjabrain_bot_overlay_path ..
                             '/main.py')
        end
    },
    all_portals_overlay = {
        url = "http://localhost:5002/",
        preload = util.config_folder("preload-all-portals.js"),
        width = 2560,
        height = 1600,
        exec_before = function()
            waywall.exec('uv run --project ' .. all_portals_overlay_path .. ' ' .. all_portals_overlay_path ..
                             '/main.py')
        end
    },
    canvas_overlay = {
        url = "http://localhost:5003/",
        preload = util.config_folder("preload-canvas.js"),
        width = 2560,
        height = 1600,
        exec_before = function()
            waywall.exec('uv run --project ' .. canvas_overlay_path .. ' ' .. canvas_overlay_path .. '/main.py')
        end
    }
}

local base_sens = 5.7 * 1.6666666

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
            ["LEFTALT"] = "TAB",
            ["Q"] = "O",
            ["O"] = "Q"
        }
    },
    theme = {
        background_png = util.config_folder("castorice.png"),
        cursor_theme = "Castorice",
        cursor_icon = "default",
        ninb_anchor = "topright"
    },
    experimental = {
        debug = false,
        jit = false,
        tearing = false,
        scene_add_text = true
    },
    shaders = {
        timer_cosmetics = {
            vertex = util.read_file("timer_cosmetics.vert"),
            fragment = util.read_file("timer_cosmetics.frag")
        },
        cosmetics = {
            vertex = util.read_file("cosmetics.vert"),
            fragment = util.read_file("cosmetics.frag")
        },
        block_coords = {
            vertex = util.read_file("block_coords.vert"),
            fragment = string.gsub(util.read_file("block_coords.frag"), "ANCHOR", block_coords_src.x .. "," ..
                block_coords_src.y .. "," .. block_coords_src.w .. "," .. block_coords_src.h)
        }
    }
}

local is_ninb_running = function()
    return util.exec_unsafe("pgrep -f 'Ninjabrain.*jar'") ~= nil
end

local exec_ninb = function()
    waywall.exec("java -Dawt.useSystemAAFontSettings=on -Dsun.java2d.uiScale=1.0 -jar " .. ninjabrain_bot_path)
end

local exec_browser_sources = function()
    for _, source in pairs(browser_sources) do
        if source.exec_before then
            source.exec_before()
        end
        waywall.exec('npm start --prefix ' .. browser_source_path .. ' -- --url=' .. source.url .. ' --preload=' ..
                         source.preload .. (source.width and ' --width=' .. source.width or '') ..
                         (source.height and ' --height=' .. source.height or ''))
    end
end

local mirrors = {
    e_counter = util.shadowed_res_mirror({
        src = {
            x = 13,
            y = 37,
            w = 37,
            h = 9
        },
        dst = {
            x = 1490,
            y = 400,
            w = 37 * 7,
            h = 9 * 7
        }
    }, 4, colors.base_f3_text, colors.magenta, colors.pink, thin_res[1], thin_res[2]),
    block_coords = util.make_mirror({
        src = block_coords_src,
        dst = {
            x = block_coords.x,
            y = block_coords.y,
            w = block_coords_src.w * block_coords.size,
            h = block_coords_src.h * block_coords.size
        },
        shader = "block_coords"
    }),
    thin_pie_entities = helpers.res_mirror({
        src = pie_src,
        dst = {
            x = thin_pie.x,
            y = thin_pie.y,
            w = 420 * thin_pie.size,
            h = 423 * thin_pie.size
        },
        color_key = {
            input = colors.base_entities,
            output = colors.magenta
        }
    }, thin_res[1], thin_res[2]),
    thin_pie_unspecified = helpers.res_mirror({
        src = pie_src,
        dst = {
            x = thin_pie.x,
            y = thin_pie.y,
            w = 420 * thin_pie.size,
            h = 423 * thin_pie.size
        },
        color_key = {
            input = colors.base_unspecified,
            output = colors.magenta
        }
    }, thin_res[1], thin_res[2]),
    thin_pie_blockentities = helpers.res_mirror({
        src = pie_src,
        dst = {
            x = thin_pie.x,
            y = thin_pie.y,
            w = 420 * thin_pie.size,
            h = 423 * thin_pie.size
        },
        color_key = {
            input = colors.base_blockentities,
            output = colors.pink
        }
    }, thin_res[1], thin_res[2]),
    thin_pie_destroyProgress = helpers.res_mirror({
        src = pie_src,
        dst = {
            x = thin_pie.x,
            y = thin_pie.y,
            w = 420 * thin_pie.size,
            h = 423 * thin_pie.size
        },
        color_key = {
            input = colors.base_destroyProgress,
            output = colors.magenta
        }
    }, thin_res[1], thin_res[2]),
    thin_pie_prepare = helpers.res_mirror({
        src = pie_src,
        dst = {
            x = thin_pie.x,
            y = thin_pie.y,
            w = 420 * thin_pie.size,
            h = 423 * thin_pie.size
        },
        color_key = {
            input = colors.base_prepare,
            output = colors.magenta
        }
    }, thin_res[1], thin_res[2]),
    thin_percent_blockentities = helpers.res_mirror({
        src = percent_src,
        dst = {
            x = thin_percent.x,
            y = thin_percent.y,
            w = 33 * thin_percent.size,
            h = 25 * thin_percent.size
        },
        color_key = {
            input = colors.base_blockentities_percent,
            output = colors.pink
        }
    }, thin_res[1], thin_res[2]),
    thin_percent_unspecified = helpers.res_mirror({
        src = percent_src,
        dst = {
            x = thin_percent.x,
            y = thin_percent.y,
            w = 33 * thin_percent.size,
            h = 25 * thin_percent.size
        },
        color_key = {
            input = colors.base_unspecified_percent,
            output = colors.magenta
        }
    }, thin_res[1], thin_res[2]),
    eye_measure = util.make_mirror({
        src = {
            x = 162,
            y = 7902,
            w = 60,
            h = 580
        },
        dst = {
            x = 94,
            y = 470,
            w = 900,
            h = 500
        }
    }),
    timer_cosmetics = util.make_mirror({
        src = {
            x = 2560 - 392,
            y = 475,
            w = 352,
            h = 115
        },
        dst = {
            x = 2560 - 392,
            y = 475,
            w = 352,
            h = 115
        },
        shader = "timer_cosmetics"
    }),
    cosmetics = util.make_mirror({
        src = {
            x = 0,
            y = 0,
            w = 2560,
            h = 1600
        },
        dst = {
            x = 0,
            y = 0,
            w = 2560,
            h = 1600
        },
        shader = "cosmetics"
    })
}

local last_mirror_state = {
    eye = false,
    f3 = false,
    tall = false,
    thin = false,
    wide = false
}

local last_state = {
    screen = ""
}

local oneshot_overlay_state = {
    enabled = false
}

local show_mirrors = function(eye, f3, tall, thin, wide)
    if tall then
        waywall.set_sensitivity(0.5 * 1.66666)
    else
        waywall.set_sensitivity(base_sens)
    end

    last_mirror_state = {
        eye = eye,
        f3 = f3,
        tall = tall,
        thin = thin,
        wide = wide
    }
    mirrors.timer_cosmetics(not (eye or f3 or tall or thin or wide or last_state.screen == "wall"))
    mirrors.cosmetics(not (eye or f3 or tall or thin or wide))
    mirrors.eye_measure(eye)

    images.measuring_overlay(eye)
    images.oneshot_overlay(oneshot_overlay_state.enabled and not (eye or f3 or tall or thin or wide))

    mirrors.cosmetics(last_state.screen == "wall")
    mirrors.block_coords(true)

    texts.preemptive(thin)
end

local thin_enable = function()
    show_mirrors(false, true, false, true, false)
end

local tall_enable = function()
    show_mirrors(true, true, true, false, false)
end

local wide_enable = function()
    show_mirrors(false, false, false, false, true)
end

local res_disable = function()
    show_mirrors(false, false, false, false, false)
end

local make_res = function(width, height, enable, disable)
    return function()
        local active_width, active_height = waywall.active_res()

        if active_width == width and active_height == height then
            waywall.set_resolution(0, 0)
            disable()
        else
            waywall.set_resolution(width, height)
            enable()
        end
    end
end

local resolutions = {
    thin = make_res(thin_res[1], thin_res[2], thin_enable, res_disable),
    tall = make_res(384, 16384, tall_enable, res_disable),
    wide = make_res(2560, 400, wide_enable, res_disable)
}

waywall.listen("load", function()

end)

waywall.listen("state", function()
    local inworld = waywall.state().inworld;
    if inworld == "unpaused" then
        io.popen("curl -X POST http://localhost:5003/message -d \"message={\\\"cursorGrabbed\\\":true}\""):close()
    elseif inworld ~= "unpaused" then
        io.popen("curl -X POST http://localhost:5003/message -d \"message={\\\"cursorGrabbed\\\":false}\""):close()
    end
    if waywall.state().screen ~= last_state.screen then
        local from = last_state
        local to = waywall.state()
        last_state = to
        if from.screen ~= to.screen then
            show_mirrors(last_mirror_state.eye, last_mirror_state.f3, last_mirror_state.tall, last_mirror_state.thin,
                last_mirror_state.wide)
            thin_enable()
            res_disable()
        end
    end
end)

config.window = {
    fullscreen_width = 2560,
    fullscreen_height = 1600
}

config.actions = {
    [thin_key] = function()
        resolutions.thin()
    end,

    [wide_key] = function()
        resolutions.wide()
    end,

    [tall_key] = function()
        resolutions.tall()
        return false
    end,

    [show_ninbot_key] = function()
        helpers.toggle_floating()
    end,

    [startup_programs_key] = function()
        standard_settings.write_settings(settings, standard_settings_path)
        print("Saved settings to " .. standard_settings_path)
        ninbot.write_prefs(ninbot_prefs, ninjabrain_bot_prefs_path)
        if not is_ninb_running() then
            exec_ninb()
            waywall.sleep(2000)
            exec_browser_sources()
        end
    end,

    [enable_oneshot_overlay_key] = function()
        oneshot_overlay_state.enabled = not oneshot_overlay_state.enabled
        show_mirrors(last_mirror_state.eye, last_mirror_state.f3, last_mirror_state.tall, last_mirror_state.thin,
            last_mirror_state.wide)
        return false
    end,

    ["*-Ctrl-Shift-Left"] = function()
        io.popen("curl -X POST http://localhost:5002/message -d \"message={\\\"type\\\":\\\"prev\\\"}\""):close()
    end,

    ["*-Ctrl-Shift-Right"] = function()
        io.popen("curl -X POST http://localhost:5002/message -d \"message={\\\"type\\\":\\\"next\\\"}\""):close()
    end
}

require("ww_command_line.init").setup(config, {
    start_key = "Ctrl-Shift-T",
    enter_key = "Return",
    look = {
        x = 200,
        y = 200,
        size = 7,
        color = colors.soft_pink,
        completion_color = colors.magenta
    },
    add_inputs = {
        ["minus"] = "-",
        ["Shift-period"] = ">",
        ["Shift-comma"] = "<",
        ["period"] = "."
    },
    commands = {
        ["chat"] = function(args)
            io.popen(
                util.config_folder("send_twitch_message.sh") .. " " .. util.config_folder(".twitch_token") .. " '" ..
                    string.gsub(table.concat(args, " "), "'", "'\\''") .. "'"):close()
        end
    },
    arbitrary_command = function(key)
    end
})

return config
