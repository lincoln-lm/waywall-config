local waywall = require("waywall")
local helpers = require("waywall.helpers")

local config_folder = function(relative_path)
    local home = os.getenv("HOME")
    return home .. "/.config/waywall/" .. relative_path
end

local read_file = function(name)
    local file = io.open(config_folder(name), "r")
    local data = file:read("*a")
    file:close()
    return data
end

local exec_unsafe = function(cmd)
    local handle = io.popen(cmd)
    local result = handle:read("*l")
    handle:close()
    return result
end

local make_mirror = function(options)
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

local make_text = function(options)
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

local make_outlined_text = function(options)
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

local make_image = function(path, dst)
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

return {
    exec_unsafe = exec_unsafe,
    make_mirror = make_mirror,
    make_image = make_image,
    make_text = make_text,
    make_outlined_text = make_outlined_text,
    read_file = read_file,
    config_folder = config_folder
}
