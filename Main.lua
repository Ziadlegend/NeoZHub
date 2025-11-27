-- NeoZ Hub v18.1 – FINAL (No Kuwait Time + Instant Autosave + Max Performance)
-- 100% ORIGINAL UI + LOADING SCREEN PROOF + NEVER DIES

repeat task.wait() until game:IsLoaded()

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local Stats = game:GetService("Stats")
local Http = game:GetService("HttpService")
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local Debris = game:GetService("Debris")

local player = Players.LocalPlayer
if not player or CoreGui:FindFirstChild("NeoZ Hub") then return end

-- ===== Instant Save (no debounce) =====
local SAVE = "NeoZHub_Autosave.json"
local write = writefile or writetofile or write_file
local read = readfile or readfromfile or read_file
local canSave = type(write) == "function" and type(read) == "function"

local function saveNow()
    if not canSave then return end
    pcall(function()
        local state = {
            Frame = {X = Frame.Position.X.Offset, Y = Frame.Position.Y.Offset},
            Toggle = {X = toggleBtn.Position.X.Offset, Y = toggleBtn.Position.Y.Offset},
            Buttons = {{X = lockBtn.Position.X.Offset, Y = lockBtn.Position.Y.Offset}, {X = themeBtn.Position.X.Offset, Y = themeBtn.Position.Y.Offset}},
            Theme = themeBtn.Text,
            Locked = locked,
            Visible = hudVisible
        }
        write(SAVE, Http:JSONEncode(state))
    end)
end

local function loadNow()
    if not canSave then return end
    local s, c = pcall(read, SAVE)
    if s and c then
        local success, data = pcall(Http.JSONDecode, Http, c)
        if success and data then
            if data.Frame then Frame.Position = UDim2.new(Frame.Position.X.Scale, data.Frame.X, Frame.Position.Y.Scale, data.Frame.Y) end
            if data.Toggle then toggleBtn.Position = UDim2.new(toggleBtn.Position.X.Scale, data.Toggle.X, toggleBtn.Position.Y.Scale, data.Toggle.Y) end
            if data.Buttons then
                lockBtn.Position = UDim2.new(0, data.Buttons[1].X, 0, data.Buttons[1].Y)
                themeBtn.Position = UDim2.new(0, data.Buttons[2].X, 0, data.Buttons[2].Y)
            end
            if data.Theme then themeBtn.Text = data.Theme end
            if data.Locked ~= nil then locked = data.Locked; lockBtn.Text = locked and "🔒" or "🔓" end
            if data.Visible ~= nil then hudVisible = data.Visible; Frame.Visible = hudVisible; for _,b in buttons do b.Visible = hudVisible end; updateToggle() end
        end
    end
end

-- ===== ORIGINAL UI (100% UNCHANGED SIZE + AUTO-SCALE) =====
local gui = Instance.new("ScreenGui", CoreGui)
gui.Name = "NeoZ Hub"
gui.ResetOnSpawn = false
gui.DisplayOrder = 999999999

local Frame = Instance.new("Frame", gui)
Frame.Size = UDim2.new(0,200,0,55)
Frame.Position = UDim2.new(0.7,0,0.05,0)
Frame.BackgroundColor3 = Color3.fromRGB(20,20,20)
Frame.BackgroundTransparency = 0.45
Frame.Active = true
Instance.new("UICorner", Frame).CornerRadius = UDim.new(0,8)

local layout = Instance.new("UIListLayout", Frame)
layout.SortOrder = Enum.SortOrder.LayoutOrder
layout.Padding = UDim.new(0,1)

local titleLabel = Instance.new("TextLabel", Frame)
titleLabel.Size = UDim2.new(1,0,0,18)
titleLabel.BackgroundTransparency = 1
titleLabel.Font = Enum.Font.SourceSansBold
titleLabel.TextScaled = true
titleLabel.TextColor3 = Color3.fromRGB(0,255,0)
titleLabel.Text = "NeoZ Hub"

local statsRow = Instance.new("Frame", Frame)
statsRow.Size = UDim2.new(1,0,0,20)
statsRow.BackgroundTransparency = 1
local hLayout = Instance.new("UIListLayout", statsRow)
hLayout.FillDirection = Enum.FillDirection.Horizontal
hLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
hLayout.Padding = UDim.new(0,5)

local function stat(txt)
    local l = Instance.new("TextLabel", statsRow)
    l.Size = UDim2.new(0.3,0,1,0)
    l.BackgroundTransparency = 1
    l.Font = Enum.Font.SourceSansBold
    l.TextScaled = true
    l.TextColor3 = Color3.fromRGB(0,255,0)
    l.Text = txt
    return l
end

local pingL = stat("Ping: ...")
local playersL = stat("Players: ...")
local fpsL = stat("FPS: ...")

playersL.Text = "Players: " .. #Players:GetPlayers()
Players.PlayerAdded:Connect(function() playersL.Text = "Players: " .. #Players:GetPlayers() end)
Players.PlayerRemoving:Connect(function() playersL.Text = "Players: " .. #Players:GetPlayers() end)

-- Buttons (auto-scale emoji size)
local function btn(emoji, x)
    local b = Instance.new("TextButton", gui)
    b.Size = UDim2.new(0,35,0,35)
    b.Position = UDim2.new(0,x,0,50)
    b.BackgroundColor3 = Color3.new(0,0,0)
    b.BackgroundTransparency = 0.4
    b.Text = emoji
    b.TextColor3 = Color3.fromRGB(0,255,0)
    b.Font = Enum.Font.SourceSansBold
    local c = Instance.new("UICorner", b)
    c.CornerRadius = UDim.new(1,0)
    local function resize()
        local s = math.min(b.AbsoluteSize.X, b.AbsoluteSize.Y) * 0.7
        b.TextSize = math.floor(s)
    end
    resize()
    b:GetPropertyChangedSignal("AbsoluteSize"):Connect(resize)
    return b
end

local lockBtn = btn("🔓", 45)
local themeBtn = btn("🌙", 95)
local buttons = {lockBtn, themeBtn}

-- Toggle
local toggleBtn = Instance.new("TextButton", gui)
toggleBtn.Size = UDim2.new(0,40,0,40)
toggleBtn.Position = UDim2.new(0.5,-20,0,10)
toggleBtn.BackgroundColor3 = Color3.new(0,0,0)
toggleBtn.BackgroundTransparency = 0.4
toggleBtn.Text = "🟢"
toggleBtn.TextColor3 = Color3.fromRGB(0,255,0)
toggleBtn.Font = Enum.Font.SourceSansBold
Instance.new("UICorner", toggleBtn).CornerRadius = UDim.new(1,0)

local hudVisible = true
local function updateToggle()
    toggleBtn.Text = hudVisible and "🟢" or "🔴"
    toggleBtn.TextColor3 = hudVisible and Color3.fromRGB(0,255,0) or Color3.fromRGB(255,0,0)
end
toggleBtn.MouseButton1Click:Connect(function()
    hudVisible = not hudVisible
    Frame.Visible = hudVisible
    for _,b in buttons do b.Visible = hudVisible end
    updateToggle()
    saveNow()
end)
updateToggle()

-- Lock
local locked = false
lockBtn.MouseButton1Click:Connect(function()
    locked = not locked
    lockBtn.Text = locked and "🔒" or "🔓"
    Frame.Active = not locked
    for _,b in buttons do b.Active = not locked end
    saveNow()
end)

-- Theme
local rainbow = false
local themes = {"🌙", "☀️", "🌈"}
themeBtn.Text = "🌙"
themeBtn.MouseButton1Click:Connect(function()
    local i = table.find(themes, themeBtn.Text) or 1
    i = (i % 3) + 1
    themeBtn.Text = themes[i]
    rainbow = (themes[i] == "🌈")
    if not rainbow then
        Frame.BackgroundColor3 = themes[i] == "🌙" and Color3.fromRGB(20,20,20) or Color3.fromRGB(220,220,220)
        for _,l in {titleLabel, pingL, playersL, fpsL} do l.TextColor3 = Color3.fromRGB(0,255,0) end
    end
    saveNow()
end)

-- ===== Instant Save on Drag =====
local dragging = false
local dragStart, startPos

local function startDrag(obj)
    obj.InputBegan:Connect(function(i)
        if locked or i.UserInputType ~= Enum.UserInputType.MouseButton1 then return end
        dragging = true
        dragStart = i.Position
        startPos = obj.Position
        i.Changed:Connect(function()
            if i.UserInputState == Enum.UserInputState.End then
                dragging = false
                saveNow()
            end
        end)
    end)
    obj.InputChanged:Connect(function(i)
        if dragging and i.UserInputType == Enum.UserInputType.MouseMovement then
            local d = i.Position - dragStart
            obj.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + d.X, startPos.Y.Scale, startPos.Y.Offset + d.Y)
        end
    end)
end

startDrag(Frame)
startDrag(toggleBtn)
for _,b in buttons do startDrag(b) end

-- Rainbow + FPS (ultra light)
local last_dt = 0
RunService:BindToRenderStep("FPS", 200, function(dt) last_dt = dt end)

local palette = {}
for i=0,11 do palette[i+1] = Color3.fromHSV(i/12,0.75,0.95) end
local idx = 1
local acc = 0

RunService.Heartbeat:Connect(function(dt)
    acc += dt
    if acc >= 0.9 then
        acc -= 0.9
        idx = (idx % 12) + 1
        if rainbow and hudVisible then
            local c = palette[idx]
            Frame.BackgroundColor3 = c
            for _,l in {titleLabel, pingL, playersL, fpsL} do l.TextColor3 = c end
        end
    end

    local fps = last_dt > 0 and math.floor(1/last_dt + 0.5) or 60
    fpsL.Text = "FPS: " .. fps

    pcall(function()
        local p = Stats.Network.ServerStatsItem["Data Ping"]
        if p then pingL.Text = "Ping: " .. math.floor(p:GetValue()) .. "ms" end
    end)
end)

-- Boosters
task.spawn(function()
    while true do
        pcall(function()
            if setfpscap then setfpscap(1/0) end
            collectgarbage("step", 60)
            Debris:ClearAll()
        end)
        task.wait(1.5)
    end
end)

-- Load
task.spawn(function()
    task.wait(1)
    loadNow()
end)

print("NeoZ Hub v18.1 – FINAL (No Kuwait Time) Loaded")
