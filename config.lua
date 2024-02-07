Config = {}

-----------------------------------------------------------------------------------
----------------------------------Webhook Settings---------------------------------
-----------------------------------------------------------------------------------
Config.EnableWebHook = false
Config.WHTitle = 'Bank:'
Config.WHLink = ''  -- Discord WH link Here
Config.WHColor = 16711680 -- red
Config.WHName = 'Bank:' -- name
Config.WHLogo = '' -- must be 30x30px
Config.WHFooterLogo = '' -- must be 30x30px
Config.WHAvatar = '' -- must be 30x30px

Config.defaultlang = "de_lang" -- Set Language (Current Languages: "en_lang" English, "de_lang" German)


Config.BankingBlips = true
Config.BlipSprite = 'blip_cash_bag'
Config.CreateNPC = true

Config.BankPositions = {
    {
        coords = vector3(-810.73, -1275.36, 43.64),--- Also the Location of Blip and Npc (Blackwater)
        NpcHeading = 179.53,
    },
    {
        coords = vector3(-307.92, 773.98, 118.7),--- Also the Location of Blip and Npc (Valentine)
        NpcHeading = 5.09,
    },
    {
        coords = vector3(1291.14, -1303.21, 77.04),--- Also the Location of Blip and Npc (Rhodes)
        NpcHeading = 318.87,
    },
    {
        coords = vector3(2644.98, -1293.9, 52.25),--- Also the Location of Blip and Npc (SaintDenise)},
        NpcHeading = 24.66,
    },
}


Config.VaultPrice = 50  -- Initial Price to Buy a Vault
Config.UpgradeCosts = 100 -- upgradecost Per level
Config.Maxlevel = 5  -- you can make inly level 1 or till 2 Max Level is 5 if you do Maxlevel to 6 it wont work
Config.Level1 = 100 --- Start Storage Size 
Config.Level2 = 200 --- Increased by 200 New size will be 300
Config.Level3 = 300 --- Increased by 300 New Size will be 600
Config.Level4 = 400 --- Increased by 400 New Size will be 1000
Config.Level5 = 500 --- Increased by 500 New Size will be 1500

Config.Doors       = {
    [2642457609] = 0, -- Valentine bank, front entrance, left door
    [3886827663] = 0, -- Valentine bank, front entrance, right door
    [1340831050] = 0, -- Valentine bank, gate to tellers
    [576950805]  = 0, -- Valentine bank, vault door
    [3718620420] = 0, -- Valentine bank, door behind tellers
    [2343746133] = 0, -- Valentine bank, door to backrooms
    [2307914732] = 0, -- Valentine bank, back door
    [334467483]  = 0, -- Valentine bank, door to hall in vault antechamber
    [1733501235] = 0, -- Saint Denis bank, west entrance, right door
    [2158285782] = 0, -- Saint Denis bank, west entrance, left door
    [1634115439] = 0, -- Saint Denis bank, manager's office, right door
    [965922748]  = 0, -- Saint Denis bank, manager's office, left door
    [2817024187] = 0, -- Saint Denis bank, north entrance, left door
    [2089945615] = 0, -- Saint Denis bank, north entrance, right door
    [1751238140] = 0, -- Saint Denis bank, vault
    [531022111]  = 0, -- Blackwater bank, entrance
    [2817192481] = 0, -- Blackwater bank, office
    [2117902999] = 0, -- Blackwater bank, teller gate
    [1462330364] = 0, -- Blackwater bank, vault
    [3317756151] = 0, -- Rhodes bank, front entrance, left door
    [3088209306] = 0, -- Rhodes bank, front entrance, right door
    [2058564250] = 0, -- Rhodes bank, door to backrooms
    [1634148892] = 0, -- Rhodes bank, teller gate
    [3483244267] = 0, -- Rhodes bank, vault
    [3142122679] = 1, -- Rhodes bank, back entrance
    [2446974165] = 0, -- Rhodes saloon, bath room door
    [340151973]  = 0, -- Saint Denis theatre, right door
    [544106233]  = 0, -- Saint Denis theatre, left door
    [1457151494] = 0, -- Saint Denis theatre, behind counter, right door
    [1688533403] = 0, -- Saint Denis theatre, behind counter, left door
    [1239033969] = 0, -- Farm house outside emerald ranch, bedroom door
    [3074790964] = 0, -- Geddes ranch house
    [3101287960] = 0, -- Armadillo bank, front door
    [3550475905] = 0, -- Armadillo bank, teller gate
    [1366165179] = 0, -- Armadillo bank, back door
    [772977516]  = 0, -- Slaver catcher house, north door
    [527767089]  = 0, -- Slaver catcher house, south door
    [3804893186] = 0, -- Saint Denis tailor, dressing room
    [2432590327] = 0, -- Rhodes general store, dressing room
    [3554893730] = 0, -- Valentine general store, dressing room
    [94437577]   = 0, -- Strawberry general store, dressing room
    [3277501452] = 0, -- Blackwater tailor, dressing room
    [3208189941] = 0, -- Tumbleweed tailor, dressing room
    [3142465793] = 0, -- Wallace Station general store, dressing room
    [1962482653] = 0, -- River boat, upper deck vault room, east door
    [2181772801] = 0, -- River boat, upper deck vault room, west door
    [1275379652] = 0, -- River boat, upper deck cabin, east door
    [4267779198] = 0, -- River boat, upper deck cabin, west door
    [1509055391] = 0, -- River boat, upper deck cabin, south doors, right door
    [2811033299] = 0, -- River boat, upper deck cabin, south doors, left door
    [586229709]  = 0, -- Saint Denis doctor, door between store and waiting room
    [1707768866] = 0, -- Galarie Laurent, manager's office
    [1657401918] = 1, -- Annesburg sheriff's office, left cell
    [1502928852] = 1, -- Annesburg sheriff's office, right cell
    [202296518]  = 0, -- Six Point Cabin
    [3782668011] = 0, -- Aberdeen Pig Farm south door
    [1423877126] = 0, -- Tumbleweed bath room door
    [3013877606] = 0, -- Tumbleweed bath, side room door
    [553939906]  = 0, -- Shady Belle, upstairs, right door
    [357129292]  = 0, -- Shady Belle, upstairs, left door
    [1523300673] = 0, -- Blackwater bath, north door
    [1915401053] = 0, -- Saint Denis tram station, east counter door
    [187523632]  = 0, -- Saint Denis tram station, west counter door
    [831345624]  = 1, -- Tumbleweed jail cell
    [2984805596] = 1, -- Tumbleweed jail, left cell door
    [2677989449] = 1, -- Tumbleweed jail, right cell door
    [1711767580] = 1, -- Saint Denis jail cell
    [193903155]  = 1, -- Valentine jail cell
    [295355979]  = 1, -- Valentine jail cell
    [1878514758] = 1, -- Rhodes jail cell
    [2514996158] = 1, -- Blackwater jail cell
    [2167775834] = 1, -- Blackwater jail cell
    [902070893]  = 1, -- Strawberry jail cell
    [1207903970] = 1, -- Strawberry jail cell
    [4016307508] = 1, -- Armadillo jail cell
    [4235597664] = 1, -- Amradillo jail cell
}