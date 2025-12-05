-- Fish It Auto Fishing - Delta Executor (Android) Safe
-- Tidak pakai CoreGui, writefile, atau fitur PC-only

local Player = game.Players.LocalPlayer
local UIS = game:GetService("UserInputService")
local VIM = game:GetService("VirtualInputManager")

-- Tunggu karakter
repeat wait() until Player.Character
local Character = Player.Character

-- Cari fishing rod
local function GetRod()
    return Character:FindFirstChild("Fishing Rod") or Player.Backpack:FindFirstChild("Fishing Rod")
end

-- Auto fishing loop
spawn(function()
    while wait(2) do
        local rod = GetRod()
        if not rod then continue end

        -- Equip rod
        if rod.Parent == Player.Backpack then
            Player.Character.Humanoid:EquipTool(rod)
        end

        -- Cek apakah sedang tidak fishing
        local bobber = rod:FindFirstChild("Line") and rod.Line:FindFirstChild("Bobber")
        if not bobber then
            -- Cast
            VIM:SendKeyEvent(true, "E", false, game)
            wait(0.1)
            VIM:SendKeyEvent(false, "E", false, game)
        else
            -- Auto reel saat bite
            local startY = bobber.Position.Y
            repeat wait(0.1) until bobber.Position.Y < startY - 2 or not bobber

            if bobber then
                -- Reel in
                VIM:SendKeyEvent(true, "E", false, game)
                wait(0.1)
                VIM:SendKeyEvent(false, "E", false, game)
                wait(2)
            end
        end
    end
end)

-- Auto sell ikan tiap 30 detik (opsional)
spawn(function()
    local Events = game.ReplicatedStorage:FindFirstChild("Events")
    if not Events then return end
    local SellAll = Events:FindFirstChild("SellAll")
    if not SellAll then return end

    while wait(30) do
        pcall(function()
            SellAll:FireServer()
        end)
    end
end)

print("✅ Fish It Auto Fishing (Mobile Safe) aktif!")
