if not game:IsLoaded() then game.Loaded:Wait() end

local rs = game:GetService("ReplicatedStorage")
local uis = game:GetService("UserInputService")
local player = game:GetService("Players").LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

_G.AndNeyActive = false
local startTime = tick()
local sessionCount = 0
local toggleKey = Enum.KeyCode.LeftControl
local alaySoundID = "rbxassetid://2865227271" 

if playerGui:FindFirstChild("AndNey_Project") then 
    playerGui.AndNey_Project:Destroy() 
end

local sg = Instance.new("ScreenGui", playerGui)
sg.Name = "AndNey_Project"
sg.ResetOnSpawn = false

local main = Instance.new("Frame", sg)
main.Size = UDim2.new(0, 220, 0, 280)
main.Position = UDim2.new(0.5, -110, 0.4, -130)
main.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
main.BorderSizePixel = 2
main.Active = true
main.Draggable = true

local title = Instance.new("TextLabel", main)
title.Size = UDim2.new(1, 0, 0.15, 0)
title.Text = "AndNey ULTIMATE v9.9.5"
title.BackgroundTransparency = 1
title.Font = Enum.Font.Code
title.TextSize = 16

task.spawn(function()
    while task.wait() do
        local color = Color3.fromHSV(tick() % 5 / 5, 1, 1)
        main.BorderColor3 = color
        title.TextColor3 = color
    end
end)

local sessionLabel = Instance.new("TextLabel", main)
sessionLabel.Size = UDim2.new(0.9, 0, 0.15, 0)
sessionLabel.Position = UDim2.new(0.05, 0, 0.15, 0)
sessionLabel.Text = "CAUGHT: 0"
sessionLabel.TextColor3 = Color3.fromRGB(0, 255, 255)
sessionLabel.BackgroundTransparency = 1
sessionLabel.Font = Enum.Font.Code
sessionLabel.TextSize = 22

local timeLabel = Instance.new("TextLabel", main)
timeLabel.Size = UDim2.new(0.9, 0, 0.1, 0)
timeLabel.Position = UDim2.new(0.05, 0, 0.32, 0)
timeLabel.Text = "Time: 00:00:00"
timeLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
timeLabel.BackgroundTransparency = 1
timeLabel.Font = Enum.Font.Code
timeLabel.TextSize = 12

local logFish = Instance.new("TextLabel", main)
logFish.Size = UDim2.new(0.9, 0, 0.1, 0)
logFish.Position = UDim2.new(0.05, 0, 0.42, 0)
logFish.Text = "Waiting for catch..."
logFish.TextColor3 = Color3.fromRGB(0, 255, 150)
logFish.BackgroundTransparency = 1
logFish.Font = Enum.Font.Code
logFish.TextSize = 10

local btnFish = Instance.new("TextButton", main)
btnFish.Size = UDim2.new(0.9, 0, 0.18, 0)
btnFish.Position = UDim2.new(0.05, 0, 0.58, 0)
btnFish.Text = "START AFK"
btnFish.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
btnFish.TextColor3 = Color3.fromRGB(255, 255, 255)
btnFish.Font = Enum.Font.Code

local hint = Instance.new("TextLabel", main)
hint.Size = UDim2.new(1, 0, 0.1, 0)
hint.Position = UDim2.new(0, 0, 0.88, 0)
hint.Text = "[L-CTRL] TO HIDE/SHOW"
hint.TextColor3 = Color3.fromRGB(150, 150, 150)
hint.BackgroundTransparency = 1
hint.Font = Enum.Font.Code
hint.TextSize = 9

uis.InputBegan:Connect(function(input, gp)
    if not gp and input.KeyCode == toggleKey then main.Visible = not main.Visible end
end)

task.spawn(function()
    while task.wait(1) do
        if _G.AndNeyActive then
            local dur = tick() - startTime
            local h, m, s = math.floor(dur/3600), math.floor((dur%3600)/60), math.floor(dur%60)
            timeLabel.Text = string.format("Time: %02d:%02d:%02d", h, m, s)
        end
    end
end)

local function showAlayNotif()
    local s = Instance.new("Sound", playerGui)
    s.SoundId = alaySoundID
    s.Volume = 2
    if not s.IsLoaded then s.Loaded:Wait() end
    s:Play()
    game:GetService("Debris"):AddItem(s, 3)

    local notif = Instance.new("TextLabel", sg)
    notif.Size = UDim2.new(0, 300, 0, 50)
    notif.Position = UDim2.new(0.5, -150, 0.35, 0)
    notif.Text = "✨ ANJAY MABAR! ✨"
    notif.TextColor3 = Color3.fromHSV(tick() % 5 / 5, 1, 1)
    notif.BackgroundTransparency = 1
    notif.Font = Enum.Font.Code
    notif.TextSize = 35
    notif.Rotation = math.random(-15, 15)
    
    task.spawn(function()
        for i = 1, 15 do
            notif.Position = notif.Position + UDim2.new(0, 0, -0.005, 0)
            notif.TextTransparency = i / 15
            task.wait(0.04)
        end
        notif:Destroy()
    end)
end

task.spawn(function()
    local fishSys = rs:WaitForChild("FishingSystem")
    while true do
        task.wait(0.1)
        if _G.AndNeyActive then
            pcall(function()
                local char = player.Character
                local rod = char:FindFirstChildOfClass("Tool") or player.Backpack:FindFirstChildOfClass("Tool")
                if not rod then return end
                local root = char.HumanoidRootPart
                local tPos = root.Position + (root.CFrame.LookVector * 7)

                fishSys.InventoryEvents.Inventory_EquipRod:FireServer(rod.Name)
                fishSys["RE/CastReplication"]:FireServer(root.Position, tPos, rod.Name, 100)
                task.wait(0.6) 
                fishSys["RE/SyncHookLanding"]:FireServer(tPos)
                task.wait(1.75) 
                
                fishSys["RE/ReplicateExclaim"]:FireServer(player)
                task.wait(0.1) 
                fishSys["RF/RollFishServer"]:InvokeServer(rod.Name, 0) 
                fishSys["RE/FishGiver"]:FireServer({["hookPosition"] = tPos})
                rs.FishingCatchSuccess:FireServer()
                fishSys["RE/CleanupCast"]:FireServer()
                
                sessionCount = sessionCount + 1
                sessionLabel.Text = "CAUGHT: " .. sessionCount
                
                pcall(function()
                    local mastery = playerGui:FindFirstChild("Mastery")
                    if mastery then
                        logFish.Text = mastery.Main.Right.Content.RightContent.Inside.CaughtLabel.Text
                    end
                end)
                
                task.spawn(showAlayNotif)
                task.wait(0.8)
            end)
        end
    end
end)

btnFish.MouseButton1Click:Connect(function()
    _G.AndNeyActive = not _G.AndNeyActive
    if _G.AndNeyActive then startTime = tick() end
    btnFish.Text = _G.AndNeyActive and "STOP AFK" or "START AFK"
    btnFish.TextColor3 = _G.AndNeyActive and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 255, 255)
end)

print("AndNey Ultimate v9.9.5 Loaded Successfully!")
