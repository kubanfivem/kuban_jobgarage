Config = {}

Config.Jobs = { "police" } -- Jobs that can access the system
Config.Framework = "QBCore" -- options: "ESX", "QBCore"
Config.Garages = {
    {
        job = "police",
        Locations = {
            { coords = vector3(461.23, -980.37, 26.68), heading = 0.0 }
        },
        CustomizationPoint = {
            coords = vector3(451.2963, -976.3116, 25.6998),
            heading = 0.0
        },
        DeletePoint = {
            coords = vector3(459.2846, -992.4221, 26.2998),
            heading = 0.0
        }
    }
}

Config.Categories = {
    ['General Duties'] = {
        { name = 'HSV', model = '14HSV' },
        { name = 'Buffalo', model = 'buffalo' }
    },
    ['Highway Patrol'] = {
        { name = 'Baller', model = 'baller' },
        { name = 'Cavalcade', model = 'cavalcade' }
    },
    ['Tactical Unit'] = {
        { name = 'Baller', model = 'baller' },
        { name = 'Cavalcade', model = 'cavalcade' }
    },
    ['Criminal Investagation Branch'] = {
        { name = 'Baller', model = 'baller' },
        { name = 'Cavalcade', model = 'cavalcade' }
    },
    ['Australian Federal Police'] = {
        { name = 'Baller', model = 'baller' },
        { name = 'Cavalcade', model = 'cavalcade' }
    }
}

Config.SpawnPoint = {
    coords = vector3(445.3, -986.22, 25.7),
    heading = 262.85
}

Config.InteractKey = 38 
Config.TextDrawDistance = 5.0 
Config.SpawnInVehicle = true
Config.CategoryTitle = 'SAPF'

-- Car Marker Settings
Config.CarTextUI = 'Press ~g~[E]~w~ to open ~y~garage'
Config.CarDrawMarker = 36

-- Customize Marker Settings
Config.CustomTextUI = 'Press ~g~[E]~w~ to Customize ~y~Vehicle'
Config.CustomDrawMarker = 27

-- Delete Marker Settings
Config.DeleteTextUI = 'Press ~g~[E]~w~ to ~r~Delete ~w~Vehicle'
Config.DeleteDrawMarker = 30
