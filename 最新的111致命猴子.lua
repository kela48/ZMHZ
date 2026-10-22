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
	Bg = Color3.fromRGB(16,16,22),
	Panel = Color3.fromRGB(22,22,30),
	TabBar = Color3.fromRGB(20,20,28),
	Item = Color3.fromRGB(30,30,42),
	ItemHover = Color3.fromRGB(40,40,56),
	Accent = Color3.fromRGB(110,110,255),
	AccentDim = Color3.fromRGB(60,60,130),
	Text = Color3.fromRGB(225,225,245),
	SubText = Color3.fromRGB(150,150,180),
	Stroke = Color3.fromRGB(70,70,160),
	Close = Color3.fromRGB(220,80,110),
	Open = Color3.fromRGB(70,160,110),
}

local TS = TweenService.Create
local T = TweenInfo.new
local UDim2new = UDim2.new
local C3 = Color3.fromRGB
local V3 = Vector3.new

local UI_ID = tostring(math.floor(tick()*1000)%100000000)
local function uid(n) return n.."_"..UI_ID end

local AccentObjects = {}
local Locked = false
local function reg(obj,prop) AccentObjects[#AccentObjects+1] = {obj=obj,prop=prop} end

local function corner(p,r)
	local c = Instance.new("UICorner",p)
	c.CornerRadius = UDim.new(0,r or 6)
	return c
end
local function stroke(p,c,t)
	local s = Instance.new("UIStroke",p)
	s.Color = c or Theme.Stroke
	s.Thickness = t or 1
	s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	return s
end
local function tween(o,tm,p)
	local a = TS(o,T(tm or 0.25),p)
	a:Play()
	return a
end

local function viewport()
	return Camera and Camera.ViewportSize or Vector2.new(1280,720)
end
local function defSize()
	local vp = viewport()
	local w = math.clamp(vp.X*0.92,320,580)
	local h = math.clamp(vp.Y*0.80,240,360)
	return Vector2.new(math.floor(w),math.floor(h))
end
local SavedSize = defSize()

local function draggable(handle,frame,onClick)
	local dragging,startPos,dragStart = false,nil,nil
	local pressPos,pressTime = nil,nil
	handle.InputBegan:Connect(function(i)
		if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then
			pressPos,pressTime = i.Position,tick()
			if Locked then return end
			dragging,startPos,dragStart = true,frame.Position,i.Position
		end
	end)
	handle.InputEnded:Connect(function(i)
		if i.UserInputType~=Enum.UserInputType.MouseButton1 and i.UserInputType~=Enum.UserInputType.Touch then return end
		if pressPos and pressTime and onClick then
			local d = i.Position-pressPos
			if math.sqrt(d.X*d.X+d.Y*d.Y)<=6 and tick()-pressTime<=0.6 then onClick() end
		end
		dragging,pressPos,pressTime = false,nil,nil
	end)
	UserInputService.InputEnded:Connect(function(i)
		if i.UserInputType~=Enum.UserInputType.MouseButton1 and i.UserInputType~=Enum.UserInputType.Touch then return end
		dragging,pressPos,pressTime = false,nil,nil
	end)
	UserInputService.InputChanged:Connect(function(i)
		if dragging and (i.UserInputType==Enum.UserInputType.MouseMovement or i.UserInputType==Enum.UserInputType.Touch) then
			local d = i.Position-dragStart
			frame.Position = UDim2new(startPos.X.Scale,startPos.X.Offset+d.X,startPos.Y.Scale,startPos.Y.Offset+d.Y)
		end
	end)
end

local function resizable(handle,frame,minS,maxS)
	minS = minS or Vector2.new(320,240)
	maxS = maxS or Vector2.new(1200,800)
	local on,startSize,startPos = false,nil,nil
	handle.InputBegan:Connect(function(i)
		if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then
			if Locked then return end
			on,startPos,startSize = true,i.Position,frame.AbsoluteSize
		end
	end)
	UserInputService.InputEnded:Connect(function(i)
		if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then on = false end
	end)
	UserInputService.InputChanged:Connect(function(i)
		if on and (i.UserInputType==Enum.UserInputType.MouseMovement or i.UserInputType==Enum.UserInputType.Touch) then
			local vp = viewport()
			local d = i.Position-startPos
			local w = math.clamp(startSize.X+d.X,minS.X,math.min(maxS.X,vp.X-24))
			local h = math.clamp(startSize.Y+d.Y,minS.Y,math.min(maxS.Y,vp.Y-24))
			frame.Size = UDim2new(0,w,0,h)
			SavedSize = Vector2.new(w,h)
		end
	end)
end

local function hover(b,n,h)
	b.MouseEnter:Connect(function() tween(b,0.15,{BackgroundColor3=h}) end)
	b.MouseLeave:Connect(function() tween(b,0.15,{BackgroundColor3=n}) end)
end

local function playSound(id,v)
	local s = Instance.new("Sound",SoundService)
	s.SoundId,s.Volume = id,v or 0.5
	s:Play()
	task.delay(3,function() s:Destroy() end)
end

local function drawX(p,sz,c,pos)
	local h = Instance.new("Frame",p)
	h.Size,h.Position,h.BackgroundTransparency = UDim2new(0,sz,0,sz),pos or UDim2new(0.5,-sz/2,0.5,-sz/2),1
	local a = Instance.new("Frame",h)
	a.Size,a.Position,a.BackgroundColor3,a.BorderSizePixel,a.Rotation = UDim2new(1,0,0,2),UDim2new(0,0,0.5,-1),c,0,45
	corner(a,1)
	local b = Instance.new("Frame",h)
	b.Size,b.Position,b.BackgroundColor3,b.BorderSizePixel,b.Rotation = UDim2new(1,0,0,2),UDim2new(0,0,0.5,-1),c,0,-45
	corner(b,1)
	return h
end
local function drawMin(p,sz,c,pos)
	local h = Instance.new("Frame",p)
	h.Size,h.Position,h.BackgroundTransparency = UDim2new(0,sz,0,sz),pos or UDim2new(0.5,-sz/2,0.5,-sz/2),1
	local b = Instance.new("Frame",h)
	b.Size,b.Position,b.BackgroundColor3,b.BorderSizePixel = UDim2new(1,-4,0,2),UDim2new(0,2,0.5,-1),c,0
	corner(b,1)
	return h
end
local function drawIcon(p,name,sz,c,pos)
	local h = Instance.new("Frame",p)
	h.Size,h.Position,h.BackgroundTransparency = UDim2new(0,sz or 16,0,sz or 16),pos or UDim2new(0,0,0.5,-(sz or 16)/2),1
	local s,c = sz or 16,c or Theme.Accent
	local function bar(x,y,w,ht,col,rot)
		local f = Instance.new("Frame",h)
		f.Size,f.Position,f.BackgroundColor3,f.BorderSizePixel = UDim2new(0,w,0,ht),UDim2new(0,x,0,y),col or c,0
		if rot then f.Rotation = rot end
		corner(f,math.min(w,ht)/2)
		return f
	end
	if name=="dot" then
		local d = Instance.new("Frame",h)
		d.Size,d.BackgroundColor3,d.BorderSizePixel = UDim2new(0,s,0,s),c,0
		corner(d,s/2)
	elseif name=="home" then
		bar(s/2-1,2,2,s-4,c)
		bar(2,s/2-2,s-4,2,c)
	elseif name=="bolt" or name=="zap" then
		local a = bar(s/2-1,1,3,s/2,c); a.Rotation = 25
		local b = bar(s/2-2,s/2-1,3,s/2,c); b.Rotation = 25
	elseif name=="settings" then
		local d = Instance.new("Frame",h)
		d.Size,d.Position,d.BackgroundTransparency,d.BorderSizePixel = UDim2new(0,s-6,0,s-6),UDim2new(0,3,0,3),1,0
		local ds = Instance.new("UIStroke",d); ds.Color,ds.Thickness = c,2
		corner(d,(s-6)/2)
		local dt = Instance.new("Frame",h)
		dt.Size,dt.Position,dt.BackgroundColor3,dt.BorderSizePixel = UDim2new(0,3,0,3),UDim2new(0,s/2-1.5,0,s/2-1.5),c,0
		corner(dt,2)
	elseif name=="shield" then
		bar(s/2-1,2,2,s-4,c)
		bar(3,s/2-1,s-6,2,c)
	elseif name=="check" then
		local a = bar(2,s/2,s/2-1,2,c); a.Rotation = 45
		local b = bar(s/2-1,s/2-2,s-3,2,c); b.Rotation = -45
	elseif name=="chevron" then
		local a = bar(s/2-1,s/2-2,2,s/2-1,c); a.Rotation = 45
		local b = bar(s/2-2,s/2-1,2,s/2-1,c); b.Rotation = -45
	elseif name=="arrowRight" then
		bar(3,s/2-1,s-6,2,c)
		local a = bar(s-6,s/2-3,2,4,c); a.Rotation = 45
		local b = bar(s-6,s/2-1,2,4,c); b.Rotation = -45
	elseif name=="palette" then
		bar(2,2,4,4,c)
		bar(s-6,2,4,4,C3(255,100,100))
		bar(2,s-6,4,4,C3(100,255,100))
	elseif name=="user" or name=="users" then
		local hd = Instance.new("Frame",h)
		hd.Size,hd.Position,hd.BackgroundColor3,hd.BorderSizePixel = UDim2new(0,6,0,6),UDim2new(0,s/2-3,0,2),c,0
		corner(hd,3)
		bar(3,s-5,s-6,3,c)
	elseif name=="wind" then
		bar(2,4,s-6,2,c)
		bar(4,s/2,s-6,2,c)
		bar(2,s-6,s-8,2,c)
	end
	return h
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = uid("ERHub")
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.DisplayOrder = 999999
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local MiniBox = Instance.new("TextButton")
MiniBox.Name = uid("MiniBox")
MiniBox.Size = UDim2new(0,46,0,46)
MiniBox.Position = UDim2new(1,-62,0.5,-23)
MiniBox.BackgroundColor3 = Theme.Panel
MiniBox.Text = ""
MiniBox.AutoButtonColor = false
MiniBox.Visible = true
MiniBox.Active = true
MiniBox.Parent = ScreenGui
corner(MiniBox,10)
local miniStroke = stroke(MiniBox,Theme.Accent,1.5)
hover(MiniBox,Theme.Panel,Theme.ItemHover)

local MiniER = Instance.new("TextLabel",MiniBox)
MiniER.Size = UDim2new(1,0,1,0)
MiniER.BackgroundTransparency = 1
MiniER.Text = "ER"
MiniER.TextColor3 = Theme.Accent
MiniER.Font = Enum.Font.GothamBold
MiniER.TextSize = 20
reg(MiniER,"TextColor3")

local Main = Instance.new("Frame")
Main.Name = uid("Main")
Main.AnchorPoint = Vector2.new(0.5,0.5)
Main.Size = UDim2new(0,0,0,0)
Main.Position = UDim2new(0.5,0,0.5,0)
Main.BackgroundColor3 = Theme.Bg
Main.Visible = false
Main.ClipsDescendants = true
Main.Parent = ScreenGui
corner(Main,12)
local mainStroke = stroke(Main,Theme.Accent,1.5)

local TopBar = Instance.new("Frame")
TopBar.Size = UDim2new(1,0,0,52)
TopBar.BackgroundColor3 = Theme.TabBar
TopBar.Parent = Main
corner(TopBar,12)

local TitleDot = Instance.new("Frame")
TitleDot.Size,TitleDot.Position,TitleDot.BackgroundColor3 = UDim2new(0,8,0,8),UDim2new(0,20,0,12),Theme.Accent
TitleDot.Parent = TopBar
corner(TitleDot,4)
reg(TitleDot,"BackgroundColor3")

local Title = Instance.new("TextLabel")
Title.Size,Title.Position = UDim2new(1,-120,0,18),UDim2new(0,40,0,8)
Title.BackgroundTransparency = 1
Title.Text = "ER致命猴子"
Title.TextColor3 = Theme.Text
Title.Font = Enum.Font.GothamBold
Title.TextSize = 16
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = TopBar

local SubTitle = Instance.new("TextLabel")
SubTitle.Size,SubTitle.Position = UDim2new(1,-120,0,14),UDim2new(0,40,0,28)
SubTitle.BackgroundTransparency = 1
SubTitle.Text = "by kela_er"
SubTitle.TextColor3 = Theme.SubText
SubTitle.Font = Enum.Font.Gotham
SubTitle.TextSize = 11
SubTitle.TextXAlignment = Enum.TextXAlignment.Left
SubTitle.Parent = TopBar

local BtnRow = Instance.new("Frame")
BtnRow.Size,BtnRow.Position,BtnRow.BackgroundTransparency = UDim2new(0,68,0,28),UDim2new(1,-76,0,12),1
BtnRow.Parent = TopBar
local BRL = Instance.new("UIListLayout",BtnRow)
BRL.FillDirection = Enum.FillDirection.Horizontal
BRL.HorizontalAlignment = Enum.HorizontalAlignment.Right
BRL.VerticalAlignment = Enum.VerticalAlignment.Center
BRL.Padding = UDim.new(0,6)

local MinBtn = Instance.new("TextButton")
MinBtn.Size,MinBtn.BackgroundColor3,MinBtn.Text,MinBtn.AutoButtonColor = UDim2new(0,28,0,28),Theme.Item,"",false
MinBtn.LayoutOrder = 1
MinBtn.Parent = BtnRow
corner(MinBtn,8)
stroke(MinBtn,Theme.Accent,1.2)
hover(MinBtn,Theme.Item,Theme.AccentDim)
drawMin(MinBtn,14,Theme.SubText)

local CloseBtn = Instance.new("TextButton")
CloseBtn.Size,CloseBtn.BackgroundColor3,CloseBtn.Text,CloseBtn.AutoButtonColor = UDim2new(0,28,0,28),Theme.Item,"",false
CloseBtn.LayoutOrder = 2
CloseBtn.Parent = BtnRow
corner(CloseBtn,8)
stroke(CloseBtn,Theme.Close,1.2)
hover(CloseBtn,Theme.Item,C3(70,30,45))
drawX(CloseBtn,12,Theme.Close)

draggable(TopBar,Main)

local TabBar = Instance.new("ScrollingFrame")
TabBar.Size = UDim2new(0,148,1,-62)
TabBar.Position = UDim2new(0,8,0,58)
TabBar.BackgroundColor3 = Theme.TabBar
TabBar.ScrollBarThickness = 4
TabBar.ScrollBarImageColor3 = Theme.Accent
TabBar.CanvasSize = UDim2new(0,0,0,0)
TabBar.AutomaticCanvasSize = Enum.AutomaticSize.Y
TabBar.ScrollingDirection = Enum.ScrollingDirection.Y
TabBar.ScrollingEnabled = true
TabBar.ElasticBehavior = Enum.ElasticBehavior.WhenScrollable
TabBar.BorderSizePixel = 0
TabBar.Parent = Main
corner(TabBar,10)
stroke(TabBar,Theme.Stroke,1)
local TabList = Instance.new("UIListLayout",TabBar)
TabList.Padding = UDim.new(0,6)
TabList.HorizontalAlignment = Enum.HorizontalAlignment.Center
local TabPad = Instance.new("UIPadding",TabBar)
TabPad.PaddingTop = UDim.new(0,8)
TabPad.PaddingBottom = UDim.new(0,8)

local Content = Instance.new("Frame")
Content.Size = UDim2new(1,-172,1,-62)
Content.Position = UDim2new(0,164,0,58)
Content.BackgroundColor3 = Theme.Panel
Content.Parent = Main
corner(Content,10)
stroke(Content,Theme.Stroke,1)

local ResizeHandle = Instance.new("TextButton")
ResizeHandle.Size,ResizeHandle.Position = UDim2new(0,18,0,18),UDim2new(1,-20,1,-20)
ResizeHandle.BackgroundTransparency = 1
ResizeHandle.Text = ""
ResizeHandle.AutoButtonColor = false
ResizeHandle.ZIndex = 5
ResizeHandle.Parent = Main
local resizeLines = {}
for i=1,3 do
	local line = Instance.new("Frame",ResizeHandle)
	line.Size,line.Position = UDim2new(0,2,0,3+i*2),UDim2new(0,12-i*3,0,14-i*3)
	line.AnchorPoint = Vector2.new(1,1)
	line.BackgroundColor3 = Theme.SubText
	line.BorderSizePixel = 0
	line.Rotation = 45
	corner(line,1)
	reg(line,"BackgroundColor3")
	resizeLines[i] = line
end
ResizeHandle.MouseEnter:Connect(function()
	for _,l in ipairs(resizeLines) do tween(l,0.15,{BackgroundColor3=Theme.Accent}) end
end)
ResizeHandle.MouseLeave:Connect(function()
	for _,l in ipairs(resizeLines) do tween(l,0.15,{BackgroundColor3=Theme.SubText}) end
end)
resizable(ResizeHandle,Main,Vector2.new(320,240),Vector2.new(1200,800))

local ContentScroll = Instance.new("ScrollingFrame",Content)
ContentScroll.Size = UDim2new(1,-16,1,-16)
ContentScroll.Position = UDim2new(0,8,0,8)
ContentScroll.BackgroundTransparency = 1
ContentScroll.BorderSizePixel = 0
ContentScroll.ScrollBarThickness = 3
ContentScroll.ScrollBarImageColor3 = Theme.Accent
ContentScroll.CanvasSize = UDim2new(0,0,0,0)
ContentScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
local ContentList = Instance.new("UIListLayout",ContentScroll)
ContentList.Padding = UDim.new(0,8)

local function sectionTitle(p,text,iconName)
	local row = Instance.new("Frame",p)
	row.Size,row.BackgroundTransparency = UDim2new(1,0,0,22),1
	if iconName then
		local icon = drawIcon(row,iconName,14,Theme.Accent,UDim2new(0,0,0.5,-7))
		for _,f in ipairs(icon:GetChildren()) do
			if f:IsA("Frame") then reg(f,"BackgroundColor3")
			elseif f:IsA("UIStroke") then reg(f,"Color") end
		end
	end
	local lbl = Instance.new("TextLabel",row)
	lbl.Size = UDim2new(1,iconName and -20 or 0,1,0)
	lbl.Position = UDim2new(0,iconName and 20 or 0,0,0)
	lbl.BackgroundTransparency = 1
	lbl.Text = text
	lbl.TextColor3 = Theme.Accent
	lbl.Font = Enum.Font.GothamBold
	lbl.TextSize = 13
	lbl.TextXAlignment = Enum.TextXAlignment.Left
	reg(lbl,"TextColor3")
	return row
end

local function paragraph(p,text)
	local row = Instance.new("Frame",p)
	row.Size,row.BackgroundColor3 = UDim2new(1,0,0,46),Theme.Item
	corner(row,8)
	local lbl = Instance.new("TextLabel",row)
	lbl.Size,lbl.Position = UDim2new(1,-20,1,0),UDim2new(0,10,0,0)
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

local function toggle(p,text,default,cb)
	local row = Instance.new("Frame",p)
	row.Size,row.BackgroundColor3 = UDim2new(1,0,0,34),Theme.Item
	corner(row,8)
	local lbl = Instance.new("TextLabel",row)
	lbl.Size,lbl.Position = UDim2new(1,-70,1,0),UDim2new(0,12,0,0)
	lbl.BackgroundTransparency = 1
	lbl.Text,lbl.TextColor3,lbl.Font,lbl.TextSize = text,Theme.Text,Enum.Font.Gotham,13
	lbl.TextXAlignment = Enum.TextXAlignment.Left
	local track = Instance.new("Frame",row)
	track.Size,track.Position,track.BackgroundColor3 = UDim2new(0,40,0,20),UDim2new(1,-50,0.5,-10),default and Theme.Open or C3(50,50,70)
	corner(track,10)
	local knob = Instance.new("Frame",track)
	knob.Size = UDim2new(0,16,0,16)
	knob.Position = default and UDim2new(1,-18,0.5,-8) or UDim2new(0,2,0.5,-8)
	knob.BackgroundColor3 = Color3.new(1,1,1)
	corner(knob,8)
	local btn = Instance.new("TextButton",row)
	btn.Size,btn.BackgroundTransparency,btn.Text = UDim2new(1,0,1,0),1,""
	local st = default
	btn.MouseButton1Click:Connect(function()
		st = not st
		TS(track,T(0.2),{BackgroundColor3=st and Theme.Open or C3(50,50,70)}):Play()
		TS(knob,T(0.2),{Position=st and UDim2new(1,-18,0.5,-8) or UDim2new(0,2,0.5,-8)}):Play()
		cb(st)
	end)
	return row
end

local function slider(p,text,min,max,default,cb)
	local row = Instance.new("Frame",p)
	row.Size,row.BackgroundColor3 = UDim2new(1,0,0,50),Theme.Item
	corner(row,8)
	local lbl = Instance.new("TextLabel",row)
	lbl.Size,lbl.Position = UDim2new(1,-20,0,20),UDim2new(0,12,0,6)
	lbl.BackgroundTransparency = 1
	lbl.Text = text.." "..tostring(default)
	lbl.TextColor3 = Theme.Text
	lbl.Font,lbl.TextSize = Enum.Font.Gotham,13
	lbl.TextXAlignment = Enum.TextXAlignment.Left
	local track = Instance.new("Frame",row)
	track.Size,track.Position,track.BackgroundColor3 = UDim2new(1,-24,0,6),UDim2new(0,12,0,34),C3(50,50,70)
	corner(track,3)
	local fill = Instance.new("Frame",track)
	fill.Size,fill.BackgroundColor3 = UDim2new((default-min)/(max-min),0,1,0),Theme.Accent
	corner(fill,3)
	reg(fill,"BackgroundColor3")
	local knob = Instance.new("TextButton",track)
	knob.Size,knob.Position,knob.BackgroundColor3,knob.Text = UDim2new(0,14,0,14),UDim2new((default-min)/(max-min),-7,0.5,-7),Color3.new(1,1,1),""
	corner(knob,7)
	local ks = stroke(knob,Theme.Accent,1.5)
	reg(ks,"Color")
	local dragging = false
	local function update(i)
		local a = math.clamp((i.Position.X-track.AbsolutePosition.X)/track.AbsoluteSize.X,0,1)
		local v = math.floor(min+a*(max-min)+0.5)
		knob.Position = UDim2new(a,-7,0.5,-7)
		fill.Size = UDim2new(a,0,1,0)
		lbl.Text = text.." "..tostring(v)
		cb(v)
	end
	knob.InputBegan:Connect(function(i)
		if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then
			dragging = true
			tween(knob,0.12,{Size=UDim2new(0,18,0,18)})
		end
	end)
	UserInputService.InputEnded:Connect(function(i)
		if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then
			dragging = false
			tween(knob,0.12,{Size=UDim2new(0,14,0,14)})
		end
	end)
	UserInputService.InputChanged:Connect(function(i)
		if dragging and (i.UserInputType==Enum.UserInputType.MouseMovement or i.UserInputType==Enum.UserInputType.Touch) then update(i) end
	end)
end

local function button(p,text,iconName,cb)
	local btn = Instance.new("TextButton",p)
	btn.Size,btn.BackgroundColor3,btn.Text,btn.AutoButtonColor = UDim2new(1,0,0,34),Theme.Item,"",false
	corner(btn,8)
	stroke(btn,Theme.Stroke,1)
	if iconName then drawIcon(btn,iconName,14,Theme.Accent,UDim2new(0,12,0.5,-7)) end
	local lbl = Instance.new("TextLabel",btn)
	lbl.Size,lbl.Position = UDim2new(1,-50,1,0),UDim2new(0,iconName and 36 or 14,0,0)
	lbl.BackgroundTransparency = 1
	lbl.Text,lbl.TextColor3,lbl.Font,lbl.TextSize = text,Theme.Text,Enum.Font.Gotham,13
	lbl.TextXAlignment = Enum.TextXAlignment.Left
	hover(btn,Theme.Item,Theme.ItemHover)
	btn.MouseButton1Click:Connect(function()
		tween(btn,0.1,{BackgroundColor3=Theme.AccentDim})
		task.delay(0.12,function() tween(btn,0.2,{BackgroundColor3=Theme.Item}) end)
		cb()
	end)
end

local function dropdown(p,text,opts,default,cb)
	local wrap = Instance.new("Frame",p)
	wrap.Size,wrap.BackgroundTransparency,wrap.ClipsDescendants = UDim2new(1,0,0,34),1,false
	local row = Instance.new("Frame",wrap)
	row.Size,row.BackgroundColor3,row.ZIndex = UDim2new(1,0,0,34),Theme.Item,2
	corner(row,8)
	local btn = Instance.new("TextButton",row)
	btn.Size,btn.BackgroundTransparency,btn.Text,btn.AutoButtonColor = UDim2new(1,0,1,0),1,"",false
	local lbl = Instance.new("TextLabel",btn)
	lbl.Size,lbl.Position = UDim2new(1,-50,1,0),UDim2new(0,14,0,0)
	lbl.BackgroundTransparency = 1
	lbl.Text,lbl.TextColor3,lbl.Font,lbl.TextSize = default or opts[1],Theme.Text,Enum.Font.Gotham,13
	lbl.TextXAlignment = Enum.TextXAlignment.Left
	local arrow = drawIcon(btn,"arrowRight",12,Theme.SubText,UDim2new(1,-26,0.5,-6))
	arrow.Rotation = 90
	local list = Instance.new("Frame",wrap)
	list.Size,list.Position,list.BackgroundColor3,list.Visible,list.ClipsDescendants,list.ZIndex = UDim2new(1,0,0,0),UDim2new(0,0,0,38),Theme.Panel,false,true,1
	corner(list,8)
	stroke(list,Theme.Stroke,1)
	local lay = Instance.new("UIListLayout",list)
	lay.Padding = UDim.new(0,2)
	local open = false
	local h = #opts*28+8
	for _,o in ipairs(opts) do
		local it = Instance.new("TextButton",list)
		it.Size,it.Position,it.BackgroundColor3,it.Text,it.TextColor3,it.Font,it.TextSize,it.AutoButtonColor = UDim2new(1,-8,0,26),UDim2new(0,4,0,0),Theme.Item,o,Theme.Text,Enum.Font.Gotham,13,false
		corner(it,6)
		hover(it,Theme.Item,Theme.ItemHover)
		it.MouseButton1Click:Connect(function()
			lbl.Text = o
			if open then
				open = false
				TS(list,T(0.2),{Size=UDim2new(1,0,0,0)}):Play()
				tween(arrow,0.25,{Rotation=90})
				tween(wrap,0.25,{Size=UDim2new(1,0,0,34)})
				task.delay(0.2,function() list.Visible = false end)
			end
			cb(o)
		end)
	end
	btn.MouseButton1Click:Connect(function()
		open = not open
		if open then
			list.Visible = true
			list.Size = UDim2new(1,0,0,0)
			TS(list,T(0.25),{Size=UDim2new(1,0,0,h)}):Play()
			tween(arrow,0.25,{Rotation=270})
			tween(wrap,0.25,{Size=UDim2new(1,0,0,34+h+4)})
		else
			TS(list,T(0.2),{Size=UDim2new(1,0,0,0)}):Play()
			tween(arrow,0.25,{Rotation=90})
			tween(wrap,0.25,{Size=UDim2new(1,0,0,34)})
			task.delay(0.2,function() list.Visible = false end)
		end
	end)
end

local function colorDropdown(p,text,colors,cb)
	local wrap = Instance.new("Frame",p)
	wrap.Size,wrap.BackgroundTransparency,wrap.ClipsDescendants = UDim2new(1,0,0,34),1,false
	local row = Instance.new("Frame",wrap)
	row.Size,row.BackgroundColor3,row.ZIndex = UDim2new(1,0,0,34),Theme.Item,2
	corner(row,8)
	local btn = Instance.new("TextButton",row)
	btn.Size,btn.BackgroundTransparency,btn.Text,btn.AutoButtonColor = UDim2new(1,0,1,0),1,"",false
	local swatch = Instance.new("Frame",btn)
	swatch.Size,swatch.Position,swatch.BackgroundColor3 = UDim2new(0,14,0,14),UDim2new(0,12,0.5,-7),colors[1].color
	corner(swatch,4)
	stroke(swatch,Color3.new(1,1,1),1)
	local lbl = Instance.new("TextLabel",btn)
	lbl.Size,lbl.Position = UDim2new(1,-80,1,0),UDim2new(0,36,0,0)
	lbl.BackgroundTransparency = 1
	lbl.Text,lbl.TextColor3,lbl.Font,lbl.TextSize = colors[1].name,Theme.Text,Enum.Font.Gotham,13
	lbl.TextXAlignment = Enum.TextXAlignment.Left
	local arrow = drawIcon(btn,"arrowRight",12,Theme.SubText,UDim2new(1,-26,0.5,-6))
	arrow.Rotation = 90
	local list = Instance.new("Frame",wrap)
	list.Size,list.Position,list.BackgroundColor3,list.Visible,list.ClipsDescendants,list.ZIndex = UDim2new(1,0,0,0),UDim2new(0,0,0,38),Theme.Panel,false,true,1
	corner(list,8)
	stroke(list,Theme.Stroke,1)
	local lay = Instance.new("UIListLayout",list)
	lay.Padding = UDim.new(0,2)
	local open = false
	local h = #colors*28+8
	for _,entry in ipairs(colors) do
		local it = Instance.new("TextButton",list)
		it.Size,it.Position,it.BackgroundColor3,it.Text,it.AutoButtonColor = UDim2new(1,-8,0,26),UDim2new(0,4,0,0),Theme.Item,"",false
		corner(it,6)
		hover(it,Theme.Item,Theme.ItemHover)
		local isw = Instance.new("Frame",it)
		isw.Size,isw.Position,isw.BackgroundColor3 = UDim2new(0,12,0,12),UDim2new(0,8,0.5,-6),entry.color
		corner(isw,3)
		stroke(isw,Color3.new(1,1,1),1)
		if entry.rainbow then
			local g = Instance.new("UIGradient",isw)
			g.Color = ColorSequence.new({
				ColorSequenceKeypoint.new(0,C3(255,0,0)),
				ColorSequenceKeypoint.new(0.2,C3(255,200,0)),
				ColorSequenceKeypoint.new(0.4,C3(0,255,100)),
				ColorSequenceKeypoint.new(0.6,C3(0,200,255)),
				ColorSequenceKeypoint.new(0.8,C3(150,0,255)),
				ColorSequenceKeypoint.new(1,C3(255,0,0)),
			})
		end
		local il = Instance.new("TextLabel",it)
		il.Size,il.Position = UDim2new(1,-40,1,0),UDim2new(0,30,0,0)
		il.BackgroundTransparency = 1
		il.Text,il.TextColor3,il.Font,il.TextSize = entry.name,Theme.Text,Enum.Font.Gotham,13
		il.TextXAlignment = Enum.TextXAlignment.Left
		it.MouseButton1Click:Connect(function()
			lbl.Text = entry.name
			if entry.rainbow then
				swatch.BackgroundColor3 = C3(180,180,180)
			else
				swatch.BackgroundColor3 = entry.color
			end
			if open then
				open = false
				TS(list,T(0.2),{Size=UDim2new(1,0,0,0)}):Play()
				tween(arrow,0.25,{Rotation=90})
				tween(wrap,0.25,{Size=UDim2new(1,0,0,34)})
				task.delay(0.2,function() list.Visible = false end)
			end
			cb(entry)
		end)
	end
	btn.MouseButton1Click:Connect(function()
		open = not open
		if open then
			list.Visible = true
			list.Size = UDim2new(1,0,0,0)
			TS(list,T(0.25),{Size=UDim2new(1,0,0,h)}):Play()
			tween(arrow,0.25,{Rotation=270})
			tween(wrap,0.25,{Size=UDim2new(1,0,0,34+h+4)})
		else
			TS(list,T(0.2),{Size=UDim2new(1,0,0,0)}):Play()
			tween(arrow,0.25,{Rotation=90})
			tween(wrap,0.25,{Size=UDim2new(1,0,0,34)})
			task.delay(0.2,function() list.Visible = false end)
		end
	end)
end

local NotifyHolder = Instance.new("Frame",ScreenGui)
NotifyHolder.Name = uid("NotifyHolder")
NotifyHolder.AnchorPoint = Vector2.new(1,0)
NotifyHolder.Position = UDim2new(1,-16,0,16)
NotifyHolder.Size = UDim2new(0,250,0,0)
NotifyHolder.BackgroundTransparency = 1
NotifyHolder.ZIndex = 10
local NotifyLayout = Instance.new("UIListLayout",NotifyHolder)
NotifyLayout.SortOrder = Enum.SortOrder.LayoutOrder
NotifyLayout.Padding = UDim.new(0,8)
NotifyLayout.VerticalAlignment = Enum.VerticalAlignment.Top

local notifyCount = 0
local function notify(title,content,duration)
	if notifyCount >= 6 then return end
	notifyCount = notifyCount + 1
	local note = Instance.new("Frame",NotifyHolder)
	note.Size = UDim2new(1,0,0,68)
	note.Position = UDim2new(1,300,0,0)
	note.BackgroundColor3 = Theme.Panel
	note.ZIndex = 10
	note.LayoutOrder = -math.floor(tick()*1000)
	corner(note,10)
	stroke(note,Theme.Accent,1.5)
	local bar = Instance.new("Frame",note)
	bar.Size,bar.Position,bar.BackgroundColor3 = UDim2new(0,3,1,-16),UDim2new(0,8,0,8),Theme.Accent
	corner(bar,2)
	local tt = Instance.new("TextLabel",note)
	tt.Size,tt.Position = UDim2new(1,-60,0,22),UDim2new(0,20,0,8)
	tt.BackgroundTransparency = 1
	tt.Text,tt.TextColor3,tt.Font,tt.TextSize = title,Theme.Text,Enum.Font.GothamBold,14
	tt.TextXAlignment = Enum.TextXAlignment.Left
	local cc = Instance.new("TextLabel",note)
	cc.Size,cc.Position = UDim2new(1,-30,0,28),UDim2new(0,20,0,30)
	cc.BackgroundTransparency = 1
	cc.Text,cc.TextColor3,cc.Font,cc.TextSize,cc.TextWrapped = content,Theme.SubText,Enum.Font.Gotham,12,true
	cc.TextXAlignment = Enum.TextXAlignment.Left
	local xn = Instance.new("TextButton",note)
	xn.Size,xn.Position,xn.BackgroundColor3,xn.Text,xn.AutoButtonColor = UDim2new(0,22,0,22),UDim2new(1,-30,0,8),Theme.Item,"",false
	corner(xn,5)
	stroke(xn,Theme.Close,1)
	hover(xn,Theme.Item,C3(60,30,40))
	drawX(xn,10,Theme.Close)
	TS(note,T(0.3),{Position=UDim2new(0,0,0,0)}):Play()
	local closed = false
	local function shut()
		if closed then return end
		closed = true
		notifyCount = math.max(0,notifyCount-1)
		TS(note,T(0.25),{Position=UDim2new(1,300,0,0)}):Play()
		task.delay(0.25,function() if note then note:Destroy() end end)
	end
	xn.MouseButton1Click:Connect(shut)
	task.delay(duration or 3,shut)
end

local Tabs = {}
local function createTab(name,iconName)
	local btn = Instance.new("TextButton",TabBar)
	btn.Size,btn.BackgroundColor3,btn.Text,btn.AutoButtonColor = UDim2new(0.9,0,0,34),Theme.Item,"",false
	corner(btn,8)
	local hl = Instance.new("Frame",btn)
	hl.Size,hl.Position,hl.AnchorPoint,hl.BackgroundColor3,hl.Visible = UDim2new(0,3,0.6,0),UDim2new(0,0,0.5,0),Vector2.new(0,0.5),Theme.Accent,false
	corner(hl,2)
	reg(hl,"BackgroundColor3")
	if iconName then
		local icon = drawIcon(btn,iconName,14,Theme.Accent,UDim2new(0,12,0.5,-7))
		for _,f in ipairs(icon:GetChildren()) do
			if f:IsA("Frame") then reg(f,"BackgroundColor3")
			elseif f:IsA("UIStroke") then reg(f,"Color") end
		end
	end
	local lbl = Instance.new("TextLabel",btn)
	lbl.Size,lbl.Position = UDim2new(1,-40,1,0),UDim2new(0,36,0,0)
	lbl.BackgroundTransparency = 1
	lbl.Text,lbl.TextColor3,lbl.Font,lbl.TextSize = name,Theme.SubText,Enum.Font.GothamBold,13
	lbl.TextXAlignment = Enum.TextXAlignment.Left
	local page = Instance.new("Frame",ContentScroll)
	page.Size,page.BackgroundTransparency,page.Visible = UDim2new(1,0,0,0),1,false
	page.AutomaticSize = Enum.AutomaticSize.Y
	local lay = Instance.new("UIListLayout",page)
	lay.Padding = UDim.new(0,8)
	local tab = {Button=btn,Page=page,Label=lbl,Highlight=hl}
	hover(btn,Theme.Item,Theme.ItemHover)
	btn.MouseButton1Click:Connect(function()
		for _,o in pairs(Tabs) do
			tween(o.Button,0.2,{BackgroundColor3=Theme.Item})
			tween(o.Label,0.2,{TextColor3=Theme.SubText})
			o.Page.Visible = false
			o.Highlight.Visible = false
		end
		tween(btn,0.2,{BackgroundColor3=Theme.AccentDim})
		tween(lbl,0.2,{TextColor3=Theme.Text})
		hl.Visible = true
		page.Visible = true
	end)
	Tabs[name] = tab
	return tab
end

local function applyAccent(c)
	Theme.Accent = c
	Theme.AccentDim = Color3.new(c.R*0.55,c.G*0.55,c.B*0.55)
	Theme.Stroke = Color3.new(c.R*0.65,c.G*0.65,c.B*0.65)
	for _,e in ipairs(AccentObjects) do
		if e.obj and e.obj.Parent then tween(e.obj,0.25,{[e.prop]=c}) end
	end
	tween(mainStroke,0.25,{Color=c})
	tween(miniStroke,0.25,{Color=c})
end

local AUTHOR_NAME = "kela_er1"
local monsterConfig = {
	{name="Gus",parentPath="GusMonster",childName="Gus"},
	{name="Kus",parentPath="KusMonster",childName="Kus"},
	{name="Scar",parentPath="Sandman/Ashy",childName="Scar"},
	{name="SandMan",parentPath="Sandman/Ashy",childName="SandMan"},
	{name="Lurker",parentPath="Sandman/Ashy",childName="Lurker"},
	{name="BloodMan",parentPath="BloodmanMonster",childName="BloodMan"},
	{name="Ashy",parentPath="Sandman/Ashy",childName="Ashy"},
	{name="Lost",parentPath="LostMonster",childName="Lost"},
	{name="Dus",parentPath="DusMonster",childName="Dus"},
}
local espSettings = {
	enabled=false,highlightEnabled=true,nameEnabled=true,distanceEnabled=true,healthEnabled=false,
	maxDistance=500,highlightColor=C3(255,0,0),outlineColor=Color3.new(1,1,1),
	nameColor=Color3.new(1,1,1),distanceColor=C3(255,235,59),textSize=14,fillTransparency=0.5,
}
local monsterToggles = {}
for _,m in ipairs(monsterConfig) do monsterToggles[m.name] = true end

local function resolveParent(path)
	local ok,obj = pcall(function() return Workspace:FindFirstChild(path,true) end)
	if ok and obj then return obj end
	if path:find("/") then
		local cur = Workspace
		for _,part in ipairs(string.split(path,"/")) do
			cur = cur:FindFirstChild(part,true)
			if not cur then return nil end
		end
		return cur
	end
	return nil
end
local function getMonsterModel(m)
	local p = resolveParent(m.parentPath)
	if not p then return nil end
	return p:FindFirstChild(m.childName,true)
end
local function getMonsterPart(model)
	if not model or not model:IsA("Model") then return nil end
	return model:FindFirstChild("HumanoidRootPart") or model:FindFirstChild("Head") or model.PrimaryPart
end
local function getMonsterHum(model)
	if not model then return nil end
	return model:FindFirstChildOfClass("Humanoid") or model:FindFirstChild("Humanoid")
end

local espObjects = {}
local espMissing = {}
local function clearMonsterESP(name)
	local c = espObjects[name]
	if c then
		if c.highlight and c.highlight.Parent then c.highlight:Destroy() end
		if c.billboard and c.billboard.Parent then c.billboard:Destroy() end
		espObjects[name] = nil
	end
end
local function clearAllESP()
	for n in pairs(espObjects) do clearMonsterESP(n) end
	espMissing = {}
end
local function createHighlight(model,name)
	local hl = Instance.new("Highlight")
	hl.Name = "ESPHighlight_"..name
	hl.Adornee = model
	hl.FillColor = espSettings.highlightColor
	hl.OutlineColor = espSettings.outlineColor
	hl.FillTransparency = espSettings.fillTransparency
	hl.OutlineTransparency = 0
	hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
	hl.Parent = model
	return hl
end
local function createBillboard(model,name)
	local head = model:FindFirstChild("Head") or getMonsterPart(model)
	if not head then return nil,nil end
	local bb = Instance.new("BillboardGui")
	bb.Name = "ESPBoard_"..name
	bb.Adornee = head
	bb.Size = UDim2new(0,200,0,60)
	bb.StudsOffset = V3(0,3,0)
	bb.AlwaysOnTop = true
	bb.LightInfluence = 0
	bb.MaxDistance = espSettings.maxDistance*10
	bb.Parent = head
	local nl = Instance.new("TextLabel")
	nl.Size,nl.BackgroundTransparency = UDim2new(1,0,0,22),1
	nl.Text,nl.TextColor3,nl.TextStrokeColor3,nl.TextStrokeTransparency,nl.Font,nl.TextSize,nl.Visible = name,espSettings.nameColor,Color3.new(0,0,0),0,Enum.Font.GothamBold,espSettings.textSize,espSettings.nameEnabled
	nl.Parent = bb
	local dl = Instance.new("TextLabel")
	dl.Size,dl.Position,dl.BackgroundTransparency = UDim2new(1,0,0,18),UDim2new(0,0,0,22),1
	dl.Text,dl.TextColor3,dl.TextStrokeColor3,dl.TextStrokeTransparency,dl.Font,dl.TextSize,dl.Visible = "0m",espSettings.distanceColor,Color3.new(0,0,0),0,Enum.Font.GothamSemibold,espSettings.textSize-2,espSettings.distanceEnabled
	dl.Parent = bb
	local hpl = Instance.new("TextLabel")
	hpl.Size,hpl.Position,hpl.BackgroundTransparency = UDim2new(1,0,0,18),UDim2new(0,0,0,40),1
	hpl.Text,hpl.TextColor3,hpl.TextStrokeColor3,hpl.TextStrokeTransparency,hpl.Font,hpl.TextSize,hpl.Visible = "",C3(0,255,0),Color3.new(0,0,0),0,Enum.Font.GothamSemibold,espSettings.textSize-2,espSettings.healthEnabled
	hpl.Parent = bb
	return bb,{nameLabel=nl,distLabel=dl,healthLabel=hpl}
end
local function updateMonsterESP(m)
	local name = m.name
	if not espSettings.enabled or not monsterToggles[name] then
		clearMonsterESP(name)
		espMissing[name] = nil
		return
	end
	local model = getMonsterModel(m)
	if not model then
		if not espMissing[name] then espMissing[name] = tick() end
		if tick()-espMissing[name] > 1.5 then clearMonsterESP(name) end
		return
	end
	espMissing[name] = nil
	local part = getMonsterPart(model)
	if not part then
		if not espMissing[name] then espMissing[name] = tick() end
		if tick()-espMissing[name] > 1.5 then clearMonsterESP(name) end
		return
	end
	local dist = (Camera.CFrame.Position-part.Position).Magnitude
	if dist>espSettings.maxDistance then
		clearMonsterESP(name)
		return
	end
	local c = espObjects[name]
	if not c then c = {} espObjects[name] = c end
	if espSettings.highlightEnabled then
		if not c.highlight or not c.highlight.Parent then
			c.highlight = createHighlight(model,name)
		else
			c.highlight.FillColor = espSettings.highlightColor
			c.highlight.OutlineColor = espSettings.outlineColor
			c.highlight.FillTransparency = espSettings.fillTransparency
		end
	elseif c.highlight then
		c.highlight:Destroy()
		c.highlight = nil
	end
	if espSettings.nameEnabled or espSettings.distanceEnabled or espSettings.healthEnabled then
		if not c.billboard or not c.billboard.Parent then
			c.billboard,c.labels = createBillboard(model,name)
		end
		if c.labels then
			local nl,dl,hpl = c.labels.nameLabel,c.labels.distLabel,c.labels.healthLabel
			if nl then nl.Text=name nl.TextColor3=espSettings.nameColor nl.TextSize=espSettings.textSize nl.Visible=espSettings.nameEnabled end
			if dl then dl.Text=string.format("%.0f m",dist) dl.TextColor3=espSettings.distanceColor dl.Visible=espSettings.distanceEnabled end
			if hpl then
				if espSettings.healthEnabled then
					local hum = getMonsterHum(model)
					if hum and hum.Health>0 then
						hpl.Text = string.format("HP: %.0f / %.0f",hum.Health,hum.MaxHealth)
						local p = hum.Health/hum.MaxHealth
						hpl.TextColor3 = p>0.5 and C3(0,255,0) or (p>0.25 and C3(255,255,0) or C3(255,0,0))
					else
						hpl.Text = ""
					end
				end
				hpl.Visible = espSettings.healthEnabled
			end
		end
	elseif c.billboard then
		c.billboard:Destroy()
		c.billboard = nil
		c.labels = nil
	end
end
local function updateAllESP()
	for _,m in ipairs(monsterConfig) do updateMonsterESP(m) end
end

local playerEspSettings = {
	enabled=false,highlightEnabled=true,nameEnabled=true,distanceEnabled=true,healthEnabled=true,
	maxDistance=1000,highlightColor=C3(0,255,127),outlineColor=Color3.new(1,1,1),
	nameColor=C3(0,255,127),distanceColor=C3(255,235,59),textSize=14,fillTransparency=0.5,showSelf=false,
}
local playerEspObjects = {}
local playerEspMissing = {}
local function clearPlayerESP(plr)
	local c = playerEspObjects[plr]
	if c then
		if c.highlight and c.highlight.Parent then c.highlight:Destroy() end
		if c.billboard and c.billboard.Parent then c.billboard:Destroy() end
		playerEspObjects[plr] = nil
	end
	playerEspMissing[plr] = nil
end
local function clearAllPlayerESP()
	for p in pairs(playerEspObjects) do clearPlayerESP(p) end
	playerEspMissing = {}
end
local function createPlayerHighlight(char,nm)
	local hl = Instance.new("Highlight")
	hl.Name = "PlayerESP_HL_"..nm
	hl.Adornee = char
	hl.FillColor = playerEspSettings.highlightColor
	hl.OutlineColor = playerEspSettings.outlineColor
	hl.FillTransparency = playerEspSettings.fillTransparency
	hl.OutlineTransparency = 0
	hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
	hl.Parent = char
	return hl
end
local function createPlayerBillboard(char,nm)
	local head = char:FindFirstChild("Head")
	if not head then return nil,nil end
	local bb = Instance.new("BillboardGui")
	bb.Name = "PlayerESP_Board_"..nm
	bb.Adornee = head
	bb.Size = UDim2new(0,200,0,60)
	bb.StudsOffset = V3(0,3,0)
	bb.AlwaysOnTop = true
	bb.LightInfluence = 0
	bb.MaxDistance = playerEspSettings.maxDistance*10
	bb.Parent = head
	local nl = Instance.new("TextLabel")
	nl.Size,nl.BackgroundTransparency = UDim2new(1,0,0,22),1
	nl.Text,nl.TextColor3,nl.TextStrokeColor3,nl.TextStrokeTransparency,nl.Font,nl.TextSize,nl.Visible = nm,playerEspSettings.nameColor,Color3.new(0,0,0),0,Enum.Font.GothamBold,playerEspSettings.textSize,playerEspSettings.nameEnabled
	nl.Parent = bb
	local dl = Instance.new("TextLabel")
	dl.Size,dl.Position,dl.BackgroundTransparency = UDim2new(1,0,0,18),UDim2new(0,0,0,22),1
	dl.Text,dl.TextColor3,dl.TextStrokeColor3,dl.TextStrokeTransparency,dl.Font,dl.TextSize,dl.Visible = "0m",playerEspSettings.distanceColor,Color3.new(0,0,0),0,Enum.Font.GothamSemibold,playerEspSettings.textSize-2,playerEspSettings.distanceEnabled
	dl.Parent = bb
	local hpl = Instance.new("TextLabel")
	hpl.Size,hpl.Position,hpl.BackgroundTransparency = UDim2new(1,0,0,18),UDim2new(0,0,0,40),1
	hpl.Text,hpl.TextColor3,hpl.TextStrokeColor3,hpl.TextStrokeTransparency,hpl.Font,hpl.TextSize,hpl.Visible = "",C3(0,255,0),Color3.new(0,0,0),0,Enum.Font.GothamSemibold,playerEspSettings.textSize-2,playerEspSettings.healthEnabled
	hpl.Parent = bb
	return bb,{nameLbl=nl,distLbl=dl,hpLbl=hpl}
end
local function updateSinglePlayerESP(plr)
	if plr==LocalPlayer and not playerEspSettings.showSelf then clearPlayerESP(plr) return end
	local char = plr.Character
	if not char or not char:IsA("Model") then
		if not playerEspMissing[plr] then playerEspMissing[plr] = tick() end
		if tick()-playerEspMissing[plr] > 1.5 then clearPlayerESP(plr) end
		return
	end
	local hrp = char:FindFirstChild("HumanoidRootPart") or char.PrimaryPart
	if not hrp then
		if not playerEspMissing[plr] then playerEspMissing[plr] = tick() end
		if tick()-playerEspMissing[plr] > 1.5 then clearPlayerESP(plr) end
		return
	end
	playerEspMissing[plr] = nil
	local dist = (Camera.CFrame.Position-hrp.Position).Magnitude
	if dist>playerEspSettings.maxDistance then clearPlayerESP(plr) return end
	local c = playerEspObjects[plr]
	if not c then c = {} playerEspObjects[plr] = c end
	if playerEspSettings.highlightEnabled then
		if not c.highlight or not c.highlight.Parent then
			c.highlight = createPlayerHighlight(char,plr.Name)
		else
			c.highlight.FillColor = playerEspSettings.highlightColor
			c.highlight.OutlineColor = playerEspSettings.outlineColor
			c.highlight.FillTransparency = playerEspSettings.fillTransparency
		end
	elseif c.highlight then
		c.highlight:Destroy()
		c.highlight = nil
	end
	if playerEspSettings.nameEnabled or playerEspSettings.distanceEnabled or playerEspSettings.healthEnabled then
		if not c.billboard or not c.billboard.Parent then
			c.billboard,c.labels = createPlayerBillboard(char,plr.Name)
		end
		if c.labels then
			local nl,dl,hpl = c.labels.nameLbl,c.labels.distLbl,c.labels.hpLbl
			if nl then nl.Text=plr.Name nl.TextColor3=playerEspSettings.nameColor nl.TextSize=playerEspSettings.textSize nl.Visible=playerEspSettings.nameEnabled end
			if dl then dl.Text=string.format("%.0f m",dist) dl.TextColor3=playerEspSettings.distanceColor dl.Visible=playerEspSettings.distanceEnabled end
			if hpl then
				if playerEspSettings.healthEnabled then
					local hum = char:FindFirstChildOfClass("Humanoid")
					if hum and hum.Health>0 then
						hpl.Text = string.format("HP: %.0f / %.0f",hum.Health,hum.MaxHealth)
						local p = hum.Health/hum.MaxHealth
						hpl.TextColor3 = p>0.5 and C3(0,255,0) or (p>0.25 and C3(255,255,0) or C3(255,0,0))
					else
						hpl.Text = ""
					end
				end
				hpl.Visible = playerEspSettings.healthEnabled
			end
		end
	elseif c.billboard then
		c.billboard:Destroy()
		c.billboard = nil
		c.labels = nil
	end
end
local function updateAllPlayerESP()
	if not playerEspSettings.enabled then clearAllPlayerESP() return end
	local all = Players:GetPlayers()
	for p in pairs(playerEspObjects) do
		if not table.find(all,p) then clearPlayerESP(p) end
	end
	for _,p in ipairs(all) do updateSinglePlayerESP(p) end
end

local authorEspObjects = {}
local function clearAuthorESP(plr)
	if authorEspObjects[plr] then
		for _,o in ipairs(authorEspObjects[plr]) do
			if o and o.Parent then o:Destroy() end
		end
		authorEspObjects[plr] = nil
	end
end
local function isAuthorPlayer(plr)
	return plr and string.lower(plr.Name)==string.lower(AUTHOR_NAME)
end
local function updateAuthorESP()
	for plr in pairs(authorEspObjects) do
		if not plr.Parent or not isAuthorPlayer(plr) then clearAuthorESP(plr) end
	end
	for _,plr in ipairs(Players:GetPlayers()) do
		if isAuthorPlayer(plr) and plr~=LocalPlayer then
			local char = plr.Character
			if char and char:IsA("Model") then
				local hrp = char:FindFirstChild("HumanoidRootPart") or char.PrimaryPart
				local head = char:FindFirstChild("Head")
				if hrp and head then
					if not authorEspObjects[plr] then authorEspObjects[plr] = {} end
					local hl = char:FindFirstChild("AuthorESP_HL_"..plr.Name)
					if not hl then
						hl = Instance.new("Highlight")
						hl.Name = "AuthorESP_HL_"..plr.Name
						hl.Adornee = char
						hl.FillColor = C3(255,215,0)
						hl.OutlineColor = Color3.new(1,1,1)
						hl.FillTransparency = 0.45
						hl.OutlineTransparency = 0
						hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
						hl.Parent = char
						table.insert(authorEspObjects[plr],hl)
					end
					local bb = head:FindFirstChild("AuthorESP_Board_"..plr.Name)
					local distance = (Camera.CFrame.Position-hrp.Position).Magnitude
					if not bb then
						bb = Instance.new("BillboardGui")
						bb.Name = "AuthorESP_Board_"..plr.Name
						bb.Adornee = head
						bb.Size = UDim2new(0,220,0,60)
						bb.StudsOffset = V3(0,3,0)
						bb.AlwaysOnTop = true
						bb.LightInfluence = 0
						bb.Parent = head
						local ttl = Instance.new("TextLabel")
						ttl.Size,ttl.BackgroundTransparency = UDim2new(1,0,0,26),1
						ttl.Text,ttl.TextColor3,ttl.TextStrokeColor3,ttl.TextStrokeTransparency,ttl.Font,ttl.TextSize = "脚本作者",C3(255,215,0),Color3.new(0,0,0),0,Enum.Font.GothamBold,20
						ttl.Parent = bb
						local sub = Instance.new("TextLabel")
						sub.Size,sub.Position,sub.BackgroundTransparency = UDim2new(1,0,0,18),UDim2new(0,0,0,26),1
						sub.Text,sub.TextColor3,sub.TextStrokeColor3,sub.TextStrokeTransparency,sub.Font,sub.TextSize = plr.Name,Color3.new(1,1,1),Color3.new(0,0,0),0,Enum.Font.GothamSemibold,14
						sub.Parent = bb
						local dist = Instance.new("TextLabel")
						dist.Name = "DistLabel"
						dist.Size,dist.Position,dist.BackgroundTransparency = UDim2new(1,0,0,16),UDim2new(0,0,0,44),1
						dist.Text,dist.TextColor3,dist.TextStrokeColor3,dist.TextStrokeTransparency,dist.Font,dist.TextSize = "0m",C3(255,235,59),Color3.new(0,0,0),0,Enum.Font.GothamSemibold,12
						dist.Parent = bb
						table.insert(authorEspObjects[plr],bb)
					else
						local dist = bb:FindFirstChild("DistLabel")
						if dist then dist.Text = string.format("%.0f m",distance) end
					end
				end
			else
				clearAuthorESP(plr)
			end
		end
	end
end

local espAccum,pAccum,aAccum = 0,0,0
RunService.Heartbeat:Connect(function(dt)
	aAccum = aAccum+dt
	if aAccum>=0.25 then
		aAccum = 0
		pcall(updateAuthorESP)
	end
	if espSettings.enabled then
		espAccum = espAccum+dt
		if espAccum>=0.1 then espAccum = 0 updateAllESP() end
	end
	if playerEspSettings.enabled then
		pAccum = pAccum+dt
		if pAccum>=0.1 then pAccum = 0 updateAllPlayerESP() end
	end
end)

Players.PlayerRemoving:Connect(function(plr)
	clearPlayerESP(plr)
	clearAuthorESP(plr)
end)

local jumpscareActive = false
local jumpscareObjectNames = {"ScarJumpscare","SandmanJumpscare","LurkerKill","LostJumpscare","KusJumpscare","GusJumpscare","DusJumpscare","BloodManKill","AshyJumpscare"}
local jumpscareScriptNames = {"PlayScarJumpscareAnimLocal","PlaySawRunnerJumpscareAnimLocal","PlaySandmanJumpscareAnimLocal","PlayLurkerJumpscareAnimLocal","PlayLostJumpscareAnimLocal","PlayKusJumpscareAnimLocal","PlayGusJumpscareAnimLocal","PlayDusJumpscareAnimLocal","PlayBloodManJumpscareAnimLocal","PlayAshyJumpscareAnimLocal"}
local function purgeJumpscare()
	local js = Workspace:FindFirstChild("Jumpscares")
	if js then
		for _,n in ipairs(jumpscareObjectNames) do
			local obj = js:FindFirstChild(n)
			if obj then pcall(function() obj:Destroy() end) end
		end
		for _,obj in ipairs(js:GetChildren()) do
			local nm = obj.Name
			if nm:match("Jumpscare") or nm:match("Kill") or nm:match("Scare") then
				pcall(function() obj:Destroy() end)
			end
		end
	end
	local ps = LocalPlayer:FindFirstChild("PlayerScripts")
	if ps then
		for _,obj in ipairs(ps:GetChildren()) do
			if table.find(jumpscareScriptNames,obj.Name) then
				pcall(function()
					if obj:IsA("LocalScript") or obj:IsA("Script") then obj.Enabled = false end
					obj:Destroy()
				end)
			end
		end
	end
	local pg = LocalPlayer:FindFirstChild("PlayerGui")
	if pg then
		for _,gui in ipairs(pg:GetChildren()) do
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

local playerSettings = {walkSpeed=40,jumpPower=60,gravity=196,godMode=false}
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
		pcall(function() hum.UseJumpPower = true hum.JumpPower = playerSettings.jumpPower end)
		pcall(function() hum.JumpHeight = playerSettings.jumpPower/7 end)
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
	if LocalPlayer.CameraMode==Enum.CameraMode.LockFirstPerson then ApplyCamera() end
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

local assistSettings = {brightnessEnabled=false,brightnessLevel=2}
local brightnessPresets = {
	[1] = {brightness=3,clockTime=14,fogEnd=100000,ambient=C3(150,150,150),outdoorAmbient=C3(150,150,150)},
	[2] = {brightness=6,clockTime=12,fogEnd=1000000,ambient=C3(200,200,200),outdoorAmbient=C3(200,200,200)},
	[3] = {brightness=20,clockTime=12,fogEnd=10000000,ambient=C3(255,255,255),outdoorAmbient=C3(255,255,255)},
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
	pcall(function()
		Lighting.Brightness = preset.brightness
		Lighting.ClockTime = preset.clockTime
		Lighting.FogEnd = preset.fogEnd
		Lighting.Ambient = preset.ambient
		Lighting.OutdoorAmbient = preset.outdoorAmbient
		Lighting.GlobalShadows = false
	end)
end
local function restoreBrightness()
	if not next(lightingOriginal) then return end
	pcall(function()
		Lighting.Brightness = lightingOriginal.Brightness
		Lighting.ClockTime = lightingOriginal.ClockTime
		Lighting.FogEnd = lightingOriginal.FogEnd
		Lighting.Ambient = lightingOriginal.Ambient
		Lighting.OutdoorAmbient = lightingOriginal.OutdoorAmbient
		Lighting.GlobalShadows = lightingOriginal.GlobalShadows
	end)
	lightingOriginal = {}
end

local function fireRespawn()
	local evt = ReplicatedStorage:FindFirstChild("RequestRespawn") or ReplicatedStorage:WaitForChild("RequestRespawn",3)
	if not evt then
		notify("致命猴子","未找到 RequestRespawn",3)
		return false
	end
	return pcall(function()
		if evt:IsA("RemoteEvent") then evt:FireServer()
		elseif evt:IsA("RemoteFunction") then evt:InvokeServer()
		elseif evt:IsA("BindableEvent") then evt:Fire() end
	end)
end
local function clickGameRespawnButton()
	local pg = LocalPlayer:FindFirstChild("PlayerGui")
	if not pg then return false end
	local target = nil
	pcall(function()
		for _,obj in ipairs(pg:GetDescendants()) do
			if obj:IsA("GuiButton") and obj.Visible then
				local nm = string.lower(obj.Name)
				local txt = obj:IsA("TextButton") and string.lower(obj.Text or "") or ""
				if nm:find("respawn") or nm:find("revive") or nm:find("rebirth")
					or txt:find("复活") or txt:find("重生") or txt:find("respawn") or txt:find("revive") then
					target = obj
					break
				end
			end
		end
	end)
	if target then
		return pcall(function()
			target.MouseButton1Click:Fire()
			target.Activated:Fire()
		end)
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
			local hum = char:WaitForChild("Humanoid",5)
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
	red=C3(255,0,0),green=C3(0,255,0),blue=C3(0,0,255),yellow=C3(255,255,0),
	purple=C3(128,0,255),cyan=C3(0,255,255),white=C3(255,255,255),black=C3(0,0,0),
	orange=C3(255,150,60),sgreen=C3(0,255,127),
}
local rainbowActive = false
local rainbowConnection = nil
local function setRainbow(state)
	rainbowActive = state
	if rainbowConnection then rainbowConnection:Disconnect() rainbowConnection = nil end
	if state then
		local hue = 0
		rainbowConnection = RunService.Heartbeat:Connect(function(dt)
			hue = (hue+dt*0.15)%1
			local c = Color3.fromHSV(hue,0.7,1)
			Theme.Accent = c
			Theme.AccentDim = Color3.new(c.R*0.55,c.G*0.55,c.B*0.55)
			Theme.Stroke = Color3.new(c.R*0.65,c.G*0.65,c.B*0.65)
			for _,e in ipairs(AccentObjects) do
				if e.obj and e.obj.Parent then e.obj[e.prop] = c end
			end
			mainStroke.Color = c
			miniStroke.Color = c
		end)
	end
end

local MainTab = createTab("怪物透视","home")
local P1 = MainTab.Page
sectionTitle(P1,"ESP 总开关","bolt")
toggle(P1,"ESP 总开关",false,function(state)
	espSettings.enabled = state
	if not state then clearAllESP() end
	notify("致命猴子",state and "ESP 已开启" or "ESP 已关闭",3)
end)
sectionTitle(P1,"显示选项","shield")
toggle(P1,"怪物高亮",true,function(v) espSettings.highlightEnabled = v end)
toggle(P1,"怪物名字",true,function(v) espSettings.nameEnabled = v end)
toggle(P1,"距离显示",true,function(v) espSettings.distanceEnabled = v end)
toggle(P1,"血量显示",false,function(v) espSettings.healthEnabled = v end)
sectionTitle(P1,"参数调节","settings")
slider(P1,"最大显示距离",50,2000,500,function(v) espSettings.maxDistance = v end)
slider(P1,"填充透明度",0,100,50,function(v) espSettings.fillTransparency = v/100 end)
slider(P1,"文字大小",10,24,14,function(v) espSettings.textSize = v end)
sectionTitle(P1,"怪物单独开关","bolt")
for _,m in ipairs(monsterConfig) do
	toggle(P1,m.name,true,function(v) monsterToggles[m.name] = v end)
end

local TabColor = createTab("颜色设置","palette")
local P2 = TabColor.Page
sectionTitle(P2,"怪物ESP颜色","palette")
colorDropdown(P2,"高亮填充颜色",{
	{name="红色",color=ColorTables.red},{name="绿色",color=ColorTables.green},
	{name="蓝色",color=ColorTables.blue},{name="黄色",color=ColorTables.yellow},
	{name="紫色",color=ColorTables.purple},{name="青色",color=ColorTables.cyan},
	{name="白色",color=ColorTables.white},{name="黑色",color=ColorTables.black},
},function(e) espSettings.highlightColor = e.color end)
colorDropdown(P2,"高亮描边颜色",{
	{name="白色",color=ColorTables.white},{name="红色",color=ColorTables.red},
	{name="绿色",color=ColorTables.green},{name="蓝色",color=ColorTables.blue},
	{name="黄色",color=ColorTables.yellow},{name="黑色",color=ColorTables.black},
},function(e) espSettings.outlineColor = e.color end)
colorDropdown(P2,"怪物名字颜色",{
	{name="白色",color=ColorTables.white},{name="红色",color=C3(255,50,50)},
	{name="黄色",color=C3(255,235,59)},{name="绿色",color=C3(50,255,50)},
	{name="青色",color=ColorTables.cyan},{name="紫色",color=C3(200,100,255)},
},function(e) espSettings.nameColor = e.color end)

local TabPlayerESP = createTab("玩家透视","users")
local P3 = TabPlayerESP.Page
sectionTitle(P3,"玩家 ESP 总开关","users")
toggle(P3,"玩家透视总开关",false,function(state)
	playerEspSettings.enabled = state
	if not state then clearAllPlayerESP() end
	notify("致命猴子",state and "玩家透视已开启" or "玩家透视已关闭",3)
end)
sectionTitle(P3,"显示选项","shield")
toggle(P3,"玩家高亮",true,function(v) playerEspSettings.highlightEnabled = v end)
toggle(P3,"玩家名字",true,function(v) playerEspSettings.nameEnabled = v end)
toggle(P3,"距离显示",true,function(v) playerEspSettings.distanceEnabled = v end)
toggle(P3,"血量显示",true,function(v) playerEspSettings.healthEnabled = v end)
toggle(P3,"显示自己",false,function(v) playerEspSettings.showSelf = v end)
sectionTitle(P3,"参数调节","settings")
slider(P3,"最大显示距离",50,3000,1000,function(v) playerEspSettings.maxDistance = v end)
slider(P3,"填充透明度",0,100,50,function(v) playerEspSettings.fillTransparency = v/100 end)
slider(P3,"文字大小",10,24,14,function(v) playerEspSettings.textSize = v end)
sectionTitle(P3,"颜色设置","palette")
colorDropdown(P3,"高亮填充颜色",{
	{name="绿色",color=ColorTables.sgreen},{name="红色",color=ColorTables.red},
	{name="蓝色",color=ColorTables.blue},{name="黄色",color=ColorTables.yellow},
	{name="紫色",color=ColorTables.purple},{name="青色",color=ColorTables.cyan},
},function(e) playerEspSettings.highlightColor = e.color end)
colorDropdown(P3,"玩家名字颜色",{
	{name="绿色",color=ColorTables.sgreen},{name="白色",color=ColorTables.white},
	{name="红色",color=C3(255,50,50)},{name="黄色",color=C3(255,235,59)},
	{name="青色",color=ColorTables.cyan},{name="紫色",color=C3(200,100,255)},
},function(e) playerEspSettings.nameColor = e.color end)

local TabPlayer = createTab("玩家功能","user")
local P4 = TabPlayer.Page
sectionTitle(P4,"怪物突脸","shield")
toggle(P4,"删除怪物突脸",false,function(state)
	setJumpscareBlock(state)
	notify("致命猴子",state and "突脸已删除" or "突脸删除已关闭",3)
end)
sectionTitle(P4,"速度","bolt")
slider(P4,"行走速度",40,500,40,function(v) playerSettings.walkSpeed = v applySpeed() end)
dropdown(P4,"速度",{"默认(40)","快速(50)","极速(150)","光速(300)","超光速(500)"},"默认(40)",function(sel)
	local presets = {["默认(40)"]=40,["快速(50)"]=50,["极速(150)"]=150,["光速(300)"]=300,["超光速(500)"]=500}
	playerSettings.walkSpeed = presets[sel] or 40
	applySpeed()
end)
sectionTitle(P4,"跳跃控制","bolt")
slider(P4,"跳跃力",60,500,60,function(v) playerSettings.jumpPower = v applyJump() end)
toggle(P4,"无限跳跃",false,function(v) setInfJump(v) end)
sectionTitle(P4,"重力调节","bolt")
slider(P4,"重力",0,400,196,function(v) playerSettings.gravity = v applyGravity() end)
sectionTitle(P4,"复活","check")
button(P4,"点击复活","check",function()
	local ok = tryRespawn()
	notify("致命猴子",ok and "已点击复活" or "复活失败",3)
end)
toggle(P4,"快速复活",false,function(v) setAutoRespawn(v) end)
sectionTitle(P4,"第三人称","user")
toggle(P4,"第三人称",true,function(state)
	keepThirdPerson = state
	ApplyCamera()
	notify("致命猴子",state and "第三人称已开启" or "第三人称已关闭",3)
end)

local TabAssist = createTab("其他功能","zap")
local P5 = TabAssist.Page
sectionTitle(P5,"亮度提升","zap")
toggle(P5,"亮度提升",false,function(state)
	assistSettings.brightnessEnabled = state
	if state then applyBrightness() else restoreBrightness() end
	notify("致命猴子",state and "亮度提升已开启" or "亮度提升已关闭",3)
end)
dropdown(P5,"亮度等级",{"微亮","中亮","超亮"},"中亮",function(sel)
	local levels = {["微亮"]=1,["中亮"]=2,["超亮"]=3}
	assistSettings.brightnessLevel = levels[sel] or 2
	if assistSettings.brightnessEnabled then applyBrightness() end
end)
sectionTitle(P5,"作者信息","shield")
button(P5,"复制作者UID","check",function()
	local txt = "UID:3493085004695814"
	pcall(function()
		if setclipboard then setclipboard(txt)
		elseif toclipboard then toclipboard(txt) end
	end)
	notify("致命猴子","已复制到剪贴板",3)
end)
sectionTitle(P5,"公告","shield")
paragraph(P5,"脚本为AI制作永久公益，禁止圈钱。谢谢配合！")
sectionTitle(P5,"更新日志","bolt")
paragraph(P5,"更新了BTM，祝大家玩的开心（更新日志：2026.10.10）")

local TabTools = createTab("其他脚本","wind")
local P6 = TabTools.Page
sectionTitle(P6,"外置脚本","wind")
button(P6,"飞行脚本","wind",function()
	pcall(function() loadstring(game:HttpGet("https://pastefy.app/sgSR0W9o/raw"))() end)
	notify("致命猴子","飞行脚本已执行",3)
end)
button(P6,"刷钱脚本","wind",function()
	pcall(function() loadstring(game:HttpGet("https://pastebin.com/raw/2xXGqd9M"))() end)
	notify("致命猴子","刷钱脚本已执行",3)
end)
button(P6,"甩飞脚本","wind",function()
	pcall(function() loadstring(game:HttpGet("https://pastebin.com/raw/EnYNYKpB"))() end)
	notify("致命猴子","甩飞脚本已执行",3)
end)
button(P6,"彩虹猴子（每个人都可以看见）","wind",function()
	pcall(function() loadstring(game:HttpGet("https://pastebin.com/raw/7JSnvWQL"))() end)
	notify("致命猴子","彩虹猴子脚本已执行",3)
end)
button(P6,"致命猿BKU脚本（推荐）","wind",function()
	pcall(function() loadstring(game:HttpGet("https://raw.githubusercontent.com/Baloksxin/ROBLOX-BKU-SCRIPT/refs/heads/main/BKU%20SCRIPT.LUA"))() end)
	notify("致命猴子","致命猿BKU脚本已执行",3)
end)
button(P6,"ER BTM","wind",function()
	pcall(function() loadstring(game:HttpGet("https://pastefy.app/0IQzgppR/raw"))() end)
	notify("致命猴子","ER BTM 脚本已执行",3)
end)

local TabNPC = createTab("控制NPC","users")
local P7 = TabNPC.Page
sectionTitle(P7,"控制修复","shield")
local npcFixConn = nil
local npcFixAddedConn = nil
local npcFixRunning = false
local function clearGUILight()
	local pg = LocalPlayer:FindFirstChild("PlayerGui")
	if not pg then return end
	local cam = Workspace.CurrentCamera
	local vp = cam and cam.ViewportSize or Vector2.new(1280,720)
	local SKIP = {"joystick","thumbstick","control","move","mobile","button","touch","pad","input","walk","sprint","jump"}
	local function skipped(obj)
		local nm = obj.Name:lower()
		for _,k in ipairs(SKIP) do
			if nm:find(k) then return true end
		end
		local p = obj.Parent
		while p and p ~= pg do
			local pn = p.Name:lower()
			for _,k in ipairs(SKIP) do
				if pn:find(k) then return true end
			end
			p = p.Parent
		end
		return false
	end
	local lightFix = {}
	for _,v in ipairs(Lighting:GetDescendants()) do
		if v:IsA("ColorCorrectionEffect") or v:IsA("BlurEffect") or v:IsA("DepthOfFieldEffect") or v:IsA("SunRaysEffect") then
			lightFix[#lightFix+1] = v
		end
	end
	for _,v in ipairs(lightFix) do pcall(function() v:Destroy() end) end
	pcall(function()
		Lighting.Ambient = C3(140,140,140)
		Lighting.OutdoorAmbient = C3(140,140,140)
		Lighting.Brightness = 2
		Lighting.ClockTime = 14
		Lighting.FogEnd = 1e6
		Lighting.FogStart = 0
	end)
	local guiFix = {}
	for _,obj in ipairs(pg:GetDescendants()) do
		if obj:IsA("GuiObject") and obj.Visible and not skipped(obj) then
			local sz = obj.AbsoluteSize
			if sz.X>=vp.X*0.9 and sz.Y>=vp.Y*0.9 then
				if obj.BackgroundTransparency<1 and obj.BackgroundColor3.R<0.2 and obj.BackgroundColor3.G<0.2 and obj.BackgroundColor3.B<0.2 then
					guiFix[#guiFix+1] = {obj,"BackgroundTransparency"}
				end
				if obj:IsA("ImageLabel") and obj.ImageTransparency<1 then
					guiFix[#guiFix+1] = {obj,"ImageTransparency"}
				end
			end
		end
	end
	for _,pair in ipairs(guiFix) do
		pcall(function() pair[1][pair[2]] = 1 end)
	end
end
local function startNpcFix()
	if npcFixRunning then return end
	npcFixRunning = true
	clearGUILight()
	local accum = 0
	npcFixConn = RunService.Heartbeat:Connect(function(dt)
		accum = accum+dt
		if accum>=1 then
			accum = 0
			clearGUILight()
		end
	end)
	local pg = LocalPlayer:FindFirstChild("PlayerGui")
	if pg then
		npcFixAddedConn = pg.DescendantAdded:Connect(function(obj)
			if not npcFixRunning then return end
			task.delay(0.1,function()
				if npcFixRunning then clearGUILight() end
			end)
		end)
	end
end
local function stopNpcFix()
	if npcFixConn then
		npcFixConn:Disconnect()
		npcFixConn = nil
	end
	if npcFixAddedConn then
		npcFixAddedConn:Disconnect()
		npcFixAddedConn = nil
	end
	npcFixRunning = false
end
toggle(P7,"修复控制NPC黑屏",false,function(state)
	if state then
		startNpcFix()
		notify("致命猴子","修复控制NPC黑屏已开启",3)
	else
		stopNpcFix()
		notify("致命猴子","修复控制NPC黑屏已关闭",3)
	end
end)
sectionTitle(P7,"控制NPC汉化","users")
button(P7,"控制NPC汉化（搭配BKU使用）","wind",function()
	pcall(function() loadstring(game:HttpGet("https://pastebin.com/raw/2dU621nr"))() end)
	notify("致命猴子","控制NPC汉化脚本已执行",3)
end)

local SettingTab = createTab("UI设置","settings")
local PUI = SettingTab.Page
sectionTitle(PUI,"界面","shield")
toggle(PUI,"固定Ui/最小化方框",false,function(v) Locked = v end)
paragraph(PUI,"开启后，主窗口、ER方框和右下角缩放块均被锁定")
sectionTitle(PUI,"UI 颜色","bolt")
colorDropdown(PUI,"UI 颜色",{
	{name="默认蓝",color=C3(110,110,255)},
	{name="红色",color=C3(255,80,100)},
	{name="绿色",color=C3(80,200,120)},
	{name="紫色",color=C3(180,90,255)},
	{name="橙色",color=C3(255,150,60)},
	{name="青色",color=C3(80,220,240)},
	{name="彩色（动态）",color=C3(200,200,200),rainbow=true},
},function(e)
	if e.rainbow then
		setRainbow(true)
	else
		setRainbow(false)
		applyAccent(e.color)
	end
end)

MainTab.Button.BackgroundColor3 = Theme.AccentDim
MainTab.Label.TextColor3 = Theme.Text
MainTab.Highlight.Visible = true
MainTab.Page.Visible = true

local function openMain()
	MiniBox.Visible = false
	Main.Visible = true
	Main.Size = UDim2new(0,0,0,0)
	Main.BackgroundTransparency = 1
	local target = SavedSize
	tween(Main,0.45,{Size=UDim2new(0,target.X,0,target.Y),BackgroundTransparency=0},Enum.EasingStyle.Back)
end
local function minimizeMain()
	local out = tween(Main,0.3,{Size=UDim2new(0,0,0,0),BackgroundTransparency=1},Enum.EasingStyle.Quart,Enum.EasingDirection.In)
	out.Completed:Connect(function()
		Main.Visible = false
		Main.Size = UDim2new(0,0,0,0)
		MiniBox.Visible = true
		MiniBox.Size = UDim2new(0,0,0,0)
		tween(MiniBox,0.35,{Size=UDim2new(0,46,0,46)},Enum.EasingStyle.Back)
	end)
	task.delay(0.6,function()
		if not Main.Visible then
			MiniBox.Visible = true
			if MiniBox.AbsoluteSize.X < 10 then
				MiniBox.Size = UDim2new(0,46,0,46)
			end
		end
	end)
end
local function closeUI()
	playSound("rbxassetid://6042053626",0.5)
	notify("致命猴子","UI 已关闭，再见！",3)
	task.delay(1.6,function()
		local out = tween(Main,0.3,{Size=UDim2new(0,0,0,0),BackgroundTransparency=1},Enum.EasingStyle.Quart,Enum.EasingDirection.In)
		out.Completed:Connect(function() ScreenGui:Destroy() end)
		task.delay(0.6,function()
			if ScreenGui and ScreenGui.Parent then ScreenGui:Destroy() end
		end)
	end)
end
local function handleMiniBoxClick()
	if not Main.Visible then openMain() end
end
MiniBox.MouseButton1Click:Connect(handleMiniBoxClick)
draggable(MiniBox,MiniBox,handleMiniBoxClick)
MinBtn.MouseButton1Click:Connect(minimizeMain)
CloseBtn.MouseButton1Click:Connect(closeUI)
openMain()