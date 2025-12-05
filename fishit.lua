-- FishIt Hub - Android FIXED
-- Author: GitZ
-- ✅ Draggable UI di Android
-- ✅ Auto Fishing, Instant Catch, Auto Perfection, Blatant
-- ❌ Teleport dihapus
-- 💡 Menggunakan input virtual (keyboard simulation)

local player = game.Players.LocalPlayer
local UIS = game:GetService("UserInputService")
local RS = game:GetService("RunService")

if player:FindFirstChild("FishItHub_Fixed") then
	warn("[FishIt Hub] Already loaded!")
	return
end

local marker = Instance.new("BoolValue")
marker.Name = "FishItHub_Fixed"
marker.Parent = player

local gui = Instance.new("ScreenGui")
gui.Name = "FishItHub_Fixed_GUI"
gui.ResetOnSpawn = false
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.Parent = player:WaitForChild("PlayerGui")

-- State
local state = {
	autoFishing = false,
	instantFishing = false,
	blatantMode = false,
	autoPerfection = true
}

-- === DRAGGABLE FLOATING BUTTON (ANDROID COMPATIBLE) ===
local openBtn = Instance.new("TextButton")
openBtn.Size = UDim2.new(0, 55, 0, 55)
openBtn.Position = UDim2.new(1, -65, 1, -65)
openBtn.BackgroundColor3 = Color3.fromRGB(30, 120, 255)
openBtn.Text = "🎣"
openBtn.Font = Enum.Font.GothamBlack
openBtn.TextSize = 24
openBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
openBtn.BorderSizePixel = 0
openBtn.AutoButtonColor = false
openBtn.Parent = gui

-- === DRAGGABLE MENU ===
local menu = Instance.new("Frame")
menu.Size = UDim2.new(0, 270, 0, 220)
menu.Position = UDim2.new(0.5, -135, 0.5, -110)
menu.BackgroundColor3 = Color3.fromRGB(18, 18, 28)
menu.BorderColor3 = Color3.fromRGB(80, 100, 180)
menu.BorderSizePixel = 2
menu.Visible = false
menu.Parent = gui

-- Draggable header (use Touch)
local dragHeader = Instance.new("Frame")
dragHeader.Size = UDim2.new(1, 0, 0, 30)
dragHeader.BackgroundColor3 = Color3.fromRGB(35, 35, 55)
dragHeader.Parent = menu

local title = Instance.new("TextLabel")
title.Text = "🐠 FishIt Pro"
title.Size = UDim2.new(1, 0, 1, 0)
title.BackgroundTransparency = 1
title.TextColor3 = Color3.fromRGB(100, 220, 255)
title.Font = Enum.Font.GothamBold
title.TextSize = 18
title.Parent = dragHeader

-- Close button
local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 26, 0, 26)
closeBtn.Position = UDim2.new(1, -30, 0, 2)
closeBtn.Text = "✕"
closeBtn.Font = Enum.Font.SourceSansBold
closeBtn.TextSize = 18
closeBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 90)
closeBtn.TextColor3 = Color3.fromRGB(255, 100, 100)
closeBtn.AutoButtonColor = false
closeBtn.Parent = dragHeader
closeBtn.MouseButton1Click:Connect(function()
	menu.Visible = false
end)

-- === DRAG SYSTEM (WORKS ON ANDROID) ===
local function makeDraggable(frame, handle)
	local dragging = false
	local dragStart, startPos

	local function inputBegan(input)
		if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
			dragging = true
			dragStart = input.Position
			startPos = frame.Position
			frame.BackgroundColor3 = Color3.fromRGB(50, 50, 80)
		end
	end

	local function inputChanged(input)
		if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
			if dragging then
				local delta = input.Position - dragStart
				frame.Position = UDim2.new(
					startPos.X.Scale, startPos.X.Offset + delta.X,
					startPos.Y.Scale, startPos.Y.Offset + delta.Y
				)
			end
		end
	end

	local function inputEnded(input)
		if (input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1) then
			dragging = false
			frame.BackgroundColor3 = Color3.fromRGB(35, 35, 55)
		end
	end

	handle.InputBegan:Connect(inputBegan)
	handle.InputChanged:Connect(inputChanged)
	handle.InputEnded:Connect(inputEnded)
end

makeDraggable(menu, dragHeader)
makeDraggable(openBtn, openBtn) -- also draggable

openBtn.MouseButton1Click:Connect(function()
	menu.Visible = not menu.Visible
end)

-- === TOGGLE FUNCTION ===
local function addToggle(name, y, default, callback)
	local frame = Instance.new("Frame")
	frame.Size = UDim2.new(1, -20, 0, 32)
	frame.Position = UDim2.new(0, 10, 0, y)
	frame.BackgroundColor3 = Color3.fromRGB(28, 28, 42)
	frame.BorderSizePixel = 0
	frame.Parent = menu

	local label = Instance.new("TextLabel")
	label.Text = name
	label.Size = UDim2.new(0.7, 0, 1, 0)
	label.BackgroundTransparency = 1
	label.TextColor3 = Color3.fromRGB(220, 220, 255)
	label.Font = Enum.Font.Gotham
	label.TextSize = 15
	label.Parent = frame

	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(0.3, 0, 1, 0)
	btn.Position = UDim2.new(0.7, 0, 0, 0)
	btn.BackgroundColor3 = default and Color3.fromRGB(40, 180, 80) or Color3.fromRGB(180, 60, 60)
	btn.Text = default and "ON" or "OFF"
	btn.TextColor3 = Color3.fromRGB(255, 255, 255)
	btn.Font = Enum.Font.GothamBold
	btn.TextSize = 14
	btn.AutoButtonColor = false
	btn.Parent = frame

	btn.MouseButton1Click:Connect(function()
		default = not default
		btn.BackgroundColor3 = default and Color3.fromRGB(40, 180, 80) or Color3.fromRGB(180, 60, 60)
		btn.Text = default and "ON" or "OFF"
		if callback then callback(default) end
	end)

	return frame
end

-- === ADD TOGGLES ===
addToggle("Auto Fishing", 40, false, function(v) state.autoFishing = v end)
addToggle("Instant Catch", 80, false, function(v) state.instantFishing = v end)
addToggle("Blatant Mode", 120, false, function(v) state.blatantMode = v end)
addToggle("Auto Perfection", 160, true, function(v) state.autoPerfection = v end)

-- === CORE FISHING LOOP (USING KEY SIMULATION) ===
-- Catatan: FishIt biasanya pakai:
--   SPACE = Cast / Reel
--   F = Perfect Timing
-- Jika berbeda, ganti KeyCode!

spawn(function()
	while player and player.Parent do
		task.wait(0.1)

		if not state.autoFishing then continue end

		-- Cek apakah pemain punya rod (di tangan atau backpack)
		local hasRod = false
		if player.Character then
			for _, child in ipairs(player.Character:GetChildren()) do
				if child:IsA("Tool") and child:FindFirstChild("Handle") then
					hasRod = true; break
				end
			end
		end
		if not hasRod and player:FindFirstChild("Backpack") then
			for _, child in ipairs(player.Backpack:GetChildren()) do
				if child:IsA("Tool") then
					hasRod = true; break
				end
			end
		end

		if not hasRod then continue end

		-- 🔁 AUTO FISHING FLOW
		-- 1. Lemparkan kail
		UIS:SendKeyEvent(true, Enum.KeyCode.Space, false, game)
		task.wait(0.1)
		UIS:SendKeyEvent(false, Enum.KeyCode.Space, false, game)

		if state.instantFishing then
			task.wait(0.1)
		else
			task.wait(math.random(15, 25) / 10) -- tunggu ikan menggigit (1.5-2.5 detik)
		end

		-- 2. Tarik kail (reel)
		UIS:SendKeyEvent(true, Enum.KeyCode.Space, false, game)
		task.wait(0.1)
		UIS:SendKeyEvent(false, Enum.KeyCode.Space, false, game)

		-- 3. Auto Perfection (spam F saat reel)
		if state.autoPerfection then
			spawn(function()
				for i = 1, 8 do
					task.wait(0.05)
					UIS:SendKeyEvent(true, Enum.KeyCode.F, false, game)
					task.wait(0.01)
					UIS:SendKeyEvent(false, Enum.KeyCode.F, false, game)
				end
			end)
		end

		-- 4. Cooldown
		task.wait(1)
	end
end)

-- === BLATANT MODE HOOK (CONTOH) ===
spawn(function()
	while player and player.Parent do
		task.wait(1)
		if state.blatantMode then
			-- Coba boost fish spawn (ganti sesuai struktur game)
			pcall(function()
				local fishSpawner = workspace:FindFirstChild("FishSpawner") or workspace:FindFirstChild("FishingManager")
				if fishSpawner then
					if fishSpawner:FindFirstChild("MaxFish") then
						fishSpawner.MaxFish.Value = math.max(fishSpawner.MaxFish.Value, 30)
					end
					if fishSpawner:FindFirstChild("SpawnRate") then
						fishSpawner.SpawnRate.Value = math.min(fishSpawner.SpawnRate.Value, 0.5)
					end
				end
			end)
		end
	end
end)

-- === CLEANUP ===
player.AncestryChanged:Connect(function()
	if not player:IsDescendantOf(game) then
		pcall(function()
			if gui and gui.Parent then gui:Destroy() end
			if marker and marker.Parent then marker:Destroy() end
		end)
	end
end)

print("[FishIt Hub] Android Fixed - Loaded! Tap 🎣 to open menu.")
