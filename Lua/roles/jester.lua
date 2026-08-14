role.name = "Jester"
role.hint = "You win if the crew win and you have been killed by one of them."
role.pool = "neutral"
role.color = Color(255, 255, 0)
role.taskPools = {}
role.wasKilledByCrew = false

role.winCondition = function()
    return role.wasKilledByCrew
end