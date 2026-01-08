local waywall = require("waywall")
local helpers = require("waywall.helpers")
local util = require("util")

local colors = {
    soft_pink = "#f28dff",
    pink = "#f681f6",
    magenta = "#9e4cc8",
    purple = "#6e1c98",

    base_f3_text = "#dddddd",
    base_entities = "#e446c4",
    base_prepare = "#464c46",
    base_unspecified = "#46ce66",
    base_unspecified_percent = "#45cb65",
    base_blockentities = "#ec6e4e",
    base_blockentities_percent = "#e96d4d",
    base_destroyProgress = "#cc6c46"
}

local ninjabrain_bot_path = util.config_folder("Ninjabrain-Bot-1.5.1.jar")
local measuring_overlay_path = util.config_folder("overlay.png")
local circle_overlay_path = util.config_folder("circle_ovl.png")
local oneshot_overlay_path = util.config_folder("oneshot.png")
local browser_source_path = util.config_folder("waywall-browser-source")
local ninjabrain_bot_overlay_path = util.config_folder("ninjabrain-bot-overlay")

local thin_key = "*-Caps_Lock"
local wide_key = "*-Tab"
local tall_key = "*-J"
local show_ninbot_key = "*-apostrophe"
local toggle_fullscreen_key = "Shift-O"
local startup_programs_key = "Shift-P"
local enable_oneshot_overlay_key = "H"

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
local e_counter_src = {
    x = 13,
    y = 37,
    w = 37,
    h = 9
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
local thin_e_counter = {
    x = 1490,
    y = 400,
    size = 7
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
    circle_overlay = util.make_image(circle_overlay_path, {
        dst = {
            x = 0,
            y = 0,
            w = 2560,
            h = 1600
        }
    }),
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
    memory_left = {
        value = "Mem: N/A",
        x = 350,
        y = 200,
        outline_size = 2,
        size = 6,
        color = colors.soft_pink,
        outline_color = colors.magenta
    },
    preemptive = {
        value = "51 pure\n61 chest front\n67 chest back",
        x = 1490,
        y = 1250,
        outline_size = 2,
        size = 6,
        color = colors.soft_pink,
        outline_color = colors.magenta
    }
}

local texts = {
    memory_left = util.make_outlined_text(text_configs.memory_left),
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
    }
}

local config = {
    input = {
        layout = "us",
        repeat_rate = 40,
        repeat_delay = 300,

        sensitivity = 1.0,
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
    shaders = {
        rainbow_timer = {
            vertex = util.read_file("timer.vert"),
            fragment = util.read_file("timer.frag")
        }
    }
}

local is_ninb_running = function()
    return util.exec_unsafe("pgrep -f 'Ninjabrain.*jar'") ~= nil
end

local get_memory_left = function()
    return util.exec_unsafe("free -m | awk '/^Mem:/ {print $7}'")
end

local exec_ninb = function()
    waywall.exec("java -Dawt.useSystemAAFontSettings=on -Dsun.java2d.uiScale=2.0 -jar " .. ninjabrain_bot_path)
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
    e_counter = util.make_mirror({
        src = e_counter_src,
        dst = {
            x = thin_e_counter.x,
            y = thin_e_counter.y,
            w = 37 * thin_e_counter.size,
            h = 9 * thin_e_counter.size
        },
        color_key = {
            input = colors.base_f3_text,
            output = colors.magenta
        }
    }),
    e_counter_shadow = util.make_mirror({
        src = e_counter_src,
        dst = {
            x = thin_e_counter.x + 4,
            y = thin_e_counter.y + 4,
            w = 37 * thin_e_counter.size,
            h = 9 * thin_e_counter.size
        },
        color_key = {
            input = colors.base_f3_text,
            output = colors.pink
        }
    }),
    thin_pie_entities = util.make_mirror({
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
    }),
    thin_pie_unspecified = util.make_mirror({
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
    }),
    thin_pie_blockentities = util.make_mirror({
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
    }),
    thin_pie_destroyProgress = util.make_mirror({
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
    }),
    thin_pie_prepare = util.make_mirror({
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
    }),
    thin_percent_blockentities = util.make_mirror({
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
    }),
    thin_percent_unspecified = util.make_mirror({
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
    }),
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
    rainbow_timer = util.make_mirror({
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
        shader = "rainbow_timer"
    })
}

local last_mirror_state = {
    eye = false,
    f3 = false,
    tall = false,
    thin = false,
    wide = false
}

local oneshot_overlay_state = {
    enabled = false
}

local show_mirrors = function(eye, f3, tall, thin, wide)
    text_configs.memory_left.value = "Mem: " .. get_memory_left() .. " MB"

    last_mirror_state = {
        eye = eye,
        f3 = f3,
        tall = tall,
        thin = thin,
        wide = wide
    }
    mirrors.rainbow_timer(not (eye or f3 or tall or thin or wide))
    mirrors.eye_measure(eye)

    images.measuring_overlay(eye)
    images.oneshot_overlay(oneshot_overlay_state.enabled and not (eye or f3 or tall or thin or wide))

    texts.memory_left(thin or wide)

    mirrors.e_counter(f3)
    mirrors.e_counter_shadow(f3)

    texts.preemptive(thin)
    images.circle_overlay(thin)
    mirrors.thin_pie_entities(thin)
    mirrors.thin_pie_unspecified(thin)
    mirrors.thin_pie_blockentities(thin)
    mirrors.thin_pie_destroyProgress(thin)
    mirrors.thin_pie_prepare(thin)

    mirrors.thin_percent_blockentities(thin)
    mirrors.thin_percent_unspecified(thin)
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
    thin = make_res(350, 1600, thin_enable, res_disable),
    tall = make_res(384, 16384, tall_enable, res_disable),
    wide = make_res(2560, 400, wide_enable, res_disable)
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
    end,

    [show_ninbot_key] = function()
        helpers.toggle_floating()
    end,

    [toggle_fullscreen_key] = waywall.toggle_fullscreen,

    [startup_programs_key] = function()
        if not is_ninb_running() then
            exec_ninb()
            exec_browser_sources()
        end
    end,

    [enable_oneshot_overlay_key] = function()
        oneshot_overlay_state.enabled = not oneshot_overlay_state.enabled
        show_mirrors(last_mirror_state.eye, last_mirror_state.f3, last_mirror_state.tall, last_mirror_state.thin,
            last_mirror_state.wide)
    end

}

return config
