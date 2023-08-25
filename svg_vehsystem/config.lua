Config = {}

Config.OnlyJob = true

Config.EnabledJobs = { -- work only if Config.OnlyJob = true
    'police',
}

Config.Notify = function(msg, type)
    lib.notify({
        title = 'Server Name',
        description = msg,
        type = type,
        position = 'top-center'
    })
end

Config.ItemCleaning = 'sponge'
Config.ItemRepair = 'fixtool'

Lang = {
    analyze = 'Analyze Diagnostics',
    repair = 'Repair Vehicle',
    clean = 'Clean Vehicle',
    diagnostic = 'Diagnostics',
    plate = 'Plate Number: ',
    engine = 'Engine Status',
    fuel = 'Vehicle Fuel',
    temperature = 'Engine Temperature',
    oil = 'Oil Level',
    copied = 'You copied the license plate!',
    noRepairItem = 'You don\'t have a fixtool!',
    repairing = 'Repairing vehicle',
    alreadyClean = 'The vehicle is already clean!',
    noCleanItem = 'You don\'t have a sponge!',
    cleaning = 'Cleaning the vehicle',
    forCopy = 'Click to copy',
    noJob = 'You don\'t have the job',
}