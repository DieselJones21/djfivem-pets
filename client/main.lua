LocalPet = {
    ped = 0,
    netId = 0,
    petId = nil,
    species = nil,
    walking = false,
    staying = false,
    sitting = false,
    attacking = false,
}

local collarObject = 0

local function dbg(...)
    if Config.Debug then
        print('[djfivem-pets]', ...)
    end
end

local function loadModel(model)
    if not IsModelValid(model) then return false end
    if HasModelLoaded(model) then return true end
    RequestModel(model)
    local timeout = GetGameTimer() + 5000
    while not HasModelLoaded(model) do
        if GetGameTimer() > timeout then return false end
        Wait(10)
    end
    return true
end

local function loadAnim(dict)
    if HasAnimDictLoaded(dict) then return true end
    RequestAnimDict(dict)
    local timeout = GetGameTimer() + 4000
    while not HasAnimDictLoaded(dict) do
        if GetGameTimer() > timeout then return false end
        Wait(10)
    end
    return true
end

function IsLocalPetOut()
    return LocalPet.ped ~= 0 and DoesEntityExist(LocalPet.ped)
end

function GetLocalPetPed()
    if IsLocalPetOut() then return LocalPet.ped end
    return 0
end

function DeleteCollar()
    if collarObject ~= 0 and DoesEntityExist(collarObject) then
        DeleteObject(collarObject)
    end
    collarObject = 0
end

function AttachCollar(ped, species)
    DeleteCollar()
    local animal = Config.Animals[species]
    if not animal or not animal.collar then return end

    local model = `p_cs_collar_01`
    if not loadModel(model) then return end

    local coords = GetEntityCoords(ped)
    local obj = CreateObject(model, coords.x, coords.y, coords.z, true, true, false)
    local cfg = animal.collar
    AttachEntityToEntity(
        obj,
        ped,
        GetPedBoneIndex(ped, cfg.bone),
        cfg.offset.x, cfg.offset.y, cfg.offset.z,
        cfg.rot.x, cfg.rot.y, cfg.rot.z,
        true, true, false, true, 1, true
    )
    collarObject = obj
    SetModelAsNoLongerNeeded(model)
end

function DespawnLocalPet()
    StopLeash()
    DeleteCollar()
    if LocalPet.ped ~= 0 and DoesEntityExist(LocalPet.ped) then
        if GetResourceState('ox_target') == 'started' then
            pcall(function()
                exports.ox_target:removeLocalEntity(LocalPet.ped)
            end)
        end
        DeletePed(LocalPet.ped)
    end
    LocalPet.ped = 0
    LocalPet.netId = 0
    LocalPet.petId = nil
    LocalPet.species = nil
    LocalPet.walking = false
    LocalPet.staying = false
    LocalPet.sitting = false
    LocalPet.attacking = false
end

local function placeOnGround(ped)
    local c = GetEntityCoords(ped)
    local found, groundZ = GetGroundZFor_3dCoord(c.x, c.y, c.z + 2.0, false)
    if found then
        SetEntityCoords(ped, c.x, c.y, groundZ, false, false, false, false)
    end
end

function SpawnLocalPet(meta)
    if IsLocalPetOut() then
        DespawnLocalPet()
    end

    local animal = Config.Animals[meta.species]
    if not animal then return nil end
    if not loadModel(animal.model) then return nil end

    local playerPed = PlayerPedId()
    local coords = GetOffsetFromEntityInWorldCoords(playerPed, 0.35, 1.6, 0.0)
    local heading = GetEntityHeading(playerPed) + 180.0

    local ped = CreatePed(28, animal.model, coords.x, coords.y, coords.z, heading, true, true)
    SetEntityAsMissionEntity(ped, true, true)
    SetModelAsNoLongerNeeded(animal.model)
    placeOnGround(ped)

    SetBlockingOfNonTemporaryEvents(ped, true)
    SetPedFleeAttributes(ped, 0, false)
    SetPedCombatAttributes(ped, 5, true)
    SetPedCombatAttributes(ped, 46, true)
    SetPedCombatAbility(ped, 2)
    SetPedCombatMovement(ped, 2)
    SetCanAttackFriendly(ped, true, false)
    SetPedCanRagdollFromPlayerImpact(ped, false)
    SetEntityInvincible(ped, false)
    SetPedDiesWhenInjured(ped, true)
    SetPedCanBeTargetted(ped, true)
    SetPedKeepTask(ped, true)
    SetPedRelationshipGroupHash(ped, `ANIMAL`)
    SetPedAsGroupMember(ped, GetPedGroupIndex(playerPed))

    if meta.texture then
        SetPedComponentVariation(ped, 0, 0, meta.texture, 0)
    end

    local hp = 100 + math.max(1, Round(meta.health or 100))
    SetEntityMaxHealth(ped, 200)
    SetEntityHealth(ped, hp)

    NetworkRegisterEntityAsNetworked(ped)
    local netId = NetworkGetNetworkIdFromEntity(ped)
    SetNetworkIdCanMigrate(netId, false)
    SetNetworkIdExistsOnAllMachines(netId, true)

    LocalPet.ped = ped
    LocalPet.netId = netId
    LocalPet.petId = meta.petId
    LocalPet.species = meta.species
    LocalPet.walking = false
    LocalPet.staying = false
    LocalPet.sitting = false
    LocalPet.attacking = false

    if meta.collar then
        AttachCollar(ped, meta.species)
    end

    AddPetTarget(ped)
    TaskFollowToOffsetOfEntity(ped, playerPed, 0.9, 0.0, 0.0, 5.0, -1, Config.FollowDistance, true)
    dbg('spawned', meta.species, netId)
    return netId
end

local function warpPetIntoVehicle(playerPed)
    if not Config.PetsEnterVehicles or not IsLocalPetOut() then return end
    if LocalPet.walking or LocalPet.attacking then return end
    local veh = GetVehiclePedIsIn(playerPed, false)
    if veh == 0 then return end
    if IsPedInAnyVehicle(LocalPet.ped, false) then return end

    local seats = GetVehicleMaxNumberOfPassengers(veh)
    for seat = 0, seats - 1 do
        if IsVehicleSeatFree(veh, seat) then
            SetPedIntoVehicle(LocalPet.ped, veh, seat)
            return
        end
    end
end

local function warpPetOutOfVehicle(playerPed)
    if not IsLocalPetOut() then return end
    if not IsPedInAnyVehicle(LocalPet.ped, false) then return end
    local coords = GetOffsetFromEntityInWorldCoords(playerPed, 0.6, 1.2, 0.0)
    ClearPedTasksImmediately(LocalPet.ped)
    SetEntityCoords(LocalPet.ped, coords.x, coords.y, coords.z, false, false, false, false)
    placeOnGround(LocalPet.ped)
end

local function followOwner()
    if not IsLocalPetOut() or LocalPet.staying or LocalPet.sitting or LocalPet.attacking then return end
    local playerPed = PlayerPedId()
    if IsPedInAnyVehicle(playerPed, false) then return end
    if IsPedInAnyVehicle(LocalPet.ped, false) then return end

    local dist = #(GetEntityCoords(playerPed) - GetEntityCoords(LocalPet.ped))
    local speed = 4.5
    if IsPedSprinting(playerPed) then
        speed = 10.0
    elseif IsPedRunning(playerPed) then
        speed = 7.5
    end

    local followDist = LocalPet.walking and Config.WalkFollowDistance or Config.FollowDistance
    if dist > Config.TeleportDistance then
        local coords = GetOffsetFromEntityInWorldCoords(playerPed, 0.4, 1.4, 0.0)
        SetEntityCoords(LocalPet.ped, coords.x, coords.y, coords.z, false, false, false, false)
        placeOnGround(LocalPet.ped)
    elseif dist > followDist then
        TaskFollowToOffsetOfEntity(LocalPet.ped, playerPed, 0.8, 0.0, 0.0, speed, -1, followDist, true)
    end
end

function SetPetStay(stay)
    if not IsLocalPetOut() then return end
    LocalPet.staying = stay
    LocalPet.sitting = false
    if stay then
        ClearPedTasks(LocalPet.ped)
        TaskStandStill(LocalPet.ped, -1)
    else
        followOwner()
    end
end

function SetPetSit(sit)
    if not IsLocalPetOut() then return end
    LocalPet.sitting = sit
    LocalPet.staying = sit
    ClearPedTasks(LocalPet.ped)
    if not sit then
        followOwner()
        return
    end

    local animal = Config.Animals[LocalPet.species]
    if animal and animal.sitScenario then
        TaskStartScenarioInPlace(LocalPet.ped, animal.sitScenario, 0, true)
    else
        TaskStandStill(LocalPet.ped, -1)
    end
end

function PlayPettingAnims()
    if not IsLocalPetOut() then return end
    local playerPed = PlayerPedId()
    local owner = Config.Anims.petOwner
    local dog = Config.Anims.petDog
    if loadAnim(owner.dict) then
        TaskPlayAnim(playerPed, owner.dict, owner.clip, 8.0, -8.0, owner.duration, 0, 0.0, false, false, false)
    end
    if Config.Animals[LocalPet.species] and Config.Animals[LocalPet.species].canAttack and loadAnim(dog.dict) then
        TaskPlayAnim(LocalPet.ped, dog.dict, dog.clip, 8.0, -8.0, dog.duration, 0, 0.0, false, false, false)
    end
end

function PlayFeedAnim()
    local playerPed = PlayerPedId()
    local anim = Config.Anims.feedOwner
    if loadAnim(anim.dict) then
        TaskPlayAnim(playerPed, anim.dict, anim.clip, 8.0, -8.0, anim.duration, 48, 0.0, false, false, false)
    end
end

function GetAimPed()
    local player = PlayerId()
    local aiming, entity = GetEntityPlayerIsFreeAimingAt(player)
    if aiming and DoesEntityExist(entity) and IsEntityAPed(entity) and entity ~= LocalPet.ped then
        return entity
    end

    local camCoord = GetGameplayCamCoord()
    local rot = GetGameplayCamRot(2)
    local dir = vector3(
        -math.sin(math.rad(rot.z)) * math.abs(math.cos(math.rad(rot.x))),
        math.cos(math.rad(rot.z)) * math.abs(math.cos(math.rad(rot.x))),
        math.sin(math.rad(rot.x))
    )
    local dest = camCoord + (dir * 18.0)
    local handle = StartShapeTestRay(camCoord.x, camCoord.y, camCoord.z, dest.x, dest.y, dest.z, 8, PlayerPedId(), 0)
    local _, didHit, _, _, entity = GetShapeTestResult(handle)
    if didHit == 1 and DoesEntityExist(entity) and IsEntityAPed(entity) and entity ~= LocalPet.ped then
        return entity
    end
    return 0
end

function CommandAttack(target)
    if not IsLocalPetOut() then return false end
    local animal = Config.Animals[LocalPet.species]
    if not animal or not animal.canAttack then return false end
    if target == 0 or not DoesEntityExist(target) then return false end
    if target == PlayerPedId() then return false end

    if LocalPet.walking then
        StopLeash()
        LocalPet.walking = false
        TriggerServerEvent('djfivem-pets:server:setWalking', false)
    end

    LocalPet.staying = false
    LocalPet.sitting = false
    LocalPet.attacking = true
    ClearPedTasks(LocalPet.ped)
    TaskCombatPed(LocalPet.ped, target, 0, 16)

    SetTimeout(Config.AttackTimeout, function()
        if LocalPet.attacking then
            LocalPet.attacking = false
            if IsLocalPetOut() then
                ClearPedTasks(LocalPet.ped)
                followOwner()
            end
        end
    end)
    return true
end

CreateThread(function()
    local wasInVehicle = false
    local lastMapped = -1
    while true do
        local sleep = 750
        if IsLocalPetOut() then
            sleep = 400
            local playerPed = PlayerPedId()
            local inVehicle = IsPedInAnyVehicle(playerPed, false)

            if inVehicle and not wasInVehicle then
                if LocalPet.walking then
                    StopLeash()
                    LocalPet.walking = false
                    TriggerServerEvent('djfivem-pets:server:setWalking', false)
                end
                warpPetIntoVehicle(playerPed)
            elseif (not inVehicle) and wasInVehicle then
                warpPetOutOfVehicle(playerPed)
            end
            wasInVehicle = inVehicle

            if IsPedDeadOrDying(LocalPet.ped, true) then
                TriggerServerEvent('djfivem-pets:server:petKilled')
                Wait(800)
                DespawnLocalPet()
                lastMapped = -1
            else
                local entityHp = GetEntityHealth(LocalPet.ped)
                if entityHp > 0 then
                    local mapped = Clamp(entityHp - 100, 0, 100)
                    if lastMapped < 0 or math.abs(mapped - lastMapped) >= 5 then
                        lastMapped = mapped
                        TriggerServerEvent('djfivem-pets:server:syncHealth', mapped)
                    end
                end
                followOwner()
            end
        else
            lastMapped = -1
            wasInVehicle = false
        end
        Wait(sleep)
    end
end)

lib.callback.register('djfivem-pets:spawnPet', function(meta)
    return SpawnLocalPet(meta)
end)

lib.callback.register('djfivem-pets:despawnPet', function()
    DespawnLocalPet()
    return true
end)

lib.callback.register('djfivem-pets:getAttackTarget', function()
    local target = GetAimPed()
    if target == 0 then return nil end
    if IsPedAPlayer(target) then
        return {
            isPlayer = true,
            serverId = GetPlayerServerId(NetworkGetPlayerIndexFromPed(target)),
        }
    end
    return {
        isPlayer = false,
        netId = NetworkGetNetworkIdFromEntity(target),
    }
end)

RegisterNetEvent('djfivem-pets:client:forceDespawn', function()
    DespawnLocalPet()
end)

RegisterNetEvent('djfivem-pets:client:collarAttached', function()
    if IsLocalPetOut() then
        AttachCollar(LocalPet.ped, LocalPet.species)
    end
end)

RegisterNetEvent('djfivem-pets:client:playPet', function()
    PlayPettingAnims()
end)

RegisterNetEvent('djfivem-pets:client:playFeed', function()
    PlayFeedAnim()
end)

RegisterNetEvent('djfivem-pets:client:setStay', function(stay)
    SetPetStay(stay)
end)

RegisterNetEvent('djfivem-pets:client:setSit', function(sit)
    SetPetSit(sit)
end)

RegisterNetEvent('djfivem-pets:client:attack', function(payload)
    local target = 0
    if payload and payload.isPlayer and payload.serverId then
        local player = GetPlayerFromServerId(payload.serverId)
        if player ~= -1 then
            target = GetPlayerPed(player)
        end
    elseif payload and payload.netId then
        target = NetworkGetEntityFromNetworkId(payload.netId)
    end
    CommandAttack(target)
end)

RegisterNetEvent('djfivem-pets:client:notify', function(key, nType, ...)
    lib.notify({
        title = locale('resource_name'),
        description = locale(key, ...),
        type = nType or 'inform',
    })
end)

AddEventHandler('onResourceStop', function(resource)
    if resource == GetCurrentResourceName() then
        DespawnLocalPet()
    end
end)
