-- FishIt Hub - Android Version
-- Author: GitZ
-- Optimized for touch (no keyboard needed)
-- Works with Delta Executor on Android

local player = game.Players.LocalPlayer

-- Prevent duplicate execution
if player:FindFirstChild("FishItHub_Android") then
    warn("[FishIt Hub] Already loaded on Android!")
    return
end

local marker = Instance.new("BoolValue")
marker.Name = "FishItHub_Android"
marker.Parent = player

local gui = Instance.new("ScreenGui")
gui.Name = "FishItHub_Android_GUI"
gui.ResetOnSpawn = false
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.Parent = player:WaitForChild("PlayerGui")

-- 🔘 Floating Open Button (Bottom-right corner)
local openButton = Instance.new("TextButton")
openButton.Size = UDim2.new(0, 60, 0, 60)
openButton.Position = UDim2.new(1, -70, 1, -70)
openButton.BackgroundColor3 = Color3.fromRGB(30, 120, 255)
openButton.BorderColor3 = Color3.fromRGB(200, 230, 255)
openButton.BorderSizePixel = 2
openButton.AutoButtonColor = false
openButton.Text = "🎣"
openButton.Font = Enum.Font.GothamBlack
openButton.TextSize = 28
openButton.TextColor3 = Color3.fromRGB(255, 255, 255)
openButton.Parent = gui

-- 📋 Main Hub Menu (initially hidden)
local hubFrame = Instance.new("Frame")
hubFrame.Size = UDim2.new(0, 280, 0, 260)
hubFrame.Position = UDim2.new(0.5, -140, 0.5, -130)
hubFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 25)
hubFrame.BorderColor3 = Color3.fromRGB(80, 100, 180)
hubFrame.BorderSizePixel = 2
hubFrame.Visible = false
hubFrame.Parent = gui

-- Title
local title = Instance.new("TextLabel")
title.Text = "🐠 FishIt Hub"
title.Size = UDim2.new(1, 0, 0, 40)
title.BackgroundTransparency = 1
title.TextColor3 = Color3.fromRGB(100, 220, 255)
title.Font = Enum.Font.GothamBold
title.TextSize = 22
title.Parent = hubFrame

-- Close button (top-right inside menu)
local closeBtn = Instance.new("TextButton")
closeBtn.Text = "✕"
closeBtn.Size = UDim2.new(0, 30, 0, 30)
closeBtn.Position = UDim2.new(1, -35, 0, 5)
closeBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
closeBtn.TextColor3 = Color3.fromRGB(255, 100, 100)
closeBtn.Font = Enum.Font.SourceSansBold
closeBtn.TextSize = 22
closeBtn.AutoButtonColor = false
closeBtn.Parent = hubFrame
closeBtn.MouseButton1Click:Connect(function()
    hubFrame.Visible = false
end)

-- 📍 Locations (EDIT TO MATCH FISHIT MAP)
local locations = {
    {Name = "Beach", Pos = Vector3.new(102, 51, 100)},
    {Name = "Lake", Pos = Vector3.new(350, 52, -200)},
    {Name = "River", Pos = Vector3.new(-180, 50, 300)},
    {Name = "Deep Sea", Pos = Vector3.new(600, 55, 500)},
    {Name = "Cave Pond", Pos = Vector3.new(-400, 60, -300)}
}

local y = 55
for _, loc in ipairs(locations) do
    local btn = Instance.new("TextButton")
    btn.Text = "→ " .. loc.Name
    btn.Size = UDim2.new(0.92, 0, 0, 36)
    btn.Position = UDim2.new(0.04, 0, 0, y)
    btn.BackgroundColor3 = Color3.fromRGB(35, 35, 55)
    btn.TextColor3 = Color3.fromRGB(220, 220, 255)
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 16
    btn.AutoButtonColor = false
    btn.Parent = hubFrame

    btn.MouseButton1Click:Connect(function()
        local char = player.Character
        if char and char:FindFirstChild("HumanoidRootPart") then
            char.HumanoidRootPart.CFrame = CFrame.new(loc.Pos)
            hubFrame.Visible = false
        else
            warn("[FishIt Hub] Character not loaded!")
        end
    end)
    y = y + 42
end

-- Toggle menu visibility
openButton.MouseButton1Click:Connect(function()
    hubFrame.Visible = not hubFrame.Visible
end)

-- Optional: Slight hover effect (visual feedback)
openButton.MouseEnter:Connect(function()
    openButton.BackgroundColor3 = Color3.fromRGB(50, 140, 255)
end)
openButton.MouseLeave:Connect(function()
    openButton.BackgroundColor3 = Color3.fromRGB(30, 120, 255)
end)

-- Cleanup on leave
player.AncestryChanged:Connect(function()
    if not player:IsDescendantOf(game) then
        pcall(function()
            if gui and gui.Parent then gui:Destroy() end
            if marker and marker.Parent then marker:Destroy() end
        end)
    end
end)

print("[FishIt Hub] Android version loaded! Tap the 🎣 button to open.")
