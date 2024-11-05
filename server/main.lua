lib.versionCheck('lokkafr/lokka_restaurants')

local jobs = require 'config.jobs'
local general = require 'config.general'

local clockins = {}
local stashes = {}
local registers = {}
local blips = {}
local commissions = {}

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
        registers = registers,
        blips = blips,
    } end)

    lib.callback.register('lokka_restaurants:getNearbyPlayers', function(source)
        local src = source
        local oxPlayers = Ox.GetPlayers()
        local players = {}
        for i = 1, #oxPlayers do
            if oxPlayers[i].source ~= src and #(GetEntityCoords(oxPlayers[i].ped) - GetEntityCoords(GetPlayerPed(src))) <= 5 then
                players[#players + 1] = { value = oxPlayers[i].userId, label = oxPlayers[i].stateId }
            end
        end
        return players
    end)

    lib.callback.register('lokka_restaurants:createInvoice', function(source, userid, amount, job)
        local src = source
        local oPlayer = Ox.GetPlayerFromUserId(userid)
        lib.print.debug('Register - finding player', userid)
        if not oPlayer then return false end
        lib.print.debug('Register - checking dist', userid)
        if #(GetEntityCoords(oPlayer.ped) - GetEntityCoords(GetPlayerPed(src))) >= 5 then return end

        local acceptedInvoice = lib.callback.await('lokka_restaurants:client:createInvoice', oPlayer.source, job.label, amount)
        if not acceptedInvoice then return false end
        lib.print.debug('Register - finding char account')
        local charAccount = Ox.GetCharacterAccount(oPlayer.stateId)
        if not charAccount then return false end

        local paying = charAccount.removeBalance({ amount = amount, message = ('%s Invoice'):format(job.label), overdraw = false })
        if paying.success then
            local pPay = math.ceil(amount * commissions[job.id])
            Ox.GetPlayer(source).getAccount().addBalance({ amount = pPay, message = ('%s Commission'):format(job.label) })
            Ox.GetGroupAccount(job.id).addBalance({ amount = (amount - pPay), message = ('%s Invoice'):format(job.label) })
            return true
        end
        return false
    end)
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
    
        lib.print.debug('Registering stashes')
        for k, v in pairs(jobs[i].Stashes) do
            if not v then goto continue end
            local sID = ('%s_%s'):format(jobName, (k):lower())
            exports.ox_inventory:RegisterStash(
                sID,
                ('%s %s'):format(jobs[i].Job.label, k),
                v.slots,
                v.maxWeight,
                nil,
                v.job == true and { [jobName] = 0 } or nil,
                v.coords
            )

            stashes[#stashes + 1] = {
                coords = v.coords,
                size = v.size,
                rotation = v.rotation,
                label = ('Open %s'):format(k),
                sID = sID,
                job = (v.job == true) and jobName or nil,
            }
            ::continue::
        end
    
        lib.print.debug('Indexing clockin')
        local newIndex = #clockins + 1
        clockins[newIndex] = jobs[i].Clockin
        clockins[newIndex].job = jobName

        if general.Crafting then
            lib.print.debug('Indexing crafting locations')
            for i2 = 1, #jobs[i].Crafting do
                local cBench = jobs[i].Crafting[i2]
                cBench.groups = { [jobName] = 0 }
                exports.ox_inventory:RegisterCraftingBench(('%s_crafting_%d'):format(jobName, i2), cBench)
            end
        end

        lib.print.debug('Indexing registers')
        for i2 = 1, #jobs[i].Registers do
            local newIndex = #registers + 1
            registers[newIndex] = jobs[i].Registers[i2]
            registers[newIndex].job = {
                id = jobName,
                label = jobs[i].Job.label,
            }
        end

        lib.print.debug('Indexing blip')
        local newIndex = #blips + 1
        blips[newIndex] = jobs[i].Blip
        blips[newIndex].Label = jobs[i].Job.label

        lib.print.debug('Registering commission')
        commissions[jobName] = jobs[i].Job.commission or 0.25

        lib.print.debug(('-- Completed %s job --'):format(jobName))
    end

    RegisterCallbacks()
end)