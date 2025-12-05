-- Fish It Auto Perfection Only
-- Jalankan saat sudah mulai reel (meter muncul)

print("✅ Auto Perfection aktif!")

local Player = game.Players.LocalPlayer
local VIM = game:GetService("VirtualInputManager")

-- Fungsi untuk baca progress meter perfection
local function GetPerfectionProgress()
    local gui = Player:FindFirstChild("PlayerGui")
    if not gui then return 0 end

    local fishingScreen = gui:FindFirstChild("FishingScreen")
    if not fishingScreen then return 0 end

    local meter = fishingScreen:FindFirstChild("Meter")
    if not meter or not meter:FindFirstChild("Bar") then return 0 end

    return meter.Bar.Size.X.Scale or 0
end

-- Loop utama: cek meter & auto perfection
spawn(function()
    while wait(0.01) do
        local progress = GetPerfectionProgress()
        if progress > 0 and progress < 1 then
            -- Zona Perfect: 95% sampai 100%
            if progress >= 0.95 then
                VIM:SendKeyEvent(true, "E", false, game)
                wait(0.01)
                VIM:SendKeyEvent(false, "E", false, game)
                wait(0.5) -- Jeda setelah perfection
            end
        end
    end
end)

print("✨ Tunggu meter muncul, lalu auto perfection akan aktif otomatis.")
