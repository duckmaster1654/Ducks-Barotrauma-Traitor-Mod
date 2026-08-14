role.name = "Mischievous Crewmember"
role.hint = "You win with the Crew but only if you complete your Mischievous tasks."
role.pool = "good"
role.color = Color(187, 255, 0)
role.hasTasks = true
role.taskPools = { "bad" }
role.taskAmount = 3
role.points = 0
role.pointsNeeded = 10

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