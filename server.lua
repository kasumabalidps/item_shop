local QBCore = exports['qb-core']:GetCoreObject()

RegisterNetEvent('itemshop:buyItem')
AddEventHandler('itemshop:buyItem', function(itemName, itemPrice)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if not Player then return end

    if Player.PlayerData.money['cash'] >= itemPrice then
        if Player.Functions.AddItem(itemName, 1) then
            Player.Functions.RemoveMoney('cash', itemPrice, "item-shop-purchase")
            TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items[itemName], 'add')
            TriggerClientEvent('ox_lib:notify', src, {
                title = 'Toko Madura',
                description = "Anda membeli 1 " .. QBCore.Shared.Items[itemName].label .. " seharga $" .. itemPrice,
                type = 'success'
            })
            TriggerClientEvent('itemshop:transactionSuccess', src, "buy")
        else
            TriggerClientEvent('ox_lib:notify', src, {
                title = 'Toko Madura',
                description = "Inventory Anda penuh!",
                type = 'error'
            })
        end
    else
        TriggerClientEvent('ox_lib:notify', src, {
            title = 'Toko Madura',
            description = "Uang Anda tidak cukup!",
            type = 'error'
        })
    end
end)

RegisterNetEvent('itemshop:sellItem')
AddEventHandler('itemshop:sellItem', function(itemName, sellPrice)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if not Player then return end
    
    local item = Player.Functions.GetItemByName(itemName)
    if not item then
        TriggerClientEvent('ox_lib:notify', src, {
            title = 'Toko Madura',
            description = "Anda tidak memiliki item ini!",
            type = 'error'
        })
        return
    end

    if Player.Functions.RemoveItem(itemName, 1) then
        Player.Functions.AddMoney('cash', sellPrice, "item-shop-sale")
        TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items[itemName], 'remove')
        TriggerClientEvent('ox_lib:notify', src, {
            title = 'Toko Madura',
            description = "Anda menjual 1 " .. QBCore.Shared.Items[itemName].label .. " seharga $" .. sellPrice,
            type = 'success'
        })
        TriggerClientEvent('itemshop:transactionSuccess', src, "sell")
    else
        TriggerClientEvent('ox_lib:notify', src, {
            title = 'Toko Madura',
            description = "Terjadi kesalahan saat menjual item!",
            type = 'error'
        })
    end
end)
