-- Fish It Advanced Auto Fishing + Auto Perfection
-- By: GitZ (Customized for You)
-- Last Updated: December 2025

-- 🛠️ CONFIGURASI
local CONFIG = {
    AutoSell = true,          -- Jual ikan otomatis tiap 30 detik
    AntiIdle = true,          -- Gerak otomatis agar tidak idle
    EnableGUI = true,         -- Tampilkan GUI toggle
    MinPerfectThreshold = 0.95 -- Minimal 95% untuk dianggap "Perfect"
}

-- ────────────────────────
-- 🔧 LIBRARY & INISIALISASI
-- ────────────────────────

local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()
local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local VirtualUser = game:GetService("VirtualUser")
local UIS = game:GetService("UserInputService")
local TS = game:GetService("TweenService")

local FishingRod = nil
local Enabled = true
local GUI = nil

-- Tunggu Rod
repeat
    FishingRod = Character:FindFirstChild("Fishing Rod") or Player.Backpack:FindFirstChild("Fishing Rod")
    task.wait(0.5)
until FishingRod

Player.Character.Humanoid:EquipTool(FishingRod)

-- ────────────────────────
-- 🎯 AUTO PERFECTION CORE
-- ────────────────────────

local function GetMeterProgress()
    local gui = Player:FindFirstChild("PlayerGui")
    if not gui then return 0 end

    local screen = gui:FindFirstChild("FishingScreen")
    if not screen then return 0 end

    local meter = screen:FindFirstChild("Meter")
    if not meter or not meter:FindFirstChild("Bar") then return 0 end

    local bar = meter.Bar
    if bar:IsA("Frame") and bar.Size.X.Scale > 0 then
        return bar.Size.X.Scale
    end
    return 0
end

-- ────────────────────────
-- 🎣 AUTO FISHING LOOP
-- ────────────────────────

spawn(function()
    while true do
        if not Enabled then
            task.wait(1)
            continue
        end

        if not FishingRod or not FishingRod.Parent then
            warn("Fishing Rod hilang!")
            break
        end

        -- Cek apakah sedang tidak fishing
        local bobber = FishingRod:FindFirstChild("Line") and FishingRod.Line:FindFirstChild("Bobber")
        if not bobber then
            -- LEMPAR PANCING
            game:GetService("VirtualInputManager"):SendKeyEvent(true, "E", false, game)
            task.wait(0.05)
            game:GetService("VirtualInputManager"):SendKeyEvent(false, "E", false, game)
            task.wait(1)
        else
            -- DETEKSI BITE & AUTO REEL + PERFECTION
            local startY = bobber.Position.Y
            local biteDetected = false
            local timeout = 0

            repeat
                task.wait(0.05)
                timeout += 0.05
                if bobber and bobber.Position.Y < startY - 2 then
                    biteDetected = true
                    break
                end
            until timeout > 15

            if biteDetected then
                -- Tekan E untuk mulai reel
                game:GetService("VirtualInputManager"):SendKeyEvent(true, "E", false, game)
                task.wait(0.05)
                game:GetService("VirtualInputManager"):SendKeyEvent(false, "E", false, game)

                -- AUTO PERFECT
                repeat
                    task.wait(0.01)
                    local progress = GetMeterProgress()
                    if progress >= CONFIG.MinPerfectThreshold then
                        game:GetService("VirtualInputManager"):SendKeyEvent(true, "E", false, game)
                        task.wait(0.01)
                        game:GetService("VirtualInputManager"):SendKeyEvent(false, "E", false, game)
                        break
                    end
                until progress >= 1 or not FishingRod:FindFirstChild("Line")

                task.wait(2) -- Jeda setelah dapat ikan
            end
        end

        task.wait(0.1)
    end
end)

-- ────────────────────────
-- 💰 AUTO SELL
-- ────────────────────────

if CONFIG.AutoSell then
    spawn(function()
        while true do
            task.wait(30)
            if Enabled and ReplicatedStorage:FindFirstChild("Events") then
                local sellEvent = ReplicatedStorage.Events:FindFirstChild("SellAll")
                if sellEvent then
                    pcall(function()
                        sellEvent:FireServer()
                    end)
                end
            end
        end
    end)
end

-- ────────────────────────
-- 🚶 ANTI-IDLE
-- ────────────────────────

if CONFIG.AntiIdle then
    spawn(function()
        while true do
            task.wait(60)
            if Enabled and Character and Character.HumanoidRootPart then
                -- Gerak kecil
                local pos = HumanoidRootPart.CFrame
                HumanoidRootPart.CFrame = pos * CFrame.new(math.random(-2, 2), 0, math.random(-2, 2))
                task.wait(0.5)
                HumanoidRootPart.CFrame = pos
            end
        end
    end)
end

-- ────────────────────────
-- 🖥️ GUI TOGGLE (OPTIONAL)
-- ────────────────────────

if CONFIG.EnableGUI then
    GUI = Instance.new("ScreenGui")
    GUI.Name = "FishItAutoGUI"
    GUI.Parent = game:GetService("CoreGui")
    GUI.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.new(0, 120, 0, 40)
    Frame.Position = UDim2.new(1, -130, 0, 20)
    Frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    Frame.BackgroundTransparency = 0.3
    Frame.BorderSizePixel = 0
    Frame.Parent = GUI

    local Text = Instance.new("TextLabel")
    Text.Size = UDim2.new(1, 0, 1, 0)
    Text.BackgroundTransparency = 1
    Text.Text = "🐟 AUTO ON"
    Text.Font = Enum.Font.GothamBold
    Text.TextColor3 = Color3.fromRGB(0, 255, 100)
    Text.TextSize = 14
    Text.Parent = Frame

    Frame.MouseButton1Click:Connect(function()
        Enabled = not Enabled
        Text.Text = Enabled and "🐟 AUTO ON" or "⏹ AUTO OFF"
        Text.TextColor3 = Enabled and Color3.fromRGB(0, 255, 100) or Color3.fromRGB(255, 50, 50)
    end)
end

-- ────────────────────────
-- ✅ SELESAI
-- ────────────────────────

print("✅ Fish It Auto Fishing + Auto Perfection aktif!")
print("ℹ️  Klik GUI di pojok kanan atas untuk matikan.")
