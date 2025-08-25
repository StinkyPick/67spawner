-- 6 7 Spawner (Local-Only, Rayfield UI)
-- Put this LocalScript in StarterPlayerScripts

local Rayfield = require(game.ReplicatedStorage:WaitForChild("RayfieldModule"))
local PetsFolder = game:GetService("ReplicatedStorage"):WaitForChild("Pets")
local player = game:GetService("Players").LocalPlayer

local Window = Rayfield:CreateWindow({
    Name = "6 7 Spawner",
    LoadingTitle = "6 7 Spawner",
    LoadingSubtitle = "By Your Friend Kai",
    ConfigurationSaving = { Enabled = false }
})

local MainTab = Window:CreateTab("Pets")
local PetSection = MainTab:CreateSection("Spawn a Pet")

-- Dropdown: list all available pets
local petNames = {}
for _, petModel in ipairs(PetsFolder:GetChildren()) do
    if petModel:IsA("Model") then
        table.insert(petNames, petModel.Name)
    end
end

local selectedPet = nil
MainTab:CreateDropdown({
    Name = "Select Pet",
    Options = petNames,
    CurrentOption = petNames[1],
    Flag = "petDropdown",
    Callback = function(val) selectedPet = val end
})

-- Value controls
local age = 1
local weight = 1
local color = Color3.new(1, 1, 1)
local scale = 1

MainTab:CreateSlider({
    Name = "Age (1-100)",
    Range = {1, 100},
    Increment = 1,
    Default = 10,
    Callback = function(val) age = val end
})

MainTab:CreateSlider({
    Name = "Weight",
    Range = {0, 100},
    Increment = 1,
    Default = 10,
    Callback = function(val) weight = val end
})

MainTab:CreateColorPicker({
    Name = "Color",
    Default = {1,1,1},
    Callback = function(col) color = Color3.fromRGB(col[1]*255, col[2]*255, col[3]*255) end
})

MainTab:CreateSlider({
    Name = "Size Scale",
    Range = {0.2, 4},
    Increment = 0.1,
    Default = 1,
    Callback = function(val) scale = val end
})

MainTab:CreateButton({
    Name = "Spawn Pet (Local Only)",
    Callback = function()
        if not selectedPet then return end
        local petModel = PetsFolder:FindFirstChild(selectedPet)
        if not petModel then return end
        local clone = petModel:Clone()
        clone.Parent = workspace
        -- set visuals
        for _, part in ipairs(clone:GetDescendants()) do
            if part:IsA("BasePart") then part.Color = color end
        end
        clone:SetPrimaryPartCFrame(player.Character and player.Character:FindFirstChild("HumanoidRootPart").CFrame * CFrame.new(3,0,0))
        clone:SetAttribute("Age", age)
        clone:SetAttribute("Weight", weight)
        clone:SetAttribute("LocalOnly", true)
        -- optional: attach labeling
    end
})

console.log("6 7 Spawner ready (local only)")
