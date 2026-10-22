local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local SoundService = game:GetService("SoundService")
local Lighting = game:GetService("Lighting")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")

local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera

local Theme = {
	Bg = Color3.fromRGB(16, 16, 22),
	Panel = Color3.fromRGB(22, 22, 30),
	TabBar = Color3.fromRGB(20, 20, 28),
	Item = Color3.fromRGB(30, 30, 42),
	ItemHover = Color3.fromRGB(40, 40, 56),
	Accent = Color3.fromRGB(110, 110, 255),
	AccentDim = Color3.fromRGB(60, 60, 130),
	Text = Color3.fromRGB(225, 225, 245),
	SubText = Color3.fromRGB(150, 150, 180),
	Stroke = Color3.fromRGB(70, 70, 160),
	Close = Color3.fromRGB(220, 80, 110),
	Open = Color3.fromRGB(70, 160, 110),
}

local UI_ID = tostring(math.floor(tick() * 1000) % 100000000)
local function uid(name) return name .. "_" .. UI_ID end

local AccentObjects = {}
local Locked = false

local function registerAccent(obj, prop)
	table.insert(AccentObjects, { obj = obj, prop = prop })
end

local function corner(parent, radius)
	local c = Instance.new("UICorner", parent)
	c.CornerRadius = UDim.new(0, radius or 6)
	return c
end

local function stroke(parent, color, thickness)
	local s = Instance.new("UIStroke", parent)
	s.Color = color or Theme.Stroke
	s.Thickness = thickness or 1
	s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	return s
end

local function tween(obj, time, props, style, dir)
	local info = TweenInfo.new(time or 0.25, style or Enum.EasingStyle.Quart, dir or Enum.EasingDirection.Out)
	local t = TweenService:Create(obj, info, props)
	t:Play()
	return t
end

local function getViewportSize()
	if Camera then return Camera.ViewportSize end
	return Vector2.new(1280, 720)
end

local function getDefaultUISize()
	local vp = getViewportSize()
	local w = math.clamp(vp.X * 0.92, 320, 580)
	local h = math.clamp(vp.Y * 0.80, 240, 360)
	return Vector2.new(math.floor(w), math.floor(h))
end

local SavedSize = getDefaultUISize()

local function makeDraggable(handle, frame, onClick)
	local dragging = false
	local dragStart, startPos
	local pressPos, pressTime

	local function onPressStart(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			pressPos = input.Position
			pressTime = tick()
			if Locked then return end
			dragging = true
			dragStart = input.Position
			startPos = frame.Position
		end
	end

	local function onPressEnd(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			if pressPos and pressTime then
				local delta = input.Position - pressPos
				local dist = math.sqrt(delta.X * delta.X + delta.Y * delta.Y)
				local elapsed = tick() - pressTime
				if dist <= 6 and elapsed <= 0.6 and onClick then onClick() end
			end
			dragging = false
			pressPos = nil
			pressTime = nil
		end
	end

	handle.InputBegan:Connect(onPressStart)
	handle.InputEnded:Connect(onPressEnd)
	UserInputService.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			if pressPos and pressTime and dragging then
				local delta = input.Position - pressPos
				local dist = math.sqrt(delta.X * delta.X + delta.Y * delta.Y)
				local elapsed = tick() - pressTime
				if dist <= 6 and elapsed <= 0.6 and onClick then onClick() end
			end
			dragging = false
			pressPos = nil
			pressTime = nil
		end
	end)

	UserInputService.InputChanged:Connect(function(input)
		if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
			local delta = input.Position - dragStart
			frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
		end
	end)
end

local function makeResizable(handle, frame, minSize, maxSize)
	minSize = minSize or Vector2.new(320, 240)
	maxSize = maxSize or Vector2.new(1200, 800)
	local resizing = false
	local startSize, startInputPos

	handle.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			if Locked then return end
			resizing = true
			startInputPos = input.Position
			startSize = frame.AbsoluteSize
		end
	end)

	UserInputService.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			resizing = false
		end
	end)

	UserInputService.InputChanged:Connect(function(input)
		if resizing and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
			local vp = getViewportSize()
			local dynMaxX = math.max(minSize.X, vp.X - 24)
			local dynMaxY = math.max(minSize.Y, vp.Y - 24)
			local maxX = math.min(maxSize.X, dynMaxX)
			local maxY = math.min(maxSize.Y, dynMaxY)
			local delta = input.Position - startInputPos
			local newWidth = math.clamp(startSize.X + delta.X, minSize.X, maxX)
			local newHeight = math.clamp(startSize.Y + delta.Y, minSize.Y, maxY)
			frame.Size = UDim2.new(0, newWidth, 0, newHeight)
			SavedSize = Vector2.new(newWidth, newHeight)
		end
	end)
end

local function addHover(btn, normal, hover)
	btn.MouseEnter:Connect(function() tween(btn, 0.15, { BackgroundColor3 = hover }) end)
	btn.MouseLeave:Connect(function() tween(btn, 0.15, { BackgroundColor3 = normal }) end)
end

local function playSound(id, volume)
	local s = Instance.new("Sound", SoundService)
	s.SoundId = id
	s.Volume = volume or 0.5
	s:Play()
	task.delay(3, function() s:Destroy() end)
end

local function drawX(parent, size, color, position)
	local holder = Instance.new("Frame", parent)
	holder.Name = uid("XIcon")
	holder.Size = UDim2.new(0, size, 0, size)
	holder.Position = position or UDim2.new(0.5, -size / 2, 0.5, -size / 2)
	holder.BackgroundTransparency = 1
	local a = Instance.new("Frame", holder)
	a.Size = UDim2.new(1, 0, 0, 2)
	a.Position = UDim2.new(0, 0, 0.5, -1)
	a.BackgroundColor3 = color
	a.BorderSizePixel = 0
	a.Rotation = 45
	corner(a, 1)
	local b = Instance.new("Frame", holder)
	b.Size = UDim2.new(1, 0, 0, 2)
	b.Position = UDim2.new(0, 0, 0.5, -1)
	b.BackgroundColor3 = color
	b.BorderSizePixel = 0
	b.Rotation = -45
	corner(b, 1)
	return holder
end

local function drawMin(parent, size, color, position)
	local holder = Instance.new("Frame", parent)
	holder.Name = uid("MinIcon")
	holder.Size = UDim2.new(0, size, 0, size)
	holder.Position = position or UDim2.new(0.5, -size / 2, 0.5, -size / 2)
	holder.BackgroundTransparency = 1
	local bar = Instance.new("Frame", holder)
	bar.Size = UDim2.new(1, -4, 0, 2)
	bar.Position = UDim2.new(0, 2, 0.5, -1)
	bar.BackgroundColor3 = color
	bar.BorderSizePixel = 0
	corner(bar, 1)
	return holder
end

local function drawIcon(parent, name, size, color, position)
	local holder = Instance.new("Frame", parent)
	holder.Name = uid("Icon_" .. name)
	holder.Size = UDim2.new(0, size or 16, 0, size or 16)
	holder.Position = position or UDim2.new(0, 0, 0.5, -(size or 16) / 2)
	holder.BackgroundTransparency = 1
	local s = size or 16
	local c = color or Theme.Accent
	local function bar(x, y, w, h, col, rot)
		local f = Instance.new("Frame", holder)
		f.Size = UDim2.new(0, w, 0, h)
		f.Position = UDim2.new(0, x, 0, y)
		f.BackgroundColor3 = col or c
		f.BorderSizePixel = 0
		if rot then f.Rotation = rot end
		corner(f, math.min(w, h) / 2)
		return f
	end
	if name == "dot" then
		local d = Instance.new("Frame", holder)
		d.Size = UDim2.new(0, s, 0, s)
		d.BackgroundColor3 = c
		d.BorderSizePixel = 0
		corner(d, s / 2)
	elseif name == "home" then
		bar(s / 2 - 1, 2, 2, s - 4, c)
		bar(2, s / 2 - 2, s - 4, 2, c)
	elseif name == "bolt" or name == "zap" then
		local a = bar(s / 2 - 1, 1, 3, s / 2, c)
		a.Rotation = 25
		local b = bar(s / 2 - 2, s / 2 - 1, 3, s / 2, c)
		b.Rotation = 25
	elseif name == "settings" then
		local d = Instance.new("Frame", holder)
		d.Size = UDim2.new(0, s - 6, 0, s - 6)
		d.Position = UDim2.new(0, 3, 0, 3)
		d.BackgroundTransparency = 1
		d.BorderSizePixel = 0
		local ds = Instance.new("UIStroke", d)
		ds.Color = c
		ds.Thickness = 2
		corner(d, (s - 6) / 2)
		local dot = Instance.new("Frame", holder)
		dot.Size = UDim2.new(0, 3, 0, 3)
		dot.Position = UDim2.new(0, s / 2 - 1.5, 0, s / 2 - 1.5)
		dot.BackgroundColor3 = c
		dot.BorderSizePixel = 0
		corner(dot, 2)
	elseif name == "shield" then
		bar(s / 2 - 1, 2, 2, s - 4, c)
		bar(3, s / 2 - 1, s - 6, 2, c)
	elseif name == "check" then
		local a = bar(2, s / 2, s / 2 - 1, 2, c)
		a.Rotation = 45
		local b = bar(s / 2 - 1, s / 2 - 2, s - 3, 2, c)
		b.Rotation = -45
	elseif name == "chevron" then
		local a = bar(s / 2 - 1, s / 2 - 2, 2, s / 2 - 1, c)
		a.Rotation = 45
		local b = bar(s / 2 - 2, s / 2 - 1, 2, s / 2 - 1, c)
		b.Rotation = -45
	elseif name == "arrowRight" then
		bar(3, s / 2 - 1, s - 6, 2, c)
		local a = bar(s - 6, s / 2 - 3, 2, 4, c)
		a.Rotation = 45
		local b = bar(s - 6, s / 2 - 1, 2, 4, c)
		b.Rotation = -45
	elseif name == "palette" then
		bar(2, 2, 4, 4, c)
		bar(s - 6, 2, 4, 4, Color3.fromRGB(255, 100, 100))
		bar(2, s - 6, 4, 4, Color3.fromRGB(100, 255, 100))
	elseif name == "user" or name == "users" then
		local h = Instance.new("Frame", holder)
		h.Size = UDim2.new(0, 6, 0, 6)
		h.Position = UDim2.new(0, s / 2 - 3, 0, 2)
		h.BackgroundColor3 = c
		h.BorderSizePixel = 0
		corner(h, 3)
		bar(3, s - 5, s - 6, 3, c)
	elseif name == "wind" then
		bar(2, 4, s - 6, 2, c)
		bar(4, s / 2, s - 6, 2, c)
		bar(2, s - 6, s - 8, 2, c)
	end
	return holder
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = uid("ERHub")
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.DisplayOrder = 999999
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local MiniBox = Instance.new("TextButton")
MiniBox.Name = uid("MiniBox")
MiniBox.Size = UDim2.new(0, 46, 0, 46)
MiniBox.Position = UDim2.new(1, -62, 0.5, -23)
MiniBox.BackgroundColor3 = Theme.Panel
MiniBox.Text = ""
MiniBox.AutoButtonColor = false
MiniBox.Visible = true
MiniBox.Parent = ScreenGui
corner(MiniBox, 10)
local miniStroke = stroke(MiniBox, Theme.Accent, 1.5)
addHover(MiniBox, Theme.Panel, Theme.ItemHover)

local MiniER = Instance.new("TextLabel", MiniBox)
MiniER.Size = UDim2.new(1, 0, 1, 0)
MiniER.BackgroundTransparency = 1
MiniER.Text = "ER"
MiniER.TextColor3 = Theme.Accent
MiniER.Font = Enum.Font.GothamBold
MiniER.TextSize = 20
registerAccent(MiniER, "TextColor3")

local Main = Instance.new("Frame")
Main.Name = uid("Main")
Main.AnchorPoint = Vector2.new(0.5, 0.5)
Main.Size = UDim2.new(0, 0, 0, 0)
Main.Position = UDim2.new(0.5, 0, 0.5, 0)
Main.BackgroundColor3 = Theme.Bg
Main.Visible = false
Main.ClipsDescendants = true
Main.Parent = ScreenGui
corner(Main, 12)
local mainStroke = stroke(Main, Theme.Accent, 1.5)

local TopBar = Instance.new("Frame")
TopBar.Name = uid("TopBar")
TopBar.Size = UDim2.new(1, 0, 0, 52)
TopBar.BackgroundColor3 = Theme.TabBar
TopBar.Parent = Main
corner(TopBar, 12)

local TitleDot = Instance.new("Frame")
TitleDot.Size = UDim2.new(0, 8, 0, 8)
TitleDot.Position = UDim2.new(0, 20, 0, 12)
TitleDot.BackgroundColor3 = Theme.Accent
TitleDot.Parent = TopBar
corner(TitleDot, 4)
registerAccent(TitleDot, "BackgroundColor3")

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -120, 0, 18)
Title.Position = UDim2.new(0, 40, 0, 8)
Title.BackgroundTransparency = 1
Title.Text = "ER致命猴子"
Title.TextColor3 = Theme.Text
Title.Font = Enum.Font.GothamBold
Title.TextSize = 16
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = TopBar

local SubTitle = Instance.new("TextLabel")
SubTitle.Size = UDim2.new(1, -120, 0, 14)
SubTitle.Position = UDim2.new(0, 40, 0, 28)
SubTitle.BackgroundTransparency = 1
SubTitle.Text = "by kela_er"
SubTitle.TextColor3 = Theme.SubText
SubTitle.Font = Enum.Font.Gotham
SubTitle.TextSize = 11
SubTitle.TextXAlignment = Enum.TextXAlignment.Left
SubTitle.Parent = TopBar

local BtnRow = Instance.new("Frame")
BtnRow.Name = uid("BtnRow")
BtnRow.Size = UDim2.new(0, 68, 0, 28)
BtnRow.Position = UDim2.new(1, -76, 0, 12)
BtnRow.BackgroundTransparency = 1
BtnRow.Parent = TopBar

local BtnRowLayout = Instance.new("UIListLayout", BtnRow)
BtnRowLayout.FillDirection = Enum.FillDirection.Horizontal
BtnRowLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right
BtnRowLayout.VerticalAlignment = Enum.VerticalAlignment.Center
BtnRowLayout.Padding = UDim.new(0, 6)
BtnRowLayout.SortOrder = Enum.SortOrder.LayoutOrder

local MinBtn = Instance.new("TextButton")
MinBtn.Name = uid("MinBtn")
MinBtn.Size = UDim2.new(0, 28, 0, 28)
MinBtn.LayoutOrder = 1
MinBtn.BackgroundColor3 = Theme.Item
MinBtn.Text = ""
MinBtn.AutoButtonColor = false
MinBtn.Parent = BtnRow
corner(MinBtn, 8)
stroke(MinBtn, Theme.Accent, 1.2)
addHover(MinBtn, Theme.Item, Theme.AccentDim)
drawMin(MinBtn, 14, Theme.SubText)

local CloseBtn = Instance.new("TextButton")
CloseBtn.Name = uid("CloseBtn")
CloseBtn.Size = UDim2.new(0, 28, 0, 28)
CloseBtn.LayoutOrder = 2
CloseBtn.BackgroundColor3 = Theme.Item
CloseBtn.Text = ""
CloseBtn.AutoButtonColor = false
CloseBtn.Parent = BtnRow
corner(CloseBtn, 8)
stroke(CloseBtn, Theme.Close, 1.2)
addHover(CloseBtn, Theme.Item, Color3.fromRGB(70, 30, 45))
drawX(CloseBtn, 12, Theme.Close)

makeDraggable(TopBar, Main)

local TabBar = Instance.new("ScrollingFrame")
TabBar.Name = uid("TabBar")
TabBar.Size = UDim2.new(0, 148, 1, -62)
TabBar.Position = UDim2.new(0, 8, 0, 58)
TabBar.BackgroundColor3 = Theme.TabBar
TabBar.Parent = Main
TabBar.ScrollBarThickness = 4
TabBar.ScrollBarImageColor3 = Theme.Accent
TabBar.CanvasSize = UDim2.new(0, 0, 0, 0)
TabBar.AutomaticCanvasSize = Enum.AutomaticSize.Y
TabBar.ScrollingDirection = Enum.ScrollingDirection.Y
TabBar.ScrollingEnabled = true
TabBar.ElasticBehavior = Enum.ElasticBehavior.WhenScrollable
TabBar.BorderSizePixel = 0
corner(TabBar, 10)
stroke(TabBar, Theme.Stroke, 1)

local TabList = Instance.new("UIListLayout", TabBar)
TabList.Padding = UDim.new(0, 6)
TabList.HorizontalAlignment = Enum.HorizontalAlignment.Center
TabList.SortOrder = Enum.SortOrder.LayoutOrder

local TabPadding = Instance.new("UIPadding", TabBar)
TabPadding.PaddingTop = UDim.new(0, 8)
TabPadding.PaddingBottom = UDim.new(0, 8)

local Content = Instance.new("Frame")
Content.Name = uid("Content")
Content.Size = UDim2.new(1, -172, 1, -62)
Content.Position = UDim2.new(0, 164, 0, 58)
Content.BackgroundColor3 = Theme.Panel
Content.Parent = Main
corner(Content, 10)
stroke(Content, Theme.Stroke, 1)

local ResizeHandle = Instance.new("TextButton")
ResizeHandle.Name = uid("ResizeHandle")
ResizeHandle.Size = UDim2.new(0, 18, 0, 18)
ResizeHandle.Position = UDim2.new(1, -20, 1, -20)
ResizeHandle.BackgroundTransparency = 1
ResizeHandle.Text = ""
ResizeHandle.AutoButtonColor = false
ResizeHandle.ZIndex = 5
ResizeHandle.Parent = Main

local resizeLines = {}
for i = 1, 3 do
	local line = Instance.new("Frame", ResizeHandle)
	line.Size = UDim2.new(0, 2, 0, 3 + i * 2)
	line.Position = UDim2.new(0, 12 - i * 3, 0, 14 - i * 3)
	line.AnchorPoint = Vector2.new(1, 1)
	line.BackgroundColor3 = Theme.SubText
	line.BorderSizePixel = 0
	line.Rotation = 45
	corner(line, 1)
	registerAccent(line, "BackgroundColor3")
	table.insert(resizeLines, line)
end

ResizeHandle.MouseEnter:Connect(function()
	for _, line in ipairs(resizeLines) do tween(line, 0.15, { BackgroundColor3 = Theme.Accent }) end
end)
ResizeHandle.MouseLeave:Connect(function()
	for _, line in ipairs(resizeLines) do tween(line, 0.15, { BackgroundColor3 = Theme.SubText }) end
end)
makeResizable(ResizeHandle, Main, Vector2.new(320, 240), Vector2.new(1200, 800))

local ContentScroll = Instance.new("ScrollingFrame", Content)
ContentScroll.Size = UDim2.new(1, -16, 1, -16)
ContentScroll.Position = UDim2.new(0, 8, 0, 8)
ContentScroll.BackgroundTransparency = 1
ContentScroll.BorderSizePixel = 0
ContentScroll.ScrollBarThickness = 3
ContentScroll.ScrollBarImageColor3 = Theme.Accent
ContentScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
ContentScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y

local ContentList = Instance.new("UIListLayout", ContentScroll)
ContentList.Padding = UDim.new(0, 8)
ContentList.SortOrder = Enum.SortOrder.LayoutOrder

local function makeSectionTitle(parent, text, iconName)
	local row = Instance.new("Frame", parent)
	row.Size = UDim2.new(1, 0, 0, 22)
	row.BackgroundTransparency = 1
	if iconName then
		local icon = drawIcon(row, iconName, 14, Theme.Accent, UDim2.new(0, 0, 0.5, -7))
		for _, f in ipairs(icon:GetChildren()) do
			if f:IsA("Frame") then registerAccent(f, "BackgroundColor3") end
		end
	end
	local lbl = Instance.new("TextLabel", row)
	lbl.Size = UDim2.new(1, iconName and -20 or 0, 1, 0)
	lbl.Position = UDim2.new(0, iconName and 20 or 0, 0, 0)
	lbl.BackgroundTransparency = 1
	lbl.Text = text
	lbl.TextColor3 = Theme.Accent
	lbl.Font = Enum.Font.GothamBold
	lbl.TextSize = 13
	lbl.TextXAlignment = Enum.TextXAlignment.Left
	registerAccent(lbl, "TextColor3")
	return row
end

local function makeParagraph(parent, text)
	local row = Instance.new("Frame", parent)
	row.Size = UDim2.new(1, 0, 0, 46)
	row.BackgroundColor3 = Theme.Item
	corner(row, 8)
	local lbl = Instance.new("TextLabel", row)
	lbl.Size = UDim2.new(1, -20, 1, 0)
	lbl.Position = UDim2.new(0, 10, 0, 0)
	lbl.BackgroundTransparency = 1
	lbl.Text = text
	lbl.TextColor3 = Theme.SubText
	lbl.Font = Enum.Font.Gotham
	lbl.TextSize = 12
	lbl.TextWrapped = true
	lbl.TextXAlignment = Enum.TextXAlignment.Left
	lbl.TextYAlignment = Enum.TextYAlignment.Center
	return row
end

local function makeToggle(parent, text, default, callback)
	local row = Instance.new("Frame", parent)
	row.Size = UDim2.new(1, 0, 0, 34)
	row.BackgroundColor3 = Theme.Item
	corner(row, 8)
	local lbl = Instance.new("TextLabel", row)
	lbl.Size = UDim2.new(1, -70, 1, 0)
	lbl.Position = UDim2.new(0, 12, 0, 0)
	lbl.BackgroundTransparency = 1
	lbl.Text = text
	lbl.TextColor3 = Theme.Text
	lbl.Font = Enum.Font.Gotham
	lbl.TextSize = 13
	lbl.TextXAlignment = Enum.TextXAlignment.Left
	local track = Instance.new("Frame", row)
	track.Size = UDim2.new(0, 40, 0, 20)
	track.Position = UDim2.new(1, -50, 0.5, -10)
	track.BackgroundColor3 = default and Theme.Open or Color3.fromRGB(50, 50, 70)
	corner(track, 10)
	local knob = Instance.new("Frame", track)
	knob.Size = UDim2.new(0, 16, 0, 16)
	knob.Position = default and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)
	knob.BackgroundColor3 = Color3.new(1, 1, 1)
	corner(knob, 8)
	local btn = Instance.new("TextButton", row)
	btn.Size = UDim2.new(1, 0, 1, 0)
	btn.BackgroundTransparency = 1
	btn.Text = ""
	local state = default
	btn.MouseButton1Click:Connect(function()
		state = not state
		tween(track, 0.2, { BackgroundColor3 = state and Theme.Open or Color3.fromRGB(50, 50, 70) })
		tween(knob, 0.2, { Position = state and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8) })
		if callback then callback(state) end
	end)
end

local function makeSlider(parent, text, min, max, default, callback)
	local row = Instance.new("Frame", parent)
	row.Size = UDim2.new(1, 0, 0, 50)
	row.BackgroundColor3 = Theme.Item
	corner(row, 8)
	local lbl = Instance.new("TextLabel", row)
	lbl.Size = UDim2.new(1, -20, 0, 20)
	lbl.Position = UDim2.new(0, 12, 0, 6)
	lbl.BackgroundTransparency = 1
	lbl.Text = text .. " " .. tostring(default)
	lbl.TextColor3 = Theme.Text
	lbl.Font = Enum.Font.Gotham
	lbl.TextSize = 13
	lbl.TextXAlignment = Enum.TextXAlignment.Left
	local track = Instance.new("Frame", row)
	track.Size = UDim2.new(1, -24, 0, 6)
	track.Position = UDim2.new(0, 12, 0, 34)
	track.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
	corner(track, 3)
	local fill = Instance.new("Frame", track)
	fill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
	fill.BackgroundColor3 = Theme.Accent
	corner(fill, 3)
	registerAccent(fill, "BackgroundColor3")
	local knob = Instance.new("TextButton", track)
	knob.Size = UDim2.new(0, 14, 0, 14)
	knob.Position = UDim2.new((default - min) / (max - min), -7, 0.5, -7)
	knob.BackgroundColor3 = Color3.new(1, 1, 1)
	knob.Text = ""
	corner(knob, 7)
	local knobStroke = stroke(knob, Theme.Accent, 1.5)
	registerAccent(knobStroke, "Color")
	local dragging = false
	local function update(input)
		local alpha = math.clamp((input.Position.X - track.AbsolutePosition.X) / track.AbsoluteSize.X, 0, 1)
		local value = math.floor(min + alpha * (max - min) + 0.5)
		knob.Position = UDim2.new(alpha, -7, 0.5, -7)
		fill.Size = UDim2.new(alpha, 0, 1, 0)
		lbl.Text = text .. " " .. tostring(value)
		if callback then callback(value) end
	end
	knob.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = true
			tween(knob, 0.12, { Size = UDim2.new(0, 18, 0, 18) })
		end
	end)
	UserInputService.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = false
			tween(knob, 0.12, { Size = UDim2.new(0, 14, 0, 14) })
		end
	end)
	UserInputService.InputChanged:Connect(function(input)
		if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
			update(input)
		end
	end)
end

local function makeButton(parent, text, iconName, callback)
	local btn = Instance.new("TextButton", parent)
	btn.Size = UDim2.new(1, 0, 0, 34)
	btn.BackgroundColor3 = Theme.Item
	btn.Text = ""
	btn.Font = Enum.Font.GothamBold
	btn.TextSize = 13
	btn.AutoButtonColor = false
	corner(btn, 8)
	stroke(btn, Theme.Stroke, 1)
	if iconName then drawIcon(btn, iconName, 14, Theme.Accent, UDim2.new(0, 12, 0.5, -7)) end
	local lbl = Instance.new("TextLabel", btn)
	lbl.Size = UDim2.new(1, -50, 1, 0)
	lbl.Position = UDim2.new(0, iconName and 36 or 14, 0, 0)
	lbl.BackgroundTransparency = 1
	lbl.Text = text
	lbl.TextColor3 = Theme.Text
	lbl.Font = Enum.Font.Gotham
	lbl.TextSize = 13
	lbl.TextXAlignment = Enum.TextXAlignment.Left
	addHover(btn, Theme.Item, Theme.ItemHover)
	btn.MouseButton1Click:Connect(function()
		tween(btn, 0.1, { BackgroundColor3 = Theme.AccentDim })
		task.delay(0.12, function() tween(btn, 0.2, { BackgroundColor3 = Theme.Item }) end)
		if callback then callback() end
	end)
end

local function makeDropdown(parent, text, options, default, callback)
	local wrapper = Instance.new("Frame", parent)
	wrapper.Size = UDim2.new(1, 0, 0, 34)
	wrapper.BackgroundTransparency = 1
	wrapper.ClipsDescendants = false
	local row = Instance.new("Frame", wrapper)
	row.Size = UDim2.new(1, 0, 0, 34)
	row.BackgroundColor3 = Theme.Item
	row.ZIndex = 2
	corner(row, 8)
	local btn = Instance.new("TextButton", row)
	btn.Size = UDim2.new(1, 0, 1, 0)
	btn.BackgroundTransparency = 1
	btn.Text = ""
	btn.AutoButtonColor = false
	local lbl = Instance.new("TextLabel", btn)
	lbl.Size = UDim2.new(1, -50, 1, 0)
	lbl.Position = UDim2.new(0, 14, 0, 0)
	lbl.BackgroundTransparency = 1
	lbl.Text = default or options[1]
	lbl.TextColor3 = Theme.Text
	lbl.Font = Enum.Font.Gotham
	lbl.TextSize = 13
	lbl.TextXAlignment = Enum.TextXAlignment.Left
	local arrow = drawIcon(btn, "arrowRight", 12, Theme.SubText, UDim2.new(1, -26, 0.5, -6))
	arrow.Rotation = 90
	local list = Instance.new("Frame", wrapper)
	list.Size = UDim2.new(1, 0, 0, 0)
	list.Position = UDim2.new(0, 0, 0, 38)
	list.BackgroundColor3 = Theme.Panel
	list.Visible = false
	list.ClipsDescendants = true
	list.ZIndex = 1
	corner(list, 8)
	stroke(list, Theme.Stroke, 1)
	local listLayout = Instance.new("UIListLayout", list)
	listLayout.Padding = UDim.new(0, 2)
	listLayout.SortOrder = Enum.SortOrder.LayoutOrder
	local open = false
	local itemHeight = 28
	local padding = 8
	local function closeList()
		open = false
		tween(list, 0.2, { Size = UDim2.new(1, 0, 0, 0) })
		tween(arrow, 0.25, { Rotation = 90 })
		tween(wrapper, 0.25, { Size = UDim2.new(1, 0, 0, 34) })
		task.delay(0.22, function() list.Visible = false end)
	end
	for _, option in ipairs(options) do
		local item = Instance.new("TextButton", list)
		item.Size = UDim2.new(1, -8, 0, 26)
		item.Position = UDim2.new(0, 4, 0, 0)
		item.BackgroundColor3 = Theme.Item
		item.Text = option
		item.TextColor3 = Theme.Text
		item.Font = Enum.Font.Gotham
		item.TextSize = 13
		item.AutoButtonColor = false
		corner(item, 6)
		addHover(item, Theme.Item, Theme.ItemHover)
		item.MouseButton1Click:Connect(function()
			lbl.Text = option
			if open then closeList() end
			if callback then callback(option) end
		end)
	end
	btn.MouseButton1Click:Connect(function()
		open = not open
		if open then
			local listHeight = #options * itemHeight + padding
			list.Visible = true
			list.Size = UDim2.new(1, 0, 0, 0)
			tween(list, 0.25, { Size = UDim2.new(1, 0, 0, listHeight) })
			tween(arrow, 0.25, { Rotation = 270 })
			tween(wrapper, 0.25, { Size = UDim2.new(1, 0, 0, 34 + listHeight + 4) })
		else
			closeList()
		end
	end)
end

local function makeColorDropdown(parent, text, colors, callback)
	local wrapper = Instance.new("Frame", parent)
	wrapper.Size = UDim2.new(1, 0, 0, 34)
	wrapper.BackgroundTransparency = 1
	wrapper.ClipsDescendants = false
	local row = Instance.new("Frame", wrapper)
	row.Size = UDim2.new(1, 0, 0, 34)
	row.BackgroundColor3 = Theme.Item
	row.ZIndex = 2
	corner(row, 8)
	local btn = Instance.new("TextButton", row)
	btn.Size = UDim2.new(1, 0, 1, 0)
	btn.BackgroundTransparency = 1
	btn.Text = ""
	btn.AutoButtonColor = false
	local swatch = Instance.new("Frame", btn)
	swatch.Size = UDim2.new(0, 14, 0, 14)
	swatch.Position = UDim2.new(0, 12, 0.5, -7)
	swatch.BackgroundColor3 = colors[1].color
	corner(swatch, 4)
	stroke(swatch, Color3.fromRGB(255, 255, 255), 1)
	local lbl = Instance.new("TextLabel", btn)
	lbl.Size = UDim2.new(1, -80, 1, 0)
	lbl.Position = UDim2.new(0, 36, 0, 0)
	lbl.BackgroundTransparency = 1
	lbl.Text = colors[1].name
	lbl.TextColor3 = Theme.Text
	lbl.Font = Enum.Font.Gotham
	lbl.TextSize = 13
	lbl.TextXAlignment = Enum.TextXAlignment.Left
	local arrow = drawIcon(btn, "arrowRight", 12, Theme.SubText, UDim2.new(1, -26, 0.5, -6))
	arrow.Rotation = 90
	local list = Instance.new("Frame", wrapper)
	list.Size = UDim2.new(1, 0, 0, 0)
	list.Position = UDim2.new(0, 0, 0, 38)
	list.BackgroundColor3 = Theme.Panel
	list.Visible = false
	list.ClipsDescendants = true
	list.ZIndex = 1
	corner(list, 8)
	stroke(list, Theme.Stroke, 1)
	local listLayout = Instance.new("UIListLayout", list)
	listLayout.Padding = UDim.new(0, 2)
	listLayout.SortOrder = Enum.SortOrder.LayoutOrder
	local open = false
	local itemHeight = 28
	local padding = 8
	local function closeList()
		open = false
		tween(list, 0.2, { Size = UDim2.new(1, 0, 0, 0) })
		tween(arrow, 0.25, { Rotation = 90 })
		tween(wrapper, 0.25, { Size = UDim2.new(1, 0, 0, 34) })
		task.delay(0.22, function() list.Visible = false end)
	end
	for _, entry in ipairs(colors) do
		local item = Instance.new("TextButton", list)
		item.Size = UDim2.new(1, -8, 0, 26)
		item.Position = UDim2.new(0, 4, 0, 0)
		item.BackgroundColor3 = Theme.Item
		item.Text = ""
		item.AutoButtonColor = false
		corner(item, 6)
		addHover(item, Theme.Item, Theme.ItemHover)
		local itemSwatch = Instance.new("Frame", item)
		itemSwatch.Size = UDim2.new(0, 12, 0, 12)
		itemSwatch.Position = UDim2.new(0, 8, 0.5, -6)
		itemSwatch.BackgroundColor3 = entry.color
		corner(itemSwatch, 3)
		stroke(itemSwatch, Color3.fromRGB(255, 255, 255), 1)
		if entry.rainbow then
			local grad = Instance.new("UIGradient", itemSwatch)
			grad.Color = ColorSequence.new({
				ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 0, 0)),
				ColorSequenceKeypoint.new(0.2, Color3.fromRGB(255, 200, 0)),
				ColorSequenceKeypoint.new(0.4, Color3.fromRGB(0, 255, 100)),
				ColorSequenceKeypoint.new(0.6, Color3.fromRGB(0, 200, 255)),
				ColorSequenceKeypoint.new(0.8, Color3.fromRGB(150, 0, 255)),
				ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 0, 0)),
			})
		end
		local itemLbl = Instance.new("TextLabel", item)
		itemLbl.Size = UDim2.new(1, -40, 1, 0)
		itemLbl.Position = UDim2.new(0, 30, 0, 0)
		itemLbl.BackgroundTransparency = 1
		itemLbl.Text = entry.name
		itemLbl.TextColor3 = Theme.Text
		itemLbl.Font = Enum.Font.Gotham
		itemLbl.TextSize = 13
		itemLbl.TextXAlignment = Enum.TextXAlignment.Left
		item.MouseButton1Click:Connect(function()
			lbl.Text = entry.name
			if entry.rainbow then
				swatch.BackgroundColor3 = Color3.fromRGB(180, 180, 180)
			else
				swatch.BackgroundColor3 = entry.color
			end
			if open then closeList() end
			if callback then callback(entry) end
		end)
	end
	btn.MouseButton1Click:Connect(function()
		open = not open
		if open then
			local listHeight = #colors * itemHeight + padding
			list.Visible = true
			list.Size = UDim2.new(1, 0, 0, 0)
			tween(list, 0.25, { Size = UDim2.new(1, 0, 0, listHeight) })
			tween(arrow, 0.25, { Rotation = 270 })
			tween(wrapper, 0.25, { Size = UDim2.new(1, 0, 0, 34 + listHeight + 4) })
		else
			closeList()
		end
	end)
end

local NotifyHolder = Instance.new("Frame", ScreenGui)
NotifyHolder.Name = uid("NotifyHolder")
NotifyHolder.AnchorPoint = Vector2.new(1, 0)
NotifyHolder.Position = UDim2.new(1, -16, 0, 16)
NotifyHolder.Size = UDim2.new(0, 250, 0, 0)
NotifyHolder.BackgroundTransparency = 1
NotifyHolder.ZIndex = 10

local NotifyLayout = Instance.new("UIListLayout", NotifyHolder)
NotifyLayout.SortOrder = Enum.SortOrder.LayoutOrder
NotifyLayout.Padding = UDim.new(0, 8)
NotifyLayout.VerticalAlignment = Enum.VerticalAlignment.Top

local function notify(title, content, duration)
	local note = Instance.new("Frame", NotifyHolder)
	note.Name = uid("Notify")
	note.Size = UDim2.new(1, 0, 0, 68)
	note.BackgroundColor3 = Theme.Panel
	note.ZIndex = 10
	note.LayoutOrder = -math.floor(tick() * 1000)
	corner(note, 10)
	stroke(note, Theme.Accent, 1.5)
	local accentBar = Instance.new("Frame", note)
	accentBar.Size = UDim2.new(0, 3, 1, -16)
	accentBar.Position = UDim2.new(0, 8, 0, 8)
	accentBar.BackgroundColor3 = Theme.Accent
	corner(accentBar, 2)
	local t = Instance.new("TextLabel", note)
	t.Size = UDim2.new(1, -60, 0, 22)
	t.Position = UDim2.new(0, 20, 0, 8)
	t.BackgroundTransparency = 1
	t.Text = title
	t.TextColor3 = Theme.Text
	t.Font = Enum.Font.GothamBold
	t.TextSize = 14
	t.TextXAlignment = Enum.TextXAlignment.Left
	local c = Instance.new("TextLabel", note)
	c.Size = UDim2.new(1, -30, 0, 28)
	c.Position = UDim2.new(0, 20, 0, 30)
	c.BackgroundTransparency = 1
	c.Text = content
	c.TextColor3 = Theme.SubText
	c.Font = Enum.Font.Gotham
	c.TextSize = 12
	c.TextXAlignment = Enum.TextXAlignment.Left
	c.TextWrapped = true
	local closeNoteBtn = Instance.new("TextButton", note)
	closeNoteBtn.Size = UDim2.new(0, 22, 0, 22)
	closeNoteBtn.Position = UDim2.new(1, -30, 0, 8)
	closeNoteBtn.BackgroundColor3 = Theme.Item
	closeNoteBtn.Text = ""
	closeNoteBtn.AutoButtonColor = false
	corner(closeNoteBtn, 5)
	stroke(closeNoteBtn, Theme.Close, 1)
	addHover(closeNoteBtn, Theme.Item, Color3.fromRGB(60, 30, 40))
	drawX(closeNoteBtn, 10, Theme.Close)
	note.Position = UDim2.new(1, 280, 0, 0)
	note.BackgroundTransparency = 1
	accentBar.BackgroundTransparency = 1
	tween(note, 0.4, { Position = UDim2.new(0, 0, 0, 0), BackgroundTransparency = 0 }, Enum.EasingStyle.Back)
	tween(accentBar, 0.4, { BackgroundTransparency = 0 }, Enum.EasingStyle.Quart)
	local closed = false
	local function closeNoteNow()
		if closed then return end
		closed = true
		local out = tween(note, 0.28, { Position = UDim2.new(1, 280, 0, 0) })
		out.Completed:Connect(function() note:Destroy() end)
	end
	closeNoteBtn.MouseButton1Click:Connect(closeNoteNow)
	task.delay(duration or 3, closeNoteNow)
end

local Tabs = {}
local function createTab(name, iconName)
	local btn = Instance.new("TextButton", TabBar)
	btn.Size = UDim2.new(0.9, 0, 0, 34)
	btn.BackgroundColor3 = Theme.Item
	btn.Text = ""
	btn.AutoButtonColor = false
	corner(btn, 8)
	local highlight = Instance.new("Frame", btn)
	highlight.Name = uid("Highlight")
	highlight.Size = UDim2.new(0, 3, 0.6, 0)
	highlight.Position = UDim2.new(0, 0, 0.5, 0)
	highlight.AnchorPoint = Vector2.new(0, 0.5)
	highlight.BackgroundColor3 = Theme.Accent
	highlight.Visible = false
	corner(highlight, 2)
	registerAccent(highlight, "BackgroundColor3")
	if iconName then
		local icon = drawIcon(btn, iconName, 14, Theme.Accent, UDim2.new(0, 12, 0.5, -7))
		for _, f in ipairs(icon:GetChildren()) do
			if f:IsA("Frame") then registerAccent(f, "BackgroundColor3") end
		end
	end
	local lbl = Instance.new("TextLabel", btn)
	lbl.Size = UDim2.new(1, -40, 1, 0)
	lbl.Position = UDim2.new(0, 36, 0, 0)
	lbl.BackgroundTransparency = 1
	lbl.Text = name
	lbl.TextColor3 = Theme.SubText
	lbl.Font = Enum.Font.GothamBold
	lbl.TextSize = 13
	lbl.TextXAlignment = Enum.TextXAlignment.Left
	local page = Instance.new("Frame", ContentScroll)
	page.Size = UDim2.new(1, 0, 0, 0)
	page.BackgroundTransparency = 1
	page.Visible = false
	page.AutomaticSize = Enum.AutomaticSize.Y
	local layout = Instance.new("UIListLayout", page)
	layout.Padding = UDim.new(0, 8)
	layout.SortOrder = Enum.SortOrder.LayoutOrder
	local tab = { Button = btn, Page = page, Label = lbl, Highlight = highlight }
	addHover(btn, Theme.Item, Theme.ItemHover)
	btn.MouseButton1Click:Connect(function()
		for _, other in pairs(Tabs) do
			tween(other.Button, 0.2, { BackgroundColor3 = Theme.Item })
			tween(other.Label, 0.2, { TextColor3 = Theme.SubText })
			other.Page.Visible = false
			other.Highlight.Visible = false
		end
		tween(btn, 0.2, { BackgroundColor3 = Theme.AccentDim })
		tween(lbl, 0.2, { TextColor3 = Theme.Text })
		highlight.Visible = true
		page.Visible = true
	end)
	Tabs[name] = tab
	return tab
end

local function applyAccent(color)
	Theme.Accent = color
	Theme.AccentDim = Color3.new(color.R * 0.55, color.G * 0.55, color.B * 0.55)
	Theme.Stroke = Color3.new(color.R * 0.65, color.G * 0.65, color.B * 0.65)
	for _, entry in ipairs(AccentObjects) do
		if entry.obj and entry.obj.Parent then
			tween(entry.obj, 0.25, { [entry.prop] = color })
		end
	end
	tween(mainStroke, 0.25, { Color = color })
	tween(miniStroke, 0.25, { Color = color })
end

local AUTHOR_NAME = "kela_er1"

local monsterConfig = {
	{ name = "Gus", parentPath = "GusMonster", childName = "Gus" },
	{ name = "Kus", parentPath = "KusMonster", childName = "Kus" },
	{ name = "Scar", parentPath = "Sandman/Ashy", childName = "Scar" },
	{ name = "SandMan", parentPath = "Sandman/Ashy", childName = "SandMan" },
	{ name = "Lurker", parentPath = "Sandman/Ashy", childName = "Lurker" },
	{ name = "BloodMan", parentPath = "BloodmanMonster", childName = "BloodMan" },
	{ name = "Ashy", parentPath = "Sandman/Ashy", childName = "Ashy" },
	{ name = "Lost", parentPath = "LostMonster", childName = "Lost" },
	{ name = "Dus", parentPath = "DusMonster", childName = "Dus" },
}

local espSettings = {
	enabled = false,
	highlightEnabled = true,
	nameEnabled = true,
	distanceEnabled = true,
	healthEnabled = false,
	maxDistance = 500,
	highlightColor = Color3.fromRGB(255, 0, 0),
	outlineColor = Color3.fromRGB(255, 255, 255),
	nameColor = Color3.fromRGB(255, 255, 255),
	distanceColor = Color3.fromRGB(255, 235, 59),
	textSize = 14,
	fillTransparency = 0.5,
}

local monsterToggles = {}
for _, m in ipairs(monsterConfig) do monsterToggles[m.name] = true end

local function resolveParent(parentPath)
	local ok, obj = pcall(function() return Workspace:FindFirstChild(parentPath, true) end)
	if ok and obj then return obj end
	if parentPath:find("/") then
		local current = Workspace
		for _, part in ipairs(string.split(parentPath, "/")) do
			current = current:FindFirstChild(part, true)
			if not current then return nil end
		end
		return current
	end
	return nil
end

local function getMonsterModel(monster)
	local parent = resolveParent(monster.parentPath)
	if not parent then return nil end
	return parent:FindFirstChild(monster.childName, true)
end

local function getMonsterPart(model)
	if not model or not model:IsA("Model") then return nil end
	return model:FindFirstChild("HumanoidRootPart") or model:FindFirstChild("Head") or model.PrimaryPart
end

local function getMonsterHumanoid(model)
	if not model then return nil end
	return model:FindFirstChildOfClass("Humanoid") or model:FindFirstChild("Humanoid")
end

local espObjects = {}

local function clearMonsterESP(name)
	local cache = espObjects[name]
	if cache then
		if cache.highlight and cache.highlight.Parent then cache.highlight:Destroy() end
		if cache.billboard and cache.billboard.Parent then cache.billboard:Destroy() end
		espObjects[name] = nil
	end
end

local function clearAllESP()
	for name in pairs(espObjects) do clearMonsterESP(name) end
end

local function createHighlight(model, name)
	local hl = Instance.new("Highlight")
	hl.Name = "ESPHighlight_" .. name
	hl.Adornee = model
	hl.FillColor = espSettings.highlightColor
	hl.OutlineColor = espSettings.outlineColor
	hl.FillTransparency = espSettings.fillTransparency
	hl.OutlineTransparency = 0
	hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
	hl.Parent = model
	return hl
end

local function createBillboard(model, name)
	local head = model:FindFirstChild("Head") or getMonsterPart(model)
	if not head then return nil, nil end
	local bb = Instance.new("BillboardGui")
	bb.Name = "ESPBoard_" .. name
	bb.Adornee = head
	bb.Size = UDim2.new(0, 200, 0, 60)
	bb.StudsOffset = Vector3.new(0, 3, 0)
	bb.AlwaysOnTop = true
	bb.LightInfluence = 0
	bb.MaxDistance = espSettings.maxDistance * 10
	bb.Parent = head
	local nl = Instance.new("TextLabel")
	nl.Size = UDim2.new(1, 0, 0, 22)
	nl.BackgroundTransparency = 1
	nl.Text = name
	nl.TextColor3 = espSettings.nameColor
	nl.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
	nl.TextStrokeTransparency = 0
	nl.Font = Enum.Font.GothamBold
	nl.TextSize = espSettings.textSize
	nl.Visible = espSettings.nameEnabled
	nl.Parent = bb
	local dl = Instance.new("TextLabel")
	dl.Size = UDim2.new(1, 0, 0, 18)
	dl.Position = UDim2.new(0, 0, 0, 22)
	dl.BackgroundTransparency = 1
	dl.Text = "0m"
	dl.TextColor3 = espSettings.distanceColor
	dl.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
	dl.TextStrokeTransparency = 0
	dl.Font = Enum.Font.GothamSemibold
	dl.TextSize = espSettings.textSize - 2
	dl.Visible = espSettings.distanceEnabled
	dl.Parent = bb
	local hpl = Instance.new("TextLabel")
	hpl.Size = UDim2.new(1, 0, 0, 18)
	hpl.Position = UDim2.new(0, 0, 0, 40)
	hpl.BackgroundTransparency = 1
	hpl.Text = ""
	hpl.TextColor3 = Color3.fromRGB(0, 255, 0)
	hpl.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
	hpl.TextStrokeTransparency = 0
	hpl.Font = Enum.Font.GothamSemibold
	hpl.TextSize = espSettings.textSize - 2
	hpl.Visible = espSettings.healthEnabled
	hpl.Parent = bb
	return bb, { nameLabel = nl, distLabel = dl, healthLabel = hpl }
end

local function updateMonsterESP(monster)
	local name = monster.name
	local model = getMonsterModel(monster)
	if not model then clearMonsterESP(name) return end
	if not espSettings.enabled or not monsterToggles[name] then clearMonsterESP(name) return end
	local part = getMonsterPart(model)
	if not part then clearMonsterESP(name) return end
	local distance = (Camera.CFrame.Position - part.Position).Magnitude
	if distance > espSettings.maxDistance then clearMonsterESP(name) return end
	local cache = espObjects[name]
	if not cache then
		cache = {}
		espObjects[name] = cache
	end
	if espSettings.highlightEnabled then
		if not cache.highlight or not cache.highlight.Parent then
			cache.highlight = createHighlight(model, name)
		else
			cache.highlight.FillColor = espSettings.highlightColor
			cache.highlight.OutlineColor = espSettings.outlineColor
			cache.highlight.FillTransparency = espSettings.fillTransparency
		end
	elseif cache.highlight then
		cache.highlight:Destroy()
		cache.highlight = nil
	end
	if espSettings.nameEnabled or espSettings.distanceEnabled or espSettings.healthEnabled then
		if not cache.billboard or not cache.billboard.Parent then
			cache.billboard, cache.labels = createBillboard(model, name)
		end
		if cache.labels then
			local nl, dl, hpl = cache.labels.nameLabel, cache.labels.distLabel, cache.labels.healthLabel
			if nl then
				nl.Text = name
				nl.TextColor3 = espSettings.nameColor
				nl.TextSize = espSettings.textSize
				nl.Visible = espSettings.nameEnabled
			end
			if dl then
				dl.Text = string.format("%.0f m", distance)
				dl.TextColor3 = espSettings.distanceColor
				dl.Visible = espSettings.distanceEnabled
			end
			if hpl then
				if espSettings.healthEnabled then
					local hum = getMonsterHumanoid(model)
					if hum and hum.Health > 0 then
						hpl.Text = string.format("HP: %.0f / %.0f", hum.Health, hum.MaxHealth)
						local p = hum.Health / hum.MaxHealth
						hpl.TextColor3 = p > 0.5 and Color3.fromRGB(0, 255, 0) or (p > 0.25 and Color3.fromRGB(255, 255, 0) or Color3.fromRGB(255, 0, 0))
					else
						hpl.Text = ""
					end
				end
				hpl.Visible = espSettings.healthEnabled
			end
		end
	elseif cache.billboard then
		cache.billboard:Destroy()
		cache.billboard = nil
		cache.labels = nil
	end
end

local function updateAllESP()
	for _, m in ipairs(monsterConfig) do updateMonsterESP(m) end
end

local playerEspSettings = {
	enabled = false,
	highlightEnabled = true,
	nameEnabled = true,
	distanceEnabled = true,
	healthEnabled = true,
	maxDistance = 1000,
	highlightColor = Color3.fromRGB(0, 255, 127),
	outlineColor = Color3.fromRGB(255, 255, 255),
	nameColor = Color3.fromRGB(0, 255, 127),
	distanceColor = Color3.fromRGB(255, 235, 59),
	textSize = 14,
	fillTransparency = 0.5,
	showSelf = false,
}

local playerEspObjects = {}

local function clearPlayerESP(plr)
	local cache = playerEspObjects[plr]
	if cache then
		if cache.highlight and cache.highlight.Parent then cache.highlight:Destroy() end
		if cache.billboard and cache.billboard.Parent then cache.billboard:Destroy() end
		playerEspObjects[plr] = nil
	end
end

local function clearAllPlayerESP()
	for plr in pairs(playerEspObjects) do clearPlayerESP(plr) end
end

local function createPlayerHighlight(char, plrName)
	local hl = Instance.new("Highlight")
	hl.Name = "PlayerESP_HL_" .. plrName
	hl.Adornee = char
	hl.FillColor = playerEspSettings.highlightColor
	hl.OutlineColor = playerEspSettings.outlineColor
	hl.FillTransparency = playerEspSettings.fillTransparency
	hl.OutlineTransparency = 0
	hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
	hl.Parent = char
	return hl
end

local function createPlayerBillboard(char, plrName)
	local head = char:FindFirstChild("Head")
	if not head then return nil, nil end
	local bb = Instance.new("BillboardGui")
	bb.Name = "PlayerESP_Board_" .. plrName
	bb.Adornee = head
	bb.Size = UDim2.new(0, 200, 0, 60)
	bb.StudsOffset = Vector3.new(0, 3, 0)
	bb.AlwaysOnTop = true
	bb.LightInfluence = 0
	bb.MaxDistance = playerEspSettings.maxDistance * 10
	bb.Parent = head
	local nl = Instance.new("TextLabel")
	nl.Size = UDim2.new(1, 0, 0, 22)
	nl.BackgroundTransparency = 1
	nl.Text = plrName
	nl.TextColor3 = playerEspSettings.nameColor
	nl.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
	nl.TextStrokeTransparency = 0
	nl.Font = Enum.Font.GothamBold
	nl.TextSize = playerEspSettings.textSize
	nl.Visible = playerEspSettings.nameEnabled
	nl.Parent = bb
	local dl = Instance.new("TextLabel")
	dl.Size = UDim2.new(1, 0, 0, 18)
	dl.Position = UDim2.new(0, 0, 0, 22)
	dl.BackgroundTransparency = 1
	dl.Text = "0m"
	dl.TextColor3 = playerEspSettings.distanceColor
	dl.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
	dl.TextStrokeTransparency = 0
	dl.Font = Enum.Font.GothamSemibold
	dl.TextSize = playerEspSettings.textSize - 2
	dl.Visible = playerEspSettings.distanceEnabled
	dl.Parent = bb
	local hpl = Instance.new("TextLabel")
	hpl.Size = UDim2.new(1, 0, 0, 18)
	hpl.Position = UDim2.new(0, 0, 0, 40)
	hpl.BackgroundTransparency = 1
	hpl.Text = ""
	hpl.TextColor3 = Color3.fromRGB(0, 255, 0)
	hpl.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
	hpl.TextStrokeTransparency = 0
	hpl.Font = Enum.Font.GothamSemibold
	hpl.TextSize = playerEspSettings.textSize - 2
	hpl.Visible = playerEspSettings.healthEnabled
	hpl.Parent = bb
	return bb, { nameLbl = nl, distLbl = dl, hpLbl = hpl }
end

local function updateSinglePlayerESP(plr)
	if plr == LocalPlayer and not playerEspSettings.showSelf then clearPlayerESP(plr) return end
	local char = plr.Character
	if not char or not char:IsA("Model") then clearPlayerESP(plr) return end
	local hrp = char:FindFirstChild("HumanoidRootPart") or char.PrimaryPart
	if not hrp then clearPlayerESP(plr) return end
	local distance = (Camera.CFrame.Position - hrp.Position).Magnitude
	if distance > playerEspSettings.maxDistance then clearPlayerESP(plr) return end
	local cache = playerEspObjects[plr]
	if not cache then
		cache = {}
		playerEspObjects[plr] = cache
	end
	if playerEspSettings.highlightEnabled then
		if not cache.highlight or not cache.highlight.Parent then
			cache.highlight = createPlayerHighlight(char, plr.Name)
		else
			cache.highlight.FillColor = playerEspSettings.highlightColor
			cache.highlight.OutlineColor = playerEspSettings.outlineColor
			cache.highlight.FillTransparency = playerEspSettings.fillTransparency
		end
	elseif cache.highlight then
		cache.highlight:Destroy()
		cache.highlight = nil
	end
	if playerEspSettings.nameEnabled or playerEspSettings.distanceEnabled or playerEspSettings.healthEnabled then
		if not cache.billboard or not cache.billboard.Parent then
			cache.billboard, cache.labels = createPlayerBillboard(char, plr.Name)
		end
		if cache.labels then
			local nl, dl, hpl = cache.labels.nameLbl, cache.labels.distLbl, cache.labels.hpLbl
			if nl then
				nl.Text = plr.Name
				nl.TextColor3 = playerEspSettings.nameColor
				nl.TextSize = playerEspSettings.textSize
				nl.Visible = playerEspSettings.nameEnabled
			end
			if dl then
				dl.Text = string.format("%.0f m", distance)
				dl.TextColor3 = playerEspSettings.distanceColor
				dl.Visible = playerEspSettings.distanceEnabled
			end
			if hpl then
				if playerEspSettings.healthEnabled then
					local hum = char:FindFirstChildOfClass("Humanoid")
					if hum and hum.Health > 0 then
						hpl.Text = string.format("HP: %.0f / %.0f", hum.Health, hum.MaxHealth)
						local p = hum.Health / hum.MaxHealth
						hpl.TextColor3 = p > 0.5 and Color3.fromRGB(0, 255, 0) or (p > 0.25 and Color3.fromRGB(255, 255, 0) or Color3.fromRGB(255, 0, 0))
					else
						hpl.Text = ""
					end
				end
				hpl.Visible = playerEspSettings.healthEnabled
			end
		end
	elseif cache.billboard then
		cache.billboard:Destroy()
		cache.billboard = nil
		cache.labels = nil
	end
end

local function updateAllPlayerESP()
	if not playerEspSettings.enabled then clearAllPlayerESP() return end
	local all = Players:GetPlayers()
	for plr in pairs(playerEspObjects) do
		if not table.find(all, plr) then clearPlayerESP(plr) end
	end
	for _, plr in ipairs(all) do updateSinglePlayerESP(plr) end
end

local authorEspObjects = {}

local function clearAuthorESP(plr)
	if authorEspObjects[plr] then
		for _, o in ipairs(authorEspObjects[plr]) do
			if o and o.Parent then o:Destroy() end
		end
		authorEspObjects[plr] = nil
	end
end

local function isAuthorPlayer(plr)
	return plr and string.lower(plr.Name) == string.lower(AUTHOR_NAME)
end

local authorAccum = 0
RunService.Heartbeat:Connect(function(dt)
	authorAccum = authorAccum + dt
	if authorAccum < 0.25 then return end
	authorAccum = 0
	pcall(function()
		for plr in pairs(authorEspObjects) do
			if not plr.Parent or not isAuthorPlayer(plr) then clearAuthorESP(plr) end
		end
		for _, plr in ipairs(Players:GetPlayers()) do
			if isAuthorPlayer(plr) and plr ~= LocalPlayer then
				local char = plr.Character
				if char and char:IsA("Model") then
					local hrp = char:FindFirstChild("HumanoidRootPart") or char.PrimaryPart
					local head = char:FindFirstChild("Head")
					if hrp and head then
						if not authorEspObjects[plr] then authorEspObjects[plr] = {} end
						local hl = char:FindFirstChild("AuthorESP_HL_" .. plr.Name)
						if not hl then
							hl = Instance.new("Highlight")
							hl.Name = "AuthorESP_HL_" .. plr.Name
							hl.Adornee = char
							hl.FillColor = Color3.fromRGB(255, 215, 0)
							hl.OutlineColor = Color3.fromRGB(255, 255, 255)
							hl.FillTransparency = 0.45
							hl.OutlineTransparency = 0
							hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
							hl.Parent = char
							table.insert(authorEspObjects[plr], hl)
						end
						local bb = head:FindFirstChild("AuthorESP_Board_" .. plr.Name)
						local distance = (Camera.CFrame.Position - hrp.Position).Magnitude
						if not bb then
							bb = Instance.new("BillboardGui")
							bb.Name = "AuthorESP_Board_" .. plr.Name
							bb.Adornee = head
							bb.Size = UDim2.new(0, 220, 0, 60)
							bb.StudsOffset = Vector3.new(0, 3, 0)
							bb.AlwaysOnTop = true
							bb.LightInfluence = 0
							bb.Parent = head
							local ttl = Instance.new("TextLabel")
							ttl.Size = UDim2.new(1, 0, 0, 26)
							ttl.BackgroundTransparency = 1
							ttl.Text = "脚本作者"
							ttl.TextColor3 = Color3.fromRGB(255, 215, 0)
							ttl.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
							ttl.TextStrokeTransparency = 0
							ttl.Font = Enum.Font.GothamBold
							ttl.TextSize = 20
							ttl.Parent = bb
							local sub = Instance.new("TextLabel")
							sub.Size = UDim2.new(1, 0, 0, 18)
							sub.Position = UDim2.new(0, 0, 0, 26)
							sub.BackgroundTransparency = 1
							sub.Text = plr.Name
							sub.TextColor3 = Color3.fromRGB(255, 255, 255)
							sub.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
							sub.TextStrokeTransparency = 0
							sub.Font = Enum.Font.GothamSemibold
							sub.TextSize = 14
							sub.Parent = bb
							local dist = Instance.new("TextLabel")
							dist.Name = "DistLabel"
							dist.Size = UDim2.new(1, 0, 0, 16)
							dist.Position = UDim2.new(0, 0, 0, 44)
							dist.BackgroundTransparency = 1
							dist.Text = "0m"
							dist.TextColor3 = Color3.fromRGB(255, 235, 59)
							dist.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
							dist.TextStrokeTransparency = 0
							dist.Font = Enum.Font.GothamSemibold
							dist.TextSize = 12
							dist.Parent = bb
							table.insert(authorEspObjects[plr], bb)
						else
							local dist = bb:FindFirstChild("DistLabel")
							if dist then dist.Text = string.format("%.0f m", distance) end
						end
					end
				else
					clearAuthorESP(plr)
				end
			end
		end
	end)
end)

Players.PlayerRemoving:Connect(function(plr)
	clearPlayerESP(plr)
	clearAuthorESP(plr)
end)

local espAccum, pAccum = 0, 0
RunService.Heartbeat:Connect(function(dt)
	if espSettings.enabled then
		espAccum = espAccum + dt
		if espAccum >= 0.1 then
			espAccum = 0
			updateAllESP()
		end
	end
	if playerEspSettings.enabled then
		pAccum = pAccum + dt
		if pAccum >= 0.1 then
			pAccum = 0
			updateAllPlayerESP()
		end
	end
end)

local jumpscareActive = false
local jumpscareObjectNames = { "ScarJumpscare","SandmanJumpscare","LurkerKill","LostJumpscare","KusJumpscare","GusJumpscare","DusJumpscare","BloodManKill","AshyJumpscare" }
local jumpscareScriptNames = { "PlayScarJumpscareAnimLocal","PlaySawRunnerJumpscareAnimLocal","PlaySandmanJumpscareAnimLocal","PlayLurkerJumpscareAnimLocal","PlayLostJumpscareAnimLocal","PlayKusJumpscareAnimLocal","PlayGusJumpscareAnimLocal","PlayDusJumpscareAnimLocal","PlayBloodManJumpscareAnimLocal","PlayAshyJumpscareAnimLocal" }

local function purgeJumpscare()
	local jumpscares = Workspace:FindFirstChild("Jumpscares")
	if jumpscares then
		for _, n in ipairs(jumpscareObjectNames) do
			local obj = jumpscares:FindFirstChild(n)
			if obj then pcall(function() obj:Destroy() end) end
		end
		for _, obj in ipairs(jumpscares:GetChildren()) do
			local nm = obj.Name
			if nm:match("Jumpscare") or nm:match("Kill") or nm:match("Scare") then
				pcall(function() obj:Destroy() end)
			end
		end
	end
	local playerScripts = LocalPlayer:FindFirstChild("PlayerScripts")
	if playerScripts then
		for _, obj in ipairs(playerScripts:GetChildren()) do
			if table.find(jumpscareScriptNames, obj.Name) then
				pcall(function()
					if obj:IsA("LocalScript") or obj:IsA("Script") then obj.Enabled = false end
					obj:Destroy()
				end)
			end
		end
	end
	local playerGui = LocalPlayer:FindFirstChild("PlayerGui")
	if playerGui then
		for _, gui in ipairs(playerGui:GetChildren()) do
			local nm = gui.Name
			if nm:match("Jumpscare") or nm:match("Scare") or nm:match("JumpScare") then
				pcall(function() gui:Destroy() end)
			end
		end
	end
end

local function setJumpscareBlock(state)
	if state then
		if jumpscareActive then return end
		jumpscareActive = true
		purgeJumpscare()
		task.spawn(function()
			while jumpscareActive do
				purgeJumpscare()
				task.wait(0.3)
			end
		end)
	else
		jumpscareActive = false
	end
end

local playerSettings = {
	walkSpeed = 40,
	jumpPower = 60,
	gravity = 196,
	godMode = false
}

local function getHum()
	local char = LocalPlayer.Character
	return char and char:FindFirstChildOfClass("Humanoid")
end

local function applySpeed()
	local hum = getHum()
	if hum then pcall(function() hum.WalkSpeed = playerSettings.walkSpeed end) end
end

local function applyJump()
	local hum = getHum()
	if hum then
		pcall(function()
			hum.UseJumpPower = true
			hum.JumpPower = playerSettings.jumpPower
		end)
		pcall(function() hum.JumpHeight = playerSettings.jumpPower / 7 end)
	end
end

local infJumpConn = nil
local function setInfJump(state)
	if state then
		if infJumpConn then return end
		infJumpConn = UserInputService.JumpRequest:Connect(function()
			local hum = getHum()
			if hum then pcall(function() hum:ChangeState(Enum.HumanoidStateType.Jumping) end) end
		end)
	elseif infJumpConn then
		infJumpConn:Disconnect()
		infJumpConn = nil
	end
end

local function applyGravity()
	pcall(function() Workspace.Gravity = playerSettings.gravity end)
end

local keepThirdPerson = true

local function ApplyCamera()
	if keepThirdPerson then
		LocalPlayer.CameraMode = Enum.CameraMode.Classic
		LocalPlayer.CameraMinZoomDistance = 0.5
		LocalPlayer.CameraMaxZoomDistance = 128
	else
		LocalPlayer.CameraMode = Enum.CameraMode.LockFirstPerson
		LocalPlayer.CameraMinZoomDistance = 0.5
		LocalPlayer.CameraMaxZoomDistance = 0.5
	end
end

task.spawn(function()
	task.wait(1)
	if LocalPlayer.CameraMode == Enum.CameraMode.LockFirstPerson then ApplyCamera() end
end)

LocalPlayer.CharacterAdded:Connect(function()
	task.wait(0.5)
	ApplyCamera()
	applySpeed()
	applyJump()
	if playerSettings.godMode then
		local hum = getHum()
		if hum then pcall(function() hum.BreakJointsOnDeath = false end) end
	end
end)

if LocalPlayer.Character then ApplyCamera() end

task.spawn(function()
	task.wait(0.5)
	applySpeed()
	applyJump()
end)

local assistSettings = {
	brightnessEnabled = false,
	brightnessLevel = 2
}

local brightnessPresets = {
	[1] = { brightness = 3, clockTime = 14, fogEnd = 100000, ambient = Color3.fromRGB(150, 150, 150), outdoorAmbient = Color3.fromRGB(150, 150, 150) },
	[2] = { brightness = 6, clockTime = 12, fogEnd = 1000000, ambient = Color3.fromRGB(200, 200, 200), outdoorAmbient = Color3.fromRGB(200, 200, 200) },
	[3] = { brightness = 20, clockTime = 12, fogEnd = 10000000, ambient = Color3.fromRGB(255, 255, 255), outdoorAmbient = Color3.fromRGB(255, 255, 255) },
}

local lightingOriginal = {}

local function applyBrightness()
	local preset = brightnessPresets[assistSettings.brightnessLevel]
	if not preset then return end
	if not next(lightingOriginal) then
		pcall(function()
			lightingOriginal.Brightness = Lighting.Brightness
			lightingOriginal.ClockTime = Lighting.ClockTime
			lightingOriginal.FogEnd = Lighting.FogEnd
			lightingOriginal.Ambient = Lighting.Ambient
			lightingOriginal.OutdoorAmbient = Lighting.OutdoorAmbient
			lightingOriginal.GlobalShadows = Lighting.GlobalShadows
		end)
	end
	pcall(function() Lighting.Brightness = preset.brightness end)
	pcall(function() Lighting.ClockTime = preset.clockTime end)
	pcall(function() Lighting.FogEnd = preset.fogEnd end)
	pcall(function() Lighting.Ambient = preset.ambient end)
	pcall(function() Lighting.OutdoorAmbient = preset.outdoorAmbient end)
	pcall(function() Lighting.GlobalShadows = false end)
end

local function restoreBrightness()
	if not next(lightingOriginal) then return end
	pcall(function() Lighting.Brightness = lightingOriginal.Brightness end)
	pcall(function() Lighting.ClockTime = lightingOriginal.ClockTime end)
	pcall(function() Lighting.FogEnd = lightingOriginal.FogEnd end)
	pcall(function() Lighting.Ambient = lightingOriginal.Ambient end)
	pcall(function() Lighting.OutdoorAmbient = lightingOriginal.OutdoorAmbient end)
	pcall(function() Lighting.GlobalShadows = lightingOriginal.GlobalShadows end)
	lightingOriginal = {}
end

local function fireRespawn()
	local evt = ReplicatedStorage:FindFirstChild("RequestRespawn") or ReplicatedStorage:WaitForChild("RequestRespawn", 3)
	if not evt then
		notify("致命猴子", "未找到 RequestRespawn", 3)
		return false
	end
	return pcall(function()
		if evt:IsA("RemoteEvent") then evt:FireServer()
		elseif evt:IsA("RemoteFunction") then evt:InvokeServer()
		elseif evt:IsA("BindableEvent") then evt:Fire() end
	end)
end

local function clickGameRespawnButton()
	local playerGui = LocalPlayer:FindFirstChild("PlayerGui")
	if not playerGui then return false end
	local target = nil
	local ok = pcall(function()
		for _, obj in ipairs(playerGui:GetDescendants()) do
			if obj:IsA("GuiButton") and obj.Visible then
				local nm = string.lower(obj.Name)
				local txt = ""
				if obj:IsA("TextButton") then txt = string.lower(obj.Text or "") end
				if nm:find("respawn") or nm:find("revive") or nm:find("rebirth") or txt:find("复活") or txt:find("重生") or txt:find("respawn") or txt:find("revive") then
					target = obj
					break
				end
			end
		end
	end)
	if ok and target then
		local fired = pcall(function()
			target.MouseButton1Click:Fire()
			target.Activated:Fire()
		end)
		return fired
	end
	return false
end

local function tryRespawn()
	if clickGameRespawnButton() then return true end
	return fireRespawn()
end

local autoRespawnConn = nil
local function setAutoRespawn(state)
	if state then
		if autoRespawnConn then return end
		autoRespawnConn = LocalPlayer.CharacterAdded:Connect(function(char)
			local hum = char:WaitForChild("Humanoid", 5)
			if not hum then return end
			hum.Died:Connect(function()
				task.wait(0.5)
				fireRespawn()
			end)
		end)
	elseif autoRespawnConn then
		autoRespawnConn:Disconnect()
		autoRespawnConn = nil
	end
end

local ColorTables = {
	red = Color3.fromRGB(255, 0, 0),
	green = Color3.fromRGB(0, 255, 0),
	blue = Color3.fromRGB(0, 0, 255),
	yellow = Color3.fromRGB(255, 255, 0),
	purple = Color3.fromRGB(128, 0, 255),
	cyan = Color3.fromRGB(0, 255, 255),
	white = Color3.fromRGB(255, 255, 255),
	black = Color3.fromRGB(0, 0, 0),
	orange = Color3.fromRGB(255, 150, 60),
	sgreen = Color3.fromRGB(0, 255, 127),
}

local rainbowActive = false
local rainbowConnection = nil

local function setRainbow(state)
	rainbowActive = state
	if rainbowConnection then
		rainbowConnection:Disconnect()
		rainbowConnection = nil
	end
	if state then
		local hue = 0
		rainbowConnection = RunService.Heartbeat:Connect(function(dt)
			hue = (hue + dt * 0.15) % 1
			local c = Color3.fromHSV(hue, 0.7, 1)
			Theme.Accent = c
			Theme.AccentDim = Color3.new(c.R * 0.55, c.G * 0.55, c.B * 0.55)
			Theme.Stroke = Color3.new(c.R * 0.65, c.G * 0.65, c.B * 0.65)
			for _, entry in ipairs(AccentObjects) do
				if entry.obj and entry.obj.Parent then entry.obj[entry.prop] = c end
			end
			mainStroke.Color = c
			miniStroke.Color = c
		end)
	end
end

local MainTab = createTab("怪物透视", "home")
local P1 = MainTab.Page
makeSectionTitle(P1, "ESP 总开关", "bolt")
makeToggle(P1, "ESP 总开关", false, function(state)
	espSettings.enabled = state
	if not state then clearAllESP() end
	notify("致命猴子", state and "ESP 已开启" or "ESP 已关闭", 3)
end)
makeSectionTitle(P1, "显示选项", "shield")
makeToggle(P1, "怪物高亮", true, function(v) espSettings.highlightEnabled = v end)
makeToggle(P1, "怪物名字", true, function(v) espSettings.nameEnabled = v end)
makeToggle(P1, "距离显示", true, function(v) espSettings.distanceEnabled = v end)
makeToggle(P1, "血量显示", false, function(v) espSettings.healthEnabled = v end)
makeSectionTitle(P1, "参数调节", "settings")
makeSlider(P1, "最大显示距离", 50, 2000, 500, function(v) espSettings.maxDistance = v end)
makeSlider(P1, "填充透明度", 0, 100, 50, function(v) espSettings.fillTransparency = v / 100 end)
makeSlider(P1, "文字大小", 10, 24, 14, function(v) espSettings.textSize = v end)
makeSectionTitle(P1, "怪物单独开关", "bolt")
for _, m in ipairs(monsterConfig) do
	makeToggle(P1, m.name, true, function(v) monsterToggles[m.name] = v end)
end

local TabColor = createTab("颜色设置", "palette")
local P2 = TabColor.Page
makeSectionTitle(P2, "怪物ESP颜色", "palette")
makeColorDropdown(P2, "高亮填充颜色", {
	{ name = "红色", color = ColorTables.red },
	{ name = "绿色", color = ColorTables.green },
	{ name = "蓝色", color = ColorTables.blue },
	{ name = "黄色", color = ColorTables.yellow },
	{ name = "紫色", color = ColorTables.purple },
	{ name = "青色", color = ColorTables.cyan },
	{ name = "白色", color = ColorTables.white },
	{ name = "黑色", color = ColorTables.black },
}, function(entry) espSettings.highlightColor = entry.color end)
makeColorDropdown(P2, "高亮描边颜色", {
	{ name = "白色", color = ColorTables.white },
	{ name = "红色", color = ColorTables.red },
	{ name = "绿色", color = ColorTables.green },
	{ name = "蓝色", color = ColorTables.blue },
	{ name = "黄色", color = ColorTables.yellow },
	{ name = "黑色", color = ColorTables.black },
}, function(entry) espSettings.outlineColor = entry.color end)
makeColorDropdown(P2, "怪物名字颜色", {
	{ name = "白色", color = ColorTables.white },
	{ name = "红色", color = Color3.fromRGB(255, 50, 50) },
	{ name = "黄色", color = Color3.fromRGB(255, 235, 59) },
	{ name = "绿色", color = Color3.fromRGB(50, 255, 50) },
	{ name = "青色", color = ColorTables.cyan },
	{ name = "紫色", color = Color3.fromRGB(200, 100, 255) },
}, function(entry) espSettings.nameColor = entry.color end)

local TabPlayerESP = createTab("玩家透视", "users")
local P3 = TabPlayerESP.Page
makeSectionTitle(P3, "玩家 ESP 总开关", "users")
makeToggle(P3, "玩家透视总开关", false, function(state)
	playerEspSettings.enabled = state
	if not state then clearAllPlayerESP() end
	notify("致命猴子", state and "玩家透视已开启" or "玩家透视已关闭", 3)
end)
makeSectionTitle(P3, "显示选项", "shield")
makeToggle(P3, "玩家高亮", true, function(v) playerEspSettings.highlightEnabled = v end)
makeToggle(P3, "玩家名字", true, function(v) playerEspSettings.nameEnabled = v end)
makeToggle(P3, "距离显示", true, function(v) playerEspSettings.distanceEnabled = v end)
makeToggle(P3, "血量显示", true, function(v) playerEspSettings.healthEnabled = v end)
makeToggle(P3, "显示自己", false, function(v) playerEspSettings.showSelf = v end)
makeSectionTitle(P3, "参数调节", "settings")
makeSlider(P3, "最大显示距离", 50, 3000, 1000, function(v) playerEspSettings.maxDistance = v end)
makeSlider(P3, "填充透明度", 0, 100, 50, function(v) playerEspSettings.fillTransparency = v / 100 end)
makeSlider(P3, "文字大小", 10, 24, 14, function(v) playerEspSettings.textSize = v end)
makeSectionTitle(P3, "颜色设置", "palette")
makeColorDropdown(P3, "高亮填充颜色", {
	{ name = "绿色", color = ColorTables.sgreen },
	{ name = "红色", color = ColorTables.red },
	{ name = "蓝色", color = ColorTables.blue },
	{ name = "黄色", color = ColorTables.yellow },
	{ name = "紫色", color = ColorTables.purple },
	{ name = "青色", color = ColorTables.cyan },
}, function(entry) playerEspSettings.highlightColor = entry.color end)
makeColorDropdown(P3, "玩家名字颜色", {
	{ name = "绿色", color = ColorTables.sgreen },
	{ name = "白色", color = ColorTables.white },
	{ name = "红色", color = Color3.fromRGB(255, 50, 50) },
	{ name = "黄色", color = Color3.fromRGB(255, 235, 59) },
	{ name = "青色", color = ColorTables.cyan },
	{ name = "紫色", color = Color3.fromRGB(200, 100, 255) },
}, function(entry) playerEspSettings.nameColor = entry.color end)

local TabPlayer = createTab("玩家功能", "user")
local P4 = TabPlayer.Page
makeSectionTitle(P4, "怪物突脸", "shield")
makeToggle(P4, "删除怪物突脸", false, function(state)
	setJumpscareBlock(state)
	notify("致命猴子", state and "突脸已删除" or "突脸删除已关闭", 3)
end)
makeSectionTitle(P4, "速度", "bolt")
makeSlider(P4, "行走速度", 40, 500, 40, function(v)
	playerSettings.walkSpeed = v
	applySpeed()
end)
makeDropdown(P4, "速度", { "默认(40)", "快速(50)", "极速(150)", "光速(300)", "超光速(500)" }, "默认(40)", function(sel)
	local presets = { ["默认(40)"] = 40, ["快速(50)"] = 50, ["极速(150)"] = 150, ["光速(300)"] = 300, ["超光速(500)"] = 500 }
	playerSettings.walkSpeed = presets[sel] or 40
	applySpeed()
end)
makeSectionTitle(P4, "跳跃控制", "bolt")
makeSlider(P4, "跳跃力", 60, 500, 60, function(v)
	playerSettings.jumpPower = v
	applyJump()
end)
makeToggle(P4, "无限跳跃", false, function(v) setInfJump(v) end)
makeSectionTitle(P4, "重力调节", "bolt")
makeSlider(P4, "重力", 0, 400, 196, function(v)
	playerSettings.gravity = v
	applyGravity()
end)
makeSectionTitle(P4, "复活", "check")
makeButton(P4, "点击复活", "check", function()
	local ok = tryRespawn()
	notify("致命猴子", ok and "已点击复活" or "复活失败", 3)
end)
makeToggle(P4, "快速复活", false, function(v) setAutoRespawn(v) end)
makeSectionTitle(P4, "第三人称", "user")
makeToggle(P4, "第三人称", true, function(state)
	keepThirdPerson = state
	ApplyCamera()
	notify("致命猴子", state and "第三人称已开启" or "第三人称已关闭", 3)
end)

local TabAssist = createTab("其他功能", "zap")
local P5 = TabAssist.Page
makeSectionTitle(P5, "亮度提升", "zap")
makeToggle(P5, "亮度提升", false, function(state)
	assistSettings.brightnessEnabled = state
	if state then applyBrightness() else restoreBrightness() end
	notify("致命猴子", state and "亮度提升已开启" or "亮度提升已关闭", 3)
end)
makeDropdown(P5, "亮度等级", { "微亮", "中亮", "超亮" }, "中亮", function(sel)
	local levels = { ["微亮"] = 1, ["中亮"] = 2, ["超亮"] = 3 }
	assistSettings.brightnessLevel = levels[sel] or 2
	if assistSettings.brightnessEnabled then applyBrightness() end
end)
makeSectionTitle(P5, "作者信息", "shield")
makeButton(P5, "复制作者UID", "check", function()
	local copyText = "UID:3493085004695814"
	pcall(function()
		if setclipboard then setclipboard(copyText) elseif toclipboard then toclipboard(copyText) end
	end)
	notify("致命猴子", "已复制到剪贴板", 3)
end)
makeSectionTitle(P5, "公告", "shield")
makeParagraph(P5, "脚本为AI制作永久公益，禁止圈钱。谢谢配合！")
makeSectionTitle(P5, "更新日志", "bolt")
makeParagraph(P5, "更新了BTM，祝大家玩的开心（更新日志：2026.10.10）”")

local TabTools = createTab("其他脚本", "wind")
local P6 = TabTools.Page
makeSectionTitle(P6, "外置脚本", "wind")
makeButton(P6, "飞行脚本", "wind", function()
	pcall(function() loadstring(game:HttpGet("https://pastefy.app/sgSR0W9o/raw"))() end)
	notify("致命猴子", "飞行脚本已执行", 3)
end)
makeButton(P6, "刷钱脚本", "wind", function()
	pcall(function() loadstring(game:HttpGet("https://pastebin.com/raw/2xXGqd9M"))() end)
	notify("致命猴子", "刷钱脚本已执行", 3)
end)
makeButton(P6, "甩飞脚本", "wind", function()
	pcall(function() loadstring(game:HttpGet("https://pastebin.com/raw/EnYNYKpB"))() end)
	notify("致命猴子", "甩飞脚本已执行", 3)
end)
makeButton(P6, "工具获取器", "wind", function()
	pcall(function()
		local TweenServiceL = game:GetService("TweenService")
		local PlayerGuiL = LocalPlayer:WaitForChild("PlayerGui")
		local ITEMS = {
			{ label = "获取手电筒", names = {"Flashlight", "FlashLight", "Torch"}, keywords = {"flashlight", "flash light", "torch", "手电筒"}, color = Color3.fromRGB(255, 170, 60) },
			{ label = "获取雷达", names = {"Radar"}, keywords = {"radar", "雷达"}, color = Color3.fromRGB(70, 165, 255) },
		}
		local function getBackpack()
			local bp = LocalPlayer:FindFirstChildOfClass("Backpack")
			if not bp then bp = LocalPlayer:WaitForChild("Backpack", 5) end
			return bp
		end
		local function hasItem(names)
			local bp = getBackpack()
			local char = LocalPlayer.Character
			for _, n in ipairs(names) do
				if bp and bp:FindFirstChild(n) then return true end
				if char and char:FindFirstChild(n) then return true end
			end
			return false
		end
		local function findToolSource(names)
			local roots = { Workspace, ReplicatedStorage, getBackpack(), LocalPlayer:FindFirstChild("StarterGear") }
			for _, root in ipairs(roots) do
				if root then
					for _, n in ipairs(names) do
						local obj = root:FindFirstChild(n, true)
						if obj and obj:IsA("Tool") then return obj end
					end
				end
			end
			return nil
		end
		local function tryPrompts(keywords)
			local touched = false
			for _, d in ipairs(Workspace:GetDescendants()) do
				if d:IsA("ProximityPrompt") then
					local holder = d.Parent
					if holder then
						local name = holder.Name:lower()
						for _, k in ipairs(keywords) do
							if string.find(name, k, 1, true) then
								touched = true
								d.MaxActivationDistance = 1e6
								d.HoldDuration = 0
								d.RequiresLineOfSight = false
								pcall(function()
									d:InputHoldBegin()
									task.wait(0.06)
									d:InputHoldEnd()
								end)
								break
							end
						end
					end
				end
			end
			return touched
		end
		local function grabItem(item)
			if hasItem(item.names) then return false, "背包里已经有了" end
			tryPrompts(item.keywords)
			task.wait(0.5)
			if hasItem(item.names) then return true, "已获取 " .. item.names[1] end
			local src = findToolSource(item.names)
			if src then
				local bp = getBackpack()
				if bp then
					local clone = src:Clone()
					clone.Parent = bp
					return true, "已获取 " .. clone.Name .. "（本地）"
				end
			end
			return false, "没找到该物品"
		end
		local old = PlayerGuiL:FindFirstChild("ToolGrabberUI")
		if old then old:Destroy() end
		local TGui = Instance.new("ScreenGui")
		TGui.Name = "ToolGrabberUI"
		TGui.ResetOnSpawn = false
		TGui.IgnoreGuiInset = true
		TGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
		TGui.Parent = PlayerGuiL
		local FULL_SIZE = UDim2.new(0, 250, 0, 190)
		local MINI_SIZE = UDim2.new(0, 250, 0, 34)
		local TMain = Instance.new("Frame")
		TMain.Name = "Main"
		TMain.AnchorPoint = Vector2.new(0.5, 0)
		TMain.Position = UDim2.new(0.5, 0, 0.3, 0)
		TMain.Size = FULL_SIZE
		TMain.BackgroundColor3 = Color3.fromRGB(28, 28, 34)
		TMain.BorderSizePixel = 0
		TMain.ClipsDescendants = true
		TMain.Active = true
		TMain.Parent = TGui
		local tCorner = Instance.new("UICorner")
		tCorner.CornerRadius = UDim.new(0, 10)
		tCorner.Parent = TMain
		local tStroke = Instance.new("UIStroke")
		tStroke.Color = Color3.fromRGB(62, 62, 78)
		tStroke.Thickness = 1
		tStroke.Parent = TMain
		local TTitleBar = Instance.new("Frame")
		TTitleBar.Name = "TitleBar"
		TTitleBar.Size = UDim2.new(1, 0, 0, 34)
		TTitleBar.BackgroundColor3 = Color3.fromRGB(38, 38, 48)
		TTitleBar.BorderSizePixel = 0
		TTitleBar.Parent = TMain
		local TTitle = Instance.new("TextLabel")
		TTitle.Size = UDim2.new(1, -80, 1, 0)
		TTitle.Position = UDim2.new(0, 12, 0, 0)
		TTitle.BackgroundTransparency = 1
		TTitle.Font = Enum.Font.GothamBold
		TTitle.Text = "工具获取器"
		TTitle.TextColor3 = Color3.fromRGB(235, 235, 245)
		TTitle.TextSize = 14
		TTitle.TextXAlignment = Enum.TextXAlignment.Left
		TTitle.Parent = TTitleBar
		local function makeIconButton(text, xOffset, color)
			local btn = Instance.new("TextButton")
			btn.Size = UDim2.new(0, 28, 0, 28)
			btn.Position = UDim2.new(1, xOffset, 0.5, -14)
			btn.BackgroundColor3 = color
			btn.BorderSizePixel = 0
			btn.AutoButtonColor = false
			btn.Text = text
			btn.Font = Enum.Font.GothamBold
			btn.TextSize = 15
			btn.TextColor3 = Color3.fromRGB(230, 230, 240)
			btn.Parent = TTitleBar
			local c = Instance.new("UICorner")
			c.CornerRadius = UDim.new(0, 6)
			c.Parent = btn
			btn.MouseEnter:Connect(function() TweenServiceL:Create(btn, TweenInfo.new(0.12), { BackgroundColor3 = color:Lerp(Color3.new(1, 1, 1), 0.18) }):Play() end)
			btn.MouseLeave:Connect(function() TweenServiceL:Create(btn, TweenInfo.new(0.12), { BackgroundColor3 = color }):Play() end)
			return btn
		end
		local TMinBtn = makeIconButton("–", -66, Color3.fromRGB(58, 58, 72))
		local TCloseBtn = makeIconButton("×", -34, Color3.fromRGB(70, 45, 45))
		local TBody = Instance.new("Frame")
		TBody.Name = "Body"
		TBody.Position = UDim2.new(0, 0, 0, 34)
		TBody.Size = UDim2.new(1, 0, 1, -34)
		TBody.BackgroundTransparency = 1
		TBody.Parent = TMain
		local function makeActionButton(text, yOffset, color, parent)
			local btn = Instance.new("TextButton")
			btn.Size = UDim2.new(1, -28, 0, 42)
			btn.Position = UDim2.new(0, 14, 0, yOffset)
			btn.BackgroundColor3 = color
			btn.BorderSizePixel = 0
			btn.AutoButtonColor = false
			btn.Text = text
			btn.Font = Enum.Font.GothamBold
			btn.TextSize = 14
			btn.TextColor3 = Color3.fromRGB(255, 255, 255)
			btn.Parent = parent
			local c = Instance.new("UICorner")
			c.CornerRadius = UDim.new(0, 8)
			c.Parent = btn
			btn.MouseEnter:Connect(function() TweenServiceL:Create(btn, TweenInfo.new(0.12), { BackgroundColor3 = color:Lerp(Color3.new(1, 1, 1), 0.15) }):Play() end)
			btn.MouseLeave:Connect(function() TweenServiceL:Create(btn, TweenInfo.new(0.12), { BackgroundColor3 = color }):Play() end)
			btn.MouseButton1Down:Connect(function() TweenServiceL:Create(btn, TweenInfo.new(0.08), { BackgroundColor3 = color:Lerp(Color3.new(0, 0, 0), 0.2) }):Play() end)
			btn.MouseButton1Up:Connect(function() TweenServiceL:Create(btn, TweenInfo.new(0.08), { BackgroundColor3 = color }):Play() end)
			return btn
		end
		local TStatus = Instance.new("TextLabel")
		TStatus.Name = "Status"
		TStatus.Size = UDim2.new(1, -28, 0, 26)
		TStatus.Position = UDim2.new(0, 14, 1, -34)
		TStatus.BackgroundTransparency = 1
		TStatus.Font = Enum.Font.Gotham
		TStatus.Text = "就绪"
		TStatus.TextColor3 = Color3.fromRGB(150, 150, 165)
		TStatus.TextSize = 12
		TStatus.TextXAlignment = Enum.TextXAlignment.Left
		TStatus.TextWrapped = true
		TStatus.Parent = TBody
		local busy = false
		local function setStatus(text, color, resetAfter)
			TStatus.Text = text
			TStatus.TextColor3 = color
			if resetAfter then
				local snapshot = text
				task.delay(resetAfter, function()
					if TStatus.Text == snapshot then
						TStatus.Text = "就绪"
						TStatus.TextColor3 = Color3.fromRGB(150, 150, 165)
					end
				end)
			end
		end
		local function onGrab(item)
			if busy then return end
			busy = true
			setStatus("正在获取 " .. item.names[1] .. " ...", Color3.fromRGB(200, 200, 215))
			task.spawn(function()
				local ok, msg = grabItem(item)
				if ok then
					setStatus(msg, Color3.fromRGB(120, 230, 140), 2)
				else
					setStatus(msg, Color3.fromRGB(255, 120, 120), 2)
				end
				busy = false
			end)
		end
		local FlashBtn = makeActionButton(ITEMS[1].label, 14, ITEMS[1].color, TBody)
		local RadarBtn = makeActionButton(ITEMS[2].label, 68, ITEMS[2].color, TBody)
		FlashBtn.MouseButton1Click:Connect(function() onGrab(ITEMS[1]) end)
		RadarBtn.MouseButton1Click:Connect(function() onGrab(ITEMS[2]) end)
		local tdragging = false
		local tdragStart = nil
		local tstartPos = nil
		TTitleBar.InputBegan:Connect(function(input)
			if input.UserInputType ~= Enum.UserInputType.MouseButton1 and input.UserInputType ~= Enum.UserInputType.Touch then return end
			local t = input.Target
			if t == TMinBtn or t == TCloseBtn or (t and (t.Parent == TMinBtn or t.Parent == TCloseBtn)) then return end
			tdragging = true
			tdragStart = input.Position
			tstartPos = TMain.Position
			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then tdragging = false end
			end)
		end)
		UserInputService.InputChanged:Connect(function(input)
			if not tdragging then return end
			if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
				local delta = input.Position - tdragStart
				TMain.Position = UDim2.new(tstartPos.X.Scale, tstartPos.X.Offset + delta.X, tstartPos.Y.Scale, tstartPos.Y.Offset + delta.Y)
			end
		end)
		local tminimized = false
		TMinBtn.MouseButton1Click:Connect(function()
			tminimized = not tminimized
			TBody.Visible = not tminimized
			TweenServiceL:Create(TMain, TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { Size = tminimized and MINI_SIZE or FULL_SIZE }):Play()
			TMinBtn.Text = tminimized and "+" or "–"
		end)
		TCloseBtn.MouseButton1Click:Connect(function() TGui:Destroy() end)
	end)
	notify("致命猴子", "工具获取器已打开", 3)
end)
makeButton(P6, "彩虹猴子（每个人都可以看见）", "wind", function()
	pcall(function() loadstring(game:HttpGet("https://pastebin.com/raw/7JSnvWQL"))() end)
	notify("致命猴子", "彩虹猴子脚本已执行", 3)
end)
makeButton(P6, "致命猿BKU脚本（推荐）", "wind", function()
	pcall(function() loadstring(game:HttpGet("https://raw.githubusercontent.com/Baloksxin/ROBLOX-BKU-SCRIPT/refs/heads/main/BKU%20SCRIPT.LUA"))() end)
	notify("致命猴子", "致命猿BKU脚本已执行", 3)
end)
makeButton(P6, "ER BTM", "wind", function()
	pcall(function() loadstring(game:HttpGet("https://pastefy.app/0IQzgppR/raw"))() end)
	notify("致命猴子", "ER BTM 脚本已执行", 3)
end)

local TabNPC = createTab("控制NPC", "users")
local P7 = TabNPC.Page
makeSectionTitle(P7, "NPC 绑定", "users")
makeButton(P7, "固定在NPC脚底下", "check", function()
	pcall(function()
		if LocalPlayer:WaitForChild("PlayerGui"):FindFirstChild("Kela_Anchor_UI") then
			LocalPlayer.PlayerGui.Kela_Anchor_UI:Destroy()
		end
		if getgenv().SyncConn then
			getgenv().SyncConn:Disconnect()
			getgenv().SyncConn = nil
		end
		local ScreenGuiN = Instance.new("ScreenGui")
		ScreenGuiN.Name = "Kela_Anchor_UI"
		ScreenGuiN.Parent = LocalPlayer:WaitForChild("PlayerGui")
		ScreenGuiN.ResetOnSpawn = false
		local MainFrame = Instance.new("Frame")
		MainFrame.Parent = ScreenGuiN
		MainFrame.Size = UDim2.new(0, 260, 0, 220)
		MainFrame.Position = UDim2.new(0.1, 0, 0.4, 0)
		MainFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 20)
		MainFrame.BorderSizePixel = 0
		MainFrame.Active = true
		MainFrame.ClipsDescendants = true
		Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 8)
		local UIStrokeN = Instance.new("UIStroke")
		UIStrokeN.Color = Color3.fromRGB(0, 150, 255)
		UIStrokeN.Thickness = 1.5
		UIStrokeN.Transparency = 0.5
		UIStrokeN.Parent = MainFrame
		local TopBarN = Instance.new("Frame")
		TopBarN.Parent = MainFrame
		TopBarN.Size = UDim2.new(1, 0, 0, 35)
		TopBarN.BackgroundColor3 = Color3.fromRGB(25, 25, 28)
		TopBarN.BorderSizePixel = 0
		Instance.new("UICorner", TopBarN).CornerRadius = UDim.new(0, 8)
		local Signature = Instance.new("TextLabel")
		Signature.Parent = TopBarN
		Signature.Size = UDim2.new(1, -40, 1, 0)
		Signature.Position = UDim2.new(0, 10, 0, 0)
		Signature.BackgroundTransparency = 1
		Signature.Font = Enum.Font.GothamBold
		Signature.TextSize = 14
		Signature.Text = "by kela_er"
		Signature.TextColor3 = Color3.fromRGB(0, 200, 255)
		Signature.TextXAlignment = Enum.TextXAlignment.Left
		local MinimizeBtn = Instance.new("TextButton")
		MinimizeBtn.Parent = TopBarN
		MinimizeBtn.Size = UDim2.new(0, 25, 0, 25)
		MinimizeBtn.Position = UDim2.new(1, -30, 0, 5)
		MinimizeBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
		MinimizeBtn.Text = "-"
		MinimizeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
		MinimizeBtn.Font = Enum.Font.GothamBold
		MinimizeBtn.TextSize = 18
		MinimizeBtn.BorderSizePixel = 0
		Instance.new("UICorner", MinimizeBtn).CornerRadius = UDim.new(0, 4)
		local ContentN = Instance.new("Frame")
		ContentN.Parent = MainFrame
		ContentN.Size = UDim2.new(1, -20, 1, -45)
		ContentN.Position = UDim2.new(0, 10, 0, 40)
		ContentN.BackgroundTransparency = 1
		local NameInput = Instance.new("TextBox")
		NameInput.Parent = ContentN
		NameInput.Size = UDim2.new(1, 0, 0, 35)
		NameInput.BackgroundColor3 = Color3.fromRGB(28, 28, 32)
		NameInput.TextColor3 = Color3.fromRGB(255, 255, 255)
		NameInput.Font = Enum.Font.Gotham
		NameInput.TextSize = 14
		NameInput.PlaceholderText = "输入要绑定的 NPC 名字"
		NameInput.Text = ""
		NameInput.BorderSizePixel = 0
		Instance.new("UICorner", NameInput).CornerRadius = UDim.new(0, 5)
		local BindBtn = Instance.new("TextButton")
		BindBtn.Parent = ContentN
		BindBtn.Size = UDim2.new(1, 0, 0, 40)
		BindBtn.Position = UDim2.new(0, 0, 0, 50)
		BindBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
		BindBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
		BindBtn.Font = Enum.Font.GothamBold
		BindBtn.TextSize = 15
		BindBtn.Text = "把本体绑到 NPC 脚底"
		BindBtn.BorderSizePixel = 0
		Instance.new("UICorner", BindBtn).CornerRadius = UDim.new(0, 5)
		local UnbindBtn = Instance.new("TextButton")
		UnbindBtn.Parent = ContentN
		UnbindBtn.Size = UDim2.new(1, 0, 0, 35)
		UnbindBtn.Position = UDim2.new(0, 0, 0, 100)
		UnbindBtn.BackgroundColor3 = Color3.fromRGB(220, 20, 60)
		UnbindBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
		UnbindBtn.Font = Enum.Font.GothamBold
		UnbindBtn.TextSize = 15
		UnbindBtn.Text = "取消绑定 (秒恢复)"
		UnbindBtn.BorderSizePixel = 0
		Instance.new("UICorner", UnbindBtn).CornerRadius = UDim.new(0, 5)
		local dragging, dragInput, dragStart, startPos
		TopBarN.InputBegan:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
				dragging = true
				dragStart = input.Position
				startPos = MainFrame.Position
				input.Changed:Connect(function()
					if input.UserInputState == Enum.UserInputState.End then dragging = false end
				end)
			end
		end)
		TopBarN.InputChanged:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
				dragInput = input
			end
		end)
		UserInputService.InputChanged:Connect(function(input)
			if input == dragInput and dragging then
				local delta = input.Position - dragStart
				MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
			end
		end)
		local isMinimized = false
		MinimizeBtn.MouseButton1Click:Connect(function()
			isMinimized = not isMinimized
			local targetSize = isMinimized and UDim2.new(0, 260, 0, 35) or UDim2.new(0, 260, 0, 220)
			TweenService:Create(MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quart), { Size = targetSize }):Play()
			for _, child in ipairs(ContentN:GetChildren()) do
				if child:IsA("GuiObject") then
					TweenService:Create(child, TweenInfo.new(0.2), { BackgroundTransparency = isMinimized and 1 or 0, TextTransparency = isMinimized and 1 or 0 }):Play()
				end
			end
			MinimizeBtn.Text = isMinimized and "+" or "-"
		end)
		local currentTargetNPC = nil
		BindBtn.MouseButton1Click:Connect(function()
			local targetName = NameInput.Text
			if targetName == "" then return end
			BindBtn.Text = "正在检索..."
			task.wait(0.5)
			for _, obj in ipairs(workspace:GetDescendants()) do
				if obj:IsA("Model") and obj.Name == targetName and obj:FindFirstChild("Humanoid") then
					currentTargetNPC = obj
					break
				end
			end
			if not currentTargetNPC then
				BindBtn.Text = "未找到目标！"
				task.wait(1)
				BindBtn.Text = "把本体绑到 NPC 脚底"
				return
			end
			local myChar = workspace:FindFirstChild(LocalPlayer.Name) or LocalPlayer.Character
			local npcRoot = currentTargetNPC:FindFirstChild("HumanoidRootPart")
			local myRoot = myChar and myChar:FindFirstChild("HumanoidRootPart")
			if npcRoot and myRoot then
				if getgenv().SyncConn then getgenv().SyncConn:Disconnect() end
				local offset = Vector3.new(0, -25, 0)
				for _, part in ipairs(myChar:GetDescendants()) do
					if part:IsA("BasePart") then part.CanCollide = false end
				end
				BindBtn.Text = "✅ 绑定成功！"
				BindBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 100)
				getgenv().SyncConn = RunService.Heartbeat:Connect(function()
					if npcRoot and npcRoot.Parent and myRoot and myRoot.Parent then
						myRoot.CFrame = CFrame.new(npcRoot.Position + offset)
					end
				end)
			end
		end)
		UnbindBtn.MouseButton1Click:Connect(function()
			if getgenv().SyncConn then
				getgenv().SyncConn:Disconnect()
				getgenv().SyncConn = nil
			end
			local trueChar = workspace:FindFirstChild(LocalPlayer.Name) or LocalPlayer.Character
			if trueChar then
				local myHum = trueChar:FindFirstChildOfClass("Humanoid")
				if myHum then
					myHum.WalkSpeed = 16
					myHum.JumpPower = 50
					myHum:ChangeState(Enum.HumanoidStateType.GettingUp)
					myHum.PlatformStand = false
				end
				for _, part in ipairs(trueChar:GetDescendants()) do
					if part:IsA("BasePart") then
						part.CanCollide = true
						part.Anchored = false
					end
				end
				local myRoot = trueChar:FindFirstChild("HumanoidRootPart")
				if myRoot then myRoot.CFrame = myRoot.CFrame + Vector3.new(0, 10, 0) end
			end
			BindBtn.Text = "把本体绑到 NPC 脚底"
			BindBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
			UnbindBtn.Text = "已取消"
			task.wait(1.5)
			UnbindBtn.Text = "取消绑定 (秒恢复)"
		end)
	end)
end)
makeSectionTitle(P7, "控制修复", "shield")
makeToggle(P7, "修复控制NPC黑屏", false, function(state)
	if state then
		pcall(function()
			local PlayerGuiF = LocalPlayer:WaitForChild("PlayerGui")
			local CameraF = workspace.CurrentCamera
			local SKIP = { "joystick","thumbstick","control","move","mobile","button","touch","pad","input","walk","sprint","jump" }
			local function isSkipped(obj)
				local name = obj.Name:lower()
				for _, k in ipairs(SKIP) do
					if name:find(k) then return true end
				end
				local p = obj.Parent
				while p and p ~= PlayerGuiF do
					local pn = p.Name:lower()
					for _, k in ipairs(SKIP) do
						if pn:find(k) then return true end
					end
					p = p.Parent
				end
				return false
			end
			local function clearLighting()
				for _, v in ipairs(Lighting:GetDescendants()) do
					if v:IsA("ColorCorrectionEffect") or v:IsA("BlurEffect") or v:IsA("DepthOfFieldEffect") or v:IsA("SunRaysEffect") then
						v:Destroy()
					end
				end
				Lighting.Ambient = Color3.fromRGB(140, 140, 140)
				Lighting.OutdoorAmbient = Color3.fromRGB(140, 140, 140)
				Lighting.Brightness = 2
				Lighting.ClockTime = 14
				Lighting.FogEnd = 1e6
				Lighting.FogStart = 0
			end
			local function clearGUI()
				local vp = CameraF.ViewportSize
				for _, obj in ipairs(PlayerGuiF:GetDescendants()) do
					if obj:IsA("GuiObject") and obj.Visible and not isSkipped(obj) then
						local sz = obj.AbsoluteSize
						local fullscreen = sz.X >= vp.X * 0.9 and sz.Y >= vp.Y * 0.9
						if fullscreen then
							if obj.BackgroundTransparency < 1 and obj.BackgroundColor3.R < 0.2 and obj.BackgroundColor3.G < 0.2 and obj.BackgroundColor3.B < 0.2 then
								obj.BackgroundTransparency = 1
							end
							if obj:IsA("ImageLabel") and obj.ImageTransparency < 1 then
								obj.ImageTransparency = 1
							end
						end
					end
				end
			end
			if _G._GusiFixRunning then return end
			_G._GusiFixRunning = true
			clearLighting()
			clearGUI()
			task.spawn(function()
				while _G._GusiFixRunning do
					task.wait(1)
					if not _G._GusiFixRunning then break end
					clearLighting()
					clearGUI()
				end
			end)
			local pending = false
			PlayerGuiF.DescendantAdded:Connect(function()
				if pending then return end
				pending = true
				task.delay(0.15, function()
					pending = false
					if _G._GusiFixRunning then clearGUI() end
				end)
			end)
		end)
		notify("致命猴子", "修复控制NPC黑屏已开启", 3)
	else
		_G._GusiFixRunning = false
		notify("致命猴子", "修复控制NPC黑屏已关闭", 3)
	end
end)
makeSectionTitle(P7, "控制NPC汉化", "users")
makeButton(P7, "控制NPC汉化（搭配BKU使用）", "wind", function()
	pcall(function() loadstring(game:HttpGet("https://pastebin.com/raw/2dU621nr"))() end)
	notify("致命猴子", "控制NPC汉化脚本已执行", 3)
end)

local SettingTab = createTab("UI设置", "settings")
local PUI = SettingTab.Page
makeSectionTitle(PUI, "界面", "shield")
makeToggle(PUI, "固定Ui/最小化方框", false, function(v) Locked = v end)
makeParagraph(PUI, "开启后，主窗口、ER方框和右下角缩放块均被锁定")
makeSectionTitle(PUI, "UI 颜色", "bolt")
makeColorDropdown(PUI, "UI 颜色", {
	{ name = "默认蓝", color = Color3.fromRGB(110, 110, 255) },
	{ name = "红色", color = Color3.fromRGB(255, 80, 100) },
	{ name = "绿色", color = Color3.fromRGB(80, 200, 120) },
	{ name = "紫色", color = Color3.fromRGB(180, 90, 255) },
	{ name = "橙色", color = Color3.fromRGB(255, 150, 60) },
	{ name = "青色", color = Color3.fromRGB(80, 220, 240) },
	{ name = "彩色（动态）", color = Color3.fromRGB(200, 200, 200), rainbow = true },
}, function(entry)
	if entry.rainbow then
		setRainbow(true)
	else
		setRainbow(false)
		applyAccent(entry.color)
	end
end)

MainTab.Button.BackgroundColor3 = Theme.AccentDim
MainTab.Label.TextColor3 = Theme.Text
MainTab.Highlight.Visible = true
MainTab.Page.Visible = true

local function openMain()
	MiniBox.Visible = false
	Main.Visible = true
	Main.Size = UDim2.new(0, 0, 0, 0)
	Main.BackgroundTransparency = 1
	local target = SavedSize
	tween(Main, 0.45, { Size = UDim2.new(0, target.X, 0, target.Y), BackgroundTransparency = 0 }, Enum.EasingStyle.Back)
end

local function minimizeMain()
	local out = tween(Main, 0.3, { Size = UDim2.new(0, 0, 0, 0), BackgroundTransparency = 1 }, Enum.EasingStyle.Quart, Enum.EasingDirection.In)
	out.Completed:Connect(function()
		Main.Visible = false
		MiniBox.Visible = true
		MiniBox.Size = UDim2.new(0, 0, 0, 0)
		tween(MiniBox, 0.35, { Size = UDim2.new(0, 46, 0, 46) }, Enum.EasingStyle.Back)
	end)
end

local function closeUI()
	playSound("rbxassetid://6042053626", 0.5)
	notify("致命猴子", "UI 已关闭，再见！", 3)
	task.delay(1.6, function()
		local out = tween(Main, 0.3, { Size = UDim2.new(0, 0, 0, 0), BackgroundTransparency = 1 }, Enum.EasingStyle.Quart, Enum.EasingDirection.In)
		out.Completed:Connect(function() ScreenGui:Destroy() end)
	end)
end

local function handleMiniBoxClick()
	if not Main.Visible then openMain() end
end

makeDraggable(MiniBox, MiniBox, handleMiniBoxClick)
MinBtn.MouseButton1Click:Connect(minimizeMain)
CloseBtn.MouseButton1Click:Connect(closeUI)

