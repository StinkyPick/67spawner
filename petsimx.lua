-- Load Rayfield
local Rayfield = loadstring(game:HttpGet("https://sirius.menu/rayfield"))()

local Window = Rayfield:CreateWindow({
    Name = "Pet Sim X",
    LoadingTitle = "Nexten Script Hub",
    LoadingSubtitle = "Auto Farm, Speed, Noclip & More by yfk",
    ConfigurationSaving = {
        Enabled = true,
        FolderName = "NextenScripts",
        FileName = "PetSimXConfig"
    }
})

-- Tabs
local MainTab = Window:CreateTab("Main", 4483362458)
local PlayerTab = Window:CreateTab("Player", 4483362458)
local MiscTab = Window:CreateTab("Misc", 4483362458)

-- Auto Farm
local autoFarmEnabled = false
MainTab:CreateToggle({
    Name = "Auto Farm",
    CurrentValue = false,
    Flag = "AutoFarmToggle",
    Callback = function(value)
        autoFarmEnabled = value
        if autoFarmEnabled then
            spawn(function()
                while autoFarmEnabled do
                    -- Make all pets target nearest coin
                    local player = game.Players.LocalPlayer
                    if player and player.Character and player.Character:FindFirstChild("Pets") then
                        for _,pet in pairs(player.Character.Pets:GetChildren()) do
                            if pet:FindFirstChild("HumanoidRootPart") then
                                local closestCoin = nil
                                local shortestDistance = math.huge
                                for _,coin in pairs(workspace.Coins:GetChildren()) do
                                    if coin:IsA("Part") then
                                        local distance = (pet.HumanoidRootPart.Position - coin.Position).Magnitude
                                        if distance < shortestDistance then
                                            shortestDistance = distance
                                            closestCoin = coin
                                        end
                                    end
                                end
                                if closestCoin then
                                    pet.HumanoidRootPart.CFrame = CFrame.new(closestCoin.Position)
                                end
                            end
                        end
                    end
                    wait(0.1) -- faster collection
                end
            end)
        end
    end
})

-- Speed
local speedValue = 50
PlayerTab:CreateSlider({
    Name = "Walk Speed",
    Range = {16, 250},
    Increment = 1,
    Suffix = "speed",
    CurrentValue = 50,
    Flag = "SpeedSlider",
    Callback = function(value)
        speedValue = value
        game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = speedValue
    end
})

-- Noclip
local noclipEnabled = false
MiscTab:CreateToggle({
    Name = "Noclip",
    CurrentValue = false,
    Flag = "NoclipToggle",
    Callback = function(value)
        noclipEnabled = value
        local character = game.Players.LocalPlayer.Character
        if character then
            for _,part in pairs(character:GetChildren()) do
                if part:IsA("BasePart") then
                    part.CanCollide = not noclipEnabled and true or false
                end
            end
        end
    end
})

-- Teleport to Egg Shop
MainTab:CreateButton({
    Name = "Teleport to Egg Shop",
    Callback = function()
        local shop = workspace:FindFirstChild("EggShop")
        if shop then
            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = shop.CFrame + Vector3.new(0,5,0)
        end
    end
})

-- Auto Rebirth
local autoRebirth = false
MainTab:CreateToggle({
    Name = "Auto Rebirth",
    CurrentValue = false,
    Flag = "AutoRebirthToggle",
    Callback = function(value)
        autoRebirth = value
        spawn(function()
            while autoRebirth do
                if game:GetService("Players").LocalPlayer.PlayerGui:FindFirstChild("RebirthButton") then
                    fireclickdetector(game:GetService("Players").LocalPlayer.PlayerGui.RebirthButton)
                end
                wait(1)
            end
        end)
    end
})

Rayfield:Notify({
    Title = "Pet Sim X Script",
    Content = "Loaded successfully! Auto Farm, Speed, Noclip & More!",
    Duration = 5,
    Image = 4483362458
})
