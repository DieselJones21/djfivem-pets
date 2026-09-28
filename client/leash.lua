local rope = 0
local leashActive = false
local texturesReady = false

local function loadRopeTextures()
    if texturesReady and RopeAreTexturesLoaded() then
        return true
    end
    RopeLoadTextures()
    local timeout = GetGameTimer() + 3000
    while not RopeAreTexturesLoaded() do
        if GetGameTimer() > timeout then return false end
        Wait(20)
    end
    texturesReady = true
    return true
end

function StopLeash()
    leashActive = false
    LocalPet.walking = false
    if rope ~= 0 then
        DeleteRope(rope)
        rope = 0
    end
end

function StartLeash()
    if not IsLocalPetOut() then return false end
    StopLeash()
    if not loadRopeTextures() then return false end

    local playerPed = PlayerPedId()
    local pcoords = GetEntityCoords(playerPed)
    local length = Config.Leash.length

    rope = AddRope(pcoords.x, pcoords.y, pcoords.z, 0.0, 0.0, 0.0, length, Config.Leash.type, length, 0.1, 0.5, false, false, false, 1.0, false, 0)
    if rope == 0 then return false end

    LocalPet.walking = true
    LocalPet.staying = false
    LocalPet.sitting = false
    leashActive = true

    local handBone = GetPedBoneIndex(playerPed, 57005)
    local neckBone = GetPedBoneIndex(LocalPet.ped, 39317)

    CreateThread(function()
        while leashActive and IsLocalPetOut() and rope ~= 0 do
            local owner = PlayerPedId()
            local animal = LocalPet.ped
            if not DoesEntityExist(animal) or IsPedInAnyVehicle(owner, false) then
                StopLeash()
                TriggerServerEvent('djfivem-pets:server:setWalking', false)
                break
            end

            local hand = GetWorldPositionOfEntityBone(owner, handBone)
            local neck = GetWorldPositionOfEntityBone(animal, neckBone)
            if hand.x == 0.0 then hand = GetOffsetFromEntityInWorldCoords(owner, 0.2, 0.2, 0.35) end
            if neck.x == 0.0 then neck = GetOffsetFromEntityInWorldCoords(animal, 0.0, 0.15, 0.35) end

            AttachEntitiesToRope(rope, owner, animal, hand.x, hand.y, hand.z, neck.x, neck.y, neck.z, length, false, false, 0, 0)
            Wait(50)
        end
    end)

    return true
end

RegisterNetEvent('djfivem-pets:client:startWalk', function()
    StartLeash()
end)

RegisterNetEvent('djfivem-pets:client:stopWalk', function()
    StopLeash()
end)

AddEventHandler('onResourceStop', function(resource)
    if resource == GetCurrentResourceName() then
        StopLeash()
    end
end)
