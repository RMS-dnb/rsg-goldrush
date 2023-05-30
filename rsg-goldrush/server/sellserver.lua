local RSGCore = exports['rsg-core']:GetCoreObject()

RegisterServerEvent('rsg-goldrush:server:sellitem')
AddEventHandler('rsg-goldrush:server:sellitem', function(amount, data)
    local src = source
    local Player = RSGCore.Functions.GetPlayer(src)
    local amount = tonumber(amount)
    local checkitem = Player.Functions.GetItemByName(data.item)
    if amount >= 0 then
        if checkitem ~= nil then
            local amountitem = Player.Functions.GetItemByName(data.item).amount
            if amountitem >= amount then
                totalcash = (amount * data.price) 
                Player.Functions.RemoveItem(data.item, amount)
                TriggerClientEvent('inventory:client:ItemBox', src, RSGCore.Shared.Items[data.item], "remove")
                Player.Functions.AddMoney('cash', totalcash)
               --TriggerClientEvent('RSGCore:Notify', src, 'You sold ' ..amount.. ' for  $'..totalcash, 'success')
                exports['rsg-goldrush']:DisplayNotification('You sold ' ..amount.. ' for  $'..totalcash, 5000)
            else
                --TriggerClientEvent('RSGCore:Notify', src, 'You don\'t have that much on you.', 'error')
                exports['rsg-goldrush']:DisplayNotification('You dont have that much on you.', 5000)
            end
        else
            --TriggerClientEvent('RSGCore:Notify', src, 'You don\'t have an item on you', 'error')
            exports['rsg-goldrush']:DisplayNotification('You dont have an item on you.', 5000)
        end
    else
        --TriggerClientEvent('RSGCore:Notify', src, 'must not be a negative value.', 'error')
        exports['rsg-goldrush']:DisplayNotification('Must not be a negative value.', 5000)
    end
end)
