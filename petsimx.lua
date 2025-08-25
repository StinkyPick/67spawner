--// Load Rayfield
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "Steal a Brainrot Hub",
   LoadingTitle = "Loading...",
   LoadingSubtitle = "by yfk",
   ConfigurationSaving = {
      Enabled = true,
      FolderName = "BrainrotHub",
      FileName = "MainConfig"
   },
   Discord = {
      Enabled = false,
   },
   KeySystem = false
})

--// Tabs
local MainTab = Window:CreateTab("Main", 4483362458)
local PlayerTab = Window:CreateTab("Player", 4483362458)
local BaseTab = Window:CreateTab("Base", 4483362458)

--// Variables
local savedBaseCFrame = nil
local noclipEnabled = false
local infJumpEnabled = false
local antiHitEnabled = false
local antiRagdollEnabled = false

----------------------------------------------------
-- AUTO COLLECT MONEY
----------------------------------------------------
MainTab:CreateButton({
    Name = "Auto Collect Money",
    Callback = function()
        local player = game.Players.LocalPlayer
        local char = player.Character
        if not char or not char:FindFirstChild("HumanoidRootPart") then return end

        local root = char.HumanoidRootPart
        local oldCFrame = root.CFrame

        for _,v in pairs(workspace:GetDescendants()) do
            if v:IsA("Part") and v.Name == "Money" then
                root.CFrame = v.CFrame
                wait(0.1)
            end
        end

        -- teleport back
        root.CFrame = oldCFrame
        Rayfield:Notify({
            Title = "Auto Collect",
            Content = "Collected all nearby Brainrot cash!",
            Duration = 3
        })
    end
})

----------------------------------------------------
-- NOCLIP
----------------------------------------------------
PlayerTab:CreateToggle({
    Name = "Noclip",
    CurrentValue = false,
    Callback = function(state)
        noclipEnabled = state
    end
})

game:GetService("RunService").Stepped:Connect(function()
    if noclipEnabled then
        for _, part in pairs(game.Players.LocalPlayer.Character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    end
end)

----------------------------------------------------
-- WALKSPEED
----------------------------------------------------
PlayerTab:CreateSlider({
    Name = "WalkSpeed",
    Range = {16, 200},
    Increment = 1,
    Suffix = "Speed",
    CurrentValue = 16,
    Callback = function(val)
        game.Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid").WalkSpeed = val
    end,
})

----------------------------------------------------
-- INFINITE JUMP
----------------------------------------------------
PlayerTab:CreateToggle({
    Name = "Infinite Jump",
    CurrentValue = false,
    Callback = function(state)
        infJumpEnabled = state
    end
})

game:GetService("UserInputService").JumpRequest:Connect(function()
    if infJumpEnabled then
        local hum = game.Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if hum then
            hum:ChangeState("Jumping")
        end
    end
end)

----------------------------------------------------
-- ANTI-HIT
----------------------------------------------------
PlayerTab:CreateToggle({
    Name = "Anti Hit",
    CurrentValue = false,
    Callback = function(state)
        antiHitEnabled = state
        local hum = game.Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if hum then
            if state then
                hum:SetStateEnabled(Enum.HumanoidStateType.Dead, false)
                hum.Health = hum.MaxHealth
            else
                hum:SetStateEnabled(Enum.HumanoidStateType.Dead, true)
            end
        end
    end
})

----------------------------------------------------
-- ANTI-RAGDOLL
----------------------------------------------------
PlayerTab:CreateToggle({
    Name = "Anti Ragdoll",
    CurrentValue = false,
    Callback = function(state)
        antiRagdollEnabled = state
        local char = game.Players.LocalPlayer.Character
        if char then
            for _,v in pairs(char:GetDescendants()) do
                if v:IsA("BallSocketConstraint") then
                    v.Enabled = not state
                end
            end
        end
    end
})

----------------------------------------------------
-- BASE SYSTEM
----------------------------------------------------
BaseTab:CreateButton({
    Name = "Save Base Spot",
    Callback = function()
        local player = game.Players.LocalPlayer
        if player and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            savedBaseCFrame = player.Character.HumanoidRootPart.CFrame
            Rayfield:Notify({
                Title = "Base Saved",
                Content = "Your base spot has been saved!",
                Duration = 3
            })
        end
    end
})

BaseTab:CreateButton({
    Name = "Go To Base",
    Callback = function()
        local player = game.Players.LocalPlayer
        if savedBaseCFrame and player and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            player.Character.HumanoidRootPart.CFrame = savedBaseCFrame
            Rayfield:Notify({
                Title = "Teleported",
                Content = "You have been teleported to your base spot!",
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
