Config = {}

-- Konfigurasi NPC
Config.NPC = {
    model = "a_m_m_business_01",
    coords = vector3(-715.72, -923.82, 18.0),
    heading = 90.0
}

-- Konfigurasi Blip
Config.Blip = {
    sprite = 852,  -- ID sprite blip dari FiveM
    color = 47,   -- Warna blip
    scale = 0.7, -- Ukuran blip
    label = "Toko Madura" -- Label yang muncul di map
}

-- Daftar barang yang tersedia untuk dibeli
Config.ItemsForSale = {
    { name = "tosti", price = 2, amount = 50 },
    { name = "water_bottle", price = 2, amount = 50 },
    { name = "kurkakola", price = 2, amount = 50 },
    { name = "twerks_candy", price = 2, amount = 50 },
    { name = "snikkel_candy", price = 2, amount = 50 },
    { name = "sandwich", price = 2, amount = 50 },
    { name = "beer", price = 7, amount = 50 },
    { name = "whiskey", price = 10, amount = 50 },
    { name = "vodka", price = 12, amount = 50 },
    { name = "bandage", price = 100, amount = 50 },
    { name = "lighter", price = 2, amount = 50 },
    { name = "rolling_paper", price = 2, amount = 50 }
}

-- Daftar barang yang bisa dijual (opsional, bisa disesuaikan)
Config.ItemsForBuy = {
    tosti = 1,
    water_bottle = 1,
    kurkakola = 1,
    sandwich = 1,
    beer = 3,
    whiskey = 5,
    vodka = 6,
    lighter = 1
}
