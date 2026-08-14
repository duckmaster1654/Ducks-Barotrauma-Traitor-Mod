task.name = "Wacky and Quacky"
task.hint = "Keep 5 deep diver ducks in the Ballast tanks for 30 seconds."
task.pool = "bad"
task.isUnique = true
task.points = 2
task.role = nil
task.target = nil

task.init = function(self)
    Traitormod.patchRecipe(self.player, "deepdiverduck")
    return true
end

task.time = 0

task.condition = function(self)
    local num = 0

    for _, v in ipairs(Traitormod.AllItems) do
        if tostring(v.Prefab.Identifier.Value) == "deepdiverduck" and string.find(string.lower(v.CurrentHull.RoomName), "ballast")  then
            num = num + 1
        end
    end

    if num >= 5 then
        self.time = self.time + 1 / 60

        print(self.time)

        if self.time >= 30 then
            return true
        end
    else
        self.time = 0
    end
end