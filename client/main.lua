local general = require 'config.general'
local zones = {}

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

RegisterNetEvent('onResourceStop', function(rN)
    if rN ~= GetCurrentResourceName() then return end
    for i = 1, #zones do exports.ox_target:removeZone(zones[i]) end
end)