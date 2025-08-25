-- Load Rayfield
local Rayfield = loadstring(game:HttpGet("https://sirius.menu/rayfield"))()

local Window = Rayfield:CreateWindow({
    Name = "Pet Sim X",
    LoadingTitle = "Nexten Script Hub",
    LoadingSubtitle = "Auto Farm, Noclip, Auto Rebirth, Save Pet Egg & More yfk",
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

-- Optimized Auto Farm
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
                                    pet.HumanoidRootPart.CFrame = CFrame.new(closestCoin.Position + Vector3.new(0,3,0))
                                end
                            end
                        end
                    end
                    wait(0.05)
                end
            end)
        end
    end
})

-- Save Pet Egg
MainTab:CreateButton({
    Name = "Save Pet Egg",
    Callback = function()
        local player = game.Players.LocalPlayer
        local egg = workspace:FindFirstChild("Egg") -- change if egg model has a different name
        if egg and player and player.Character then
            player.Character.HumanoidRootPart.CFrame = egg.CFrame + Vector3.new(0,5,0)
            Rayfield:Notify({
                Title = "Pet Sim X",
                Content = "Teleported to Pet Egg!",
                Duration = 3
            })
        else
            Rayfield:Notify({
                Title = "Pet Sim X",
                Content = "No egg found!",
                Duration = 3
            })
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

-- Fixed Noclip
local noclipEnabled = false
MiscTab:CreateToggle({
    Name = "Noclip",
    CurrentValue = false,
    Flag = "NoclipToggle",
    Callback = function(value)
        noclipEnabled = value
        local player = game.Players.LocalPlayer
        if player and player.Character then
            local character = player.Character
            spawn(function()
                while noclipEnabled do
                    for _, part in pairs(character:GetChildren()) do
                        if part:IsA("BasePart") then
                            part.CanCollide = false
                        end
                    end
                    game:GetService("RunService").Stepped:Wait()
                end
                for _, part in pairs(character:GetChildren()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = true
                    end
                end
            end)
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

-- Fixed Auto Rebirth
local autoRebirth = false
MainTab:CreateToggle({
    Name = "Auto Rebirth",
    CurrentValue = false,
    Flag = "AutoRebirthToggle",
    Callback = function(value)
        autoRebirth = value
        spawn(function()
            while autoRebirth do
                local rebirthBtn = workspace:FindFirstChild("RebirthButton") or game.Players.LocalPlayer.PlayerGui:FindFirstChild("RebirthButton")
                if rebirthBtn and rebirthBtn:IsA("ClickDetector") then
                    fireclickdetector(rebirthBtn)
                end
                wait(0.5)
            end
        end)
    end
})

Rayfield:Notify({
    Title = "Pet Sim X Script",
    Content = "Loaded successfully! Auto Farm, Save Pet Egg & Auto Rebirth working!",
    Duration = 5,
    Image = 4483362458
})
