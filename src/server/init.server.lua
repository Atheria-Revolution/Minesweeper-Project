--= Module Initialiser by Danael_21 X StarShadow64 =--

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")

local Remote = Instance.new("RemoteEvent", game.ReplicatedStorage)
Remote.Name = "Play"

local GS = Instance.new("NumberValue", game.ReplicatedStorage)
GS.Name = "GridSize"
local BN = Instance.new("NumberValue", game.ReplicatedStorage)
BN.Name = "BombNumber"
local CR = Instance.new("BoolValue", game.ReplicatedStorage)
CR.Name = "CameraReady"

local module

Remote.OnServerEvent:Connect(function(player, GridSize, BombN)
    GS.Value = GridSize
    if BombN then
        BN.Value = BombN
    end

    delay(.05, function()
        require(module)(player)
    end)
end)

function RunModules()
    local ModuleF = Instance.new("Folder")
    ModuleF.Parent = ServerScriptService
    ModuleF.Name = "ModuleFolder"
    for _, modules in pairs(script:GetChildren()) do
        if modules:IsA("ModuleScript") then
            modules.Parent = ModuleF
            module = modules
        elseif modules:IsA("Script") then
            modules.Parent = game.ReplicatedStorage
            modules.Disabled = true
        end
    end
end

print("Starting server modules")
RunModules()