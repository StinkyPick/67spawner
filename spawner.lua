-- // 6 7 Spawner - Grow a Garden (Rayfield UI)
-- // Made for Delta Executor

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

local MainTab = Window:CreateTab("Pets", 4483362458) -- Pet icon

local Section = MainTab:CreateSection("Pet Spawner")

-- Grab pets from your inventory (adjust if path is different in Grow a Garden)
local Pets = {}
local player = game.Players.LocalPlayer

if player:FindFirstChild("Pets") then
    for _, pet in pairs(player.Pets:GetChildren()) do
        table.insert(Pets, pet.Name)
    end
end

local SelectedPet = nil

MainTab:CreateDropdown({
    Name = "Select Pet",
    Options = Pets,
    CurrentOption = {},
    Flag = "PetDropdown",
    Callback = function(option)
        SelectedPet = option
        Rayfield:Notify({
            Title = "Pet Selected",
            Content = "You selected: " .. option,
            Duration = 3
        })
    end,
})

MainTab:CreateButton({
    Name = "Spawn Pet",
    Callback = function()
        if SelectedPet then
            local petFolder = player:FindFirstChild("Pets")
            if petFolder then
                local Pet = petFolder:FindFirstChild(SelectedPet)
                if Pet then
                    local Clone = Pet:Clone()
                    Clone.Parent = workspace -- visible to everyone locally
                    Clone:SetPrimaryPartCFrame(player.Character.HumanoidRootPart.CFrame * CFrame.new(3,0,0))

                    Rayfield:Notify({
                        Title = "Pet Spawned",
                        Content = SelectedPet .. " has been spawned!",
                        Duration = 3
                    })
                else
                    Rayfield:Notify({
                        Title = "Error",
                        Content = "Pet not found in inventory!",
                        Duration = 3
                    })
                end
            end
        else
            Rayfield:Notify({
                Title = "Error",
                Content = "No pet selected!",
                Duration = 3
            })
        end
    end,
})

-- this makes the UI appear
Rayfield:LoadConfiguration()
