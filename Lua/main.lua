Traitormod.Roles = {}
Traitormod.Tasks = {}
Traitormod.Config = {}

dofile(Traitormod.Path .. "/Lua/tableUtils.lua")
dofile(Traitormod.Path .. "/Lua/load.lua")

Hook.Add("roundStart", "traitormodStart", function()
    dofile(Traitormod.Path .. "/Lua/load.lua")

    Characters = Character.CharacterList
    Players = Client.ClientList
    PlayerData = {}
    Traitormod.PlayerData = PlayerData
    Traitormod.traitorVictoryPoints = 0
    dofile(Traitormod.Path .. "/Lua/config.lua")

    Traitormod.traitorVictoryPointsNeeded = Traitormod.Config.traitorVictoryPointsNeeded

    AvailableRoles = {}

    for pool, amount in pairs(Traitormod.Config.Pools) do
        print("adding ".. amount .. " of roles from pool: " .. pool)
        if amount == 0 then goto continue end

        for _ = 1, amount do
            local role = {pool = "nil"}

            while role.pool != pool do
                role = randomFromTable(Traitormod.Roles)
            end

            print("role: ".. role.name .. " added to pool.")

            table.insert(AvailableRoles, TableCopy(role))
        end

        ::continue::
    end

    for i, player in pairs( tableShuffle(Players) ) do -- assign roles and tell people their roles
        local name = player.Name
        local role = TableCopy(randomFromTableRemove(AvailableRoles))

        if not role or role == nil then
            role = TableCopy(Traitormod.Roles[1])
        end

        print("giving ".. name .. " the role: " .. role.name)

        PlayerData[name] = {
            ply = player,
            role = role,
        }

        if role.pool == "traitor" then
            role.pointsNeeded = Traitormod.Config.traitorVictoryPointsNeeded
            role.points = 0
        end

        local chatMessage = ChatMessage.Create("Traitormod", "You are a: " .. role.name .. "\n" .. role.hint, ChatMessageType.Default, nil, nil)
        chatMessage.Color = role.color
        Game.SendDirectChatMessage(chatMessage, player)
    end

    for i, data in pairs( PlayerData ) do -- assign tasks and tell people their tasks
        local role = data.role
        local availableTasks = {}
        local curTask

        if not role.hasTasks then goto continue end
        data.tasks = {}

        for key, task in pairs(Traitormod.Tasks) do
            if not tableHasValue(role.taskPools, task.pool) then goto continue2 end

            table.insert(availableTasks, task)
            ::continue2::
        end
        

        for i = 1, role.taskAmount do
            availableTasks = tableShuffle(availableTasks)

            for _, task in pairs( availableTasks ) do
                curTask = TableCopy(task)
                curTask.role = role
                curTask.player = data.ply

                if not curTask:init() then goto continue2 end

                if task.isUnique then 
                    for index, task2 in pairs(availableTasks) do
                        if task2.name == curTask.name then
                            table.remove(availableTasks, index)
                            break
                        end
                    end
                end

                table.insert(data.tasks, curTask)
                break
                ::continue2::
            end

            local chatMessage
            if curTask then
                chatMessage = ChatMessage.Create("Task ".. i, curTask.name .. "\n" .. curTask.hint , ChatMessageType.Default, nil, nil)
                chatMessage.Color = role.color
            else
                chatMessage = ChatMessage.Create("ERROR", "Task could not be loaded", ChatMessageType.Default, nil, nil)
                chatMessage.Color = Color(255,0,0)
            end
            Game.SendDirectChatMessage(chatMessage, data.ply)
        end
    
        ::continue::
    end
end)

Hook.Add("roundEnd", "traitormodEnd", function()
    Traitormod.traitorVictory = Traitormod.traitorVictoryPoints >= Traitormod.traitorVictoryPointsNeeded

    if Traitormod.traitorVictory then
        Game.SendMessage("Traitors Win!", ChatMessageType.Default)
    else
        Game.SendMessage("Crewmates Win!", ChatMessageType.Default)
    end
    
    for _, player in pairs(Players) do
        local text = ""
        local name = player.Name
        local victoryStatus
        local victoryStatusText
        local messageColor = Color(196,196,196)

        if PlayerData[name] then
            if PlayerData[name].role.winCondition() then
                messageColor = Color(255,230,0)
                victoryStatus = "won"
            else
                messageColor = Color(255,255,255)
                victoryStatus = "lost"
            end

            text = "was a " .. PlayerData[name].role.name .. " and " .. victoryStatus
        else
            text = "was a spectator."
        end

        for _, player2 in pairs(Players) do
            local chatMessage = ChatMessage.Create(name, text, ChatMessageType.Default, nil, nil)
            chatMessage.Color = messageColor
            Game.SendDirectChatMessage(chatMessage, player2)
        end
    end
end)

Hook.Add("think", "traitormodThink", function()
    if not PlayerData then return end

    Traitormod.AllItems = Game.GameSession.Submarine.GetItems(false)

    for _, data in pairs(PlayerData) do
        if not data.role then 
            print("role is a nil value wtff")
            return 
        end
        if not data.role.hasTasks then goto continue end

        for __, task in pairs(data.tasks) do
            if not task.isComplete and task:condition() then
                task.isComplete = true

                print("task complete: " .. task.name)

                local role = data.role
                local availableTasks = {}
                local curTask

                if not role.completedTasks then
                    role.completedTasks = {}
                end

                table.insert(role.completedTasks, task)

                for key, task2 in pairs(Traitormod.Tasks) do
                    if not tableHasValue(role.taskPools, task2.pool) then goto continue5 end

                    table.insert(availableTasks, task2)
                    ::continue5::
                end

                if role.pool == "traitor" then
                    Traitormod.traitorVictoryPoints = Traitormod.traitorVictoryPoints + task.points
                    role.points = Traitormod.traitorVictoryPoints
                else
                    role.points = role.points + task.points
                end

                availableTasks = tableShuffle(availableTasks)

                local chatMessage = ChatMessage.Create("Task Completed", "Task Completed: " .. task.name .. "\n" .. task.points .. " points awarded (" .. role.points .. "/" .. role.pointsNeeded .. ")", ChatMessageType.Default, nil, nil)
                chatMessage.color = Color(0, 255, 0)
                Game.SendDirectChatMessage(chatMessage, data.ply)

                for _, data2 in pairs(PlayerData) do
                    if data2 == data then goto continue4 end
                    if data2.role.pool ~= data.role.pool then goto continue4 end

                    chatMessage = ChatMessage.Create("Task Completed by Traitors", task.points .. " points awarded(" .. role.points .. "/" .. role.pointsNeeded .. ")", ChatMessageType.Default, nil, nil)
                    chatMessage.color = Color(0, 255, 0)
                    Game.SendDirectChatMessage(chatMessage, data2.ply)

                    ::continue4::
                end

                for _, task2 in pairs( availableTasks ) do
                    if task.isUnique then 
                        for index, task3 in pairs(data.tasks) do
                            if task3.name == curTask.name then
                                goto continue2
                            end
                        end

                        for index, task3 in pairs(role.completedTasks) do
                            if task3.name == curTask.name then
                                goto continue2
                            end
                        end
                    end

                    task2.role = nil

                    curTask = TableCopy(task2)
                    curTask.role = role
                    curTask.player = data.ply

                    if not curTask:init() then goto continue2 end

                    break
                    ::continue2::
                end

                table.insert(data.tasks, curTask)

                local chatMessage
                if curTask then
                    chatMessage = ChatMessage.Create("New Task", curTask.name .. "\n" .. curTask.hint , ChatMessageType.Default, nil, nil)
                    chatMessage.Color = role.color
                else
                    chatMessage = ChatMessage.Create("ERROR", "Task could not be loaded", ChatMessageType.Default, nil, nil)
                    chatMessage.Color = Color(255,0,0)
                end
                Game.SendDirectChatMessage(chatMessage, data.ply)
            end
        end

        ::continue::
    end
end)