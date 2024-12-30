local menuAcilmisMi = false
local aracKodu = "t20"
local aracSpawnEdildi = false
local oyuncuAractaMi = function()

    return IsPedInAnyVehicle(PlayerPedId(), false)
end

local menuGoster = function()
    if oyuncuAractaMi() then
        return
    end

    menuAcilmisMi = not menuAcilmisMi
    SetNuiFocus(menuAcilmisMi, menuAcilmisMi)
    SendNUIMessage({
        type = "toggleMenu",
        visible = menuAcilmisMi
    })
end

local aracSpawnEt = function()
    if aracSpawnEdildi then
        --"5 saniye delay"
        return
    end

    local oyuncuPed = PlayerPedId()
    local oyuncuKonum = GetEntityCoords(oyuncuPed)

    RequestModel(aracKodu)
    while not HasModelLoaded(aracKodu) do
        Wait(0)
    end

    local yeniArac = CreateVehicle(aracKodu, oyuncuKonum.x, oyuncuKonum.y, oyuncuKonum.z + 1.0, GetEntityHeading(oyuncuPed), true, false)
    TaskWarpPedIntoVehicle(oyuncuPed, yeniArac, -1)

    SetEntityAsNoLongerNeeded(yeniArac)
    SetModelAsNoLongerNeeded(aracKodu)

    aracSpawnEdildi = true
    SetTimeout(5000, function()
        aracSpawnEdildi = false
    end)

    menuAcilmisMi = false
    SetNuiFocus(false, false)
    SendNUIMessage({
        type = "toggleMenu",
        visible = false
    })
end

RegisterKeyMapping('menuTogla', 'Menüyü Aç/Kapat', 'keyboard', 'F1')
RegisterCommand('menuTogla', menuGoster)

RegisterNUICallback('spawnt20', function()
    aracKodu = "t20"
    aracSpawnEt()
end)

RegisterNUICallback('spawnArac', function(data)
    aracKodu = data.aracKodu or "t20"
    aracSpawnEt()
end)

RegisterNUICallback('closeMenu', function()
    menuAcilmisMi = false
    SetNuiFocus(false, false)
    SendNUIMessage({
        type = "toggleMenu",
        visible = false
    })
end)
