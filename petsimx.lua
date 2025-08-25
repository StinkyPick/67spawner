--// Load Rayfield UI
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "Steal a Brainrot Hub",
   LoadingTitle = "Steal a Brainrot",
   LoadingSubtitle = "by yfk",
   ConfigurationSaving = {
      Enabled = false
   }
})

local MainTab = Window:CreateTab("Main", 4483362458)

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TeleportService = game:GetService("TeleportService")

local Player = Players.LocalPlayer

--// Auto Rejoin if in Private Server
if game.PrivateServerId ~= "" and game.PrivateServerOwnerId ~= 0 then
    TeleportService:Teleport(game.PlaceId, Player)
end

--// Walkspeed
MainTab:CreateSlider({
    Name = "WalkSpeed",
    Range = {16, 300},
    Increment = 1,
    CurrentValue = 16,
    Callback = function(v)
        if Player.Character and Player.Character:FindFirstChild("Humanoid") then
            Player.Character.Humanoid.WalkSpeed = v
        end
    end
})

--// Noclip
local noclip = false
MainTab:CreateToggle({
    Name = "Noclip",
    CurrentValue = false,
    Callback = function(v)
        noclip = v
    end
})

RunService.Stepped:Connect(function()
    if noclip and Player.Character then
        for _, part in pairs(Player.Character:GetDescendants()) do
            if part:IsA("BasePart") and part.CanCollide then
                part.CanCollide = false
            end
        end
    end
end)

--// Infinite Jump
local infJump = false
MainTab:CreateToggle({
    Name = "Infinite Jump",
    CurrentValue = false,
    Callback = function(v)
        infJump = v
    end
})

UserInputService.JumpRequest:Connect(function()
    if infJump and Player.Character and Player.Character:FindFirstChild("Humanoid") then
        Player.Character:FindFirstChild("Humanoid"):ChangeState("Jumping")
    end
end)

--// Anti-Hit + Anti-Ragdoll
MainTab:CreateToggle({
    Name = "Anti Hit / Anti Ragdoll",
    CurrentValue = true,
    Callback = function(v)
        if v then
            RunService.Stepped:Connect(function()
                if Player.Character then
                    -- Anti Ragdoll
                    local humanoid = Player.Character:FindFirstChild("Humanoid")
                    if humanoid then
                        humanoid:ChangeState(Enum.HumanoidStateType.GettingUp)
                    end
                    -- Anti Hit (forces you upright)
                    local hrp = Player.Character:FindFirstChild("HumanoidRootPart")
                    if hrp then
                        hrp.Velocity = Vector3.new(0, hrp.Velocity.Y, 0)
                    end
                end
            end)
        end
    end
})

--// Save / Go To Base
local savedBaseCFrame = nil
MainTab:CreateButton({
    Name = "Save Base Spot",
    Callback = function()
        if Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") then
            savedBaseCFrame = Player.Character.HumanoidRootPart.CFrame
            Rayfield:Notify({
                Title = "Base Saved",
                Content = "Your base spot has been saved!",
                Duration = 4
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
                Content = "You have been teleported to your base spot!",
                Duration = 4
            })
        else
            Rayfield:Notify({
                Title = "Error",
                Content = "No base spot saved yet!",
                Duration = 4
            })
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
                        if not autoCollect then break end
                        if obj:IsA("TouchTransmitter") and obj.Parent and obj.Parent:IsA("BasePart") then
                            hrp.CFrame = obj.Parent.CFrame * CFrame.new(0, -2, 0)
                            task.wait(2) -- stay on part
                        end
                    end
                    hrp.CFrame = oldCFrame
                end
            end
        end)
    end
})
