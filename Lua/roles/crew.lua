role.name = "Crewmember"
role.hint = "Complete the mission to win, you only win if the traitors dont complete their tasks or if they die."
role.pool = "crew"
role.color = Color(0, 255, 0)
role.taskPools = {}

role.winCondition = function()
    return not Traitormod.traitorVictory
end