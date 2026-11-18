task.name = "Kill Crewmember"
task.hint = "Task not initiated"
task.pool = "traitor"
task.isUnique = false
task.points = 5
task.role = nil
task.target = nil

task.isComplete = false

task.init = function(self)
    self.target = self.role.findTarget()

    if not self.target then return false end

    self.hint = "Make sure that " .. self.target.Name .. " has an opium overdose. They dont have to die."

    return true
end

task.condition = function(self)
    if not self.target or not self.target.Character then
        return false
    end

    local affliction = self.Target.CharacterHealth.GetAffliction("opiumoverdose", true)

    return affliction ~= nil and aff.Strength > 1
end