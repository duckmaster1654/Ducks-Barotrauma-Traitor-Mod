task.name = "Save The Planet"
task.hint = "Recycle 5 useful tools"
task.pool = "WIP nOT UFKCINGIN UFNCITONAL"
task.isUnique = true
task.points = 3
task.role = nil
task.target = nil

task.amountDestroyed = 0

task.toollist = {
    weldingtorch = true,
    wrench = true,
    screwdriver = true,
    plasmacutter = true,
}


task.init = function(self)
    Hook.Patch(
        "Barotrauma.Item",
        "item.deconstructed",
        {
            "Barotrauma.Item",
            "Barotrauma.Item",
            "Barotrauma.Character",
        },
        function(_, ptable)
            print("disasembled")

            if ptable.OriginalParameters.userCharacter == self.player.Character  and  self.toollist[ptable.OriginalParameters.item.Identifier.Value] then
                task.amountDestroyed = task.amountDestroyed + 1
                print("disasembled for task")
            end
        end,
        Hook.HookMethodType.Before
    )

    return true
end

task.time = 0

task.condition = function()
    if task.amountDestroyed >= 5 then
        return true
    end

    return false
end