--= Minesweeper Module by Danael_21 X StarShadow64 =--

--= A minesweeper working only with 2 scripts =--


--= Constants =--

wait(0.0001)
local Folder = Instance.new("Folder", game.Workspace)
Folder.Name = "MinesweeperInstance"
local plateSize = game.ReplicatedStorage:FindFirstChild("GridSize").Value
local tilesize = 4
local bombNumber = game.ReplicatedStorage:FindFirstChild("BombNumber")
local cameraReady = game.ReplicatedStorage:FindFirstChild("CameraReady")
local LT = nil
local CV = false
local GameOver = false
local d = false
local Win = false
local MFolder = Instance.new("Folder", game.Workspace)
MFolder.Name = "MusicFolder"
local S1 = Instance.new("Sound", MFolder)
S1.Name = "Click"
S1.SoundId = "rbxassetid://7802172696"
local S2 = Instance.new("Sound", MFolder)
S2.Name = "Explode"
S2.SoundId = "rbxassetid://8447388510"
local S3 = Instance.new("Sound", MFolder)
S3.Name = "Win"
S3.SoundId = "rbxassetid://10701236140"

--= Functions =--

function setupPlate()
    local mainTile = game.ReplicatedStorage:FindFirstChild("MTile")
    if not mainTile then
        mainTile = Instance.new("Part")
        mainTile.Name = "MTile"
        mainTile.Parent = game.ReplicatedStorage
        mainTile.Size = Vector3.new(tilesize, tilesize, tilesize)
        mainTile.Anchored = true
        mainTile.TopSurface = Enum.SurfaceType.Smooth
        mainTile.BottomSurface = Enum.SurfaceType.Smooth
        mainTile.Color = Color3.fromRGB(77, 77, 77)
        mainTile.Orientation = Vector3.new(0,180,0)
        local cd = Instance.new("ClickDetector", mainTile)
        cd.MaxActivationDistance = 1000
        local sg = Instance.new("SurfaceGui", mainTile)
        sg.SizingMode = Enum.SurfaceGuiSizingMode.PixelsPerStud
        sg.PixelsPerStud = 30
        sg.Face = Enum.NormalId.Top
        sg.Enabled = false
        local te = Instance.new("TextLabel", sg)
        te.Size = UDim2.new(1,0,1,0)
        te.TextScaled = true
        te.BackgroundTransparency = 1
        te.Font = Enum.Font.Arcade
        te.TextColor3 = Color3.fromRGB(255, 255, 255)
    end

    local FT = mainTile:Clone()
    FT.Parent = Folder
    FT.Name = 1
    FT.Position = Vector3.new(-(tilesize*(plateSize/2)), 0, -(tilesize*(plateSize/2)))

    for i=1, plateSize do
        for v=1, plateSize-1 do
            if not LT then LT = FT end
            local NT = LT:Clone()
            NT.Parent = Folder
            NT.Name = tonumber(LT.Name) + 1
            NT.Position = LT.Position + Vector3.new(0,0,tilesize)
            if NT.Name == tostring(((plateSize*plateSize)/2) + 0.5) then
                local CamP = mainTile:Clone()
                CamP.Name = "CamPart"
                CamP.Parent = game.Workspace
                CamP.Position = NT.Position + Vector3.new(0, plateSize*4, 0)
                CamP.Orientation = Vector3.new(-90,-90,0)
                CamP.Transparency = 1
                CamP.CanCollide = false
                CamP:FindFirstChild("ClickDetector"):Destroy()
                CamP:FindFirstChild("SurfaceGui"):Destroy()
                cameraReady.Value = true
            end
            if CV==false then
                NT.Color = Color3.fromRGB(255, 255, 255)
                CV = true
            else
                NT.Color = Color3.fromRGB(77, 77, 77)
                CV = false
            end
            LT = NT
        end

        if i==plateSize then
        else
            local NT = LT:Clone()
            NT.Parent = Folder
            NT.Name = tonumber(LT.Name) + 1
            NT.Position = Vector3.new(-(tilesize*(plateSize/2)), 0, -(tilesize*(plateSize/2))) - Vector3.new(i*tilesize,0,0)
            if CV==false then
                NT.Color = Color3.fromRGB(255, 255, 255)
                CV = true
            else
                NT.Color = Color3.fromRGB(77, 77, 77)
                CV = false
            end
            LT = NT
        end
    end

    for i, finishedTiles in pairs(Folder:GetChildren()) do
        finishedTiles.Size = Vector3.new(tilesize-0.5, tilesize-0.5, tilesize-0.5)
    end
end

function testTile(BasePos, NewPos)
    for i, parts in pairs(Folder:GetChildren()) do
        if parts.Position == BasePos + NewPos then
            if parts:FindFirstChild("Bomb") then
                return true
            else
                return false
            end
        end
    end

    return false
end

function calculateBombs()
    local bn
    if bombNumber and bombNumber.Value >=1 then
        bn = bombNumber.Value
    else
        local maxBomb = (plateSize*plateSize)/5
        bn = math.random(maxBomb-5, maxBomb)
    end
    local r
    local BFolder = Instance.new("Folder", game.Workspace)
    BFolder.Name = "BombFolder"
    print("The plate will have "..bn.." bombs.")
    for i=1, bn do
        local GT = Folder:GetChildren()
        r = math.random(1, #GT)
        local tilesChoosen = GT[r]
        if tilesChoosen then
            --tilesChoosen.Name = "BombT"
            tilesChoosen.Parent = BFolder
            --tilesChoosen.Color = Color3.fromRGB(255, 0, 0)
            local BValue = Instance.new("BoolValue", tilesChoosen)
            BValue.Name = "Bomb"
            local ig = Instance.new("ImageLabel", tilesChoosen:FindFirstChild("SurfaceGui"))
            ig.Name = "BombImage"
            ig.Size = UDim2.new(1,0,1,0)
            ig.Image = "rbxassetid://5295297207"
            ig.ImageTransparency = 1
            ig.BackgroundTransparency = 1
            tilesChoosen:FindFirstChild("SurfaceGui"):FindFirstChild("TextLabel").Text = ""
        end
    end

    for i, btiles in pairs(BFolder:GetChildren()) do
        btiles.Parent = Folder
    end

    BFolder:Destroy()
    BFolder = nil

    for i, tiles in pairs(Folder:GetChildren()) do
        if not tiles:FindFirstChild("Bomb") then
            local BA = 0
            local testV

            testV = testTile(tiles.Position, Vector3.new(0,0,4))
            if testV == true then
                BA = BA + 1
            end
            testV = testTile(tiles.Position, Vector3.new(4,0,4))
            if testV == true then
                BA = BA + 1
            end
            testV = testTile(tiles.Position, Vector3.new(0,0,-4))
            if testV == true then
                BA = BA + 1
            end
            testV = testTile(tiles.Position, Vector3.new(-4,0,-4))
            if testV == true then
                BA = BA + 1
            end
            testV = testTile(tiles.Position, Vector3.new(4,0,-4))
            if testV == true then
                BA = BA + 1
            end
            testV = testTile(tiles.Position, Vector3.new(4,0,0))
            if testV == true then
                BA = BA + 1
            end
            testV = testTile(tiles.Position, Vector3.new(-4,0,0))
            if testV == true then
                BA = BA + 1
            end
            testV = testTile(tiles.Position, Vector3.new(-4,0,4))
            if testV == true then
                BA = BA + 1
            end


            tiles:FindFirstChild("SurfaceGui"):FindFirstChild("TextLabel").Text = BA
            local BAV = Instance.new("NumberValue", tiles)
            BAV.Name = "BombArround"
            BAV.Value = BA
        end
    end
end

function checkForWin()
    local TilesCompleted = 0
    local TT = #Folder:GetChildren()
    for i, checkTiles in pairs(Folder:GetChildren()) do
        if checkTiles:FindFirstChild("Bomb") then
            TilesCompleted = TilesCompleted + 1
        else
            if not checkTiles:FindFirstChild("ClickDetector") then
                TilesCompleted = TilesCompleted + 1
            end
        end
    end

    if TilesCompleted >= TT then
        Win = true
        S3:Play()
        for i=1, TT do
            for v, winTiles in pairs(Folder:GetChildren()) do
                if winTiles.Name == tostring(i) then
                    if winTiles:FindFirstChild("Bomb") then
                        winTiles.Color = Color3.fromRGB(255, 0, 0)
                        winTiles:FindFirstChild("SurfaceGui"):FindFirstChild("BombImage").ImageTransparency = 0
                        winTiles:FindFirstChild("SurfaceGui").Enabled = true
                    else
                        winTiles.Color = Color3.fromRGB(255, 242, 0)
                        winTiles:FindFirstChild("SurfaceGui"):FindFirstChild("TextLabel").TextColor3 = Color3.fromRGB(0, 221, 255)
                        winTiles:FindFirstChild("SurfaceGui").Enabled = true
                    end
                end
            end
            wait()
        end

        wait(2)
        GameOver = true
        Win = false
    end
end

function enableTiles()
    for i, tiles in pairs(Folder:GetChildren()) do
        local CD = tiles:FindFirstChild("ClickDetector")
        local SG = tiles:FindFirstChild("SurfaceGui")
        SG.Enabled = false

        CD.MouseClick:Connect(function(player)
            if GameOver == false and Win == false then
                tiles.Color = Color3.fromRGB(27, 184, 168)
                if SG.TextLabel.Text == "🚩" then
                    return
                else
                    CD:Destroy()
                    if tiles:FindFirstChild("Bomb") then
                        S2:Play()
                        SG.Enabled = true
                        SG.BombImage.ImageTransparency = 0
                        GameOver = true
                    else
                        S1:Play()
                        if tiles:FindFirstChild("BombArround").Value == 0 then
                            local NewZScript = game.ReplicatedStorage:FindFirstChild("zeroactivator"):Clone()
                            NewZScript.Parent = tiles
                            NewZScript.Name = "ZeroActivator"
                            NewZScript.Disabled = false
                            SG.Enabled = true
                        else
                            SG.Enabled = true
                        end
                        checkForWin()
                    end
                end
            end 
        end)

        CD.RightMouseClick:Connect(function(player)
            if GameOver == false then
                if tiles:FindFirstChild("Bomb") then
                    if SG.TextLabel.Text == "🚩" then
                        SG.TextLabel.Text = ""
                        SG.Enabled = false
                    else
                        SG.TextLabel.Text = "🚩"
                        SG.Enabled = true
                        checkForWin()
                    end
                else
                    if SG.TextLabel.Text == "🚩" then
                        SG.TextLabel.Text = tiles.BombArround.Value
                        SG.Enabled = false
                    else
                        SG.TextLabel.Text = "🚩"
                        SG.Enabled = true
                    end
                end
            end
        end)
    end
end

--= Main Module =--

return function(player)
    cameraReady.Value = false
    plateSize = game.ReplicatedStorage:FindFirstChild("GridSize").Value
    bombNumber = game.ReplicatedStorage:FindFirstChild("BombNumber")
    print("Setting up plate")
    setupPlate()
    print("Calculating bombs")
    calculateBombs()
    print("Enabling tiles")
    enableTiles()

    while true do
        wait(0.001)
        if GameOver == true and d ==false then
            d = true
            wait(0.2)
            for i, parts in pairs(Folder:GetChildren()) do
                parts:Destroy()
            end
            game.Workspace:FindFirstChild("CamPart"):Destroy()
            wait(0.1)

            LT = nil
            CV = false
            GameOver = false
            d = false
            game.ReplicatedStorage:FindFirstChild("Play"):FireClient(player)
        end
    end
end