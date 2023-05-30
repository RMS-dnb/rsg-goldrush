local RSGCore = exports['rsg-core']:GetCoreObject()

-- prompts and blips
Citizen.CreateThread(function()
    for sellvendor, v in pairs(Config.VendorShops) do
        exports['rsg-core']:createPrompt(v.prompt, v.coords, RSGCore.Shared.Keybinds['J'], v.header, {
            type = 'client',
            event = 'rsg-goldrush:client:openmenu',
            args = { v.prompt },
        })
        if v.showblip == true then
            local SellVendorBlip = Citizen.InvokeNative(0x554D9D53F696D002, 1664425300, v.coords)
            SetBlipSprite(SellVendorBlip, GetHashKey(v.blip.blipSprite), true)
            SetBlipScale(SellVendorBlip, v.blip.blipScale)
            Citizen.InvokeNative(0x9CB1A1623062F402, SellVendorBlip, v.blip.blipName)
        end
    end
end)

-- Utility function to check if a value exists in a table
local function tableContains(table, value)
    for _, v in pairs(table) do
        if v == value then
            return true
        end
    end
    return false
end

RegisterNetEvent('rsg-goldrush:client:openmenu') 
AddEventHandler('rsg-goldrush:client:openmenu', function(menuid)
    local job = RSGCore.Functions.GetPlayerData().job.name -- Retrieve the player's job name using the correct method

    -- Define the allowed job names as a table
    local allowedJobs = {'goldsmelter', 'goldsmelter1', 'goldsmelter2'}

    -- Check if the player's job is allowed to access the menu
    if tableContains(allowedJobs, job) then
        local shoptable = {
            {
                header = "| "..getMenuTitle(menuid).." |",
                isMenuHeader = true,
            },
        }
        local closemenu = {
            header = "Close menu",
            txt = '', 
            params = {
                event = 'rsg-menu:closeMenu',
            }
        }
        for k, v in pairs(Config.VendorShops) do
            if v.prompt == menuid then
                for g, f in pairs(v.shopdata) do
                    local lineintable = {
                        header = "<img src=nui://rsg-inventory/html/images/"..f.image.." width=20px>"..f.title..' (price $'..f.price..')',
                        params = {
                            event = 'rsg-goldrush:client:sellcount',
                            args = {menuid, f}
                        }
                    }
                    table.insert(shoptable, lineintable)
                end 
            end
        end
        table.insert(shoptable, closemenu)
        exports['rsg-menu']:openMenu(shoptable)
    else
        -- Display a notification to the player indicating that they don't have the required job
        -- RSGCore.Functions.Notify('You are not authorized to access this menu.', 'error')
        exports['rsg-goldrush']:DisplayNotification('You are not authorized to access this menu.', 5000)
    end
end)



RegisterNetEvent('rsg-goldrush:client:sellcount') 
AddEventHandler('rsg-goldrush:client:sellcount', function(arguments)
    local menuid = arguments[1]
    local data = arguments[2]
    local inputdata = exports['rsg-input']:ShowInput({
        header = "Enter the number of 1pc / "..data.price.." $",
        submitText = "sell",
        inputs = {
            {
                text = data.description,
                input = "amount",
                type = "number",
                isRequired = true
            },
        }
    })
    if inputdata ~= nil then
        for k,v in pairs(inputdata) do
            TriggerServerEvent('rsg-goldrush:server:sellitem', v,data)
        end
    end
end)


function getMenuTitle(menuid)
    for k,v in pairs(Config.VendorShops)  do
        if menuid == v.prompt then
            return v.header
        end
    end
end
