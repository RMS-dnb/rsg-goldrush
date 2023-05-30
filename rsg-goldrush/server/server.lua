local RSGCore = exports['rsg-core']:GetCoreObject()

-- give reward
RegisterServerEvent('rsg-goldrush:server:reward')
AddEventHandler('rsg-goldrush:server:reward', function()
    local src = source
    local Player = RSGCore.Functions.GetPlayer(src)
	local foundgold = math.random(1,100)
	if foundgold < Config.GoldChance then
		local chance = math.random(1,100)
		if chance <= 50 then
			local item1 = Config.RewardItems[math.random(1, #Config.RewardItems)]
			-- add items
			Player.Functions.AddItem(item1, Config.SmallRewardAmount)
			TriggerClientEvent("inventory:client:ItemBox", src, RSGCore.Shared.Items[item1], "add")
			--TriggerClientEvent('RSGCore:Notify', src, 'not much in this pan', 'primary')
			TriggerClientEvent('gp_notify:client:SendAlert', source, { text = 'Not much in this pan', length = '5000' })
		elseif chance >= 50 and chance <= 80 then -- medium reward
			local item1 = Config.RewardItems[math.random(1, #Config.RewardItems)]
			local item2 = Config.RewardItems[math.random(1, #Config.RewardItems)]
			-- add items
			Player.Functions.AddItem(item1, Config.MediumRewardAmount)
			TriggerClientEvent("inventory:client:ItemBox", src, RSGCore.Shared.Items[item1], "add")
			Player.Functions.AddItem(item2, Config.MediumRewardAmount)
			TriggerClientEvent("inventory:client:ItemBox", src, RSGCore.Shared.Items[item2], "add")
			--TriggerClientEvent('RSGCore:Notify', src, 'looks like good gold', 'primary')
			TriggerClientEvent('gp_notify:client:SendAlert', source, { text = 'Looks like gold', length = '5000' })
		elseif chance > 80 then -- large reward
			local item1 = Config.RewardItems[math.random(1, #Config.RewardItems)]
			local item2 = Config.RewardItems[math.random(1, #Config.RewardItems)]
			local item3 = Config.RewardItems[math.random(1, #Config.RewardItems)]
			-- add items
			Player.Functions.AddItem(item1, Config.LargeRewardAmount)
			TriggerClientEvent("inventory:client:ItemBox", src, RSGCore.Shared.Items[item1], "add")
			Player.Functions.AddItem(item2, Config.LargeRewardAmount)
			TriggerClientEvent("inventory:client:ItemBox", src, RSGCore.Shared.Items[item2], "add")
			Player.Functions.AddItem(item3, Config.LargeRewardAmount)
			TriggerClientEvent("inventory:client:ItemBox", src, RSGCore.Shared.Items[item3], "add")
			--TriggerClientEvent('RSGCore:Notify', src, 'gold fever jackpot..', 'primary')
			TriggerClientEvent('gp_notify:client:SendAlert', source, { text = 'Gold fever JACKPOT', length = '5000' })
		end
	else
		--TriggerClientEvent('RSGCore:Notify', src, 'no gold this time..', 'primary')
		TriggerClientEvent('gp_notify:client:SendAlert', source, { text = 'No gold this time', length = '5000' })
	end
end)
