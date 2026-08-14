Traitormod = {}
Traitormod.patchedRecipes = {}

LuaUserData.RegisterType("Barotrauma.Identifier")

if CLIENT then
    Networking.Receive("DucksTraitorItemPatch", function(recipeIdentifier)
        local identifier = recipeIdentifier.ReadString()
        print("adding patch for recipe " .. identifier )
        Traitormod.patchedRecipes[identifier] = true
    end)

    Hook.Patch(
        "Barotrauma.Character",
        "HasRecipeForItem",
        {
            "Barotrauma.Identifier",
        },
        function(instance, ptable)
            --print("recipe hook thing on client")

            local identifier = ""
            if ptable.OriginalParameters.recipeIdentifier then
                identifier = ptable.OriginalParameters.recipeIdentifier
            end

            if Traitormod.patchedRecipes[tostring(identifier)] then
                --print("patch executed: " .. tostring(tostring(identifier)))
                ptable.PreventExecution = true
                return true
            else
                ptable.PreventExecution = false
                return false
            end
        end,
        Hook.HookMethodType.Before
    )

    return
end

Hook.Patch(
    "Barotrauma.Character",
    "HasRecipeForItem",
    {
        "Barotrauma.Identifier",
    },
    function(instance, ptable)
        --print("recipe hook thing on server")

        ptable.PreventExecution = true
        return true
    end,
    Hook.HookMethodType.Before
)

Traitormod.patchRecipe = function (client, recipeIdentifier)
    print("patching item " .. recipeIdentifier .. " for player: " .. client.Name)
    IWriteMessage = Networking.Start("DucksTraitorItemPatch")
    IWriteMessage.WriteString(recipeIdentifier)
    Networking.Send(IWriteMessage, client.Connection, DeliveryMethod.Reliable)
end

local path = table.pack(...)[1]

Traitormod.Path = path

dofile(Traitormod.Path .. "/Lua/main.lua")