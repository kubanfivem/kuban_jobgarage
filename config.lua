Config = {}

Config.Jobs = { "police" } -- Jobs that can access the system
Config.Framework = "QBCore" -- options: "ESX", "QBCore"
Config.Garages = {
    {
        job = "police",
        Locations = {
            { coords = vector3(380.86, -1613.24, 29.99), heading = 0.0 }
        },
        CustomizationPoint = {
            coords = vector3(401.02, -1618.11, 29.29),
            heading = 0.0
        },
        DeletePoint = {
            coords = vector3(377.79, -1616.86, 29.29),
            heading = 0.0
        },
        SpawnPoint = {
            coords = vector3(385.82, -1624.66, 29.29),
            heading = 320.54
        }
    }
}

Config.Categories = {
    ['General Duties'] = {
        { name = 'Police', model = 'police' },
        { name = 'Police Buffalo', model = 'police2' },
        { name = 'Police Vapid', model = 'police3' }
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
        { name = 'Police Cruiser', model = 'police4' },
        { name = 'Cavalcade', model = 'cavalcade' }
    },
    ['Australian Federal Police'] = {
        { name = 'Baller', model = 'baller' },
        { name = 'Cavalcade', model = 'cavalcade' }
    }
}

Config.InteractKey = 38 
Config.TextDrawDistance = 4.0 
Config.SpawnInVehicle = true
Config.CategoryTitle = 'POLICE'
Config.Plate = 'POLICE'

--- Repair Settings
Config.Timetorepair = 5000 -- 5 Seconds
Config.ProgressBarText = "Repairing Vehicle..."
Config.RepairSuccess = 'Vehicle repaired successfully.'
Config.NotInVehicle = 'You are not in a vehicle.'

-- Car Marker Settings
Config.CarTextUI = 'Press ~g~[E]~w~ to open ~y~garage'
Config.CarDrawMarker = 36

-- Customize Marker Settings
Config.CustomTextUI = 'Press ~g~[E]~w~ to Customize ~y~Vehicle'
Config.CustomDrawMarker = 27

Config.RepairIcon = 'fas fa-wrench'
Config.LiveryIcon = 'fas fa-paint-brush'
Config.ExtraIcon = 'fas fa-tools'
Config.ColorIcon = 'fas fa-palette'
Config.PlateIcon = 'fas fa-id-card'

-- Delete Marker Settings
Config.DeleteTextUI = 'Press ~g~[E]~w~ to ~r~Delete ~w~Vehicle'
Config.DeleteDrawMarker = 30
