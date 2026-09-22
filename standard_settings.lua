local function serialize_json(table_)
    local result = "";
    if type(table_) == "table" then
        result = result .. "{"
        for key, value in pairs(table_) do
            result = result .. serialize_json(key) .. ":"
            result = result .. serialize_json(value) .. ","
        end
        result = result:sub(1, -2)
        result = result .. "}"
        return result
    elseif table_ == "null" then
        return "null"
    elseif type(table_) == "string" then
        return '"' .. table_ .. '"'
    elseif type(table_) == "number" then
        return table_
    else
        return tostring(table_)
    end
end

local write_settings = function(settings, path)
    local file = io.open(path, "w")
    file:write(serialize_json(settings))
    file:close()
end

return {
    write_settings = write_settings
}
