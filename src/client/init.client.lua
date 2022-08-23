local player = game.Players.LocalPlayer
local cam = game.Workspace.CurrentCamera

wait(2)
local CP = game.Workspace:FindFirstChild("CamPart")
if CP then
    repeat
        cam.CameraType = Enum.CameraType.Scriptable
    until cam.CameraType == Enum.CameraType.Scriptable
    cam.CFrame = CP.CFrame

    player.Character.HumanoidRootPart.CFrame = CP.CFrame + Vector3.new(0,5,0)
    player.Character.HumanoidRootPart.Anchored = true
end