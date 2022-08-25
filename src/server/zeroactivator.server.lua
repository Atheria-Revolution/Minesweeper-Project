
--= Minesweeper Zero-Activator additions by Danael_21 X StarShadow64 =--

--= The additionnal script to the Minesweeper module for the Zero algorisum =--


--= Main script =--

wait(0.0001)
local Folder = game.Workspace:FindFirstChild("MinesweeperInstance")
local tile = script.Parent

repeat
    Folder = game.Workspace:FindFirstChild("MinesweeperInstance")
    wait(0.0001)
until Folder

function testTile(BasePos, NewPos)
    for i, parts in pairs(Folder:GetChildren()) do
        if parts.Position == BasePos + NewPos then
            if parts:FindFirstChild("ClickDetector") then
                parts:FindFirstChild("ClickDetector"):Destroy()
            end
            parts:FindFirstChild("SurfaceGui").Enabled = true
            parts.Color = Color3.fromRGB(27, 184, 168)
            if parts:FindFirstChild("BombArround").Value == 0 then
                if parts:FindFirstChild("ZeroActivator") then
                else
                    local NewActivator = script:Clone()
                    NewActivator.Parent = parts
                    NewActivator.Name = "ZeroActivator"
                    NewActivator.Disabled = false
                end
            end
        end
    end

    return false
end


if script.Parent:IsA("Part") then
else
    script.Disabled = true
end


tile.Color = Color3.fromRGB(27, 184, 168)
testV = testTile(tile.Position, Vector3.new(0,0,4))
testV = testTile(tile.Position, Vector3.new(4,0,4))
testV = testTile(tile.Position, Vector3.new(0,0,-4))
testV = testTile(tile.Position, Vector3.new(-4,0,-4))
testV = testTile(tile.Position, Vector3.new(4,0,-4))
testV = testTile(tile.Position, Vector3.new(4,0,0))
testV = testTile(tile.Position, Vector3.new(-4,0,0))
testV = testTile(tile.Position, Vector3.new(-4,0,4))

