-- FishIt Hub - Loadstring-compatible script
-- Author: GitZ
-- Compatible with Delta Executor
-- Press 'H' to open the hub menu

local player = game.Players.LocalPlayer
local UIS = game:GetService("UserInputService")

-- Prevent duplicate execution
if player:FindFirstChild("FishItHubLoaded") then
    warn("[FishIt Hub] Already loaded!")
    return
end

local marker = Instance.new("BoolValue")
marker.Name = "FishItHubLoaded"
marker.Parent = player

-- Create GUI
local gui = Instance.new("ScreenGui")
gui.Name = "FishItHub_GUI"
gui.ResetOnSpawn = false
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.Parent = player:WaitForChild("PlayerGui")

-- Main frame
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 260, 0, 230)
frame.Position = UDim2.new(0.5, -130, 0.5, -115)
frame.BackgroundColor3 = Color3.fromRGB(18, 18, 28)
frame.BorderColor3 = Color3.fromRGB(80, 80, 120)
frame.BorderSizePixel = 2
frame.Visible = false
frame.Parent = gui

-- Title
local title = Instance.new("TextLabel")
title.Text = "🐠 FishIt Hub"
title.Size = UDim2.new(1, 0, 0, 40)
title.BackgroundTransparency = 1
title.TextColor3 = Color3.fromRGB(100, 220, 255)
title.Font = Enum.Font.GothamBold
title.TextSize = 24
title.Parent = frame

-- Close button
local closeBtn = Instance.new("TextButton")
closeBtn.Text = "✕"
closeBtn.Size = UDim2.new(0, 28, 0, 28)
closeBtn.Position = UDim2.new(1, -32, 0, 6)
closeBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
closeBtn.TextColor3 = Color3.fromRGB(255, 100, 100)
closeBtn.Font = Enum.Font.SourceSans
closeBtn.TextSize = 20
closeBtn.AutoButtonColor = false
closeBtn.Parent = frame
closeBtn.MouseButton1Click:Connect(function()
    frame.Visible = false
end)

-- Define fishing locations (⚠️ EDIT THESE TO MATCH ACTUAL SPAWNS IN FISHIT)
local locations = {
    {Name = "Beach", Pos = Vector3.new(102, 51, 100)},
    {Name = "Lake", Pos = Vector3.new(350, 52, -200)},
    {Name = "River", Pos = Vector3.new(-180, 50, 300)},
    {Name = "Deep Sea", Pos = Vector3.new(600, 55, 500)},
    {Name = "Cave Pond", Pos = Vector3.new(-400, 60, -300)}
}

local y = 50
for _, loc in ipairs(locations) do
    local btn = Instance.new("TextButton")
    btn.Text = "→ " .. loc.Name
    btn.Size = UDim2.new(0.92, 0, 0, 30)
    btn.Position = UDim2.new(0.04, 0, 0, y)
    btn.BackgroundColor3 = Color3.fromRGB(35, 35, 55)
    btn.TextColor3 = Color3.fromRGB(220, 220, 255)
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 15
    btn.AutoButtonColor = false
    btn.Parent = frame

    btn.MouseButton1Click:Connect(function()
        local char = player.Character
        if char and char:FindFirstChild("HumanoidRootPart") then
            char.HumanoidRootPart.CFrame = CFrame.new(loc.Pos)
            frame.Visible = false
        else
            warn("[FishIt Hub] Character not found!")
        end
    end)
    y = y + 35
end

-- Toggle with 'H' key
UIS.InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.H then
        frame.Visible = not frame.Visible
    end
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

print("[FishIt Hub] Loaded successfully! Press 'H' to open.")
