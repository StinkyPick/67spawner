-- // 6 7 Spawner - Grow a Garden (Rayfield UI)
-- // Made for Roblox Studio (simulating Grow a Garden Pets)

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
    Name = "6 7 Spawner",
    LoadingTitle = "6 7 Spawner",
    LoadingSubtitle = "by Your Friend Kai",
    ConfigurationSaving = {
       Enabled = true,
       FolderName = "67Spawner",
       FileName = "Settings"
    }
})

local player = game.Players.LocalPlayer

-- Create a simulated "Pets" folder for the player
if not player:FindFirstChild("Pets") then
    local Inventory = Instance.new("Folder")
    Inventory.Name = "Pets"
    Inventory.Parent = player
end

local PetsFolder = player:FindFirstChild("Pets")

-- Predefined Grow a Garden pets list
local Pets = {
    "Bunny","Dog","Golden Lab","Dairy Cow","Starfish","Crab","Seagull","Black Bunny",
    "Cat","Chicken","Deer","Bee","Bacon Pig","Jackalope","Monkey","Red Fox","Dragonfly",
    "Disco Bee","Queen Bee","Raccoon","Kitsune","Raiju","Spinosaurus","Butterfly","Blood Hedgehog",
    "Moon Cat","Kappa","Sushi Bear","Triceratops","Pterodactyl","Capybara","Mole","Griffin",
    "Tanchozuru","Hotdog Daschund","Gorilla Chef","Moth","Brontosaurus","Ostrich","Seal",
    "Hyacinth Macaw","Scarlet Macaw","Blood Owl","Tarantula Hawk","Bear Bee","Night Owl","Polar Bear",
    "Raptor","Pachycephalosaurus","Mochi Mouse","Iguanodon","Snake","Fennec Fox","Honey Bee",
    "Petal Bee","Red Giant Ant","Giant Ant","Bald Eagle","Owl","Praying Mantis","Corrupted Kodama",
    "Kodama","Squirrel","Peacock","Toucan","Axolotl","Stegosaurus","Seedling","Chicken Zombie"
}

local SelectedPet = nil

-- Spawner UI
local MainTab = Window:CreateTab("Pets", 4483362458)
local Section = MainTab:CreateSection("Pet Spawner")

MainTab:CreateDropdown({
    Name = "Select Pet",
    Options = Pets,
    CurrentOption = {},
    Flag = "PetDropdown",
    Callback = function(option)
        SelectedPet = option
        Rayfield:Notify({Title="Pet Selected", Content="You selected: "..option, Duration=3})
    end
})

MainTab:CreateButton({
    Name = "Spawn Pet",
    Callback = function()
        if SelectedPet then
            -- Check if the player already has a copy in their inventory
            local Pet = PetsFolder:FindFirstChild(SelectedPet)
            if not Pet then
                -- Simulate adding pet to inventory
                Pet = Instance.new("Model")
                Pet.Name = SelectedPet
                Pet.Parent = PetsFolder
            end

            -- Clone the pet and spawn it in the workspace (visible to everyone)
            local Clone = Instance.new("Model")
            Clone.Name = SelectedPet
            Clone.Parent = workspace
            if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                Clone:SetPrimaryPartCFrame(player.Character.HumanoidRootPart.CFrame * CFrame.new(3,0,0))
            end

            Rayfield:Notify({Title="Pet Spawned", Content=SelectedPet.." spawned in workspace!", Duration=3})
        else
            Rayfield:Notify({Title="Error", Content="No pet selected!", Duration=3})
        end
    end
})

-- Load configuration
Rayfield:LoadConfiguration()
