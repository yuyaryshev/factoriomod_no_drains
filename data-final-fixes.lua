-- data-final-fixes.lua
require("tables") -- Load the type_drains table

local function radar_has_extra_scan_range(radar)
    local scan = radar.max_distance_of_sector_revealed or 0
    local vision = radar.max_distance_of_nearby_sector_revealed or 0
    return type(scan) == "number" and type(vision) == "number" and scan > vision
end

-- Remove all drains
for i_type, v_type in pairs(data.raw) do
    if type(v_type) == "table" then
        for i_name, v_name in pairs(v_type) do
            local name = (v_name.name or i_name)
			local old_drain = v_name.energy_source and v_name.energy_source.drain or nil
			local old_energy_usage = v_name.energy_usage
			local entity_type = (v_type.type or i_type)
			
            if v_name.energy_source and (old_drain or type_drains[entity_type]) then

                -- Check if type exists in type_drains and if settings for it are enabled
                local remove_drain_enabled = false
                if entity_type == "radar" then
                    local remove_all_radars = settings.startup["remove-drain-radar"].value
                    local remove_vision_only_radars = settings.startup["remove-drain-radar-only-if-no-scan"].value
                    remove_drain_enabled = remove_all_radars or (remove_vision_only_radars and not radar_has_extra_scan_range(v_name))
                else
                    remove_drain_enabled = type_drains[entity_type] and settings.startup["remove-drain-" .. entity_type].value
                end

                if remove_drain_enabled then
--					if type(v_name.energy_source) == "table" and v_name.energy_source.drain then
					if v_name.energy_source and v_name.energy_source.type == "electric" and type(v_name.energy_source) == "table" then
						v_name.energy_source.drain = "0W"
					end
				
					if old_energy_usage and type_drains[entity_type].remove_usage then
						v_name.energy_usage = entity_type == "radar" and "1W" or "0W"
						if entity_type == "radar" then					
							 v_name.energy_per_nearby_scan="1J"
							 v_name.energy_per_sector="30J"
						end						
					end
                end
				
				--if v_name.energy_usage and entity_type == "roboport" then
					--log(serpent.line(v_name))
				--end				

                --log("name = " .. name .. ", type = " .. entity_type .. ", old_drain = " .. (old_drain or "nil") .. ", new_drain = " .. (v_name.energy_source and v_name.energy_source.drain or "nil")..", old_energy_usage = " .. (old_energy_usage or "nil") .. ", new_energy_usage = " .. (v_name.energy_usage or "nil"))
            end
            ::continue::
        end
    end
end
