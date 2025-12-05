-- Fish It Auto Fishing + Auto Perfection (Delta Android Safe)
-- Jalankan dengan: loadstring(game:HttpGet("YOUR_RAW_URL"))()

print("Memulai Fish It Auto...")

local Player = game.Players.LocalPlayer
local VIM = game:GetService("VirtualInputManager")

-- Tunggu karakter
repeat wait() until Player.Character
local Character = Player.Character

-- Fungsi untuk dapatkan fishing rod
local function GetRod()
    return Character:FindFirstChild("Fishing Rod") or Player.Backpack:FindFirstChild("Fishing Rod")
end

-- Auto sell ikan tiap 30 detik
spawn(function()
    while wait(30) do
        local sellEvent = game.ReplicatedStorage:FindFirstChild("Events") and game.ReplicatedStorage.Events:FindFirstChild("SellAll")
        if sellEvent then
            pcall(function() sellEvent:FireServer() end)
        end
    end
end)

-- Auto fishing + perfection
spawn(function()
    while wait(1) do
        local rod = GetRod()
        if not rod then continue end

        -- Equip rod jika di backpack
        if rod.Parent == Player.Backpack then
            Character.Humanoid:EquipTool(rod)
        end

        -- Cek apakah sedang fishing
        local bobber = rod:FindFirstChild("Line") and rod.Line:FindFirstChild("Bobber")
        if not bobber then
            -- Lempar kail
            VIM:SendKeyEvent(true, "E", false, game)
            wait(0.1)
            VIM:SendKeyEvent(false, "E", false, game)
        else
            -- Deteksi bite
            local startY = bobber.Position.Y
            repeat wait(0.05) until bobber.Position.Y < startY - 2 or not bobber

            if bobber then
                -- Tarik ikan
                VIM:SendKeyEvent(true, "E", false, game)
                wait(0.1)
                VIM:SendKeyEvent(false, "E", false, game)

                -- 🔥 AUTO PERFECTION
                local function GetProgress()
                    local gui = Player:FindFirstChild("PlayerGui")
                    if not gui then return 0 end
                    local screen = gui:FindFirstChild("FishingScreen")
                    if not screen then return 0 end
                    local bar = screen:FindFirstChild("Meter") and screen.Meter:FindFirstChild("Bar")
                    if not bar then return 0 end
                    return bar.Size.X.Scale or 0
                end

                repeat
                    wait(0.01)
                    local p = GetProgress()
                    if p >= 0.95 then
                        VIM:SendKeyEvent(true, "E", false, game)
                        wait(0.01)
                        VIM:SendKeyEvent(false, "E", false, game)
                        break
                    end
                until p >= 1 or not rod:FindFirstChild("Line")

                wait(2)
            end
        end
    end
end)

print("✅ Fish It Auto Fishing + Perfection aktif!")
