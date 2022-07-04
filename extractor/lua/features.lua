local json = import('/lua/system/dkson.lua').json



function extract_user(user)
    return json.encode({ name = user.Nickname, faction = user:GetFactionIndex() }, { exception = json.encodeexception })
end


function extract_units(user, brains)
    local units = {}
    for _, brain in brains do
        for _, unit in brain:GetListOfUnits(categories.ALLUNITS + categories.ALLPROJECTILES) do
            table.insert(units, unit)
        end
    end

    local encoded_units = {}
    for _, unit in units do
        local index = user:GetArmyIndex()
        local blip = unit:GetBlip(index)
        if blip ~= nil then
            encoded_units[unit:GetEntityId()] = {
                blip = {
                    destroyed = blip:IsKnownFake(index) or blip:IsMaybeDead(index) or blip:BeenDestroyed(),
                    identified = blip:IsSeenEver(index),
                    certain = blip:IsOnOmni(index) or blip:IsSeenNow(index),
                    radar = blip:IsOnRadar(index) or blip:IsOnSonar(index)
                },
                owner = unit:GetArmy(),
                fire_state = unit:GetFireState(),
                health = unit:GetHealth(),
                orientation = unit:GetOrientation(),
                position = unit:GetPositionXYZ(),
                target = unit:GetTargetEntity()
            }
        end
    end

    local economy = {
        income = {
            energy = user:GetEconomyIncome('ENERGY'),
            mass = user:GetEconomyIncome('MASS')
        },
        stored = {
            energy = user:GetEconomyStored('ENERGY'),
            mass = user:GetEconomyStored('MASS')
        }
    }

    return json.encode({ units = encoded_units, economy = economy }, { exception = json.encodeexception })
end
