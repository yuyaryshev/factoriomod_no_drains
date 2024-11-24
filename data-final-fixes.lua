-- data-final-fixes.lua
require("tables") -- Load the type_drains table

-- Remove all drains
for i_type, v_type in pairs(data.raw) do
    if type(v_type) == "table" then
        for i_name, v_name in pairs(v_type) do
            local name = (v_name.name or i_name)
			local old_drain = v_name.energy_source and v_name.energy_source.drain or nil
			local old_energy_usage = v_name.energy_usage
			local entity_type = (v_type.type or i_type)
			
            if v_name.energy_source and (old_drain or type_drains[entity_type]) then

                -- Check if type exists in type_drains and if the setting for it is enabled
                if type_drains[entity_type] and settings.startup["remove-drain-" .. entity_type].value then
					if type(v_name.energy_source) == "table" and v_name.energy_source.drain then
						v_name.energy_source.drain = "0W"
					end
				
					if old_energy_usage and type_drains[entity_type].remove_usage then
						v_name.energy_usage = entity_type == "radar" and "1W" or "0W"
					end
                end
				
				--if v_name.energy_usage and entity_type == "roboport" then
					--log(serpent.line(v_name))
				--end				

                --log("name = " .. name .. ", type = " .. entity_type .. ", old_drain = " .. (old_drain or "nil") .. ", new_drain = " .. (v_name.energy_source and v_name.energy_source.drain or "nil")..", old_energy_usage = " .. (old_energy_usage or "nil") .. ", new_energy_usage = " .. (v_name.energy_usage or "nil"))
            end
        end
    end
end
