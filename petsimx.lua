-- Load Rayfield
local Rayfield = loadstring(game:HttpGet("https://sirius.menu/rayfield"))()

local Window = Rayfield:CreateWindow({
    Name = "Steal a Brainrot",
    LoadingTitle = "Nexten Script Hub",
    LoadingSubtitle = "Auto Money, Noclip, WalkSpeed, Infinite Jump, Anti-Hit & Anti-Ragdoll by yfk",
    ConfigurationSaving = {
        Enabled = true,
        FolderName = "NextenScriptHub",
        FileName = "StealABrainrot"
    }
})

-- Tabs
local MainTab = Window:CreateTab("Main", 4483362458)
local PlayerTab = Window:CreateTab("Player", 4483362458)
local MiscTab = Window:CreateTab("Misc", 4483362458)

-- Variables
local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local autoCollectEnabled = false
local noclipEnabled = false
local infiniteJumpEnabled = false
local walkspeedValue = 50
local antiHitEnabled = false

-- Functions
local function noclipLoop()
    while noclipEnabled do
        for _,part in pairs(character:GetChildren()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
        game:GetService("RunService").Stepped:Wait()
    end
    for _,part in pairs(character:GetChildren()) do
        if part:IsA("BasePart") then
            part.CanCollide = true
        end
    end
end

-- Auto Collect Money
MainTab:CreateToggle({
    Name = "Auto Collect Money",
    CurrentValue = false,
    Flag = "AutoCollectMoney",
    Callback = function(value)
        autoCollectEnabled = value
        spawn(function()
            while autoCollectEnabled do
                if workspace:FindFirstChild("Cash") then
                    for _,cash in pairs(workspace.Cash:GetChildren()) do
                        if cash:IsA("Part") then
                            local originalCFrame = character.HumanoidRootPart.CFrame
                            character.HumanoidRootPart.CFrame = cash.CFrame + Vector3.new(0,3,0)
                            wait(0.05)
                            character.HumanoidRootPart.CFrame = originalCFrame
                        end
                    end
                end
                wait(0.1)
            end
        end)
    end
})

-- WalkSpeed Slider
PlayerTab:CreateSlider({
    Name = "WalkSpeed",
    Range = {16, 250},
    Increment = 1,
    Suffix = "speed",
    CurrentValue = 50,
    Flag = "WalkSpeedSlider",
    Callback = function(value)
        walkspeedValue = value
        character.Humanoid.WalkSpeed = walkspeedValue
    end
})

-- Noclip Toggle
MiscTab:CreateToggle({
    Name = "Noclip",
    CurrentValue = false,
    Flag = "NoclipToggle",
    Callback = function(value)
        noclipEnabled = value
        spawn(noclipLoop)
    end
})

-- Infinite Jump
MiscTab:CreateToggle({
    Name = "Infinite Jump",
    CurrentValue = false,
    Flag = "InfiniteJumpToggle",
    Callback = function(value)
        infiniteJumpEnabled = value
    end
})

game:GetService("UserInputService").JumpRequest:Connect(function()
    if infiniteJumpEnabled then
        character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
    end
end)

-- Anti-Hit / Anti-Ragdoll
MiscTab:CreateToggle({
    Name = "Anti Hit / Anti Ragdoll",
    CurrentValue = false,
    Flag = "AntiHitToggle",
    Callback = function(value)
        antiHitEnabled = value
        if antiHitEnabled then
            if character:FindFirstChild("Humanoid") then
                character.Humanoid:GetPropertyChangedSignal("Health"):Connect(function()
                    if character.Humanoid.Health < character.Humanoid.MaxHealth then
                        character.Humanoid.Health = character.Humanoid.MaxHealth
                    end
                end)
            end
            -- Anti ragdoll by resetting state if ragdoll occurs
            character.Humanoid.StateChanged:Connect(function(_,newState)
                if newState == Enum.HumanoidStateType.FallingDown or newState == Enum.HumanoidStateType.Ragdoll then
                    character.Humanoid:ChangeState(Enum.HumanoidStateType.GettingUp)
                end
            end)
        end
    end
})

Rayfield:Notify({
    Title = "Steal a Brainrot - Ultimate",
    Content = "Loaded! Auto Money, Noclip, WalkSpeed, Infinite Jump, Anti-Hit & Anti-Ragdoll active!",
    Duration = 5,
    Image = 4483362458
})
