-- FishIt Hub - Android Advanced
-- Author: GitZ | Features: Auto Fishing, Instant Catch, Blatant, Draggable UI
-- Safe for personal use only. Do not distribute or abuse.

local player = game.Players.LocalPlayer
local RS = game:GetService("RunService")
local UIS = game:GetService("UserInputService")

if player:FindFirstChild("FishItHub_Advanced") then
	warn("[FishIt Hub] Already loaded!")
	return
end

local marker = Instance.new("BoolValue")
marker.Name = "FishItHub_Advanced"
marker.Parent = player

local gui = Instance.new("ScreenGui")
gui.Name = "FishItHub_Advanced_GUI"
gui.ResetOnSpawn = false
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.Parent = player:WaitForChild("PlayerGui")

-- State variables
local state = {
	autoFishing = false,
	instantFishing = false,
	blatantMode = false,
	autoPerfection = true,
	fishingInProgress = false
}

-- === DRAGGABLE FLOATING BUTTON ===
local dragToggle = Instance.new("TextButton")
dragToggle.Size = UDim2.new(0, 50, 0, 50)
dragToggle.Position = UDim2.new(1, -60, 1, -60)
dragToggle.BackgroundColor3 = Color3.fromRGB(30, 120, 255)
dragToggle.BorderColor3 = Color3.fromRGB(200, 230, 255)
dragToggle.BorderSizePixel = 2
dragToggle.Text = "🎣"
dragToggle.Font = Enum.Font.GothamBlack
dragToggle.TextSize = 24
dragToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
dragToggle.AutoButtonColor = false
dragToggle.Parent = gui

local draggingToggle = false
local dragStart, startPos

dragToggle.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		draggingToggle = true
		dragStart = input.Position
		startPos = dragToggle.Position
		dragToggle.BackgroundColor3 = Color3.fromRGB(50, 160, 255)
	end
end)

dragToggle.InputChanged:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseMovement then
		if draggingToggle then
			local delta = input.Position - dragStart
			dragToggle.Position = UDim2.new(
				startPos.X.Scale, startPos.X.Offset + delta.X,
				startPos.Y.Scale, startPos.Y.Offset + delta.Y
			)
		end
	end
end)

dragToggle.InputEnded:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		draggingToggle = false
		dragToggle.BackgroundColor3 = Color3.fromRGB(30, 120, 255)
	end
end)

-- === DRAGGABLE MAIN MENU ===
local menu = Instance.new("Frame")
menu.Size = UDim2.new(0, 290, 0, 300)
menu.Position = UDim2.new(0.5, -145, 0.5, -150)
menu.BackgroundColor3 = Color3.fromRGB(15, 15, 25)
menu.BorderColor3 = Color3.fromRGB(80, 100, 180)
menu.BorderSizePixel = 2
menu.Visible = false
menu.Parent = gui

-- Draggable header
local dragBar = Instance.new("Frame")
dragBar.Size = UDim2.new(1, 0, 0, 30)
dragBar.BackgroundColor3 = Color3.fromRGB(30, 30, 50)
dragBar.BorderSizePixel = 0
dragBar.Parent = menu

local title = Instance.new("TextLabel")
title.Text = "🐠 FishIt Pro Hub"
title.BackgroundTransparency = 1
title.TextColor3 = Color3.fromRGB(100, 220, 255)
title.Font = Enum.Font.GothamBold
title.TextSize = 18
title.Size = UDim2.new(1, 0, 1, 0)
title.Parent = dragBar

-- Close button
local closeBtn = Instance.new("TextButton")
closeBtn.Text = "✕"
closeBtn.Size = UDim2.new(0, 26, 0, 26)
closeBtn.Position = UDim2.new(1, -30, 0, 2)
closeBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 90)
closeBtn.TextColor3 = Color3.fromRGB(255, 100, 100)
closeBtn.Font = Enum.Font.SourceSansBold
closeBtn.TextSize = 18
closeBtn.AutoButtonColor = false
closeBtn.Parent = dragBar
closeBtn.MouseButton1Click:Connect(function()
	menu.Visible = false
end)

-- Drag menu
local draggingMenu = false
local menuDragStart, menuStartPos

dragBar.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		draggingMenu = true
		menuDragStart = input.Position
		menuStartPos = menu.Position
	end
end)

dragBar.InputChanged:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseMovement then
		if draggingMenu then
			local delta = input.Position - menuDragStart
			menu.Position = UDim2.new(
				menuStartPos.X.Scale, menuStartPos.X.Offset + delta.X,
				menuStartPos.Y.Scale, menuStartPos.Y.Offset + delta.Y
			)
		end
	end
end)

dragBar.InputEnded:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		draggingMenu = false
	end
end)

-- === TOGGLE CREATOR ===
local function createToggle(name, x, y, defaultValue, callback)
	local toggle = Instance.new("Frame")
	toggle.Size = UDim2.new(0, 250, 0, 30)
	toggle.Position = UDim2.new(0, x, 0, y)
	toggle.BackgroundColor3 = Color3.fromRGB(25, 25, 40)
	toggle.BorderSizePixel = 0
	toggle.Parent = menu

	local label = Instance.new("TextLabel")
	label.Text = name
	label.Size = UDim2.new(0.7, 0, 1, 0)
	label.BackgroundTransparency = 1
	label.TextColor3 = Color3.fromRGB(220, 220, 255)
	label.Font = Enum.Font.Gotham
	label.TextSize = 15
	label.Parent = toggle

	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(0.3, 0, 1, 0)
	btn.Position = UDim2.new(0.7, 0, 0, 0)
	btn.BackgroundColor3 = defaultValue and Color3.fromRGB(40, 180, 80) or Color3.fromRGB(180, 60, 60)
	btn.Text = defaultValue and "ON" or "OFF"
	btn.TextColor3 = Color3.fromRGB(255, 255, 255)
	btn.Font = Enum.Font.GothamBold
	btn.TextSize = 14
	btn.AutoButtonColor = false
	btn.Parent = toggle

	btn.MouseButton1Click:Connect(function()
		defaultValue = not defaultValue
		btn.BackgroundColor3 = defaultValue and Color3.fromRGB(40, 180, 80) or Color3.fromRGB(180, 60, 60)
		btn.Text = defaultValue and "ON" or "OFF"
		if callback then callback(defaultValue) end
	end)

	return toggle
end

-- === FEATURE TOGGLES ===
local yOffset = 40

createToggle("Auto Fishing", 20, yOffset, false, function(enabled)
	state.autoFishing = enabled
end); yOffset += 40

createToggle("Instant Fishing", 20, yOffset, false, function(enabled)
	state.instantFishing = enabled
end); yOffset += 40

createToggle("Blatant Mode", 20, yOffset, false, function(enabled)
	state.blatantMode = enabled
	if enabled then
		-- Inject fish-spawner override (example logic)
		pcall(function()
			if workspace:FindFirstChild("FishSpawner") then
				workspace.FishSpawner.MaxFish.Value = 50
				workspace.FishSpawner.SpawnRate.Value = 0.2
			end
		end)
	end
end); yOffset += 40

createToggle("Auto Perfection", 20, yOffset, true, function(enabled)
	state.autoPerfection = enabled
end); yOffset += 40

-- === TELEPORT LOCATIONS ===
local locations = {
	{Name = "Beach", Pos = Vector3.new(102, 51, 100)},
	{Name = "Lake", Pos = Vector3.new(350, 52, -200)},
	{Name = "River", Pos = Vector3.new(-180, 50, 300)},
	{Name = "Deep Sea", Pos = Vector3.new(600, 55, 500)},
}

local yLoc = yOffset
for _, loc in ipairs(locations) do
	local btn = Instance.new("TextButton")
	btn.Text = "→ " .. loc.Name
	btn.Size = UDim2.new(0.92, 0, 0, 30)
	btn.Position = UDim2.new(0.04, 0, 0, yLoc)
	btn.BackgroundColor3 = Color3.fromRGB(35, 35, 55)
	btn.TextColor3 = Color3.fromRGB(220, 220, 255)
	btn.Font = Enum.Font.Gotham
	btn.TextSize = 15
	btn.AutoButtonColor = false
	btn.Parent = menu
	btn.MouseButton1Click:Connect(function()
		local char = player.Character
		if char and char:FindFirstChild("HumanoidRootPart") then
			char.HumanoidRootPart.CFrame = CFrame.new(loc.Pos)
			menu.Visible = false
		end
	end)
	yLoc += 35
end

-- Open/close menu
dragToggle.MouseButton1Click:Connect(function()
	menu.Visible = not menu.Visible
end)

-- === CORE FISHING LOGIC ===
spawn(function()
	while true do
		task.wait(0.1)
		if not state.autoFishing then continue end

		local char = player.Character
		if not char then continue end

		local hrp = char:FindFirstChild("HumanoidRootPart")
		local fishingRod = char:FindFirstChildWhichIsA("Tool") or (player:FindFirstChild("Backpack") and player.Backpack:FindFirstChildWhichIsA("Tool"))

		if not fishingRod or not hrp then continue end

		if state.fishingInProgress then continue end

		state.fishingInProgress = true

		-- Simulate cast
		if fishingRod:FindFirstChild("Cast") then
			fishingRod.Cast:Activate()
		end

		-- Instant catch
		if state.instantFishing then
			task.wait(0.3)
			if fishingRod:FindFirstChild("Reel") then
				fishingRod.Reel:Activate()
			end
		else
			-- Wait for fish bite
			task.wait(1.5)
			if fishingRod:FindFirstChild("Reel") then
				fishingRod.Reel:Activate()
			end
		end

		-- Auto perfection (simulate perfect timing)
		if state.autoPerfection then
			spawn(function()
				task.wait(0.1)
				for i = 1, 5 do
					if fishingRod:FindFirstChild("Perfect") then
						fishingRod.Perfect:Activate()
					end
					task.wait(0.05)
				end
			end)
		end

		task.wait(1.5) -- cooldown
		state.fishingInProgress = false
	end
end)

-- === Cleanup ===
player.AncestryChanged:Connect(function()
	if not player:IsDescendantOf(game) then
		pcall(function()
			if gui and gui.Parent then gui:Destroy() end
			if marker and marker.Parent then marker:Destroy() end
		end)
	end
end)

print("[FishIt Hub] Advanced Android version loaded! Tap 🎣 to open.")
