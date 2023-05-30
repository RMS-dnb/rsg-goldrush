local RSGCore = exports['rsg-core']:GetCoreObject()


-----------------------------------------------------------------------------------

-- check player has items
RSGCore.Functions.CreateCallback('rsg-goldsmelter:server:checkitems', function(source, cb, craftitems)
    local src = source
    local hasItems = false
    local icheck = 0
    local Player = RSGCore.Functions.GetPlayer(src)
    for k, v in pairs(craftitems) do
        if Player.Functions.GetItemByName(v.item) and Player.Functions.GetItemByName(v.item).amount >= v.amount then
            icheck = icheck + 1
            if icheck == #craftitems then
                cb(true)
            end
        else
            --TriggerClientEvent('RSGCore:Notify', src, ('You dont have the required items'), 'error')
            TriggerClientEvent('gp_notify:client:SendAlert', source, { text = 'You dont have the required items', length = '2500' })
            cb(false)
            return
        end
    end
end)

-----------------------------------------------------------------------------------

-- finish crafting
RegisterServerEvent('rsg-goldsmelter:server:finishcrafting')
AddEventHandler('rsg-goldsmelter:server:finishcrafting', function(craftitems, receive)
    local src = source
    local Player = RSGCore.Functions.GetPlayer(src)
    -- remove craftitems
    for k, v in pairs(craftitems) do
        if Config.Debug == true then
            print(v.item)
            print(v.amount)
        end
        Player.Functions.RemoveItem(v.item, v.amount)
        TriggerClientEvent('inventory:client:ItemBox', src, RSGCore.Shared.Items[v.item], "remove")
    end
    -- add items
    Player.Functions.AddItem(receive, 1)
    TriggerClientEvent('inventory:client:ItemBox', src, RSGCore.Shared.Items[receive], "add")
   --TriggerClientEvent('RSGCore:Notify', src, ('Finished Crafting'), 'success')
    TriggerClientEvent('gp_notify:client:SendAlert', source, { text = 'Finished Crafting', length = '2500' })
end)

