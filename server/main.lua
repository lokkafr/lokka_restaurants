lib.versionCheck('lokkafr/lokka_restaurants')

local jobs = require 'config.jobs'
local recipes = require 'config.recipes'

local clockins = {}
local stashes = {}
local crafting = {}

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
        crafting = crafting,
    } end)

    lib.callback.register('lokka_restaurants:getCraftingRecipesForBench', function(source, cID)
        local _d = { recipes = {}, title = crafting[cID].label }
        for i = 1, #crafting[cID].recipes do
            local _tR = crafting[cID].recipes[i]

            local requirements = ''
            for i2 = 1, #recipes[_tR].Cost do
                local item = exports.ox_inventory:Items(recipes[_tR].Cost[i2][1])
                if not item then goto continue end
                requirements = requirements .. ('x%d %s\r\n'):format(recipes[_tR].Cost[i2][2], item.label)
                ::continue::
            end

            _d.recipes[#_d.recipes + 1] = {
                title = recipes[_tR].Menu.title,
                description = ('Requirements:\r\n%s'):format(requirements),
                icon = recipes[_tR].Menu.icon,
                event = 'lokka_restaurants:client:beginCraft',
                args = { recipe = _tR, bench = cID, progress = recipes[_tR].Progress },
            }
        end
        return _d
    end)
end

-- Events
RegisterNetEvent('lokka_restaurants:beginCraft', function(args)
    local src = source
    local bench = crafting[args.bench]
    if not bench then return end

    if #(GetEntityCoords(GetPlayerPed(src)) - bench.coords) > 10 then return end

    local recipe = recipes[args.recipe]

    local removed = {}
    for i = 1, #recipe.Cost do
        if not exports.ox_inventory:RemoveItem(src, recipe.Cost[i][1], recipe.Cost[i][2]) then
            for k, v in pairs(removed) do
                exports.ox_inventory:AddItem(src, k, v)
            end
            removed = {}
            return
        end
        removed[recipe.Cost[i][1]] = (removed[recipe.Cost[i][1]] or 0) + recipe.Cost[i][2]
    end

    for i = 1, #recipe.Pay do
        if exports.ox_inventory:CanCarryItem(src, recipe.Pay[i][1], recipe.Pay[i][2]) then
            exports.ox_inventory:AddItem(src, recipe.Pay[i][1], recipe.Pay[i][2])
        end
    end
end)

RegisterNetEvent('onResourceStart', function(rN)
    if rN ~= GetCurrentResourceName() then return end

    for i = 1, #jobs do
        lib.print.debug(('-- Creating %s job --'):format(jobs[i].Job.name))
        if Ox.GetGroup(jobs[i].Job.name) then goto skip end
        Ox.CreateGroup(jobs[i].Job)
        ::skip::
    
        lib.print.debug('1. Registering stashes')
        for k, v in pairs(jobs[i].Stashes) do
            if not v then goto continue end
            local sID = ('%s_%s'):format(jobs[i].Job.name, (k):lower())
            exports.ox_inventory:RegisterStash(
                sID,
                ('%s %s'):format(jobs[i].Job.label, k),
                v.slots,
                v.maxWeight,
                nil,
                { [jobs[i].Job.name] = 0 },
                v.coords
            )

            stashes[#stashes + 1] = {
                coords = v.coords,
                size = v.size,
                rotation = v.rotation,
                label = ('Open %s'):format(k),
                sID = sID,
                job = jobs[i].Job.name,
            }
            ::continue::
        end
    
        lib.print.debug('2. Indexing clockin')
        local newIndex = #clockins + 1
        clockins[newIndex] = jobs[i].Clockin
        clockins[newIndex].job = jobs[i].Job.name

        lib.print.debug('3. Indexing crafting locations')
        for i2 = 1, #jobs[i].Crafting do
            local newIndex = #crafting + 1
            crafting[newIndex] = jobs[i].Crafting[i2]
            crafting[newIndex].job = jobs[i].Job.name
            crafting[newIndex].cID = newIndex
        end

        lib.print.debug(('-- Completed %s job --'):format(jobs[i].Job.name))
    end

    RegisterCallbacks()
end)