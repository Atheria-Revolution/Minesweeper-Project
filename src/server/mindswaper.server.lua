--[[

    Mineswaper.lua
    StarShadow64/Danael_21

    Description :
        A simple mineswaper game contained within 1 script
    
    Documentation :
        None

]]--











--= Variables =--

local ChangeHistoryService = game:GetService("ChangeHistoryService")
local MainPart
local Folder = Instance.new("Folder")
Folder.Parent = game.Workspace
Folder.Name = "MineswaperFolder"
local MoveD = "right"
local LastT = nil
local Count = 2
local FT = true
local PColor = true
local GameOver = false
local NewSound = Instance.new("Sound")
NewSound.Name = "Poc"
NewSound.Parent = game.ReplicatedStorage
NewSound.SoundId = "rbxassetid://7545317681"
local NewSound2 = Instance.new("Sound")
NewSound2.Name = "Poc"
NewSound2.Parent = game.ReplicatedStorage
NewSound2.SoundId = "rbxassetid://8447388510"
local d = false
local LastGroupId = 0

--= Setup lign =--

script.Parent = game.ServerScriptService

--= Functions =--

function CreateNewPart()
    local NewPart = MainPart:Clone()
    NewPart.Parent = Folder
    NewPart.Name = "MSPart"

    return(NewPart)
end

function changeDirection()
    if MoveD == "right" then
        MoveD = "up"
    elseif MoveD == "up" then
        MoveD = "left"
    elseif MoveD == "left" then
        MoveD = "down"
    elseif MoveD == "down" then
        MoveD = "right"
    end
end

function generateNewPart(Co)
    local part = CreateNewPart()
            if LastT == nil then
                part.Position = Vector3.new(0,0,0)
                part.Name = "MainPart"
                part.Color = Color3.new(1, 1, 1)
                --local oP = CreateNewPart()
                --oP.Position = part.Position + Vector3.new(0,0,i*4)
                LastT = part
            else
                if MoveD == "right" then
                    part.Position = LastT.Position + Vector3.new(0,0,4)
                    LastT = part
                elseif MoveD == "up" then
                    part.Position = LastT.Position + Vector3.new(4,0,0)
                    LastT = part
                elseif MoveD == "left" then
                    part.Position = LastT.Position + Vector3.new(0,0,-(4))
                    LastT = part
                elseif MoveD == "down" then
                    part.Position = LastT.Position + Vector3.new(-(4),0,0)
                    LastT = part
                end

                if Co == "White" then
                    part.Color = Color3.new(1, 1, 1)
                else
                    part.Color = Color3.new(0.337254, 0.337254, 0.337254)
                end
            end
end

function InitialiseGrid()
    if MainPart then
    else
        MainPart = Instance.new("Part")
        MainPart.Parent = game.ReplicatedStorage
        MainPart.Name = "MineswaperPart"
        MainPart.Size = Vector3.new(4,4,4)
        MainPart.TopSurface = Enum.SurfaceType.Smooth
        MainPart.BottomSurface = Enum.SurfaceType.Smooth
        MainPart.Anchored = true
        local CD = Instance.new("ClickDetector")
        CD.Parent = MainPart
        CD.Name = "ClickDetector"
        CD.MaxActivationDistance = 75
        local GUI = Instance.new("SurfaceGui", MainPart)
        GUI.Face = Enum.NormalId.Top
        GUI.SizingMode = Enum.SurfaceGuiSizingMode.PixelsPerStud
        GUI.PixelsPerStud = 30
        local Text = Instance.new("TextLabel", GUI)
        Text.Name = "Text"
        Text.Size = UDim2.new(1,0,1,0)
        Text.TextColor3 = Color3.new(0.015686, 0.384313, 0.937254)
        Text.Text = "Wait, generating numbers"
        Text.TextScaled = true
        Text.BackgroundTransparency = 1
    end

    for i=1, 24 do
        
        if i == 1 then
            for x=1, Count do
                if LastT == nil then
                    generateNewPart("White")
                    generateNewPart("Black")
                    changeDirection()
                else
                    generateNewPart("White")
                end
                
                if x == Count then
                    changeDirection()
                end
            end
        else
            for x=1, Count do
                if LastT == nil then
                    generateNewPart()
                    generateNewPart()
                    changeDirection()
                else
                    if PColor == true then
                        generateNewPart("Black")
                    else
                        generateNewPart("White")
                    end
                    
                end

                if PColor == true then
                    PColor = false
                else
                    PColor = true
                end
                
                if x == Count then
                    changeDirection()
                end
            end

            if FT == true then
                FT = false
            else
                Count = Count + 1
                FT = true
            end

        end

        if i == 24 then
            LastT:Destroy()
        end
        
    end
end

function InitialiseCam()
    local MP = Folder:FindFirstChild("MainPart")
    if MP then
        print("Setting up CamPart")
        local CamPart = MP:Clone()
        CamPart.Parent = game.Workspace
        CamPart.Name = "CamPart"
        CamPart:FindFirstChild("SurfaceGui"):Destroy()
        CamPart.Transparency = 1
        CamPart.CanCollide = false
        CamPart:FindFirstChild("ClickDetector"):Destroy()
        CamPart.Position = CamPart.Position + Vector3.new(0,4*11,0)
        CamPart.Orientation = Vector3.new(-90,0,0)
    end
end

function CreateBombs()
    local BF = game.Workspace:FindFirstChild("BombFolder")

    if BF then
    else
        BF = Instance.new("Folder")
        BF.Parent = game.Workspace
        BF.Name = "BombFolder"
    end
    for i=1, 30 do
        local MP = Folder:GetChildren()
        local TT = #Folder:GetChildren()
        local r = math.random(1, TT)
        local PartChoosen = MP[r]
        if PartChoosen then
            if PartChoosen.Name == "BombT" then
                print("Already bomb")
            end
            local BV = Instance.new("BoolValue")
            BV.Name = "Bomb"
            BV.Parent = PartChoosen
            --PartChoosen.Color = Color3.new(0.894117, 0.976470, 0)
            PartChoosen.Parent = BF
            PartChoosen.Name = "BombT"
        end
    end
end

function FinishGrid()
    for i, parts in pairs(game.Workspace:FindFirstChild("BombFolder"):GetChildren()) do
        parts.Parent = Folder
    end

    game.Workspace:FindFirstChild("BombFolder"):Destroy()

    for i, parts in pairs(Folder:GetChildren()) do
        if parts.Name == "CamPart" then
        else
            parts.Orientation = Vector3.new(0,-90,0)
            if parts.Color == Color3.new(1, 1, 1) then
                parts:FindFirstChild("SurfaceGui"):FindFirstChild("Text").TextColor3 = Color3.new(0.298039, 0.580392, 1)
            else
                parts:FindFirstChild("SurfaceGui"):FindFirstChild("Text").TextColor3 = Color3.new(0, 0.160784, 0.4)
            end
        end
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

function testNul(BasePos, NewPos)
    for i, parts in pairs(Folder:GetChildren()) do
        if parts.Position == BasePos + NewPos then
            if parts:FindFirstChild("BombArround").Value == 0 then
                return parts, true
            else
                return parts, false
            end
        end
    end

    return nil
end

function CalculateBombs()
    for i, parts in pairs(Folder:GetChildren()) do
        if parts:FindFirstChild("Bomb") then
            parts:FindFirstChild("SurfaceGui"):FindFirstChild("Text").Text = ""
            local Image = Instance.new("ImageLabel")
            Image.Parent = parts:FindFirstChild("SurfaceGui")
            Image.Name = "BombImage"
            Image.BackgroundTransparency = 1
            Image.Image = "rbxassetid://5295297207"
            Image.Size = UDim2.new(1,0,1,0)
            Image.ImageTransparency = 1
        else
            local BA = 0

            local test = testTile(parts.Position, Vector3.new(0,0,4))
            if test == true then
                BA = BA + 1
            end
            local test = testTile(parts.Position, Vector3.new(4,0,4))
            if test == true then
                BA = BA + 1
            end
            local test = testTile(parts.Position, Vector3.new(0,0,-4))
            if test == true then
                BA = BA + 1
            end
            local test = testTile(parts.Position, Vector3.new(-4,0,-4))
            if test == true then
                BA = BA + 1
            end
            local test = testTile(parts.Position, Vector3.new(4,0,-4))
            if test == true then
                BA = BA + 1
            end
            local test = testTile(parts.Position, Vector3.new(4,0,0))
            if test == true then
                BA = BA + 1
            end
            local test = testTile(parts.Position, Vector3.new(-4,0,0))
            if test == true then
                BA = BA + 1
            end
            local test = testTile(parts.Position, Vector3.new(-4,0,4))
            if test == true then
                BA = BA + 1
            end

            parts:FindFirstChild("SurfaceGui"):FindFirstChild("Text").Text = BA
            local BAV = Instance.new("NumberValue")
            BAV.Parent = parts
            BAV.Name = "BombArround"
            BAV.Value = BA
        end
    end
end

function makeGroups()
    for i, tiles in pairs(Folder:GetChildren()) do
        if tiles:FindFirstChild("Bomb") then
            print("Bomb")
        else
            if tiles:FindFirstChild("BombArround").Value == 0 then
                if tiles:FindFirstChild("Grouped") then
                    
                else

                end
                tiles.Color = Color3.new(1, 0, 0)
                local CurentLayer = LastGroupId
                LastGroupId = LastGroupId + 1
                local AllGrouped = true
                local ciD = Instance.new("NumberValue")
                ciD.Name = "Grouped"
                ciD.Value = CurentLayer
                ciD.Parent = tiles
                local test1 = nil
                local test2 = nil
                local test3 = nil
                local test4 = nil
                local test5 = nil
                local test6 = nil
                local test7 = nil
                local test8 = nil
                local var1 = nil
                local var2 = nil
                local var3 = nil
                local var4 = nil
                local var5 = nil
                local var6 = nil
                local var7 = nil
                local var8 = nil

                repeat
                    AllGrouped = true

                    if test1 or test2 or test3 or test4 or test5 or test6 or test7 or test8 then
                        
                    else
                        test1, var1 = testNul(tiles.Position, Vector3.new(0,0,4))
                        if test1 then
                            if var1 == true then
                                local iD = Instance.new("NumberValue")
                                iD.Name = "Grouped"
                                iD.Value = CurentLayer
                                iD.Parent = test1
                                AllGrouped = false
                            else
                                local iD = Instance.new("NumberValue")
                                iD.Name = "Grouped"
                                iD.Value = CurentLayer
                                iD.Parent = test1
                            end
                        end
                        test2, var2 = testNul(tiles.Position, Vector3.new(4,0,4))
                        if test2 then
                            if var2 == true then
                                local iD = Instance.new("NumberValue")
                                iD.Name = "Grouped"
                                iD.Value = CurentLayer
                                iD.Parent = test2
                                AllGrouped = false
                            else
                                local iD = Instance.new("NumberValue")
                                iD.Name = "Grouped"
                                iD.Value = CurentLayer
                                iD.Parent = test2
                            end
                        end
                        test3, var3 = testNul(tiles.Position, Vector3.new(0,0,-4))
                        if test3 then
                            if var3 == true then
                                local iD = Instance.new("NumberValue")
                                iD.Name = "Grouped"
                                iD.Value = CurentLayer
                                iD.Parent = test3
                                AllGrouped = false
                            else
                                local iD = Instance.new("NumberValue")
                                iD.Name = "Grouped"
                                iD.Value = CurentLayer
                                iD.Parent = test3
                            end
                        end
                        test4, var4 = testNul(tiles.Position, Vector3.new(-4,0,-4))
                        if test4 then
                            if var4 == true then
                                local iD = Instance.new("NumberValue")
                                iD.Name = "Grouped"
                                iD.Value = CurentLayer
                                iD.Parent = test4
                                AllGrouped = false
                            else
                                local iD = Instance.new("NumberValue")
                                iD.Name = "Grouped"
                                iD.Value = CurentLayer
                                iD.Parent = test4
                            end
                        end
                        test5, var5 = testNul(tiles.Position, Vector3.new(-4,0,4))
                        if test5 then
                            if var5 == true then
                                local iD = Instance.new("NumberValue")
                                iD.Name = "Grouped"
                                iD.Value = CurentLayer
                                iD.Parent = test5
                                AllGrouped = false
                            else
                                local iD = Instance.new("NumberValue")
                                iD.Name = "Grouped"
                                iD.Value = CurentLayer
                                iD.Parent = test5
                            end
                        end
                        test6, var6 = testNul(tiles.Position, Vector3.new(-4,0,0))
                        if test6 then
                            if var6 == true then
                                local iD = Instance.new("NumberValue")
                                iD.Name = "Grouped"
                                iD.Value = CurentLayer
                                iD.Parent = test6
                                AllGrouped = false
                            else
                                local iD = Instance.new("NumberValue")
                                iD.Name = "Grouped"
                                iD.Value = CurentLayer
                                iD.Parent = test6
                            end
                        end
                        test7, var7 = testNul(tiles.Position, Vector3.new(4,0,0))
                        if test7 then
                            if var7 == true then
                                local iD = Instance.new("NumberValue")
                                iD.Name = "Grouped"
                                iD.Value = CurentLayer
                                iD.Parent = test7
                                AllGrouped = false
                            else
                                local iD = Instance.new("NumberValue")
                                iD.Name = "Grouped"
                                iD.Value = CurentLayer
                                iD.Parent = test7
                            end
                        end
                        test8, var8 = testNul(tiles.Position, Vector3.new(4,0,-4))
                        if test8 then
                            if var8 == true then
                                local iD = Instance.new("NumberValue")
                                iD.Name = "Grouped"
                                iD.Value = CurentLayer
                                iD.Parent = test8
                                AllGrouped = false
                            else
                                local iD = Instance.new("NumberValue")
                                iD.Name = "Grouped"
                                iD.Value = CurentLayer
                                iD.Parent = test8
                            end
                        end

                        
                    end
                until AllGrouped == true
            end
        end
    end
end

function MakeSound(n)
    if n == 1 then
        local NSound = NewSound:Clone()
        NSound.Name = "Poc"
        NSound.Parent = game.Workspace
        NSound:Play()
        wait(NSound.TimeLength)
        NSound:Destroy()
    else
        local NSound = NewSound2:Clone()
        NSound.Name = "Poc"
        NSound.Parent = game.Workspace
        NSound:Play()
        wait(NSound.TimeLength)
        NSound:Destroy()
    end
    
end

function GiveFunctionnalities()
    for i, tiles in pairs(Folder:GetChildren()) do
        local CD = tiles:FindFirstChild("ClickDetector")
        local SG = tiles:FindFirstChild("SurfaceGui")
        SG.Enabled = false

        CD.MouseClick:Connect(function(player)
            if GameOver == false then
                if SG.Text.Text == "🚩" then
                    return
                else
                    CD:Destroy()
                    if tiles:FindFirstChild("Bomb") then
                        SG.Enabled = true
                        SG.BombImage.ImageTransparency = 0
                        GameOver = true
                        delay(0.5, function()
                            MakeSound(2)
                        end)
                    else
                        SG.Enabled = true
                        delay(0.5, function()
                            MakeSound(1)
                        end)
                    end
                end
            end 
        end)

        CD.RightMouseClick:Connect(function(player)
            if GameOver == false then
                if tiles:FindFirstChild("Bomb") then
                    if SG.Text.Text == "🚩" then
                        SG.Text.Text = ""
                        SG.Enabled = false
                    else
                        SG.Text.Text = "🚩"
                        SG.Enabled = true
                    end
                else
                    if SG.Text.Text == "🚩" then
                        SG.Text.Text = tiles.BombArround.Value
                        SG.Enabled = false
                    else
                        SG.Text.Text = "🚩"
                        SG.Enabled = true
                    end
                end
            end
        end)
    end
end

function DestroyGrid()
    for i, parts in pairs(Folder:GetChildren()) do
        parts:Destroy()
        wait(0.001)
    end
end

--= Main script =--

InitialiseGrid() --Call the InitialiseGrid function to get the basic 13 by 13 Grid
InitialiseCam() --Call the InitialiseCam function to setup the camera block above the plate
CreateBombs() --Call the CreateBombs function that will place bombs on the board
FinishGrid() --Call the FinishGrid function that will regroup everything in the main folder and polish the plate
CalculateBombs() --Call the CalculateBombs function that will calculate the bomb number arround every "normal" tile
makeGroups() --Call the makeGroups function that will regroup all the 0 tiles in pairs
GiveFunctionnalities() --Call the GiveFunctionnalities that will make all the tiles work

while true do
    if GameOver == true then
        if d == false then
            d = true
            DestroyGrid()
            wait(0.1)

            MoveD = 'right'
            LastT = nil
            Count = 2
            FT = true
            PColor = true

            InitialiseGrid()
            InitialiseCam()
            CreateBombs()
            FinishGrid()
            CalculateBombs()
            GiveFunctionnalities()

            GameOver = false
        end
    end
    wait(0.01)
end




