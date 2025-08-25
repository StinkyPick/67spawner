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

-- Ensure a "Pets" folder exists in the player
if not player:FindFirstChild("Pets") then
    local Inventory = Instance.new("Folder")
    Inventory.Name = "Pets"
    Inventory.Parent = player
end

local PetsFolder = player:FindFirstChild("Pets")

-- List of Grow a Garden pets
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

-- Pets category UI
local PetsTab = Window:CreateTab("Pets", 4483362458)
local Section = PetsTab:CreateSection("Pet Spawner")

-- Dropdown to select pet
local PetDropdown = PetsTab:CreateDropdown({
    Name = "Select Pet",
    Options = Pets,
    CurrentOption = nil,
    Flag = "PetDropdown",
    Callback = function(option)
        SelectedPet = option
        Rayfield:Notify({Title="Pet Selected", Content="You selected: "..option, Duration=3})
    end
})

-- Button to spawn pet
PetsTab:CreateButton({
    Name = "Spawn Pet",
    Callback = function()
        if SelectedPet then
            -- Add pet to player's Pets folder (simulated inventory)
            local Pet = PetsFolder:FindFirstChild(SelectedPet)
            if not Pet then
                Pet = Instance.new("Model")
                Pet.Name = SelectedPet
                Pet.Parent = PetsFolder
            end

            -- Spawn pet in workspace
            local Clone = Instance.new("Model")
            Clone.Name = SelectedPet
            Clone.Parent = workspace

            if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                Clone:SetPrimaryPartCFrame(player.Character.HumanoidRootPart.CFrame * CFrame.new(3,0,0))
            end

            -- Reset selection
            SelectedPet = nil
            PetDropdown:SetValue(nil)

            Rayfield:Notify({Title="Pet Spawned", Content=Clone.Name.." has spawned!", Duration=3})
        else
            Rayfield:Notify({Title="Error", Content="No pet selected!", Duration=3})
        end
    end
})

-- Load configuration
Rayfield:LoadConfiguration()
