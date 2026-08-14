role.name = "Sheriff"
role.hint = "You only win if the crew win and you have directly killed a traitor."
role.pool = "good"
role.color = Color(0, 140, 0)
role.taskPools = {}
role.hasKilledTraitor = false

role.init = function()

end

role.winCondition = function()
    return role.hasKilledTraitor
end