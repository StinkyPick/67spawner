--// Load Rayfield UI
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "Steal a Brainrot",
   LoadingTitle = "Steal a Brainrot",
   LoadingSubtitle = "by yfk",
   ConfigurationSaving = {Enabled = false}
})

local MainTab = Window:CreateTab("Main", 4483362458)

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Player = Players.LocalPlayer

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
    Callback = function(v) noclip = v end
})
RunService.Stepped:Connect(function()
    if noclip and Player.Character then
        for _, part in pairs(Player.Character:GetDescendants()) do
            if part:IsA("BasePart") then part.CanCollide = false end
        end
    end
end)

--// Infinite Jump
local infJump = false
MainTab:CreateToggle({
    Name = "Infinite Jump",
    CurrentValue = false,
    Callback = function(v) infJump = v end
})
UserInputService.JumpRequest:Connect(function()
    if infJump and Player.Character and Player.Character:FindFirstChild("Humanoid") then
        Player.Character.Humanoid:ChangeState("Jumping")
    end
end)

--// Anti-Hit + Anti-Ragdoll
local antiHit = false
MainTab:CreateToggle({
    Name = "Anti Hit / Anti Ragdoll",
    CurrentValue = false,
    Callback = function(v) antiHit = v end
})
RunService.Stepped:Connect(function()
    if antiHit and Player.Character then
        local hum = Player.Character:FindFirstChild("Humanoid")
        if hum then hum:ChangeState(Enum.HumanoidStateType.GettingUp) end
        local hrp = Player.Character:FindFirstChild("HumanoidRootPart")
        if hrp then hrp.Velocity = Vector3.new(0, hrp.Velocity.Y, 0) end
    end
end)

--// Save / Go To Base
local savedBaseCFrame
MainTab:CreateButton({
    Name = "Save Base Spot",
    Callback = function()
        if Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") then
            savedBaseCFrame = Player.Character.HumanoidRootPart.CFrame
            Rayfield:Notify({Title="Base Saved",Content="Base spot saved!",Duration=3})
        end
    end
})
MainTab:CreateButton({
    Name = "Go To Base",
    Callback = function()
        if savedBaseCFrame and Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") then
            Player.Character.HumanoidRootPart.CFrame = savedBaseCFrame
            Rayfield:Notify({Title="Teleported",Content="Returned to base!",Duration=3})
        end
    end
})

--// Auto Collect Money
local autoCollect = false
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
                    local oldCFrame = hrp.CFrame
                    for _, obj in pairs(workspace:GetDescendants()) do
                        if not autoCollect then break end
                        if obj:IsA("TouchTransmitter") and obj.Parent:IsA("BasePart") then
                            hrp.CFrame = obj.Parent.CFrame * CFrame.new(0,-2,0)
                            task.wait(5) -- stay on part for 5 seconds
                        end
                    end
                    hrp.CFrame = oldCFrame
                end
            end
        end)
    end
})

--// Anti Kick (Button)
MainTab:CreateButton({
    Name = "Activate Anti Kick",
    Callback = function()
        local mt = getrawmetatable(game)
        local oldNamecall = mt.__namecall
        setreadonly(mt,false)
        mt.__namecall = newcclosure(function(self,...)
            if getnamecallmethod()=="Kick" or getnamecallmethod()=="kick" then
                warn("[ANTI-KICK] Blocked kick attempt")
                return nil
            end
            return oldNamecall(self,...)
        end)
        Player.Kick = function(...) warn("[ANTI-KICK] Blocked kick attempt") end
        Rayfield:Notify({Title="Anti Kick",Content="Protection Activated",Duration=3})
    end
})

--// Anti Ban (Button)
MainTab:CreateButton({
    Name = "Activate Anti Ban",
    Callback = function()
        game:BindToClose(function()
            warn("[ANTI-BAN] Blocked bind to close!")
            task.wait(9e9) -- freeze game instead of closing
        end)
        Rayfield:Notify({Title="Anti Ban",Content="Protection Activated",Duration=3})
    end
})
