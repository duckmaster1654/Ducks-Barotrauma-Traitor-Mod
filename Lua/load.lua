Roles = Traitormod.Roles
Tasks = Traitormod.Tasks

for _, v in pairs(File.GetFiles( Traitormod.Path .. "/Lua/roles/" )) do
    local name
    if not string.match(v, ".lua") then goto continue end
    name = v:gsub(".lua", ""):gsub("LocalMods/Ducks Traitor Mod/Lua/roles/", "")

    role = {}
    table.insert(Roles, role)

    dofile(v)
    print("Loaded Role: "..name)
    ::continue::
end

for _, v in pairs(File.GetFiles( Traitormod.Path .. "/Lua/tasks/" )) do
    local name
    if not string.match(v, ".lua") then goto continue end
    name = v:gsub(".lua", ""):gsub("LocalMods/Ducks Traitor Mod/Lua/tasks/", "")

    task = {}
    table.insert(Tasks, task)

    dofile(v)
    print("Loaded Task: "..name)
    ::continue::
end

