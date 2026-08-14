task.name = "Divine Labor"
task.hint = "Craft and place 4 husk figurines in the ship for atleast 60 seconds"
task.pool = "bad"
task.isUnique = true
task.points = 3
task.role = nil
task.target = nil

task.init = function(self)
    Traitormod.patchRecipe(self.player, "huskfigurine")
    return true
end

task.condition = function(self)
    local num = 0

    for _, item in ipairs(Traitormod.AllItems) do
        if tostring(item.Prefab.Identifier.Value) == "huskfigurine" and item.GetComponentString("Holdable").IsAttached then
            num = num + 1
        end
    end

    if num >= 5 then
        self.time = self.time + 1 / 60

        if self.time >= 60 then
            return true
        end
    else
        self.time = 0
    end
end