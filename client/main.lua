local general = require 'config.general'
local zones = {}
local blips = {}

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

for i = 1, #data.registers do
    local r = data.registers[i]
    r.debug = general.Zones.Debug
    r.drawSprite = general.Zones.Sprite
    r.options = {
        label = 'Register',
        icon = 'fas fa-cash-register',
        groups = r.job.id,
        onSelect = function (_)
            local options = lib.callback.await('lokka_restaurants:getNearbyPlayers', false)
            local input = lib.inputDialog('Register', {
                {
                    type = 'select',
                    label = 'State ID',
                    options = options,
                    icon = 'fas fa-id-card',
                    required = true,
                },
                {
                    type = 'number',
                    label = 'Amount',
                    icon = 'fas fa-money-bill',
                    required = true,
                    min = 0,
                },
            })

            if not input then return end
            local invoicePaid = lib.callback.await('lokka_restaurants:createInvoice', false, tonumber(input[1]), tonumber(input[2]), r.job)
            lib.notify({
                title = 'Invoice Status',
                description = invoicePaid and 'Paid' or 'Unpaid',
                type = invoicePaid and 'success' or 'error'
            })
        end,
        distance = 2,
    }
    zones[#zones+1] = exports.ox_target:addBoxZone(r)
end

for i = 1, #data.blips do
    local b = data.blips[i]
    local blip = AddBlipForCoord(b.Coords)
    SetBlipSprite(blip, b.Sprite)
    SetBlipDisplay(blip, 4)
    SetBlipScale(blip, b.Size)
    SetBlipColour(blip, b.Color)
    SetBlipAsShortRange(blip, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString(b.Label)
    EndTextCommandSetBlipName(blip)
    if general.BlipCategory then SetBlipCategory(blip, 11) end
    blips[#blips+1] = blip
end

RegisterNetEvent('onResourceStop', function(rN)
    if rN ~= GetCurrentResourceName() then return end
    for i = 1, #zones do exports.ox_target:removeZone(zones[i]) end
    for i = 1, #blips do RemoveBlip(blips[i]) end
end)

lib.callback.register('lokka_restaurants:client:createInvoice', function(job, amount)
    local alert = lib.alertDialog({
        header = ('%s Invoice'):format(job),
        content = ('Do you agree to pay $%d?'):format(amount),
        centered = true,
        cancel = true,
    })
    return alert == 'confirm'
end)