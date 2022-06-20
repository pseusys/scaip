local OldOnSync = OnSync
function OnSync()
    OldOnSync()
    local json = import('/lua/system/dkson.lua').json
    -- not at all optimal - many lines repeated multiple times (for every player, I guess); info about current army should be pulled from some other place - GetFocusArmy?..
    local encoded = json.encode({ sync = Sync, data = UnitData }, { exception = json.encodeexception })
    LOG("SYNC: " .. encoded)
end
