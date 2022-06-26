function get_members(t)
    local obj_names = {}
    for key, _ in pairs(t) do
        if key ~= "__index" then
            table.insert(obj_names, key)
        end
    end
    local meta_names = {}
    for key, _ in pairs(getmetatable(t)) do
        if key ~= "__index" then
            table.insert(meta_names, key)
        end
    end
    return { obj_names = obj_names, meta_names = meta_names }
end

local OldBeginSession = BeginSession
function BeginSession()
    OldBeginSession()
    local json = import('/lua/system/dkson.lua').json
    ForkThread(function()
        local player = {}
        for _, v in ArmyBrains do
            if v.Nickname == "SusSusAmogus" then
                player = v
                break
            end
        end

        local player_encoded = json.encode({ get_members(player) }, { exception = json.encodeexception })
        LOG("PLAYER: " .. player_encoded)

        while true do
            local units = player:GetListOfUnits(categories.TECH1, true)
            if units[1] ~= nil then
                local unit_encoded = json.encode({ get_members(units[1]) }, { exception = json.encodeexception })
                LOG("UNIT: " .. unit_encoded)
            end
            -- Maybe too fast? There are 10 ticks in a second.
            WaitTicks(5)
        end
    end)
end
