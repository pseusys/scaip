local File = '*.ext'

dofile(InitFileDir .. '\\SupComDataPath.lua')

LOG('Hooking extractor')
table.insert(hook, '/extractorhook')

local oldPath = path
path = {}
table.insert(path, { dir = InitFileDir .. '\\..\\gamedata\\' .. File, mountpoint = '/' })

for _, v in oldPath do
    table.insert(path, v)
end
