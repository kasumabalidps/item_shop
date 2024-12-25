local QBCore = exports['qb-core']:GetCoreObject()
local shopNPC = nil
local shopBlip = nil

function createBlip()
    if shopBlip then return end
    
    shopBlip = AddBlipForCoord(Config.NPC.coords.x, Config.NPC.coords.y, Config.NPC.coords.z)
    SetBlipSprite(shopBlip, Config.Blip.sprite)
    SetBlipDisplay(shopBlip, 4)
    SetBlipScale(shopBlip, 1.0)
    SetBlipColour(shopBlip, Config.Blip.color)
    SetBlipAsShortRange(shopBlip, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString(Config.Blip.label)
    EndTextCommandSetBlipName(shopBlip)

    SetBlipAlpha(shopBlip, 255)
    SetBlipHiddenOnLegend(shopBlip, false)
    SetBlipPriority(shopBlip, 10)
end

function removeBlip()
    if shopBlip then
        RemoveBlip(shopBlip)
        shopBlip = nil
    end
end

function createNPC()
    if shopNPC then return shopNPC end

    RequestModel(Config.NPC.model)
    while not HasModelLoaded(Config.NPC.model) do Wait(500) end

    shopNPC = CreatePed(4, Config.NPC.model, Config.NPC.coords.x, Config.NPC.coords.y, Config.NPC.coords.z, Config.NPC.heading, false, true)
    if not shopNPC or shopNPC == 0 then return nil end

    SetEntityInvincible(shopNPC, true)
    SetBlockingOfNonTemporaryEvents(shopNPC, true)
    FreezeEntityPosition(shopNPC, true)
    SetPedDefaultComponentVariation(shopNPC)

    return shopNPC
end

function DeleteShopNPC()
    if shopNPC then
        DeletePed(shopNPC)
        shopNPC = nil
    end
end

AddEventHandler('onResourceStop', function(resourceName)
    if GetCurrentResourceName() == resourceName then 
        DeleteShopNPC()
        removeBlip()
    end
end)

AddEventHandler('onClientResourceStart', function(resourceName)
    if GetCurrentResourceName() == resourceName then
        Wait(1000)
        createNPC()
        createBlip()
    end
end)

-- Fungsi untuk membuat menu pembelian
RegisterNetEvent('itemshop:openPurchaseMenu')
AddEventHandler('itemshop:openPurchaseMenu', function(items)
    local options = {}
    
    for _, item in ipairs(items) do
        local itemData = QBCore.Shared.Items[item.name]
        if itemData then
            table.insert(options, {
                title = itemData.label,
                description = ("Harga: $%d | Stok: %d"):format(item.price, item.amount),
                icon = 'fas fa-shopping-cart',
                onSelect = function()
                    TriggerServerEvent('itemshop:buyItem', item.name, item.price)
                end,
                metadata = {
                    {label = 'Harga', value = ("$%d"):format(item.price)},
                    {label = 'Stok', value = item.amount},
                    {label = 'Berat', value = itemData.weight and ("%dkg"):format(itemData.weight) or "0kg"}
                }
            })
        end
    end

    lib.registerContext({
        id = 'shop_purchase_menu',
        title = 'Toko Madura (Libur kalau Kiamat)',
        options = options
    })

    lib.showContext('shop_purchase_menu')
end)

-- Fungsi untuk membuat menu penjualan
RegisterNetEvent('itemshop:openSellMenu')
AddEventHandler('itemshop:openSellMenu', function()
    local playerItems = QBCore.Functions.GetPlayerData().items
    local options = {}
    
    if playerItems then
        for _, item in pairs(playerItems) do
            if item and Config.ItemsForBuy[item.name] then
                local itemData = QBCore.Shared.Items[item.name]
                if itemData then
                    table.insert(options, {
                        title = itemData.label,
                        description = ("Jual seharga $%d"):format(Config.ItemsForBuy[item.name]),
                        icon = 'fas fa-dollar-sign',
                        onSelect = function()
                            TriggerServerEvent('itemshop:sellItem', item.name, Config.ItemsForBuy[item.name])
                        end,
                        metadata = {
                            {label = 'Harga Jual', value = ("$%d"):format(Config.ItemsForBuy[item.name])},
                            {label = 'Jumlah', value = item.amount},
                            {label = 'Berat', value = itemData.weight and ("%dkg"):format(itemData.weight) or "0kg"}
                        }
                    })
                end
            end
        end
    end

    if #options == 0 then
        options = {
            {
                title = 'Tidak ada barang yang bisa dijual',
                description = 'Kamu tidak memiliki barang yang bisa dijual di sini',
                icon = 'fas fa-times',
                disabled = true
            }
        }
    end

    lib.registerContext({
        id = 'shop_sell_menu',
        title = 'Jual Barang',
        options = options
    })

    lib.showContext('shop_sell_menu')
end)
