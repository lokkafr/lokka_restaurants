lib.versionCheck('lokkafr/lokka_restaurants')

local jobs = require 'config.jobs'

local clockins = {}
local stashes = {}

-- Functions
local function RegisterCallbacks()
    lib.callback.register('lokka_restaurants:clockin', function(source, locationIndex)
        local src = source
    
        local clockLoc = clockins[locationIndex]
        if not clockLoc then return end
    
        if #(GetEntityCoords(GetPlayerPed(src)) - clockLoc.coords) > 10 then return end
        
        local Player = Ox.GetPlayer(src)
        if not Player then return end
    
        if not Player.getGroup(clockLoc.job) then return end
    
        local isClockedIn = Player.get('activeGroup') == clockLoc.job
        if isClockedIn then Player.setActiveGroup() else Player.setActiveGroup(clockLoc.job) end
        TriggerClientEvent('ox_lib:notify', src, {
            title = 'Job Status',
            description = ('You have been clocked %s.'):format(isClockedIn and 'out' or 'in'),
            type = 'success'
        })
        return true
    end)
    
    lib.callback.register('lokka_restaurants:getData', function(source) return {
        clockins = clockins,
        stashes = stashes,
    } end)
end

-- Events
RegisterNetEvent('onResourceStart', function(rN)
    if rN ~= GetCurrentResourceName() then return end

    for i = 1, #jobs do
        local jobName = jobs[i].Job.name
        lib.print.debug(('-- Creating %s job --'):format(jobName))
        if Ox.GetGroup(jobName) then goto skip end
        Ox.CreateGroup(jobs[i].Job)
        ::skip::
    
        lib.print.debug('1. Registering stashes')
        for k, v in pairs(jobs[i].Stashes) do
            if not v then goto continue end
            local sID = ('%s_%s'):format(jobName, (k):lower())
            exports.ox_inventory:RegisterStash(
                sID,
                ('%s %s'):format(jobs[i].Job.label, k),
                v.slots,
                v.maxWeight,
                nil,
                { [jobName] = 0 },
                v.coords
            )

            stashes[#stashes + 1] = {
                coords = v.coords,
                size = v.size,
                rotation = v.rotation,
                label = ('Open %s'):format(k),
                sID = sID,
                job = jobName,
            }
            ::continue::
        end
    
        lib.print.debug('2. Indexing clockin')
        local newIndex = #clockins + 1
        clockins[newIndex] = jobs[i].Clockin
        clockins[newIndex].job = jobName

        lib.print.debug('3. Indexing crafting locations')
        for i2 = 1, #jobs[i].Crafting do
            exports.ox_inventory:RegisterCraftingBench(('%s_crafting_%d'):format(jobName, i2), jobs[i].Crafting)
        end

        lib.print.debug(('-- Completed %s job --'):format(jobName))
    end

    RegisterCallbacks()
end)