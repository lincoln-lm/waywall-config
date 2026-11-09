local waywall = require("waywall")
local helpers = require("waywall.helpers")
M = {}

M.config_folder = function(relative_path)
    local home = os.getenv("HOME")
    return home .. "/.config/waywall/" .. relative_path
end

M.read_file = function(name)
    local file = io.open(M.config_folder(name), "r")
    local data = file:read("*a")
    file:close()
    return data
end

M.exec_unsafe = function(cmd)
    local handle = io.popen(cmd)
    local result = handle:read("*l")
    handle:close()
    return result
end

M.make_mirror = function(options)
    local this = nil

    return function(enable)
        if enable and not this then
            this = waywall.mirror(options)
        elseif this and not enable then
            this:close()
            this = nil
        end
    end
end

M.shadowed_res_mirror = function(options, dist, src_color, dst_color_1, dst_color_2, width, height)
    local first = helpers.res_mirror({
        src = options.src,
        dst = {
            x = options.dst.x + dist,
            y = options.dst.y + dist,
            w = options.dst.w,
            h = options.dst.h
        },
        color_key = {
            input = src_color,
            output = dst_color_2
        }
    }, width, height)
    local second = helpers.res_mirror({
        src = options.src,
        dst = {
            x = options.dst.x,
            y = options.dst.y,
            w = options.dst.w,
            h = options.dst.h
        },
        color_key = {
            input = src_color,
            output = dst_color_1
        }
    }, width, height)
    return {first, second}
end

M.make_text = function(options)
    local this = nil

    return function(enable)
        if enable and not this then
            this = waywall.text(options.value, options)
        elseif this and not enable then
            this:close()
            this = nil
        end
    end
end

M.make_outlined_text = function(options)
    local this = nil

    return function(enable)
        if enable and not this then
            this = {}
            local directions = {{-options.outline_size, 0}, {2 * options.outline_size, 0}, {0, -options.outline_size},
                                {0, 2 * options.outline_size}, {-options.outline_size, -options.outline_size},
                                {-options.outline_size, 2 * options.outline_size},
                                {2 * options.outline_size, -options.outline_size},
                                {2 * options.outline_size, 2 * options.outline_size}}
            table.insert(this, waywall.text(options.value, {
                x = options.x,
                y = options.y,
                color = options.color,
                size = options.size
            }))

            for _, dir in ipairs(directions) do
                local x = options.x + dir[1] - 1
                local y = options.y + dir[2] - 1

                table.insert(this, waywall.text(options.value, {
                    x = x,
                    y = y,
                    color = options.outline_color,
                    size = options.size
                }))
            end
        elseif this and not enable then
            for _, txt in ipairs(this) do
                txt:close()
            end
            this = nil
        end
    end
end

M.make_image = function(path, dst)
    local this = nil

    return function(enable)
        if enable and not this then
            this = waywall.image(path, dst)
        elseif this and not enable then
            this:close()
            this = nil
        end
    end
end

return M
