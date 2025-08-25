-- // 6 7 Spawner - Grow a Garden (Rayfield UI)
-- // Made for Delta Executor / Studio simulation

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
    Name = "6 7 Spawner",
    LoadingTitle = "6 7 Spawner",
    LoadingSubtitle = "by Your Friend Kai",
    ConfigurationSaving = { Enabled = false } -- do not save selections
})

local player = game.Players.LocalPlayer

-- Default pet to spawn
local DefaultPetName = "Bunny"

-- Spawner UI
local MainTab = Window:CreateTab("Spawn", 4483362458)
local Section = MainTab:CreateSection("Spawn Pet")

local PetAge = ""

-- Textbox to enter Age
MainTab:CreateTextbox({
    Name = "Age (1-100)",
    PlaceholderText = "Enter Age",
    Callback = function(text)
        local num = tonumber(text)
        if num and num >= 1 and num <= 100 then
            PetAge = num
        else
            Rayfield:Notify({Title="Error", Content="Age must be between 1 and 100", Duration=3})
            PetAge = ""
        end
    end
})

-- Button to spawn pet
MainTab:CreateButton({
    Name = "Spawn Pet",
    Callback = function()
        if PetAge ~= "" then
            -- Create pet model in workspace
            local Clone = Instance.new("Model")
            Clone.Name = DefaultPetName
            Clone.Parent = workspace
            Clone:SetAttribute("Age", PetAge)

            if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                Clone:SetPrimaryPartCFrame(player.Character.HumanoidRootPart.CFrame * CFrame.new(3,0,0))
            end

            Rayfield:Notify({
                Title="Pet Spawned",
                Content=Clone.Name.." spawned with Age "..Clone:GetAttribute("Age").."!",
                Duration=3
            })

            -- Reset age input for next spawn
            PetAge = ""
        else
            Rayfield:Notify({Title="Error", Content="Enter a valid Age before spawning!", Duration=3})
        end
    end
})

-- Load configuration
Rayfield:LoadConfiguration()
