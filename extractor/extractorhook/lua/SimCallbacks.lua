local OldDoCallback = DoCallback
function DoCallback(name, data, units)
    local json = import('/lua/system/dkson.lua').json
    -- units here - currently selected units, including it make sense for certain callbacks only.
    -- perform selection as same callbacks happen multiple times
    local encoded = json.encode({ name = name, data = data, units = units }, { exception = json.encodeexception })
    -- LOG("CALLBACK: " .. encoded)
    OldDoCallback(name, data, units)
end
