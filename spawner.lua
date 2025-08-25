-- // 6 7 Spawner - Grow a Garden (Rayfield UI)
-- // Made for Roblox Studio (simulate Grow a Garden Pets)

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
local PetAge = ""
local PetWeight = ""

-- Spawner UI
local MainTab = Window:CreateTab("Pets", 4483362458)
local Section = MainTab:CreateSection("Pet Spawner")

-- Dropdown for selecting pet
local PetDropdown = MainTab:CreateDropdown({
    Name = "Select Pet",
    Options = Pets,
    CurrentOption = nil,
    Flag = "PetDropdown",
    Callback = function(option)
        SelectedPet = option
        Rayfield:Notify({Title="Pet Selected", Content="You selected: "..option, Duration=3})
    end
})

-- Textbox for Age
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

-- Textbox for Weight
MainTab:CreateTextbox({
    Name = "Weight",
    PlaceholderText = "Enter Weight",
    Callback = function(text)
        local num = tonumber(text)
        if num and num > 0 then
            PetWeight = num
        else
            Rayfield:Notify({Title="Error", Content="Weight must be a number greater than 0", Duration=3})
            PetWeight = ""
        end
    end
})

-- Button to spawn pet
MainTab:CreateButton({
    Name = "Spawn Pet",
    Callback = function()
        if SelectedPet and PetAge ~= "" and PetWeight ~= "" then
            -- Add to inventory
            local Pet = PetsFolder:FindFirstChild(SelectedPet)
            if not Pet then
                Pet = Instance.new("Model")
                Pet.Name = SelectedPet
                Pet.Parent = PetsFolder
            end
            Pet:SetAttribute("Age", PetAge)
            Pet:SetAttribute("Weight", PetWeight)

            -- Spawn clone in workspace
            local Clone = Instance.new("Model")
            Clone.Name = SelectedPet
            Clone.Parent = workspace
            Clone:SetAttribute("Age", PetAge)
            Clone:SetAttribute("Weight", PetWeight)

            if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                local hrp = player.Character.HumanoidRootPart
                Clone:SetPrimaryPartCFrame(hrp.CFrame * CFrame.new(3,0,0))
            end

            -- Reset selections
            SelectedPet = nil
            PetDropdown:SetValue(nil)
            PetAge = ""
            PetWeight = ""

            Rayfield:Notify({Title="Pet Spawned", Content=Clone.Name.." spawned with Age "..Clone:GetAttribute("Age").." and Weight "..Clone:GetAttribute("Weight").."!", Duration=3})
        else
            Rayfield:Notify({Title="Error", Content="Select a pet and enter valid Age and Weight!", Duration=3})
        end
    end
})

-- Load configuration
Rayfield:LoadConfiguration()
