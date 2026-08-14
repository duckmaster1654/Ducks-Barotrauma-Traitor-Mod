role.name = "Traitor"
role.hint = "Complete your traitorous tasks to win."
role.pool = "traitor"
role.color = Color(220, 0, 0, 255)
role.hasTasks = true
role.taskPools = { "traitor", "bad" }
role.taskAmount = 3

role.findTarget = function()
    local target = nil

    for key, player in pairs(Client.ClientList) do
        if not PlayerData[player.Name] then goto continue end
        if PlayerData[player.Name].role.pool == "traitor" then goto continue end

        target = player
        break

        ::continue::
    end

    return target
end

role.winCondition = function()
    return Traitormod.traitorVictory
end