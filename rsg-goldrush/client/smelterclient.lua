local RSGCore = exports['rsg-core']:GetCoreObject()
local PlayerData = RSGCore.Functions.GetPlayerData()
local currentname
local currentzone

-----------------------------------------------------------------------------------

--------------------------------------------------------------------------------------------------

-- job prompts and blips
Citizen.CreateThread(function()
    for _, location in ipairs(Config.GoldsmelterLocations) do
        exports['rsg-core']:createPrompt(location.location, location.coords, RSGCore.Shared.Keybinds['J'], 'Open ' .. location.name, {
            type = 'client',
            event = 'rsg-goldsmelter:client:mainmenu',
            args = { location.location, location.coords },
        })
    end
end)


-----------------------------------------------------------------------------------

-- Goldsmelter menu
RegisterNetEvent('rsg-goldsmelter:client:mainmenu', function(name, zone)
    local job = RSGCore.Functions.GetPlayerData().job.name
    if job == name then
        currentname = name
        currentzone = zone
        exports['rsg-menu']:openMenu({
            {
                header = 'goldsmelter',
                isMenuHeader = true,
            },
            {
                header = "Gold Smelter Storage",
                txt = "",
                icon = "fas fa-box",
                params = {
                    event = 'rsg-goldsmelter:client:storage',
                    isServer = false,
                    args = {},
                }
            },
            {
                header = "Job Management",
                txt = "",
                icon = "fas fa-user-circle",
                params = {
                    event = 'rsg-bossmenu:client:OpenMenu',
                    isServer = false,
                    args = {},
                }
            },
			{
                header = "parts",
                txt = "",
                icon = "fas fa-tools",
                params = {
                    event = 'rsg-goldsmelter:client:partsmenu',
                    isServer = false,
                }
            },
            {
                header = ">> Close Menu <<",
                txt = '',
                params = {
                    event = 'rsg-menu:closeMenu',
                }
            },
        })
    else
        --RSGCore.Functions.Notify('you are not authorised!', 'error')
        exports['rsg-goldrush']:DisplayNotification('You are not authorized to access this menu.', 5000)
    end
end)

-----------------------------------------------------------------------------------

-- Goldsmelter storage
RegisterNetEvent('rsg-goldsmelter:client:storage', function()
    local job = RSGCore.Functions.GetPlayerData().job.name
	local stashloc = currentname
    if job == currentname then
            TriggerServerEvent("inventory:server:OpenInventory", "stash", stashloc, {
            maxweight = Config.StorageMaxWeight,
            slots = Config.StorageMaxSlots,
        })
        TriggerEvent("inventory:client:SetCurrentStash", stashloc)
    end
end)

-----------------------------------------------------------------------------------

-- parts menu
RegisterNetEvent('rsg-goldsmelter:client:partsmenu', function()
    partsMenu = {}
    partsMenu = {
        {
            header = "Goldsmelter Crafting",
            isMenuHeader = true,
        },
    }
    local item = {}
    for k, v in pairs(Config.parts) do
        partsMenu[#partsMenu + 1] = {
            header = v.lable,
            txt = text,
            icon = 'fas fa-cog',
            params = {
                event = 'rsg-goldsmelter:client:partscheckitems',
                args = {
                    name = v.name,
                    lable = v.lable,
                    item = k,
                    crafttime = v.crafttime,
                    receive = v.receive
                }
            }
        }
    end
    partsMenu[#partsMenu + 1] = {
        header = "close_menu",
        txt = '',
        params = {
            event = 'rsg-menu:closeMenu',
        }
    }
    exports['rsg-menu']:openMenu(partsMenu)
end)

-- parts crafting : check player has the items
RegisterNetEvent('rsg-goldsmelter:client:partscheckitems', function(data)
    RSGCore.Functions.TriggerCallback('rsg-goldsmelter:server:checkitems', function(hasRequired)
    if (hasRequired) then
        if Config.Debug == true then
            print("passed")
        end
        TriggerEvent('rsg-goldsmelter:client:startpartscrafting', data.name, data.lable, data.item, tonumber(data.crafttime), data.receive)
    else
        if Config.Debug == true then
            print("failed")
        end
        return
    end
    end, Config.parts[data.item].craftitems)
end)

-- start parts crafting
RegisterNetEvent('rsg-goldsmelter:client:startpartscrafting', function(name, lable, item, crafttime, receive)
    local craftitems = Config.parts[item].craftitems
    RSGCore.Functions.Progressbar('craft-parts', ('')..lable, crafttime, false, true, {
        disableMovement = true,
        disableCarMovement = false,
        disableMouse = false,
        disableCombat = true,
    }, {}, {}, {}, function() -- Done
        TriggerServerEvent('rsg-goldsmelter:server:finishcrafting', craftitems, receive)
    end)
end)
