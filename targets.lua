local QBCore = exports['qb-core']:GetCoreObject()
local shopNPC = nil

function PlayNPCAnimation(npcPed, animType)
    if animType == "buy" or animType == "sell" then
        RequestAnimDict("mp_common")
        while not HasAnimDictLoaded("mp_common") do Wait(10) end
        TaskPlayAnim(npcPed, "mp_common", "givetake1_b", 2.0, 2.0, 1000, 51, 0, false, false, false)
        Wait(1000)
        ClearPedTasks(npcPed)
    end
end

RegisterNetEvent('itemshop:transactionSuccess')
AddEventHandler('itemshop:transactionSuccess', function(transactionType)
    if shopNPC then PlayNPCAnimation(shopNPC, transactionType) end
end)

CreateThread(function()
    Wait(1000)
    shopNPC = createNPC()
    if not shopNPC then return end

    exports.ox_target:addLocalEntity(shopNPC, {
        {
            name = 'shop:buy',
            icon = 'fas fa-shopping-cart',
            label = 'Beli Barang',
            distance = 2.5,
            onSelect = function()
                TriggerEvent('itemshop:openPurchaseMenu', Config.ItemsForSale)
            end
        },
        {
            name = 'shop:sell',
            icon = 'fas fa-dollar-sign',
            label = 'Jual Barang',
            distance = 2.5,
            onSelect = function()
                TriggerEvent('itemshop:openSellMenu')
            end
        }
    })
end)
