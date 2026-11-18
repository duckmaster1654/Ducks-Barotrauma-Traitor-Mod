task.name = "Steal the Captains ID"
task.hint = "It says it right there bro..."
task.pool = "bad"
task.isUnique = true
task.points = 5
task.role = nil
task.target = nil


task.init = function(self)
    for _, player in pairs(Client.ClientList) do
        for item in player.Character.Inventory.AllItems do
            if item.Prefab.Identifier == "idcard" and item.GetComponentString("IdCard").OwnerJobId == "captain" then
                return PlayerData[player.Name].role.pool == "good"
            end
        end
    end

    return false
end

task.condition = function(self)
    for item in self.Character.Inventory.AllItems do
        if item.Prefab.Identifier == "idcard" and item.GetComponentString("IdCard").OwnerJobId == "captain" then
            return true
        end
    end

    return false
end