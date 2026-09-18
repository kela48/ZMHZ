--[[
    致命猴子 - 整合版
    包含: 怪物ESP / 玩家ESP / 玩家功能 / 其他功能 / 飞行脚本 / 胳膊缩放 / 自动刷钱
          + 黑名单系统 / 作者系统 / 作者透视
    适配手机端 | 基于 WindUI + Orion
--]]

-- ========== 黑名单系统（最先执行） ==========
-- 被拉黑的玩家使用此脚本会被自己踢出
local BLACKLIST = {
    "名字",
    "名字"
    -- 在此添加更多被拉黑的用户名（大小写不敏感）
}

do
    local _lp = game:GetService("Players").LocalPlayer
    local _name = _lp.Name
    for _, banned in ipairs(BLACKLIST) do
        if banned ~= "" and string.lower(_name) == string.lower(banned) then
            task.wait(5)
            _lp:Kick("用户： " .. _name .. " ┃你已被加入脚本黑名单 \n\n（错误代码: kela_er）")
            return
        end
    end
end

-- ========== 加载 WindUI ==========
local WindUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/finendss/VowLibrary/refs/heads/main/WINDUI.lua"))()

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local UserInputService = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")

local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera

-- ========== 作者系统配置 ==========
local AUTHOR_NAME = "kela_er1"          -- 作者用户名（只有此用户能看到作者菜单）
local IsAuthor = (string.lower(LocalPlayer.Name) == string.lower(AUTHOR_NAME))

-- ========== 怪物路径配置 (DEX 抓取) ==========
local monsterConfig = {
    {name = "Gus",      parentPath = "GusMonster",       childName = "Gus"},
    {name = "Kus",      parentPath = "KusMonster",       childName = "Kus"},
    {name = "Scar",     parentPath = "Sandman/Ashy",     childName = "Scar"},
    {name = "SandMan",  parentPath = "Sandman/Ashy",     childName = "SandMan"},
    {name = "Lurker",   parentPath = "Sandman/Ashy",     childName = "Lurker"},
    {name = "BloodMan", parentPath = "Sandman/Ashy",     childName = "BloodMan"},
    {name = "Ashy",     parentPath = "Sandman/Ashy",     childName = "Ashy"},
    {name = "Lost",     parentPath = "LostMonster",      childName = "Lost"},
    {name = "Dus",      parentPath = "DusMonster",       childName = "Dus"},
}

-- ========== ESP 全局设置 ==========
local espSettings = {
    enabled          = false,
    highlightEnabled = true,
    nameEnabled      = true,
    distanceEnabled  = true,
    healthEnabled    = false,
    maxDistance      = 500,
    highlightColor   = Color3.fromRGB(255, 0, 0),
    outlineColor     = Color3.fromRGB(255, 255, 255),
    nameColor        = Color3.fromRGB(255, 255, 255),
    distanceColor    = Color3.fromRGB(255, 235, 59),
    textSize         = 14,
    fillTransparency = 0.5,
}

local monsterToggles = {}
for _, m in ipairs(monsterConfig) do
    monsterToggles[m.name] = true
end

-- ========== 工具函数 ==========
local function resolveParent(parentPath)
    local success, obj = pcall(function()
        return Workspace:FindFirstChild(parentPath)
    end)
    if success and obj then return obj end

    if parentPath:find("/") then
        local parts = string.split(parentPath, "/")
        local current = Workspace
        for _, part in ipairs(parts) do
            current = current:FindFirstChild(part)
            if not current then return nil end
        end
        return current
    end
    return nil
end

local function getMonsterModel(monster)
    local parent = resolveParent(monster.parentPath)
    if not parent then return nil end
    return parent:FindFirstChild(monster.childName)
end

local function getMonsterPart(model)
    if not model or not model:IsA("Model") then return nil end
    local part = model:FindFirstChild("HumanoidRootPart")
    if not part then part = model:FindFirstChild("Head") end
    if not part then part = model.PrimaryPart end
    return part
end

local function getMonsterHumanoid(model)
    if not model then return nil end
    return model:FindFirstChildOfClass("Humanoid") or model:FindFirstChild("Humanoid")
end

-- ========== ESP 对象管理 ==========
local espObjects = {}

local function clearMonsterESP(monsterName)
    if espObjects[monsterName] then
        for _, obj in ipairs(espObjects[monsterName]) do
            if obj and obj.Parent then obj:Destroy() end
        end
        espObjects[monsterName] = nil
    end
end

local function clearAllESP()
    for name, _ in pairs(espObjects) do
        clearMonsterESP(name)
    end
end

local function createHighlight(model, monsterName)
    local old = model:FindFirstChild("ESPHighlight_" .. monsterName)
    if old then old:Destroy() end

    local highlight = Instance.new("Highlight")
    highlight.Name = "ESPHighlight_" .. monsterName
    highlight.Adornee = model
    highlight.FillColor = espSettings.highlightColor
    highlight.OutlineColor = espSettings.outlineColor
    highlight.FillTransparency = espSettings.fillTransparency
    highlight.OutlineTransparency = 0
    highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    highlight.Parent = model
    return highlight
end

local function createBillboard(model, monsterName)
    local head = model:FindFirstChild("Head") or getMonsterPart(model)
    if not head then return nil end

    local old = head:FindFirstChild("ESPBoard_" .. monsterName)
    if old then old:Destroy() end

    local billboard = Instance.new("BillboardGui")
    billboard.Name = "ESPBoard_" .. monsterName
    billboard.Adornee = head
    billboard.Size = UDim2.new(0, 200, 0, 60)
    billboard.StudsOffset = Vector3.new(0, 3, 0)
    billboard.AlwaysOnTop = true
    billboard.LightInfluence = 0
    billboard.MaxDistance = espSettings.maxDistance * 10
    billboard.Parent = head

    local nameLabel = Instance.new("TextLabel")
    nameLabel.Name = "NameLabel"
    nameLabel.Size = UDim2.new(1, 0, 0, 22)
    nameLabel.Position = UDim2.new(0, 0, 0, 0)
    nameLabel.BackgroundTransparency = 1
    nameLabel.Text = monsterName
    nameLabel.TextColor3 = espSettings.nameColor
    nameLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    nameLabel.TextStrokeTransparency = 0
    nameLabel.Font = Enum.Font.GothamBold
    nameLabel.TextSize = espSettings.textSize
    nameLabel.Visible = espSettings.nameEnabled
    nameLabel.Parent = billboard

    local distLabel = Instance.new("TextLabel")
    distLabel.Name = "DistLabel"
    distLabel.Size = UDim2.new(1, 0, 0, 18)
    distLabel.Position = UDim2.new(0, 0, 0, 22)
    distLabel.BackgroundTransparency = 1
    distLabel.Text = "0m"
    distLabel.TextColor3 = espSettings.distanceColor
    distLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    distLabel.TextStrokeTransparency = 0
    distLabel.Font = Enum.Font.GothamSemibold
    distLabel.TextSize = espSettings.textSize - 2
    distLabel.Visible = espSettings.distanceEnabled
    distLabel.Parent = billboard

    local healthLabel = Instance.new("TextLabel")
    healthLabel.Name = "HealthLabel"
    healthLabel.Size = UDim2.new(1, 0, 0, 18)
    healthLabel.Position = UDim2.new(0, 0, 0, 40)
    healthLabel.BackgroundTransparency = 1
    healthLabel.Text = ""
    healthLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
    healthLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    healthLabel.TextStrokeTransparency = 0
    healthLabel.Font = Enum.Font.GothamSemibold
    healthLabel.TextSize = espSettings.textSize - 2
    healthLabel.Visible = espSettings.healthEnabled
    healthLabel.Parent = billboard

    return billboard
end

local function updateMonsterESP(monster)
    local name = monster.name
    local model = getMonsterModel(monster)

    if not model then
        clearMonsterESP(name)
        return
    end

    if not espSettings.enabled or not monsterToggles[name] then
        clearMonsterESP(name)
        return
    end

    local part = getMonsterPart(model)
    if not part then
        clearMonsterESP(name)
        return
    end

    local distance = (Camera.CFrame.Position - part.Position).Magnitude
    if distance > espSettings.maxDistance then
        clearMonsterESP(name)
        return
    end

    if not espObjects[name] then
        espObjects[name] = {}
    end

    if espSettings.highlightEnabled then
        local existing = model:FindFirstChild("ESPHighlight_" .. name)
        if not existing then
            local hl = createHighlight(model, name)
            table.insert(espObjects[name], hl)
        else
            existing.FillColor = espSettings.highlightColor
            existing.OutlineColor = espSettings.outlineColor
            existing.FillTransparency = espSettings.fillTransparency
        end
    else
        local existing = model:FindFirstChild("ESPHighlight_" .. name)
        if existing then existing:Destroy() end
    end

    local head = model:FindFirstChild("Head") or part
    local existingBoard = head:FindFirstChild("ESPBoard_" .. name)

    if espSettings.nameEnabled or espSettings.distanceEnabled or espSettings.healthEnabled then
        if not existingBoard then
            local board = createBillboard(model, name)
            if board then
                table.insert(espObjects[name], board)
            end
        else
            local nameLabel = existingBoard:FindFirstChild("NameLabel")
            local distLabel = existingBoard:FindFirstChild("DistLabel")
            local healthLabel = existingBoard:FindFirstChild("HealthLabel")

            if nameLabel then
                nameLabel.Text = name
                nameLabel.TextColor3 = espSettings.nameColor
                nameLabel.TextSize = espSettings.textSize
                nameLabel.Visible = espSettings.nameEnabled
            end
            if distLabel then
                distLabel.Text = string.format("%.0f m", distance)
                distLabel.TextColor3 = espSettings.distanceColor
                distLabel.Visible = espSettings.distanceEnabled
            end
            if healthLabel then
                local humanoid = getMonsterHumanoid(model)
                if humanoid and humanoid.Health > 0 then
                    healthLabel.Text = string.format("HP: %.0f / %.0f", humanoid.Health, humanoid.MaxHealth)
                    local hpPercent = humanoid.Health / humanoid.MaxHealth
                    if hpPercent > 0.5 then
                        healthLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
                    elseif hpPercent > 0.25 then
                        healthLabel.TextColor3 = Color3.fromRGB(255, 255, 0)
                    else
                        healthLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
                    end
                else
                    healthLabel.Text = ""
                end
                healthLabel.Visible = espSettings.healthEnabled
            end
        end
    else
        if existingBoard then existingBoard:Destroy() end
    end
end

local function updateAllESP()
    for _, monster in ipairs(monsterConfig) do
        updateMonsterESP(monster)
    end
end

local function cleanup()
    clearAllESP()
end

local renderConnection
local function startRenderLoop()
    if renderConnection then return end
    renderConnection = RunService.RenderStepped:Connect(function()
        if espSettings.enabled then
            updateAllESP()
        end
    end)
end
startRenderLoop()

-- ========== WindUI 界面 ==========
local Window = WindUI:CreateWindow({
    Title = "致命猴子",
    Icon = "eye",
    Author = "作者kela_er",
    Size = UDim2.fromOffset(600, 480),
    Transparent = true,
    Theme = "FIN",
    HideSearchBar = false,
    ScrollBarEnabled = true,
    Resizable = true,
})

Window:EditOpenButton({
    Title = "致命猴子",
    Icon = "eye",
    CornerRadius = UDim.new(0, 16),
    StrokeThickness = 2,
    Color = ColorSequence.new(Color3.fromHex("FF6B6B")),
    Draggable = true,
})

local TimeTag = Window:Tag({
    Title = "00:00",
    Color = Color3.fromRGB(255, 255, 255)
})

local hue = 0
task.spawn(function()
    while true do
        local now = os.date("*t")
        local hours = string.format("%02d", now.hour)
        local minutes = string.format("%02d", now.min)
        hue = (hue + 0.01) % 1
        local rainbowColor = Color3.fromHSV(hue, 1, 1)
        TimeTag:SetTitle(hours .. ":" .. minutes)
        TimeTag:SetColor(rainbowColor)
        task.wait(0.06)
    end
end)

Window:Tag({
    Title = "感谢使用",
    Color = Color3.fromHex("#7FDBFF")
})

-- ========== Tab 1: 主功能 ==========
local Tab1 = Window:Tab({
    Title = "怪物透视",
    Icon = "settings",
    Locked = false,
})

Tab1:Section({Title = "ESP 总开关", TextXAlignment = "Left", TextSize = 17})

Tab1:Toggle({
    Title = "ESP 总开关",
    Desc = "开启/关闭全部透视功能",
    Default = false,
    Callback = function(state)
        espSettings.enabled = state
        if not state then clearAllESP() end
        WindUI:Notify({
            Title = state and "ESP 已开启" or "ESP 已关闭",
            Content = "",
            Duration = 3
        })
    end
})

Tab1:Section({Title = "显示选项", TextXAlignment = "Left", TextSize = 17})

Tab1:Toggle({
    Title = "怪物高亮",
    Desc = "好使",
    Default = true,
    Callback = function(state) espSettings.highlightEnabled = state end
})

Tab1:Toggle({
    Title = "怪物名字",
    Desc = "在怪物头顶显示名称",
    Default = true,
    Callback = function(state) espSettings.nameEnabled = state end
})

Tab1:Toggle({
    Title = "距离显示",
    Desc = "显示你与怪物的距离",
    Default = true,
    Callback = function(state) espSettings.distanceEnabled = state end
})

Tab1:Toggle({
    Title = "血量显示",
    Desc = "显示怪物当前血量(没啥用)",
    Default = false,
    Callback = function(state) espSettings.healthEnabled = state end
})

Tab1:Section({Title = "参数调节", TextXAlignment = "Left", TextSize = 17})

Tab1:Slider({
    Title = "最大显示距离",
    Desc = "超过此距离的怪物不显示ESP",
    Value = {Min = 50, Max = 2000, Default = 500},
    Increment = 10,
    Callback = function(value) espSettings.maxDistance = value end
})

Tab1:Slider({
    Title = "高亮填充透明度",
    Desc = "0=完全不透明 1=完全透明",
    Value = {Min = 0, Max = 1, Default = 0.5},
    Increment = 0.05,
    Callback = function(value) espSettings.fillTransparency = value end
})

Tab1:Slider({
    Title = "文字大小",
    Desc = "调整ESP文字显示大小",
    Value = {Min = 10, Max = 24, Default = 14},
    Increment = 1,
    Callback = function(value) espSettings.textSize = value end
})

local TabColor = Window:Tab({
    Title = "怪物透视颜色设置",
    Icon = "palette",
    Locked = false,
})

TabColor:Section({Title = "自定义颜色", TextXAlignment = "Left", TextSize = 17})

TabColor:Dropdown({
    Title = "高亮填充颜色",
    Values = {"红色", "绿色", "蓝色", "黄色", "紫色", "青色", "白色", "黑色"},
    Value = "红色",
    Callback = function(selected)
        local colors = {
            ["红色"] = Color3.fromRGB(255, 0, 0),
            ["绿色"] = Color3.fromRGB(0, 255, 0),
            ["蓝色"] = Color3.fromRGB(0, 0, 255),
            ["黄色"] = Color3.fromRGB(255, 255, 0),
            ["紫色"] = Color3.fromRGB(128, 0, 255),
            ["青色"] = Color3.fromRGB(0, 255, 255),
            ["白色"] = Color3.fromRGB(255, 255, 255),
            ["黑色"] = Color3.fromRGB(0, 0, 0),
        }
        espSettings.highlightColor = colors[selected] or espSettings.highlightColor
    end
})

TabColor:Dropdown({
    Title = "高亮描边颜色",
    Values = {"白色", "红色", "绿色", "蓝色", "黄色", "黑色"},
    Value = "白色",
    Callback = function(selected)
        local colors = {
            ["白色"] = Color3.fromRGB(255, 255, 255),
            ["红色"] = Color3.fromRGB(255, 0, 0),
            ["绿色"] = Color3.fromRGB(0, 255, 0),
            ["蓝色"] = Color3.fromRGB(0, 0, 255),
            ["黄色"] = Color3.fromRGB(255, 255, 0),
            ["黑色"] = Color3.fromRGB(0, 0, 0),
        }
        espSettings.outlineColor = colors[selected] or espSettings.outlineColor
    end
})

TabColor:Dropdown({
    Title = "怪物名字颜色",
    Values = {"白色", "红色", "黄色", "绿色", "青色", "紫色"},
    Value = "白色",
    Callback = function(selected)
        local colors = {
            ["白色"] = Color3.fromRGB(255, 255, 255),
            ["红色"] = Color3.fromRGB(255, 50, 50),
            ["黄色"] = Color3.fromRGB(255, 235, 59),
            ["绿色"] = Color3.fromRGB(50, 255, 50),
            ["青色"] = Color3.fromRGB(0, 255, 255),
            ["紫色"] = Color3.fromRGB(200, 100, 255),
        }
        espSettings.nameColor = colors[selected] or espSettings.nameColor
    end
})

-- ========== 玩家透视 ==========
local playerEspSettings = {
    enabled         = false,
    highlightEnabled = true,
    nameEnabled     = true,
    distanceEnabled = true,
    healthEnabled   = true,
    maxDistance     = 1000,
    highlightColor  = Color3.fromRGB(0, 255, 127),
    outlineColor    = Color3.fromRGB(255, 255, 255),
    nameColor       = Color3.fromRGB(0, 255, 127),
    distanceColor   = Color3.fromRGB(255, 235, 59),
    textSize        = 14,
    fillTransparency = 0.5,
    showSelf        = false,
    showTeam        = true,
}

local playerEspObjects = {}

local function clearPlayerESP(plr)
    if playerEspObjects[plr] then
        for _, obj in ipairs(playerEspObjects[plr]) do
            if obj and obj.Parent then obj:Destroy() end
        end
        playerEspObjects[plr] = nil
    end
end

local function clearAllPlayerESP()
    for plr, _ in pairs(playerEspObjects) do
        clearPlayerESP(plr)
    end
end

local function createPlayerHighlight(char, plrName)
    local old = char:FindFirstChild("PlayerESP_HL_" .. plrName)
    if old then old:Destroy() end
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
    if not head then return nil end
    local old = head:FindFirstChild("PlayerESP_Board_" .. plrName)
    if old then old:Destroy() end

    local bb = Instance.new("BillboardGui")
    bb.Name = "PlayerESP_Board_" .. plrName
    bb.Adornee = head
    bb.Size = UDim2.new(0, 200, 0, 60)
    bb.StudsOffset = Vector3.new(0, 3, 0)
    bb.AlwaysOnTop = true
    bb.LightInfluence = 0
    bb.MaxDistance = playerEspSettings.maxDistance * 10
    bb.Parent = head

    local nameLbl = Instance.new("TextLabel")
    nameLbl.Name = "NameLabel"
    nameLbl.Size = UDim2.new(1, 0, 0, 22)
    nameLbl.Position = UDim2.new(0, 0, 0, 0)
    nameLbl.BackgroundTransparency = 1
    nameLbl.Text = plrName
    nameLbl.TextColor3 = playerEspSettings.nameColor
    nameLbl.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    nameLbl.TextStrokeTransparency = 0
    nameLbl.Font = Enum.Font.GothamBold
    nameLbl.TextSize = playerEspSettings.textSize
    nameLbl.Visible = playerEspSettings.nameEnabled
    nameLbl.Parent = bb

    local distLbl = Instance.new("TextLabel")
    distLbl.Name = "DistLabel"
    distLbl.Size = UDim2.new(1, 0, 0, 18)
    distLbl.Position = UDim2.new(0, 0, 0, 22)
    distLbl.BackgroundTransparency = 1
    distLbl.Text = "0m"
    distLbl.TextColor3 = playerEspSettings.distanceColor
    distLbl.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    distLbl.TextStrokeTransparency = 0
    distLbl.Font = Enum.Font.GothamSemibold
    distLbl.TextSize = playerEspSettings.textSize - 2
    distLbl.Visible = playerEspSettings.distanceEnabled
    distLbl.Parent = bb

    local hpLbl = Instance.new("TextLabel")
    hpLbl.Name = "HealthLabel"
    hpLbl.Size = UDim2.new(1, 0, 0, 18)
    hpLbl.Position = UDim2.new(0, 0, 0, 40)
    hpLbl.BackgroundTransparency = 1
    hpLbl.Text = ""
    hpLbl.TextColor3 = Color3.fromRGB(0, 255, 0)
    hpLbl.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    hpLbl.TextStrokeTransparency = 0
    hpLbl.Font = Enum.Font.GothamSemibold
    hpLbl.TextSize = playerEspSettings.textSize - 2
    hpLbl.Visible = playerEspSettings.healthEnabled
    hpLbl.Parent = bb

    return bb
end

local function updateSinglePlayerESP(plr)
    if plr == LocalPlayer and not playerEspSettings.showSelf then
        clearPlayerESP(plr)
        return
    end

    local char = plr.Character
    if not char or not char:IsA("Model") then
        clearPlayerESP(plr)
        return
    end

    local hrp = char:FindFirstChild("HumanoidRootPart") or char.PrimaryPart
    if not hrp then
        clearPlayerESP(plr)
        return
    end

    local distance = (Camera.CFrame.Position - hrp.Position).Magnitude
    if distance > playerEspSettings.maxDistance then
        clearPlayerESP(plr)
        return
    end

    if not playerEspObjects[plr] then
        playerEspObjects[plr] = {}
    end

    if playerEspSettings.highlightEnabled then
        local existing = char:FindFirstChild("PlayerESP_HL_" .. plr.Name)
        if not existing then
            local hl = createPlayerHighlight(char, plr.Name)
            table.insert(playerEspObjects[plr], hl)
        else
            existing.FillColor = playerEspSettings.highlightColor
            existing.OutlineColor = playerEspSettings.outlineColor
            existing.FillTransparency = playerEspSettings.fillTransparency
        end
    else
        local existing = char:FindFirstChild("PlayerESP_HL_" .. plr.Name)
        if existing then existing:Destroy() end
    end

    local head = char:FindFirstChild("Head")
    local existingBoard = head and head:FindFirstChild("PlayerESP_Board_" .. plr.Name)

    if playerEspSettings.nameEnabled or playerEspSettings.distanceEnabled or playerEspSettings.healthEnabled then
        if not existingBoard and head then
            local board = createPlayerBillboard(char, plr.Name)
            if board then
                table.insert(playerEspObjects[plr], board)
            end
        elseif existingBoard then
            local nameLbl = existingBoard:FindFirstChild("NameLabel")
            local distLbl = existingBoard:FindFirstChild("DistLabel")
            local hpLbl = existingBoard:FindFirstChild("HealthLabel")

            if nameLbl then
                nameLbl.Text = plr.Name
                nameLbl.TextColor3 = playerEspSettings.nameColor
                nameLbl.TextSize = playerEspSettings.textSize
                nameLbl.Visible = playerEspSettings.nameEnabled
            end
            if distLbl then
                distLbl.Text = string.format("%.0f m", distance)
                distLbl.TextColor3 = playerEspSettings.distanceColor
                distLbl.Visible = playerEspSettings.distanceEnabled
            end
            if hpLbl then
                local hum = char:FindFirstChildOfClass("Humanoid")
                if hum and hum.Health > 0 then
                    hpLbl.Text = string.format("HP: %.0f / %.0f", hum.Health, hum.MaxHealth)
                    local pct = hum.Health / hum.MaxHealth
                    if pct > 0.5 then
                        hpLbl.TextColor3 = Color3.fromRGB(0, 255, 0)
                    elseif pct > 0.25 then
                        hpLbl.TextColor3 = Color3.fromRGB(255, 255, 0)
                    else
                        hpLbl.TextColor3 = Color3.fromRGB(255, 0, 0)
                    end
                else
                    hpLbl.Text = ""
                end
                hpLbl.Visible = playerEspSettings.healthEnabled
            end
        end
    else
        if existingBoard then existingBoard:Destroy() end
    end
end

local function updateAllPlayerESP()
    if not playerEspSettings.enabled then
        clearAllPlayerESP()
        return
    end
    local allPlayers = Players:GetPlayers()
    for plr, _ in pairs(playerEspObjects) do
        local found = false
        for _, p in ipairs(allPlayers) do
            if p == plr then found = true; break end
        end
        if not found then
            clearPlayerESP(plr)
        end
    end
    for _, plr in ipairs(allPlayers) do
        updateSinglePlayerESP(plr)
    end
end

local playerRenderConn
local function startPlayerEspLoop()
    if playerRenderConn then return end
    playerRenderConn = RunService.RenderStepped:Connect(function()
        if playerEspSettings.enabled then
            updateAllPlayerESP()
        end
    end)
end
startPlayerEspLoop()

Players.PlayerRemoving:Connect(function(plr)
    clearPlayerESP(plr)
end)

-- ========== 玩家透视 Tab ==========
local TabPlayerESP = Window:Tab({
    Title = "玩家透视",
    Icon = "users",
    Locked = false,
})

TabPlayerESP:Section({Title = "玩家 ESP 总开关", TextXAlignment = "Left", TextSize = 17})

TabPlayerESP:Toggle({
    Title = "玩家透视总开关",
    Desc = "开启/关闭全部玩家透视功能",
    Default = false,
    Callback = function(state)
        playerEspSettings.enabled = state
        if not state then clearAllPlayerESP() end
        WindUI:Notify({
            Title = state and "玩家透视已开启" or "玩家透视已关闭",
            Content = "",
            Duration = 3
        })
    end
})

TabPlayerESP:Section({Title = "显示选项", TextXAlignment = "Left", TextSize = 17})

TabPlayerESP:Toggle({
    Title = "玩家高亮",
    Desc = "为玩家模型添加高亮描边",
    Default = true,
    Callback = function(state) playerEspSettings.highlightEnabled = state end
})

TabPlayerESP:Toggle({
    Title = "玩家名字",
    Desc = "在玩家头顶显示名称",
    Default = true,
    Callback = function(state) playerEspSettings.nameEnabled = state end
})

TabPlayerESP:Toggle({
    Title = "距离显示",
    Desc = "显示你与玩家的距离(米)",
    Default = true,
    Callback = function(state) playerEspSettings.distanceEnabled = state end
})

TabPlayerESP:Toggle({
    Title = "血量显示",
    Desc = "显示玩家当前血量",
    Default = true,
    Callback = function(state) playerEspSettings.healthEnabled = state end
})

TabPlayerESP:Toggle({
    Title = "显示自己",
    Desc = "是否也显示自己的透视",
    Default = false,
    Callback = function(state) playerEspSettings.showSelf = state end
})

TabPlayerESP:Section({Title = "参数调节", TextXAlignment = "Left", TextSize = 17})

TabPlayerESP:Slider({
    Title = "最大显示距离",
    Desc = "超过此距离的玩家不显示ESP",
    Value = {Min = 50, Max = 3000, Default = 1000},
    Increment = 10,
    Callback = function(value) playerEspSettings.maxDistance = value end
})

TabPlayerESP:Slider({
    Title = "高亮填充透明度",
    Desc = "0=完全不透明 1=完全透明",
    Value = {Min = 0, Max = 1, Default = 0.5},
    Increment = 0.05,
    Callback = function(value) playerEspSettings.fillTransparency = value end
})

TabPlayerESP:Slider({
    Title = "文字大小",
    Desc = "调整玩家ESP文字大小",
    Value = {Min = 10, Max = 24, Default = 14},
    Increment = 1,
    Callback = function(value) playerEspSettings.textSize = value end
})

TabPlayerESP:Section({Title = "颜色设置", TextXAlignment = "Left", TextSize = 17})

TabPlayerESP:Dropdown({
    Title = "高亮填充颜色",
    Values = {"绿色", "红色", "蓝色", "黄色", "紫色", "青色", "白色", "黑色"},
    Value = "绿色",
    Callback = function(selected)
        local colors = {
            ["绿色"] = Color3.fromRGB(0, 255, 127),
            ["红色"] = Color3.fromRGB(255, 0, 0),
            ["蓝色"] = Color3.fromRGB(0, 0, 255),
            ["黄色"] = Color3.fromRGB(255, 255, 0),
            ["紫色"] = Color3.fromRGB(128, 0, 255),
            ["青色"] = Color3.fromRGB(0, 255, 255),
            ["白色"] = Color3.fromRGB(255, 255, 255),
            ["黑色"] = Color3.fromRGB(0, 0, 0),
        }
        playerEspSettings.highlightColor = colors[selected] or playerEspSettings.highlightColor
    end
})

TabPlayerESP:Dropdown({
    Title = "玩家名字颜色",
    Values = {"绿色", "白色", "红色", "黄色", "青色", "紫色"},
    Value = "绿色",
    Callback = function(selected)
        local colors = {
            ["绿色"] = Color3.fromRGB(0, 255, 127),
            ["白色"] = Color3.fromRGB(255, 255, 255),
            ["红色"] = Color3.fromRGB(255, 50, 50),
            ["黄色"] = Color3.fromRGB(255, 235, 59),
            ["青色"] = Color3.fromRGB(0, 255, 255),
            ["紫色"] = Color3.fromRGB(200, 100, 255),
        }
        playerEspSettings.nameColor = colors[selected] or playerEspSettings.nameColor
    end
})

-- ============================================================
-- 作者透视系统（自动开启，独立于玩家透视，不可关闭）
-- 当作者 kela_er1 进入服务器时，自动对其透视并标注"脚本作者"
-- ============================================================
local authorEspObjects = {}   -- { [player] = {objects} }
local AUTHOR_ESP_COLOR = Color3.fromRGB(255, 215, 0)       -- 金色高亮
local AUTHOR_ESP_OUTLINE = Color3.fromRGB(255, 255, 255)   -- 白色描边
local AUTHOR_ESP_LABEL = "脚本作者"

local function clearAuthorESP(plr)
    if authorEspObjects[plr] then
        for _, obj in ipairs(authorEspObjects[plr]) do
            if obj and obj.Parent then obj:Destroy() end
        end
        authorEspObjects[plr] = nil
    end
end

local function isAuthorPlayer(plr)
    return plr and string.lower(plr.Name) == string.lower(AUTHOR_NAME)
end

local function updateAuthorESP()
    -- 清理已离开或不是作者的
    for plr, _ in pairs(authorEspObjects) do
        if not plr.Parent or not isAuthorPlayer(plr) then
            clearAuthorESP(plr)
        end
    end

    for _, plr in ipairs(Players:GetPlayers()) do
        if isAuthorPlayer(plr) and plr ~= LocalPlayer then
            local char = plr.Character
            if char and char:IsA("Model") then
                local hrp = char:FindFirstChild("HumanoidRootPart") or char.PrimaryPart
                local head = char:FindFirstChild("Head")
                if hrp and head then
                    if not authorEspObjects[plr] then
                        authorEspObjects[plr] = {}
                    end

                    -- Highlight
                    local hlName = "AuthorESP_HL_" .. plr.Name
                    local hl = char:FindFirstChild(hlName)
                    if not hl then
                        hl = Instance.new("Highlight")
                        hl.Name = hlName
                        hl.Adornee = char
                        hl.FillColor = AUTHOR_ESP_COLOR
                        hl.OutlineColor = AUTHOR_ESP_OUTLINE
                        hl.FillTransparency = 0.45
                        hl.OutlineTransparency = 0
                        hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                        hl.Parent = char
                        table.insert(authorEspObjects[plr], hl)
                    end

                    -- Billboard
                    local bbName = "AuthorESP_Board_" .. plr.Name
                    local bb = head:FindFirstChild(bbName)
                    local distance = (Camera.CFrame.Position - hrp.Position).Magnitude
                    if not bb then
                        bb = Instance.new("BillboardGui")
                        bb.Name = bbName
                        bb.Adornee = head
                        bb.Size = UDim2.new(0, 220, 0, 60)
                        bb.StudsOffset = Vector3.new(0, 3, 0)
                        bb.AlwaysOnTop = true
                        bb.LightInfluence = 0
                        bb.MaxDistance = 100000
                        bb.Parent = head

                        local title = Instance.new("TextLabel")
                        title.Name = "AuthorLabel"
                        title.Size = UDim2.new(1, 0, 0, 26)
                        title.Position = UDim2.new(0, 0, 0, 0)
                        title.BackgroundTransparency = 1
                        title.Text = AUTHOR_ESP_LABEL
                        title.TextColor3 = AUTHOR_ESP_COLOR
                        title.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
                        title.TextStrokeTransparency = 0
                        title.Font = Enum.Font.GothamBold
                        title.TextSize = 20
                        title.Parent = bb

                        local sub = Instance.new("TextLabel")
                        sub.Name = "SubLabel"
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
                        if dist then
                            dist.Text = string.format("%.0f m", distance)
                        end
                        local sub = bb:FindFirstChild("SubLabel")
                        if sub then sub.Text = plr.Name end
                    end
                end
            else
                clearAuthorESP(plr)
            end
        end
    end
end

-- 作者透视自动开启，无开关
local authorEspConn = RunService.RenderStepped:Connect(function()
    pcall(updateAuthorESP)
end)

Players.PlayerRemoving:Connect(function(plr)
    clearAuthorESP(plr)
end)

-- ========== 玩家功能 ==========
local playerSettings = {
    jumpscareRemoved = false,
    walkSpeed = 40,
    jumpPower = 60,
    noclip = false,
    infiniteJump = false,
    fly = false,
    flySpeed = 50,
    godMode = false,
    gravity = 196,
}

local function getChar()
    return LocalPlayer.Character
end

local function getHum()
    local char = getChar()
    if not char then return nil end
    return char:FindFirstChildOfClass("Humanoid")
end

-- ========== 删除怪物突脸 ==========
local jumpscareActive = false
local jumpscareTask

local jumpscareObjectNames = {
    "ScarJumpscare",
    "SandmanJumpscare",
    "LurkerKill",
    "LostJumpscare",
    "KusJumpscare",
    "GusJumpscare",
    "DusJumpscare",
    "BloodManKill",
    "AshyJumpscare",
}

local jumpscareScriptNames = {
    "PlayScarJumpscareAnimLocal",
    "PlaySawRunnerJumpscareAnimLocal",
    "PlaySandmanJumpscareAnimLocal",
    "PlayLurkerJumpscareAnimLocal",
    "PlayLostJumpscareAnimLocal",
    "PlayKusJumpscareAnimLocal",
    "PlayGusJumpscareAnimLocal",
    "PlayDusJumpscareAnimLocal",
    "PlayBloodManJumpscareAnimLocal",
    "PlayAshyJumpscareAnimLocal",
}

local function purgeJumpscare()
    local jumpscares = Workspace:FindFirstChild("Jumpscares")
    if jumpscares then
        for _, objName in ipairs(jumpscareObjectNames) do
            local obj = jumpscares:FindFirstChild(objName)
            if obj then
                pcall(function()
                    obj:Destroy()
                end)
            end
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
            local nm = obj.Name
            for _, target in ipairs(jumpscareScriptNames) do
                if nm == target then
                    pcall(function()
                        if obj:IsA("LocalScript") or obj:IsA("Script") then
                            obj.Enabled = false
                        end
                        obj:Destroy()
                    end)
                    break
                end
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
        jumpscareTask = task.spawn(function()
            while jumpscareActive do
                purgeJumpscare()
                task.wait(0.3)
            end
        end)
    else
        jumpscareActive = false
        jumpscareTask = nil
    end
end

-- ========== 速度 / 跳跃 ==========
local function applySpeed()
    local hum = getHum()
    if hum then
        pcall(function() hum.WalkSpeed = playerSettings.walkSpeed end)
    end
end

local function applyJump()
    local hum = getHum()
    if hum then
        pcall(function()
            hum.UseJumpPower = true
            hum.JumpPower = playerSettings.jumpPower
        end)
        pcall(function()
            hum.JumpHeight = playerSettings.jumpPower / 7
        end)
    end
end

-- ========== 无限跳跃 ==========
local infJumpConn
local function setInfJump(state)
    if state then
        if infJumpConn then return end
        infJumpConn = UserInputService.JumpRequest:Connect(function()
            local hum = getHum()
            if hum then
                pcall(function() hum:ChangeState(Enum.HumanoidStateType.Jumping) end)
            end
        end)
    else
        if infJumpConn then
            infJumpConn:Disconnect()
            infJumpConn = nil
        end
    end
end

-- ========== 穿墙 (Noclip) ==========
local noclipConn
local noclipOriginal = {}

local function captureNoclipOriginal()
    noclipOriginal = {}
    local char = getChar()
    if not char then return end
    for _, part in ipairs(char:GetDescendants()) do
        if part:IsA("BasePart") then
            if noclipOriginal[part] == nil then
                noclipOriginal[part] = part.CanCollide
            end
        end
    end
end

local function restoreNoclipOriginal()
    for part, orig in pairs(noclipOriginal) do
        if part and part.Parent then
            pcall(function() part.CanCollide = orig end)
        end
    end
    noclipOriginal = {}

    local char = getChar()
    if not char then return end
    local collideParts = {
        HumanoidRootPart = true,
        UpperTorso = true,
        LowerTorso = true,
        Torso = true,
        Head = true,
        LeftFoot = true,
        RightFoot = true,
        LeftLeg = true,
        RightLeg = true,
    }
    for _, part in ipairs(char:GetDescendants()) do
        if part:IsA("BasePart") then
            local shouldCollide = collideParts[part.Name] == true
            pcall(function() part.CanCollide = shouldCollide end)
        end
    end
end

local function setNoclip(state)
    playerSettings.noclip = state

    if state then
        captureNoclipOriginal()
        if noclipConn then return end
        noclipConn = RunService.Stepped:Connect(function()
            if not playerSettings.noclip then return end
            local char = getChar()
            if not char then return end
            for _, part in ipairs(char:GetDescendants()) do
                if part:IsA("BasePart") and part.CanCollide then
                    if noclipOriginal[part] == nil then
                        noclipOriginal[part] = part.CanCollide
                    end
                    part.CanCollide = false
                end
            end
        end)
    else
        if noclipConn then
            noclipConn:Disconnect()
            noclipConn = nil
        end
        restoreNoclipOriginal()
    end
end

LocalPlayer.CharacterAdded:Connect(function()
    task.wait(0.3)
    noclipOriginal = {}
    if playerSettings.noclip then
        captureNoclipOriginal()
    end
end)

-- ========== 重力 ==========
local function applyGravity()
    pcall(function() Workspace.Gravity = playerSettings.gravity end)
end

-- ========== 角色重生时重新应用 ==========
LocalPlayer.CharacterAdded:Connect(function()
    task.wait(0.5)
    applySpeed()
    applyJump()
    if playerSettings.godMode then
        local hum = getHum()
        if hum then
            pcall(function() hum.BreakJointsOnDeath = false end)
        end
    end
end)

task.spawn(function()
    task.wait(0.5)
    applySpeed()
    applyJump()
end)

-- ========== 玩家功能 Tab ==========
local TabPlayer = Window:Tab({
    Title = "玩家功能",
    Icon = "user",
    Locked = false,
})

TabPlayer:Section({Title = "怪物突脸", TextXAlignment = "Left", TextSize = 17})

TabPlayer:Toggle({
    Title = "删除怪物突脸",
    Desc = "删除怪物突脸动画",
    Default = false,
    Callback = function(state)
        playerSettings.jumpscareRemoved = state
        setJumpscareBlock(state)
        WindUI:Notify({
            Title = state and "突脸已删除" or "突脸删除已关闭",
            Content = "",
            Duration = 3
        })
    end
})

TabPlayer:Section({Title = "速度", TextXAlignment = "Left", TextSize = 17})

TabPlayer:Slider({
    Title = "行走速度",
    Desc = "别调太快",
    Value = {Min = 40, Max = 500, Default = 40},
    Increment = 1,
    Callback = function(value)
        playerSettings.walkSpeed = value
        applySpeed()
    end
})

TabPlayer:Dropdown({
    Title = "速度",
    Values = {"默认(40)", "快速(50)", "极速(150)", "光速(300)", "超光速(500)"},
    Value = "默认(40)",
    Callback = function(selected)
        local presets = {
            ["默认(40)"] = 40,
            ["快速(50)"] = 50,
            ["极速(150)"] = 150,
            ["光速(300)"] = 300,
            ["超光速(500)"] = 500,
        }
        playerSettings.walkSpeed = presets[selected] or 40
        applySpeed()
    end
})

TabPlayer:Section({Title = "跳跃控制", TextXAlignment = "Left", TextSize = 17})

TabPlayer:Slider({
    Title = "跳跃力",
    Desc = "不要调太高",
    Value = {Min = 60, Max = 500, Default = 60},
    Increment = 1,
    Callback = function(value)
        playerSettings.jumpPower = value
        applyJump()
    end
})

TabPlayer:Toggle({
    Title = "无限跳跃",
    Desc = "无限跳",
    Default = false,
    Callback = function(state)
        playerSettings.infiniteJump = state
        setInfJump(state)
    end
})

TabPlayer:Section({Title = "重力调节", TextXAlignment = "Left", TextSize = 17})

TabPlayer:Slider({
    Title = "重力",
    Desc = "196=默认,越低跳得越高/飘",
    Value = {Min = 0, Max = 400, Default = 196},
    Increment = 1,
    Callback = function(value)
        playerSettings.gravity = value
        applyGravity()
    end
})

TabPlayer:Section({Title = "穿墙", TextXAlignment = "Left", TextSize = 17})

TabPlayer:Toggle({
    Title = "穿墙",
    Desc = "穿墙",
    Default = false,
    Callback = function(state)
        setNoclip(state)
        WindUI:Notify({
            Title = state and "穿墙已开启" or "穿墙已关闭",
            Content = "",
            Duration = 3
        })
    end
})

-- ============================================================
-- 其他功能
-- ============================================================

local assistSettings = {
    autoFaceEnabled    = false,
    autoFaceTarget     = "BloodMan",
    autoFaceNearest    = false,
    brightnessEnabled  = false,
    brightnessLevel    = 2,
}

local autoFaceConn

local function getNearestMonster()
    local char = getChar()
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return nil end
    local nearest, nearestDist = nil, math.huge
    for _, monster in ipairs(monsterConfig) do
        local model = getMonsterModel(monster)
        local part = getMonsterPart(model)
        if part then
            local dist = (hrp.Position - part.Position).Magnitude
            if dist < nearestDist then
                nearestDist = dist
                nearest = monster
            end
        end
    end
    return nearest
end

local function getTargetMonster()
    if assistSettings.autoFaceNearest then
        return getNearestMonster()
    end
    for _, monster in ipairs(monsterConfig) do
        if monster.name == assistSettings.autoFaceTarget then
            return monster
        end
    end
    return nil
end

local function setAutoFace(state)
    if state then
        if autoFaceConn then return end
        autoFaceConn = RunService.RenderStepped:Connect(function()
            local char = getChar()
            if not char then return end
            local hrp = char:FindFirstChild("HumanoidRootPart")
            if not hrp then return end

            local monster = getTargetMonster()
            if not monster then return end
            local model = getMonsterModel(monster)
            local part = getMonsterPart(model)
            if not part then return end

            local myPos = hrp.Position
            local targetPos = part.Position
            local lookPos = Vector3.new(targetPos.X, myPos.Y, targetPos.Z)
            if (Vector3.new(targetPos.X, 0, targetPos.Z) - Vector3.new(myPos.X, 0, myPos.Z)).Magnitude < 0.1 then
                return
            end
            hrp.CFrame = CFrame.lookAt(myPos, lookPos)
        end)
    else
        if autoFaceConn then
            autoFaceConn:Disconnect()
            autoFaceConn = nil
        end
    end
end

local brightnessPresets = {
    [1] = {brightness = 3,  clockTime = 14, fogEnd = 100000,    ambient = Color3.fromRGB(150, 150, 150), outdoorAmbient = Color3.fromRGB(150, 150, 150)},
    [2] = {brightness = 6,  clockTime = 12, fogEnd = 1000000,   ambient = Color3.fromRGB(200, 200, 200), outdoorAmbient = Color3.fromRGB(200, 200, 200)},
    [3] = {brightness = 20, clockTime = 12, fogEnd = 10000000,  ambient = Color3.fromRGB(255, 255, 255), outdoorAmbient = Color3.fromRGB(255, 255, 255)},
}

local lightingOriginal = {}
local function saveLightingOriginal()
    if next(lightingOriginal) then return end
    pcall(function()
        lightingOriginal.Brightness      = Lighting.Brightness
        lightingOriginal.ClockTime        = Lighting.ClockTime
        lightingOriginal.FogEnd          = Lighting.FogEnd
        lightingOriginal.Ambient          = Lighting.Ambient
        lightingOriginal.OutdoorAmbient  = Lighting.OutdoorAmbient
        lightingOriginal.GlobalShadows   = Lighting.GlobalShadows
    end)
end

local function applyBrightness()
    local preset = brightnessPresets[assistSettings.brightnessLevel]
    if not preset then return end
    saveLightingOriginal()
    pcall(function() Lighting.Brightness     = preset.brightness end)
    pcall(function() Lighting.ClockTime      = preset.clockTime end)
    pcall(function() Lighting.FogEnd         = preset.fogEnd end)
    pcall(function() Lighting.Ambient        = preset.ambient end)
    pcall(function() Lighting.OutdoorAmbient = preset.outdoorAmbient end)
    pcall(function() Lighting.GlobalShadows  = false end)
end

local function restoreBrightness()
    if not next(lightingOriginal) then return end
    pcall(function() Lighting.Brightness     = lightingOriginal.Brightness end)
    pcall(function() Lighting.ClockTime      = lightingOriginal.ClockTime end)
    pcall(function() Lighting.FogEnd         = lightingOriginal.FogEnd end)
    pcall(function() Lighting.Ambient        = lightingOriginal.Ambient end)
    pcall(function() Lighting.OutdoorAmbient = lightingOriginal.OutdoorAmbient end)
    pcall(function() Lighting.GlobalShadows  = lightingOriginal.GlobalShadows end)
    lightingOriginal = {}
end

local function setBrightness(state)
    if state then
        applyBrightness()
    else
        restoreBrightness()
    end
end

local TabAssist = Window:Tab({
    Title = "其他功能",
    Icon = "zap",
    Locked = false,
})

TabAssist:Section({Title = "自动朝向怪物", TextXAlignment = "Left", TextSize = 17})

TabAssist:Toggle({
    Title = "自动朝向怪物",
    Desc = "第一人称用不了（bug）",
    Default = false,
    Callback = function(state)
        assistSettings.autoFaceEnabled = state
        setAutoFace(state)
        WindUI:Notify({
            Title = state and "自动朝向已开启" or "自动朝向已关闭",
            Content = "",
            Duration = 3
        })
    end
})

TabAssist:Dropdown({
    Title = "朝向目标",
    Desc = "选择要朝向的怪物",
    Values = (function()
        local t = {}
        for _, m in ipairs(monsterConfig) do
            table.insert(t, m.name)
        end
        return t
    end)(),
    Value = "BloodMan",
    Callback = function(selected)
        assistSettings.autoFaceTarget = selected
        assistSettings.autoFaceNearest = false
    end
})

TabAssist:Section({Title = "亮度提升", TextXAlignment = "Left", TextSize = 17})

TabAssist:Toggle({
    Title = "亮度提升",
    Desc = "不建议使用超亮",
    Default = false,
    Callback = function(state)
        assistSettings.brightnessEnabled = state
        setBrightness(state)
        WindUI:Notify({
            Title = state and "亮度提升已开启" or "亮度提升已关闭",
            Content = "",
            Duration = 3
        })
    end
})

TabAssist:Dropdown({
    Title = "亮度等级",
    Desc = "微亮 / 中亮 / 超亮",
    Values = {"微亮", "中亮", "超亮"},
    Value = "中亮",
    Callback = function(selected)
        local levels = {["微亮"] = 1, ["中亮"] = 2, ["超亮"] = 3}
        assistSettings.brightnessLevel = levels[selected] or 2
        if assistSettings.brightnessEnabled then
            applyBrightness()
        end
    end
})

TabAssist:Section({Title = "作者信息", TextXAlignment = "Left", TextSize = 17})

TabAssist:Button({
    Title = "复制作者UID",
    Desc = "点击复制 UID:3493085004695814 | 作者B站",
    Callback = function()
        local copyText = "UID:3493085004695814"
        pcall(function()
            if setclipboard then
                setclipboard(copyText)
            elseif toclipboard then
                toclipboard(copyText)
            end
        end)
        WindUI:Notify({
            Title = "已复制到剪贴板",
            Content = "作者B站",
            Duration = 3
        })
    end
})

-- ========== 飞行脚本 Tab ==========
local TabFlyScript = Window:Tab({
    Title = "飞行脚本",
    Icon = "wind",
    Locked = false,
})

TabFlyScript:Section({Title = "飞行", TextXAlignment = "Left", TextSize = 17})

TabFlyScript:Button({
    Title = "飞行",
    Desc = "点击执行飞行脚本",
    Callback = function()
        pcall(function()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/kongbaNB/9178/refs/heads/main/fly.lua"))()
        end)
        WindUI:Notify({
            Title = "飞行脚本已执行",
            Content = "",
            Duration = 3
        })
    end
})

-- ========== 身体部位缩放 ==========
local BODY_MODEL_NAME = "919191919919997"

local bodyScaleSettings = {
    enabled   = false,
    armScale  = 1.3,
    headScale = 0.6,
}

local bodyOriginalSizes = {}

local function getBodyModel()
    local model = Workspace:FindFirstChild(BODY_MODEL_NAME)
    if model then return model end
    return LocalPlayer and LocalPlayer.Character
end

local function getBodyParts()
    local model = getBodyModel()
    if not model then return nil end
    local hrp = model:FindFirstChild("HumanoidRootPart")
    if not hrp then return nil end
    local armature = hrp:FindFirstChild("Armature")
    if not armature then return nil end
    local boneTorso = armature:FindFirstChild("BoneTorso")
    if not boneTorso then return nil end
    return {
        model    = model,
        head     = boneTorso:FindFirstChild("Head"),
        rightArm = boneTorso:FindFirstChild("RightArm"),
        leftArm  = boneTorso:FindFirstChild("LeftArm"),
    }
end

local function scalePart(part, key, scale)
    if not part or not part:IsA("BasePart") then return end
    if not bodyOriginalSizes[key] or bodyOriginalSizes[key].part ~= part then
        bodyOriginalSizes[key] = {part = part, size = part.Size}
    end
    local orig = bodyOriginalSizes[key].size
    pcall(function() part.Size = orig * scale end)
end

local function restorePart(part, key)
    if not part then return end
    local data = bodyOriginalSizes[key]
    if data and data.size then
        pcall(function() part.Size = data.size end)
    end
end

local function scaleArmsContainer(model, scale)
    if not model then return end
    local armsContainer = model:FindFirstChild("Arms")
    if not armsContainer then return end
    if armsContainer:IsA("BasePart") then
        scalePart(armsContainer, "arms_root", scale)
    else
        for _, obj in ipairs(armsContainer:GetChildren()) do
            if obj:IsA("BasePart") then
                scalePart(obj, "arms_" .. obj.Name, scale)
            end
        end
    end
end

local function restoreArmsContainer(model)
    if not model then return end
    local armsContainer = model:FindFirstChild("Arms")
    if not armsContainer then return end
    if armsContainer:IsA("BasePart") then
        restorePart(armsContainer, "arms_root")
    else
        for _, obj in ipairs(armsContainer:GetChildren()) do
            if obj:IsA("BasePart") then
                restorePart(obj, "arms_" .. obj.Name)
            end
        end
    end
end

local function applyBodyScale()
    local parts = getBodyParts()
    if not parts then return end
    scalePart(parts.rightArm, "rightArm", bodyScaleSettings.armScale)
    scalePart(parts.leftArm,  "leftArm",  bodyScaleSettings.armScale)
    scaleArmsContainer(parts.model, bodyScaleSettings.armScale)
    scalePart(parts.head,     "head",     bodyScaleSettings.headScale)
end

local function restoreBodyScale()
    local parts = getBodyParts()
    if not parts then return end
    restorePart(parts.head, "head")
    restorePart(parts.rightArm, "rightArm")
    restorePart(parts.leftArm, "leftArm")
    restoreArmsContainer(parts.model)
end

local bodyScaleConn
local function startBodyScaleLoop()
    if bodyScaleConn then return end
    bodyScaleConn = RunService.RenderStepped:Connect(function()
        if bodyScaleSettings.enabled then
            applyBodyScale()
        end
    end)
end
startBodyScaleLoop()

local TabBodyScale = Window:Tab({
    Title = "胳膊大小调节",
    Icon = "maximize-2",
    Locked = false,
})

TabBodyScale:Section({Title = "胳膊变大", TextXAlignment = "Left", TextSize = 17})

TabBodyScale:Toggle({
    Title = "胳膊缩放总开关",
    Desc = "胳膊变大变小",
    Default = false,
    Callback = function(state)
        bodyScaleSettings.enabled = state
        if not state then
            restoreBodyScale()
        end
        WindUI:Notify({
            Title = state and "胳膊缩放已开启" or "胳膊缩放已关闭",
            Content = "",
            Duration = 3
        })
    end
})

TabBodyScale:Section({Title = "胳膊变大调节", TextXAlignment = "Left", TextSize = 17})

TabBodyScale:Slider({
    Title = "胳膊变大",
    Desc = "1.0=原大小  1.3=变大",
    Value = {Min = 1.0, Max = 2.0, Default = 1.3},
    Increment = 0.05,
    Callback = function(value)
        bodyScaleSettings.armScale = value
    end
})

-- ========== 刷钱脚本 Tab ==========
local TabShuaScript = Window:Tab({
    Title = "刷钱",
    Icon = "wind",
    Locked = false,
})

TabShuaScript:Section({Title = "刷钱", TextXAlignment = "Left", TextSize = 17})

TabShuaScript:Button({
    Title = "刷钱",
    Desc = "点击执行刷钱脚本",
    Callback = function()
        pcall(function()
            loadstring(game:HttpGet("https://pastebin.com/raw/2xXGqd9M"))()
        end)
        WindUI:Notify({
            Title = "刷钱脚本已执行",
            Content = "",
            Duration = 3
        })
    end
})

-- ============================================================
-- 作者菜单（仅 kela_er1 可见）
-- ============================================================
if IsAuthor then
    local TabAuthor = Window:Tab({
        Title = "作者菜单",
        Icon = "shield",
        Locked = false,
    })

    TabAuthor:Section({Title = "踢出玩家", TextXAlignment = "Left", TextSize = 17})

    local kickTargetName = ""
    TabAuthor:Input({
        Title = "玩家用户名",
        Desc = "输入要踢出的玩家用户名（区分大小写）",
        Placeholder = "输入用户名...",
        Value = "",
        Callback = function(text)
            kickTargetName = text or ""
        end
    })

    TabAuthor:Button({
        Title = "踢出该玩家",
        Desc = "将指定用户名的玩家踢出服务器",
        Callback = function()
            if kickTargetName == "" then
                WindUI:Notify({
                    Title = "请先输入用户名",
                    Content = "",
                    Duration = 3
                })
                return
            end
            local target = nil
            for _, plr in ipairs(Players:GetPlayers()) do
                if string.lower(plr.Name) == string.lower(kickTargetName) then
                    target = plr
                    break
                end
            end
            if target then
                pcall(function()
                    target:Kick("你已被脚本作者踢出服务器")
                end)
                WindUI:Notify({
                    Title = "已踢出玩家: " .. target.Name,
                    Content = "",
                    Duration = 3
                })
            else
                WindUI:Notify({
                    Title = "未找到该玩家",
                    Content = "用户名: " .. kickTargetName,
                    Duration = 3
                })
            end
        end
    })

    TabAuthor:Section({Title = "快捷操作", TextXAlignment = "Left", TextSize = 17})

    TabAuthor:Button({
        Title = "踢出所有其他玩家",
        Desc = "将服务器内除你以外的所有玩家踢出",
        Callback = function()
            local count = 0
            for _, plr in ipairs(Players:GetPlayers()) do
                if plr ~= LocalPlayer then
                    pcall(function()
                        plr:Kick("你已被脚本作者踢出服务器")
                    end)
                    count = count + 1
                end
            end
            WindUI:Notify({
                Title = "已踢出 " .. count .. " 名玩家",
                Content = "",
                Duration = 3
            })
        end
    })

    TabAuthor:Section({Title = "状态", TextXAlignment = "Left", TextSize = 17})

    TabAuthor:Paragraph({
        Title = "作者透视",
        Desc = "自动开启，不可关闭。检测到 kela_er1 进服时自动透视并标注'脚本作者'",
    })

    TabAuthor:Paragraph({
        Title = "黑名单",
        Desc = "源码内置，共 " .. #BLACKLIST .. " 个条目（空条目已忽略）",
    })
end

-- ============================================================
-- 提示：非作者玩家不知道作者菜单的存在
-- 作者透视对所有使用脚本的玩家自动生效，独立于玩家透视
-- ============================================================