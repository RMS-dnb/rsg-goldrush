local RSGCore = exports['rsg-core']:GetCoreObject()
local panning = false

Citizen.CreateThread(function()
	while true do
		Wait(0)
		local pos, awayFromObject = GetEntityCoords(PlayerPedId()), true
		local goldshakerObject = GetClosestObjectOfType(pos, 5.0, GetHashKey(Config.Prop), false, false, false)
		if goldshakerObject ~= 0 then
			local objectPos = GetEntityCoords(goldshakerObject)
			if #(pos - objectPos) < 3.0 then
				awayFromObject = false
				DrawText3Ds(objectPos.x, objectPos.y, objectPos.z + 1.0, "Check for Gold [J]")
				if IsControlJustReleased(0, RSGCore.Shared.Keybinds['J']) then
					TriggerEvent('rsg-goldrush:client:goldclaim')
				end
			end
		end
		if awayFromObject then
			Wait(1000)
		end
	end
end)

-- gold claim / pan for gold
RegisterNetEvent('rsg-goldrush:client:goldclaim', function()
	local hasItem1 = RSGCore.Functions.HasItem('claimlease', 1)
	local hasItem2 = RSGCore.Functions.HasItem('goldpan', 1)
	if hasItem1 then
		if hasItem2 and panning == false then
			panning = true
			local ped = PlayerPedId()
			TaskStartScenarioInPlace(ped, `WORLD_HUMAN_BUCKET_POUR_LOW`, 8000, true, false, false, false)
			Wait(10000)
			ClearPedTasks(ped)
			SetCurrentPedWeapon(ped, `WEAPON_UNARMED`, true)
			Wait(1000)
			AttachPan()
			GoldShake()
			local randomwait = math.random(12000,28000)
			Wait(randomwait)
			DeletePan(prop_goldpan) 
			TriggerServerEvent('rsg-goldrush:server:reward')
			panning = false
		else
			--RSGCore.Functions.Notify('you don\'t have a gold pan', 'error')
			exports['rsg-goldrush']:DisplayNotification('You dont have a goldpan.', 5000)
		end
	else
		--RSGCore.Functions.Notify('you don\'t have the a claim lease', 'error')
		exports['rsg-goldrush']:DisplayNotification('You dont have the claim lease land plot.', 5000)
	end
end)

-- attach gold pan to ped
function AttachPan()
    if not DoesEntityExist(prop_goldpan) then
    local ped = PlayerPedId()
    local coords = GetEntityCoords(ped)
    local modelHash = GetHashKey("P_CS_MININGPAN01X")  
    LoadModel(modelHash)    
    prop_goldpan = CreateObject(modelHash, coords.x+0.30, coords.y+0.10,coords.z, true, false, false)
    SetEntityVisible(prop_goldpan, true)
    SetEntityAlpha(prop_goldpan, 255, false)
    Citizen.InvokeNative(0x283978A15512B2FE, prop_goldpan, true)   
    local boneIndex = GetEntityBoneIndexByName(ped, "SKEL_R_HAND")
    AttachEntityToEntity(prop_goldpan, PlayerPedId(), boneIndex, 0.2, 0.0, -0.20, -100.0, -50.0, 0.0, false, false, false, true, 2, true)
    SetModelAsNoLongerNeeded(modelHash)
    end
end

-- ped does gold shake anim
function GoldShake()
    local dict = "script_re@gold_panner@gold_success"
    RequestAnimDict(dict)
    while not HasAnimDictLoaded(dict) do
        Wait(10)
    end
    TaskPlayAnim(PlayerPedId(), dict, "SEARCH02", 1.0, 8.0, -1, 1, 0, false, false, false)
end

-- delete goldpan prop
function DeletePan(entity)
    DeleteObject(entity)
    DeleteEntity(entity)
    Wait(100)          
    ClearPedTasks(PlayerPedId())
end

-- ensure prop is loaded
function LoadModel(model)
    local attempts = 0
    while attempts < 100 and not HasModelLoaded(model) do
        RequestModel(model)
        Citizen.Wait(10)
        attempts = attempts + 1
    end
    return IsModelValid(model)
end

-- needed to display text
function DrawText3Ds(x, y, z, text)
    local onScreen,_x,_y=GetScreenCoordFromWorldCoord(x, y, z)
    SetTextScale(0.35, 0.35)
    SetTextFontForCurrentCommand(9)
    SetTextColor(255, 255, 255, 215)
    local str = CreateVarString(10, "LITERAL_STRING", text, Citizen.ResultAsLong())
    SetTextCentre(1)
    DisplayText(str,_x,_y)
end
