-- Load Rayfield UI
local Rayfield = loadstring(game:HttpGet("https://sirius.menu/rayfield"))()

local Window = Rayfield:CreateWindow({
   Name = "Steal a Brainrot Hub",
   LoadingTitle = "Loading...",
   LoadingSubtitle = "by yfk",
   ConfigurationSaving = {
      Enabled = false
   }
})

local MainTab = Window:CreateTab("Main", 4483362458)
local Player = game.Players.LocalPlayer
local UIS = game:GetService("UserInputService")

--// AUTO REJOIN IF PRIVATE SERVER
local TeleportService = game:GetService("TeleportService")
if game.PrivateServerId ~= "" and game.PrivateServerOwnerId ~= 0 then
    task.wait(1)
    TeleportService:Teleport(game.PlaceId, Player)
end

--// Noclip
local noclipEnabled = false
game:GetService("RunService").Stepped:Connect(function()
    if noclipEnabled and Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") then
        for _, part in pairs(Player.Character:GetDescendants()) do
            if part:IsA("BasePart") and part.CanCollide then
                part.CanCollide = false
            end
        end
    end
end)

MainTab:CreateToggle({
    Name = "Noclip",
    CurrentValue = false,
    Callback = function(v)
        noclipEnabled = v
    end
})

--// Walkspeed
MainTab:CreateSlider({
    Name = "WalkSpeed",
    Range = {16, 100},
    Increment = 1,
    CurrentValue = 16,
    Callback = function(value)
        if Player.Character and Player.Character:FindFirstChild("Humanoid") then
            Player.Character.Humanoid.WalkSpeed = value
        end
    end
})

--// Infinite Jump
local infJump = false
UIS.JumpRequest:Connect(function()
    if infJump and Player.Character and Player.Character:FindFirstChild("Humanoid") then
        Player.Character.Humanoid:ChangeState("Jumping")
    end
end)

MainTab:CreateToggle({
    Name = "Infinite Jump",
    CurrentValue = false,
    Callback = function(v)
        infJump = v
    end
})

--// Anti-Hit (No damage)
local antiHit = false
Player.CharacterAdded:Connect(function(char)
    if antiHit then
        local hum = char:WaitForChild("Humanoid")
        hum.HealthChanged:Connect(function()
            hum.Health = hum.MaxHealth
        end)
    end
end)

MainTab:CreateToggle({
    Name = "Anti-Hit",
    CurrentValue = false,
    Callback = function(v)
        antiHit = v
        if v and Player.Character then
            local hum = Player.Character:FindFirstChild("Humanoid")
            if hum then
                hum.HealthChanged:Connect(function()
                    hum.Health = hum.MaxHealth
                end)
            end
        end
    end
})

--// Anti-Ragdoll
local antiRagdoll = false
MainTab:CreateToggle({
    Name = "Anti-Ragdoll",
    CurrentValue = false,
    Callback = function(v)
        antiRagdoll = v
        if v and Player.Character then
            for _, v in pairs(Player.Character:GetDescendants()) do
                if v:IsA("BallSocketConstraint") then
                    v:Destroy()
                end
            end
        end
    end
})

--// Auto Collect Money
local autoCollect = false
local oldCFrame
MainTab:CreateToggle({
    Name = "Auto Collect Money",
    CurrentValue = false,
    Callback = function(v)
        autoCollect = v
        task.spawn(function()
            while autoCollect do
                task.wait(1)
                if Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") then
                    local hrp = Player.Character.HumanoidRootPart
                    oldCFrame = hrp.CFrame
                    for _, obj in pairs(workspace:GetDescendants()) do
                        if obj:IsA("TouchTransmitter") and obj.Parent and obj.Parent:IsA("BasePart") then
                            hrp.CFrame = obj.Parent.CFrame
                            task.wait(0.1)
                        end
                    end
                    hrp.CFrame = oldCFrame
                end
            end
        end)
    end
})

--// Save Base / Go To Base
local savedBaseCFrame = nil
MainTab:CreateButton({
    Name = "Save Base Spot",
    Callback = function()
        if Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") then
            savedBaseCFrame = Player.Character.HumanoidRootPart.CFrame
            Rayfield:Notify({
                Title = "Base Saved",
                Content = "Your base spot has been saved!",
                Duration = 3
            })
        end
    end
})

MainTab:CreateButton({
    Name = "Go To Base",
    Callback = function()
        if savedBaseCFrame and Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") then
            Player.Character.HumanoidRootPart.CFrame = savedBaseCFrame
            Rayfield:Notify({
                Title = "Teleported",
                Content = "You have been teleported to your base!",
                Duration = 3
            })
        else
            Rayfield:Notify({
                Title = "Error",
                Content = "No base saved yet!",
                Duration = 3
            })
        end
    end
})
