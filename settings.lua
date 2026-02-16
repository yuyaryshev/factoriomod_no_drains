-- settings.lua
require("tables") -- Load the type_drains table

data:extend(
    (function()
        local settings = {}
        for type, data in pairs(type_drains) do
            table.insert(settings, {
                type = "bool-setting",
                name = "remove-drain-" .. type,
                setting_type = "startup",
                default_value = data.default_setting,
                order = "a-" .. type
            })
        end

        table.insert(settings, {
            type = "bool-setting",
            name = "remove-drain-radar-only-if-no-scan",
            setting_type = "startup",
            default_value = true,
            order = "b-radar-only-if-no-scan"
        })

        return settings
    end)()
)
