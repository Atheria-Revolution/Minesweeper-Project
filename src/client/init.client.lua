--= Module Initialiser by Danael_21 X StarShadow64 =--

wait(0.5)
local ServerScriptService = game:GetService("ServerScriptService")
local d = false

function RunModules()
    local ModuleF = Instance.new("Folder")
    ModuleF.Parent = ServerScriptService
    ModuleF.Name = "ModuleFolder"
    for _, modules in pairs(script:GetChildren()) do
        if modules:IsA("ModuleScript") then
            modules.Parent = ModuleF
            require(modules)()
        end
    end
end

print("Starting clients modules")
RunModules()