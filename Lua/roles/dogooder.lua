role.name = "Do-gooder Crewmember"
role.hint = "You win with the Crew but only if you complete your Helpful tasks."
role.pool = "UNFINISHEDgood"
role.color = Color(25, 255, 25)
role.hasTasks = true
role.taskPools = { "good" }
role.taskAmount = 3

role.findTarget = function()
    local target = nil

    for key, player in pairs(Client.ClientList) do
        if not PlayerData[player.Name] then goto continue end
        if PlayerData[player.Name].role.name == "Mischievous Crewmember" then goto continue end

        target = player
        break

        ::continue::
    end

    return target
end

role.winCondition = function()
    return Traitormod.traitorVictory
end