local Handler = {
    Data = {
        isPlayerLoaded = false
    },
    playerModel = "mp_m_freemode_01",
    autoSpawn = true,
    spawnCoords = vec3(-1.5707, 17.7441, 71.0760),
    spawnHeading = 50.0,
}



function Handler:OnLoadPlayer()
    self.Data.isPlayerLoaded = true

    if self.autoSpawn then
        Handler:AutoSpawn()
    end

end


function Handler:AutoSpawn()

    DoScreenFadeOut(100)

    Wait(500)

    local model = self.playerModel
    RequestModel(model)
    while not HasModelLoaded(model) do
        Wait(250)
    end

    SetPlayerModel(PlayerId(), model)

    local x,y,z = table.unpack(self.spawnCoords)

    RequestCollisionAtCoord(x, y, z)

    SetEntityCoordsNoOffset(PlayerPedId(), x, y, z, false, false, false)
    NetworkResurrectLocalPlayer(x, y, z, self.spawnHeading, true, false)

    ClearPedTasksImmediately(PlayerPedId())
    RemoveAllPedWeapons(PlayerPedId())


    ShutdownLoadingScreen()

    FreezeEntityPosition(PlayerPedId(), false)

    SetPedDefaultComponentVariation(PlayerPedId())

    DoScreenFadeIn(1000)

end



Citizen.CreateThread(function()
    while not NetworkIsPlayerActive(PlayerId()) do
        Wait(500)
    end

    Handler:OnLoadPlayer()
end)



Handler.IsPlayerLoaded = function()
    return Handler.Data.isPlayerLoaded
end

Handler.SpawnPlayer = function()
    Handler:AutoSpawn()
end


exports("IsPlayerLoaded", Handler.IsPlayerLoaded)
exports("SpawnPlayer", Handler.SpawnPlayer)