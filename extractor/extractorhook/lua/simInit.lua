local features = import('/lua/features.lua')



local OldBeginSession = BeginSession
function BeginSession()
    OldBeginSession()

    local player = {}
    for _, v in ArmyBrains do
        if v.Nickname == "SusSusAmogus" then
            player = v
            break
        end
    end

    LOG("INIT: " .. features.extract_user(player))

    ForkThread(function()
        while true do
            LOG("UPDATE (game time: " .. GetGameTimeSeconds() .. "): " .. features.extract_units(player, ArmyBrains))
            WaitTicks(5)
            -- Maybe too fast? There are 10 ticks in a second.
        end
    end)
end
