-- // 6 7 Spawner - Grow a Garden (Rayfield UI)
-- // Made for Delta Executor (Local Only, No Callback Errors)

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
    Name = "6 7 Spawner",
    LoadingTitle = "6 7 Spawner",
    LoadingSubtitle = "by Your Friend Kai",
    ConfigurationSaving = { Enabled = false }
})

local player = game.Players.LocalPlayer

-- Ensure Pets folder exists
if not player:FindFirstChild("Pets") then
    local folder = Instance.new("Folder")
    folder.Name = "Pets"
    folder.Parent = player
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

-- Pets tab UI
local PetsTab = Window:CreateTab("Pets", 4483362458)
PetsTab:CreateSection("Pet Spawner")

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

-- Spawn Pet button
PetsTab:CreateButton({
    Name = "Spawn Pet",
    Callback = function()
        if not SelectedPet then
            Rayfield:Notify({Title="Error", Content="No pet selected!", Duration=3})
            return
        end

        -- Add pet to player's inventory
        local InventoryPet = Instance.new("Folder")
        InventoryPet.Name = SelectedPet
        InventoryPet.Parent = PetsFolder

        -- Local visual placeholder
        local PetVisual = Instance.new("Part")
        PetVisual.Size = Vector3.new(2,2,2)
        PetVisual.Anchored = true
        PetVisual.CanCollide = false
        PetVisual.Material = Enum.Material.SmoothPlastic
        PetVisual.Color = Color3.fromRGB(255, 200, 200) -- optional color per pet
        PetVisual.Name = SelectedPet .. "_Visual"
        PetVisual.Parent = workspace

        -- Position in front of the player
        if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local hrp = player.Character.HumanoidRootPart
            PetVisual.CFrame = hrp.CFrame * CFrame.new(3,0,0)
        end

        -- Billboard name
        local Billboard = Instance.new("BillboardGui")
        Billboard.Size = UDim2.new(0,100,0,50)
        Billboard.StudsOffset = Vector3.new(0,3,0)
        Billboard.Adornee = PetVisual
        Billboard.Parent = PetVisual

        local Label = Instance.new("TextLabel")
        Label.Size = UDim2.new(1,0,1,0)
        Label.BackgroundTransparency = 1
        Label.Text = SelectedPet
        Label.TextColor3 = Color3.fromRGB(255,255,255)
        Label.TextScaled = true
        Label.Parent = Billboard

        -- Reset selection
        SelectedPet = nil
        PetDropdown:SetValue(nil)

        -- Notify success
        Rayfield:Notify({Title="Pet Spawned", Content=InventoryPet.Name.." spawned locally!", Duration=3})
    end
})

Rayfield:LoadConfiguration()
