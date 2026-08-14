task.name = "Kill Crewmember"
task.hint = "Task not initiated"
task.pool = "UNIMPLEMENTED"
task.isUnique = false
task.points = 5
task.role = nil
task.target = nil

task.isComplete = false

task.init = function(self)
    self.target = self.role.findTarget()

    if not self.target then return false end

    self.hint = "Make sure that " .. self.target.Name .. " has an opium overdose."

    return true
end

task.condition = function(self)
    return self.isComplete
end