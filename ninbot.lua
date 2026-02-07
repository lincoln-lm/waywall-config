local bit = require("bit")

local PREFS_HEADER =
    "<?xml version=\"1.0\" encoding=\"UTF-8\" standalone=\"no\"?>\n<!DOCTYPE map SYSTEM \"http://java.sun.com/dtd/preferences.dtd\">\n<map MAP_XML_VERSION=\"1.0\">\n"

local PREFS_FOOTER = "</map>"

local THEME_UID_MAP = {
    title_bar = "a",
    header_background = "b",
    result_background = "c",
    throws_background = "d",
    dividers = "e",
    header_dividers = "f",
    text = "h",
    title_text = "n",
    throws_text = "k",
    divine_text = "i",
    version_text = "j",
    header_text = "o",
    subpixel_increase = "l",
    subpixel_decrease = "m",
    certainty_100 = "r",
    certainty_50 = "q",
    certainty_0 = "p"
}

local serialize_int = function(value, bit_length)
    local result = "";
    while (bit_length > 0) do
        local char = string.char(bit.band(value, 63) + 48);
        if char == "&" then
            char = "&amp;"
        elseif char == "'" then
            char = "&apos;"
        elseif char == ">" then
            char = "&gt;"
        elseif char == "<" then
            char = "&lt;"
        elseif char == "\"" then
            char = "&quot;"
        end
        result = char .. result
        value = bit.rshift(value, 6)
        bit_length = bit_length - 6
    end
    return result
end

local write_prefs = function(prefs, path)
    local prefs_str = PREFS_HEADER;
    for key, value in pairs(prefs) do
        if key == "custom_themes" then
            local themes_str = ""
            local themes_names_str = ""
            for _, theme in pairs(value) do
                for theme_key, theme_value in pairs(theme) do
                    if theme_key ~= "name" then
                        local color_int = tonumber(theme_value:gsub("#", ""), 16)
                        themes_str = themes_str .. THEME_UID_MAP[theme_key] .. serialize_int(color_int, 24)
                    end
                end
                themes_str = themes_str .. "."
                themes_names_str = themes_names_str .. theme.name .. "."
            end
            themes_str = themes_str:sub(1, -2)
            themes_names_str = themes_names_str:sub(1, -2)
            prefs_str = prefs_str .. string.format("<entry key=\"%s\" value=\"%s\"/>\n", "custom_themes", themes_str)
            prefs_str = prefs_str ..
                            string.format("<entry key=\"%s\" value=\"%s\"/>\n", "custom_themes_names", themes_names_str)
        else
            prefs_str = prefs_str .. string.format("<entry key=\"%s\" value=\"%s\"/>\n", key, value)
        end
    end
    prefs_str = prefs_str .. PREFS_FOOTER
    local file = io.open(path, "w")
    file:write(prefs_str)
    file:close()
end

return {
    write_prefs = write_prefs,
    SETTINGS = SETTINGS
}
