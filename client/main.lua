local general = require 'config.general'
local zones = {}

local function ShowCraftingMenu(craftingID)
    local data = lib.callback.await('lokka_restaurants:getCraftingRecipesForBench', false, craftingID)
    lib.registerContext({
        id = 'lokka_crafting',
        title = data.title,
        options = data.recipes,
    })
    lib.showContext('lokka_crafting')
end

local data = lib.callback.await('lokka_restaurants:getData', false)

for i = 1, #data.clockins do
    local aG = Ox.GetPlayer().get('activeGroup')
    local z = data.clockins[i]
    z.debug = general.Zones.Debug
    z.drawSprite = general.Zones.Sprite
    z.options = {
        {
            label = 'Clock In',
            icon = 'fas fa-clock',
            groups = z.job,
            onSelect = function (_) lib.callback('lokka_restaurants:clockin', false, function() end, i) end,
            canInteract = function(_, _, _, _, _) return aG ~= z.job end,
            distance = 2,
        },
        {
            label = 'Clock Out',
            icon = 'fas fa-clock',
            groups = z.job,
            onSelect = function (_) lib.callback('lokka_restaurants:clockin', false, function() end, i) end,
            canInteract = function(_, _, _, _, _) return aG == z.job end,
            distance = 2,
        },
    }
    zones[#zones+1] = exports.ox_target:addBoxZone(z)
end

for i = 1, #data.stashes do
    local s = data.stashes[i]
    s.debug = general.Zones.Debug
    s.drawSprite = general.Zones.Sprite
    s.options = {
        label = s.label,
        icon = 'fas fa-box',
        groups = s.job,
        onSelect = function (_) exports.ox_inventory:openInventory('stash', s.sID) end,
        distance = 2,
    }
    zones[#zones+1] = exports.ox_target:addBoxZone(s)
end

for i = 1, #data.crafting do
    local c = data.crafting[i]
    c.debug = general.Zones.Debug
    c.drawSprite = general.Zones.Sprite
    c.options = {
        label = c.label,
        icon = c.icon,
        groups = c.job,
        onSelect = function (_) ShowCraftingMenu(c.cID) end,
        distance = 2,
    }
    zones[#zones+1] = exports.ox_target:addBoxZone(c)
end

RegisterNetEvent('onResourceStop', function(rN)
    if rN ~= GetCurrentResourceName() then return end
    for i = 1, #zones do exports.ox_target:removeZone(zones[i]) end
end)

RegisterNetEvent('lokka_restaurants:client:beginCraft', function(args)
    if lib.progressBar({
        duration = args.progress.time,
        label = args.progress.label,
        useWhileDead = false,
        canCancel = true,
        disable = { move = true, car = true, combat = true, sprint = true, },
        anim = args.progress.anim,
    }) then TriggerServerEvent('lokka_restaurants:beginCraft', args) end
end)