-- FishIt Hub - Android Final v2
-- Author: GitZ
-- Fitur: Auto Click, Infinite Jump, Auto Sell (Count / Delay in Minutes)
-- ❌ Auto Buy dihapus
-- ✅ Delay dalam MENIT
-- ✅ UI draggable di Android

local player = game.Players.LocalPlayer
local UIS = game:GetService("UserInputService")
local VirtualUser = game:GetService("VirtualUser")

if player:FindFirstChild("FishItHub_FinalV2") then
	warn("[FishIt Hub] Already loaded!")
	return
end

local marker = Instance.new("BoolValue")
marker.Name = "FishItHub_FinalV2"
marker.Parent = player

local gui = Instance.new("ScreenGui")
gui.Name = "FishItHub_FinalV2_GUI"
gui.ResetOnSpawn = false
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.Parent = player:WaitForChild("PlayerGui")

-- State
local state = {
	autoClick = false,
	infiniteJump = false,
	autoSell = false,
	sellCount = 20,        -- jual tiap 20 ikan (asumsi)
	sellDelayMin = 5,      -- atau tiap 5 menit
	fishCaught = 0,        -- counter simulasi
	lastSellTime = tick(),
	autoFishingActive = false
}

-- Deteksi auto fishing (opsional)
spawn(function()
	while player and player.Parent do
		task.wait(0.5)
		-- Simulasi: jika player pakai rod & idle, anggap sedang fishing
		local char = player.Character
		if char and char:FindFirstChildWhichIsA("Tool") then
			state.autoFishingActive = true
			state.fishCaught = state.fishCaught + 1  -- increment tiap 0.5 detik (sesuaikan)
		else
			state.autoFishingActive = false
		end
	end
end)

-- === FLOATING BUTTON ===
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
menu.Size = UDim2.new(0, 290, 0, 270)
menu.Position = UDim2.new(0.5, -145, 0.5, -135)
menu.BackgroundColor3 = Color3.fromRGB(18, 18, 28)
menu.BorderColor3 = Color3.fromRGB(80, 100, 180)
menu.BorderSizePixel = 2
menu.Visible = false
menu.Parent = gui

local dragHeader = Instance.new("Frame")
dragHeader.Size = UDim2.new(1, 0, 0, 30)
dragHeader.BackgroundColor3 = Color3.fromRGB(35, 35, 55)
dragHeader.Parent = menu

local title = Instance.new("TextLabel")
title.Text = "🐠 FishIt Auto"
title.Size = UDim2.new(1, 0, 1, 0)
title.BackgroundTransparency = 1
title.TextColor3 = Color3.fromRGB(100, 220, 255)
title.Font = Enum.Font.GothamBold
title.TextSize = 18
title.Parent = dragHeader

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

-- === DRAG SYSTEM ===
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
		if (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) and dragging then
			local delta = input.Position - dragStart
			frame.Position = UDim2.new(
				startPos.X.Scale, startPos.X.Offset + delta.X,
				startPos.Y.Scale, startPos.Y.Offset + delta.Y
			)
		end
	end

	local function inputEnded(input)
		if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
			dragging = false
			frame.BackgroundColor3 = (frame == menu and Color3.fromRGB(35, 35, 55)) or Color3.fromRGB(30, 120, 255)
		end
	end

	handle.InputBegan:Connect(inputBegan)
	handle.InputChanged:Connect(inputChanged)
	handle.InputEnded:Connect(inputEnded)
end

makeDraggable(menu, dragHeader)
makeDraggable(openBtn, openBtn)
openBtn.MouseButton1Click:Connect(function()
	menu.Visible = not menu.Visible
end)

-- === TOGGLES ===
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

addToggle("Auto Click", 40, false, function(v) state.autoClick = v end)
addToggle("Infinite Jump", 80, false, function(v) state.infiniteJump = v end)
addToggle("Auto Sell", 120, false, function(v) state.autoSell = v end)

-- === AUTO SELL SETTINGS ===
local y = 160

-- Count input
local countLabel = Instance.new("TextLabel")
countLabel.Text = "Sell every (count):"
countLabel.Size = UDim2.new(0.65, 0, 0, 20)
countLabel.Position = UDim2.new(0.05, 0, 0, y)
countLabel.BackgroundTransparency = 1
countLabel.TextColor3 = Color3.fromRGB(200, 200, 220)
countLabel.Font = Enum.Font.Gotham
countLabel.TextSize = 14
countLabel.Parent = menu

local countBox = Instance.new("TextBox")
countBox.Text = tostring(state.sellCount)
countBox.Size = UDim2.new(0.25, 0, 0, 20)
countBox.Position = UDim2.new(0.7, 0, 0, y)
countBox.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
countBox.TextColor3 = Color3.fromRGB(255, 255, 255)
countBox.Font = Enum.Font.Gotham
countBox.TextSize = 14
countBox.Parent = menu
countBox.FocusLost:Connect(function()
	state.sellCount = math.max(1, tonumber(countBox.Text) or 20)
	countBox.Text = tostring(state.sellCount)
end)
y += 30

-- Delay (menit) input
local delayLabel = Instance.new("TextLabel")
delayLabel.Text = "or every (minutes):"
delayLabel.Size = UDim2.new(0.65, 0, 0, 20)
delayLabel.Position = UDim2.new(0.05, 0, 0, y)
delayLabel.BackgroundTransparency = 1
delayLabel.TextColor3 = Color3.fromRGB(200, 200, 220)
delayLabel.Font = Enum.Font.Gotham
delayLabel.TextSize = 14
delayLabel.Parent = menu

local delayBox = Instance.new("TextBox")
delayBox.Text = tostring(state.sellDelayMin)
delayBox.Size = UDim2.new(0.25, 0, 0, 20)
delayBox.Position = UDim2.new(0.7, 0, 0, y)
delayBox.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
delayBox.TextColor3 = Color3.fromRGB(255, 255, 255)
delayBox.Font = Enum.Font.Gotham
delayBox.TextSize = 14
delayBox.Parent = menu
delayBox.FocusLost:Connect(function()
	state.sellDelayMin = math.max(1, tonumber(delayBox.Text) or 5)
	delayBox.Text = tostring(state.sellDelayMin)
end)

-- === AUTO CLICK ===
spawn(function()
	while player and player.Parent do
		task.wait(0.1)
		if not state.autoClick then continue end
		pcall(function()
			VirtualUser:CaptureController()
			VirtualUser:ClickButton1(Vector2.new(500, 500))
		end)
		task.wait(0.9)
	end
end)

-- === INFINITE JUMP ===
spawn(function()
	while player and player.Parent do
		task.wait(0.1)
		if not state.infiniteJump then continue end
		local char = player.Character
		local humanoid = char and char:FindFirstChild("Humanoid")
		if humanoid and humanoid:GetState() ~= Enum.HumanoidStateType.Dead then
			humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
		end
		task.wait(0.75)
	end
end)

-- === AUTO SELL (COUNT OR MINUTES) ===
spawn(function()
	while player and player.Parent do
		task.wait(2)
		if not state.autoSell then continue end

		local sellByCount = state.fishCaught >= state.sellCount
		local sellByTime = (tick() - state.lastSellTime) >= (state.sellDelayMin * 60)

		if sellByCount or sellByTime then
			pcall(function()
				-- Cari tombol "Sell" di semua GUI
				for _, gui in ipairs(player.PlayerGui:GetChildren()) do
					if gui:IsA("ScreenGui") then
						local function findSell(obj)
							if obj:IsA("TextButton") and obj.Visible and (obj.Text:lower():find("sell") or obj.Name:lower():find("sell")) then
								return obj
							end
							for _, child in ipairs(obj:GetChildren()) do
								local res = findSell(child)
								if res then return res end
							end
						end

						local btn = findSell(gui)
						if btn then
							VirtualUser:CaptureController()
							VirtualUser:ClickButton1(btn.AbsolutePosition + Vector2.new(10, 10))
							state.fishCaught = 0
							state.lastSellTime = tick()
							warn("[Auto Sell] Triggered: Count=" .. (sellByCount and "✓" or "✗") .. ", Time=" .. (sellByTime and "✓" or "✗"))
							break
						end
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

print("[FishIt Hub] Final v2 Loaded! Tap 🎣 to open menu.")
