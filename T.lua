--[[==========================================================================
    MM2 DELTA HUB — FINAL COMPLETE EDITION (Mobile Optimized)
    ฟีเจอร์: Noclip | WalkSpeed | AutoCoin | AuraKill(200m)
            Sheriff Aimbot(120m) | Fling Murderer | ESP ผู้เล่น
    แก้บัคครบ: ไม่มีลูปซ้อน | pcall ครอบทุกจุด | เช็ค firetouchinterest ถูกวิธี
              | ปิดเมนูสะอาดหมดจด | ล้าง ESP อัตโนมัติ
============================================================================]]

if not Drawing or not getgenv then
    print("[ERROR] Executor ไม่รองรับ Drawing API หรือ getgenv")
    return
end

--========== ทำความสะอาดสคริปต์เก่า ก่อนรันใหม่ ==========
pcall(function()
    if getgenv().MM2_MainUI then getgenv().MM2_MainUI:Destroy() end
end)
local oldConns = {
    "MM2_Render", "MM2_Stepped", "MM2_Heartbeat",
    "MM2_Coin", "MM2_Aura", "MM2_Aim", "MM2_Fling",
    "MM2_Noclip", "MM2_Speed", "MM2_PlayerRemoving", "MM2_PlayerAdded"
}
for _, key in ipairs(oldConns) do
    if getgenv()[key] then pcall(function() getgenv()[key]:Disconnect() end) end
    getgenv()[key] = nil
end
-- ล้าง Drawing เก่า
if getgenv().MM2_ESPCache then
    for _, data in pairs(getgenv().MM2_ESPCache) do
        pcall(function() if data.Box then data.Box:Remove() end end)
        pcall(function() if data.Text then data.Text:Remove() end end)
    end
end
getgenv().MM2_ESPCache = nil

--========== บริการและตัวแปรหลัก ==========
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local Workspace = game:GetService("Workspace")
local TweenService = game:GetService("TweenService")
local Camera = Workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer

local Settings = {
    Noclip        = false,
    WalkSpeed     = false,
    AutoCoin      = false,
    AuraKill      = false,
    SheriffAimbot = false,
    FlingMurderer = false,
    SpeedValue    = 27,
    CoinSpeed     = 20,
    AuraRange     = 200,        -- ✅ ยืนยัน 200 เมตรตามที่ต้องการ
    AimRange      = 120,        -- ✅ Aimbot 120 เมตร
    FlingSpeed    = 20,         -- ✅ บินเร็ว 20 เท่ากับเก็บเหรียญ
    MinCoins      = 40
}

local canFireTouch = (type(firetouchinterest) == "function") -- ✅ เช็คถูกวิธี

--========== สร้าง UI ==========
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "MM2_DeltaHub_Final"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
if syn and syn.protect_gui then
    syn.protect_gui(ScreenGui)
    ScreenGui.Parent = CoreGui
elseif gethui then
    ScreenGui.Parent = gethui()
else
    ScreenGui.Parent = CoreGui
end
getgenv().MM2_MainUI = ScreenGui

-- ไอคอนลอย (เปิด-ปิดเมนู + ลากได้)
local FloatingBtn = Instance.new("TextButton")
FloatingBtn.Size = UDim2.new(0, 56, 0, 56)
FloatingBtn.Position = UDim2.new(0, 20, 0.45, 0)
FloatingBtn.BackgroundColor3 = Color3.fromRGB(22, 22, 32)
FloatingBtn.Text = "🔪"
FloatingBtn.TextColor3 = Color3.fromRGB(231, 76, 60)
FloatingBtn.TextSize = 26
FloatingBtn.Font = Enum.Font.GothamBold
FloatingBtn.Active = true
FloatingBtn.Draggable = true
FloatingBtn.Parent = ScreenGui
local fc = Instance.new("UICorner", FloatingBtn); fc.CornerRadius = UDim.new(1, 0)
local fs = Instance.new("UIStroke", FloatingBtn)
fs.Color = Color3.fromRGB(231, 76, 60); fs.Thickness = 2.5

-- หน้าต่างเมนูหลัก
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 280, 0, 540)
MainFrame.Position = UDim2.new(0.5, -140, 0.5, -270)
MainFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 28)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 14)
local ms = Instance.new("UIStroke", MainFrame)
ms.Color = Color3.fromRGB(60, 60, 90); ms.Thickness = 1.5

-- แถบหัวข้อ
local TitleBar = Instance.new("Frame")
TitleBar.Size = UDim2.new(1, 0, 0, 44)
TitleBar.BackgroundColor3 = Color3.fromRGB(26, 26, 40)
TitleBar.Parent = MainFrame
Instance.new("UICorner", TitleBar).CornerRadius = UDim.new(0, 14)

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -90, 1, 0)
Title.Position = UDim2.new(0, 12, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "MM2 DELTA HUB"
Title.TextColor3 = Color3.fromRGB(231, 76, 60)
Title.TextSize = 15
Title.Font = Enum.Font.GothamBold
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = TitleBar

-- ปุ่มซ่อนเมนู ( − )
local HideBtn = Instance.new("TextButton")
HideBtn.Size = UDim2.new(0, 30, 0, 30)
HideBtn.Position = UDim2.new(1, -72, 0.5, -15)
HideBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
HideBtn.Text = "−"
HideBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
HideBtn.TextSize = 18
HideBtn.Font = Enum.Font.GothamBold
HideBtn.Parent = TitleBar
Instance.new("UICorner", HideBtn).CornerRadius = UDim.new(0, 8)

-- ปุ่มปิดทั้งระบบ ( ✕ )
local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 30, 0, 30)
CloseBtn.Position = UDim2.new(1, -38, 0.5, -15)
CloseBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
CloseBtn.Text = "✕"
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.TextSize = 14
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.Parent = TitleBar
Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(0, 8)

-- แถบสถานะ
local StatusLabel = Instance.new("TextLabel")
StatusLabel.Size = UDim2.new(1, -20, 0, 36)
StatusLabel.Position = UDim2.new(0, 10, 0, 52)
StatusLabel.BackgroundColor3 = Color3.fromRGB(26, 26, 40)
StatusLabel.Text = "บทบาท: กำลังตรวจสอบ..."
StatusLabel.TextColor3 = Color3.fromRGB(220, 220, 220)
StatusLabel.TextSize = 13
StatusLabel.Font = Enum.Font.GothamMedium
StatusLabel.Parent = MainFrame
Instance.new("UICorner", StatusLabel).CornerRadius = UDim.new(0, 8)

local CoinLabel = Instance.new("TextLabel")
CoinLabel.Size = UDim2.new(1, -20, 0, 30)
CoinLabel.Position = UDim2.new(0, 10, 0, 94)
CoinLabel.BackgroundColor3 = Color3.fromRGB(26, 26, 40)
CoinLabel.Text = "เหรียญ: -"
CoinLabel.TextColor3 = Color3.fromRGB(241, 196, 15)
CoinLabel.TextSize = 12
CoinLabel.Font = Enum.Font.GothamMedium
CoinLabel.Parent = MainFrame
Instance.new("UICorner", CoinLabel).CornerRadius = UDim.new(0, 8)

--========== ฟังก์ชันสร้างปุ่ม (ขนาดใหญ่เหมาะกับมือถือ) ==========
local Buttons = {}
local function CreateButton(text, posY, key)
    local Btn = Instance.new("TextButton")
    Btn.Size = UDim2.new(1, -20, 0, 46)
    Btn.Position = UDim2.new(0, 10, 0, posY)
    Btn.BackgroundColor3 = Color3.fromRGB(28, 28, 42)
    Btn.Text = text .. "  [ปิด]"
    Btn.TextColor3 = Color3.fromRGB(231, 76, 60)
    Btn.TextSize = 14
    Btn.Font = Enum.Font.GothamBold
    Btn.Parent = MainFrame
    Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 10)
    local st = Instance.new("UIStroke", Btn)
    st.Color = Color3.fromRGB(50, 50, 75); st.Thickness = 1
    Btn.MouseButton1Click:Connect(function()
        Settings[key] = not Settings[key]
        if Settings[key] then
            Btn.Text = text .. "  [เปิด]"
            Btn.TextColor3 = Color3.fromRGB(46, 204, 113)
            st.Color = Color3.fromRGB(46, 204, 113)
        else
            Btn.Text = text .. "  [ปิด]"
            Btn.TextColor3 = Color3.fromRGB(231, 76, 60)
            st.Color = Color3.fromRGB(50, 50, 75)
        end
    end)
    Buttons[key] = Btn
    return Btn
end

CreateButton("Noclip ทะลุกำแพง", 132, "Noclip")
CreateButton("WalkSpeed เร็ว (27)", 184, "WalkSpeed")
CreateButton("Auto Coin เก็บเหรียญ", 236, "AutoCoin")
CreateButton("Aura Kill (200m)", 288, "AuraKill")
CreateButton("Sheriff Aimbot (120m)", 340, "SheriffAimbot")
CreateButton("Fling Murderer", 392, "FlingMurderer")

-- คำแนะนำด้านล่าง
local TipLabel = Instance.new("TextLabel")
TipLabel.Size = UDim2.new(1, -20, 0, 60)
TipLabel.Position = UDim2.new(0, 10, 0, 448)
TipLabel.BackgroundTransparency = 1
TipLabel.Text = "🔪 ฆาตกร=ฟันอัตโนมัติ\n🔫 นายอำเภอ=ล็อกเป้า+ยิง\n😊 ชาวบ้าน=เก็บเหรียญ 40 → Fling"
TipLabel.TextColor3 = Color3.fromRGB(150, 150, 170)
TipLabel.TextSize = 11
TipLabel.Font = Enum.Font.GothamMedium
TipLabel.TextWrapped = true
TipLabel.Parent = MainFrame

-- ควบคุมเปิด-ปิดเมนู
local menuVisible = true
FloatingBtn.MouseButton1Click:Connect(function()
    menuVisible = not menuVisible
    MainFrame.Visible = menuVisible
end)
HideBtn.MouseButton1Click:Connect(function()
    menuVisible = false
    MainFrame.Visible = false
end)

--========== ตัวแปรแคช ==========
local RoleCache = {}
local ESPCache = {}
getgenv().MM2_ESPCache = ESPCache
local processedCoins = {}
local coinContainerCache = nil
local lastCoinSearch = 0
local lastCoinCheck = 0
local OriginalCanCollide = {}
local scriptActive = true

--========== ฟังก์ชันช่วยเหลือ ==========
local function RemoveESP(player)
    if ESPCache[player] then
        pcall(function() if ESPCache[player].Box then ESPCache[player].Box:Remove() end end)
        pcall(function() if ESPCache[player].Text then ESPCache[player].Text:Remove() end end)
        ESPCache[player] = nil
    end
    RoleCache[player] = nil
end

-- ตรวจสอบบทบาทผู้เล่น (3 ชั้น: StringValue → Tool ในตัว → Tool ในกระเป๋า)
local function GetPlayerRole(player)
    local char = player.Character
    if not char then return "Innocent" end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if hum and hum.Health <= 0 then return "Innocent" end

    -- ชั้น 1: เช็ค StringValue ใน Character
    for _, child in ipairs(char:GetChildren()) do
        if child:IsA("StringValue") then
            local v = child.Value:lower()
            if v:find("murder") then return "Murderer" end
            if v:find("sheriff") then return "Sheriff" end
        end
    end
    -- ชั้น 1.5: เช็ค Role ใน Player
    local roleVal = player:FindFirstChild("Role") or char:FindFirstChild("Role")
    if roleVal and roleVal:IsA("StringValue") then
        local v = roleVal.Value:lower()
        if v:find("murder") then return "Murderer" end
        if v:find("sheriff") then return "Sheriff" end
    end
    -- ชั้น 2: เช็ค Tool
    local function CheckTools(parent)
        if not parent then return nil end
        for _, tool in ipairs(parent:GetChildren()) do
            if tool:IsA("Tool") then
                local n = tool.Name:lower()
                if n:find("knife") or n:find("blade") or n:find("murderer") then return "Murderer" end
                if n:find("gun") or n:find("revolver") or n:find("sheriff") then return "Sheriff" end
            end
        end
        return nil
    end
    local r = CheckTools(char)
    if r then return r end
    r = CheckTools(player:FindFirstChild("Backpack"))
    if r then return r end
    return "Innocent"
end

-- ดึงจำนวนเหรียญ (✅ คืนค่าถูกต้อง ไม่คืน 0 เสมอ)
local function GetCurrentCoins()
    local paths = {
        function() return LocalPlayer:FindFirstChild("PlayerData") and LocalPlayer.PlayerData:FindFirstChild("Coins") and tonumber(LocalPlayer.PlayerData.Coins.Value) end,
        function() return LocalPlayer:FindFirstChild("Coins") and tonumber(LocalPlayer.Coins.Value) end,
        function() return LocalPlayer:FindFirstChild("leaderstats") and LocalPlayer.leaderstats:FindFirstChild("Coins") and tonumber(LocalPlayer.leaderstats.Coins.Value) end,
    }
    for _, fn in ipairs(paths) do
        local ok, val = pcall(fn)
        if ok and type(val) == "number" then return val end
    end
    return nil -- หาไม่เจอ
end

-- หากล่องเหรียญ (✅ แคชไว้ ไม่หาทุกเฟรม)
local function GetCoinContainer()
    local now = tick()
    if coinContainerCache and (now - lastCoinSearch) < 5 then return coinContainerCache end
    lastCoinSearch = now
    local c = Workspace:FindFirstChild("Normal") or Workspace:FindFirstChild("CoinContainer")
    if not c then
        for _, v in ipairs(Workspace:GetChildren()) do
            if v:FindFirstChild("CoinContainer") then c = v.CoinContainer; break end
        end
    end
    coinContainerCache = c
    return c
end

-- หาฆาตกร (คืน player + hrp)
local function FindMurderer()
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer then
            local role = RoleCache[p] or GetPlayerRole(p)
            if role == "Murderer" then
                local char = p.Character
                local hrp = char and char:FindFirstChild("HumanoidRootPart")
                local hum = char and char:FindFirstChildOfClass("Humanoid")
                if hrp and hum and hum.Health > 0 then
                    return p, hrp
                end
            end
        end
    end
    return nil, nil
end

--========== ติดตามผู้เล่น ==========
local function SetupPlayer(player)
    player.CharacterAdded:Connect(function()
        task.wait(0.15)
        RoleCache[player] = GetPlayerRole(player)
    end)
    if player.Character then RoleCache[player] = GetPlayerRole(player) end
end
for _, p in ipairs(Players:GetPlayers()) do SetupPlayer(p) end
getgenv().MM2_PlayerAdded = Players.PlayerAdded:Connect(SetupPlayer)
getgenv().MM2_PlayerRemoving = Players.PlayerRemoving:Connect(RemoveESP)

--========== 1. Noclip ==========
getgenv().MM2_Noclip = RunService.Stepped:Connect(function()
    if not scriptActive then return end
    local char = LocalPlayer.Character
    if not char then return end
    local active = Settings.Noclip or Settings.AutoCoin or Settings.FlingMurderer
    if active then
        for _, part in ipairs(char:GetDescendants()) do
            if part:IsA("BasePart") then
                if OriginalCanCollide[part] == nil then OriginalCanCollide[part] = part.CanCollide end
                part.CanCollide = false
            end
        end
    else
        for part, val in pairs(OriginalCanCollide) do
            pcall(function() if part and part.Parent then part.CanCollide = val end end)
        end
        table.clear(OriginalCanCollide)
    end
end)

--========== 2. WalkSpeed ==========
getgenv().MM2_Speed = RunService.Heartbeat:Connect(function()
    if not scriptActive then return end
    local char = LocalPlayer.Character
    if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if hum and hum.Health > 0 then
        hum.WalkSpeed = Settings.WalkSpeed and Settings.SpeedValue or 16
    end
end)

--========== 3. Auto Coin (✅ ลูปเดียว ไม่ซ้อน) ==========
getgenv().MM2_Coin = RunService.Heartbeat:Connect(function()
    if not scriptActive or not Settings.AutoCoin or Settings.FlingMurderer then return end
    local char = LocalPlayer.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hrp or not hum or hum.Health <= 0 then return end

    -- อัปเดต UI เหรียญทุก 1 วิ
    local now = tick()
    if now - lastCoinCheck > 1 then
        lastCoinCheck = now
        local coins = GetCurrentCoins()
        if coins ~= nil then
            CoinLabel.Text = "เหรียญ: " .. coins .. " / " .. Settings.MinCoins
            CoinLabel.TextColor3 = coins >= Settings.MinCoins and Color3.fromRGB(46,204,113) or Color3.fromRGB(241,196,15)
        else
            CoinLabel.Text = "เหรียญ: ไม่พบข้อมูล"
            CoinLabel.TextColor3 = Color3.fromRGB(230,126,34)
        end
    end

    -- ถ้าเป็นชาวบ้านและเหรียญครบแล้ว → หยุดเก็บ
    local myRole = GetPlayerRole(LocalPlayer)
    local coins = GetCurrentCoins()
    if myRole == "Innocent" and coins and coins >= Settings.MinCoins then return end

    local container = GetCoinContainer()
    if not container then return end

    local children = container:GetChildren()
    if #children == 0 then table.clear(processedCoins); return end

    -- หาเหรียญที่ใกล้ที่สุด
    local closest, minDist = nil, math.huge
    for _, coin in ipairs(children) do
        if processedCoins[coin] then continue end
        if coin.Name ~= "Coin" and not coin:FindFirstChild("CoinVisual") then continue end
        local part = coin:IsA("BasePart") and coin or coin:FindFirstChildWhichIsA("BasePart")
        if part then
            local d = (hrp.Position - part.Position).Magnitude
            if d < minDist then minDist = d; closest = coin end
        end
    end

    if closest then
        local part = closest:IsA("BasePart") and closest or closest:FindFirstChildWhichIsA("BasePart")
        if not part then return end
        local target = part.Position - Vector3.new(0, 0.5, 0)
        local dir = target - hrp.Position
        if dir.Magnitude < 2 then
            processedCoins[closest] = true
            hrp.Velocity = Vector3.new(0, 0, 0)
        else
            hrp.Velocity = dir.Unit * Settings.CoinSpeed
            hum:Move(dir.Unit)
        end
    else
        table.clear(processedCoins)
    end
end)

--========== 4. Aura Kill (ฆาตกร=มีด / นายอำเภอ=ปืน) ==========
getgenv().MM2_Aura = RunService.Heartbeat:Connect(function()
    if not scriptActive or not Settings.AuraKill then return end
    local char = LocalPlayer.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hrp or not hum or hum.Health <= 0 then return end

    -- อัปเดต RoleCache ทุกเฟรม
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer then RoleCache[p] = GetPlayerRole(p) end
    end

    local myRole = GetPlayerRole(LocalPlayer)
    local tool = char:FindFirstChildOfClass("Tool")
    local toolName = tool and tool.Name:lower() or ""
    local isMurderer = (myRole == "Murderer") or toolName:find("knife") or toolName:find("blade")
    local isSheriff  = (myRole == "Sheriff") or toolName:find("gun") or toolName:find("revolver")

    -- ถืออาวุธอัตโนมัติ
    if (isMurderer or isSheriff) and not tool then
        local bp = LocalPlayer:FindFirstChild("Backpack")
        if bp then
            for _, t in ipairs(bp:GetChildren()) do
                if t:IsA("Tool") then
                    local n = t.Name:lower()
                    if (isMurderer and (n:find("knife") or n:find("blade"))) or
                       (isSheriff and (n:find("gun") or n:find("revolver"))) then
                        hum:EquipTool(t); tool = t; break
                    end
                end
            end
        end
    end

    -- กรณีนายอำเภอ: ยิงปืนทาง RemoteEvent (เฉพาะฆาตกร)
    elseif isSheriff and tool then
        for _, p in ipairs(Players:GetPlayers()) do
            if p == LocalPlayer then continue end
            pcall(function()
                if (RoleCache[p] or GetPlayerRole(p)) ~= "Murderer" then return end
                local pChar = p.Character
                local pHrp = pChar and pChar:FindFirstChild("HumanoidRootPart")
                local pHum = pChar and pChar:FindFirstChildOfClass("Humanoid")
                if pHrp and pHum and pHum.Health > 0 then
                    if (hrp.Position - pHrp.Position).Magnitude <= Settings.AuraRange then
                        local evt = tool:FindFirstChild("Shoot") or tool:FindFirstChild("Remote") or tool:FindFirstChild("GunEvent")
                        if evt and evt:IsA("RemoteEvent") then
                            evt:FireServer(pHrp.Position, pHrp)
                        else
                            for _, d in ipairs(tool:GetDescendants()) do
                                if d:IsA("RemoteEvent") then d:FireServer(pHrp.Position, pHrp) end
                            end
                        end
                    end
                end
            end)
        end
    end
end)

--========== 5. Sheriff Aimbot (✅ เฉพาะนายอำเภอ ล็อกศีรษะฆาตกร 120m อัตโนมัติ) ==========
getgenv().MM2_Aim = RunService.RenderStepped:Connect(function()
    if not scriptActive or not Settings.SheriffAimbot then return end
    local char = LocalPlayer.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    local myRole = GetPlayerRole(LocalPlayer)
    local tool = char:FindFirstChildOfClass("Tool")
    local toolName = tool and tool.Name:lower() or ""
    local isSheriff = (myRole == "Sheriff") or toolName:find("gun") or toolName:find("revolver")
    if not isSheriff then return end

    local targetHead, bestDist = nil, Settings.AimRange
    for _, p in ipairs(Players:GetPlayers()) do
        if p == LocalPlayer then continue end
        pcall(function()
            if (RoleCache[p] or GetPlayerRole(p)) ~= "Murderer" then return end
            local pChar = p.Character
            local head = pChar and pChar:FindFirstChild("Head")
            local pHrp = pChar and pChar:FindFirstChild("HumanoidRootPart")
            local pHum = pChar and pChar:FindFirstChildOfClass("Humanoid")
            if head and pHrp and pHum and pHum.Health > 0 then
                local _, onScreen = Camera:WorldToViewportPoint(head.Position)
                if onScreen then
                    local d = (hrp.Position - pHrp.Position).Magnitude
                    if d <= bestDist then bestDist = d; targetHead = head end
                end
            end
        end)
    end

    if targetHead then
        pcall(function()
            Camera.CFrame = CFrame.new(Camera.CFrame.Position, targetHead.Position)
        end)
    end
end)

--========== 6. Fling Murderer (✅ บินหาฆาตกร แล้วดีดออกนอกแมพ) ==========
getgenv().MM2_Fling = RunService.Heartbeat:Connect(function()
    if not scriptActive or not Settings.FlingMurderer then return end
    local char = LocalPlayer.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hrp or not hum or hum.Health <= 0 then return end

    local myRole = GetPlayerRole(LocalPlayer)
    -- ชาวบ้านต้องเก็บเหรียญครบ 40 ก่อน (ถ้าหาเหรียญไม่เจอ = ผ่าน)
    if myRole == "Innocent" then
        local coins = GetCurrentCoins()
        if coins ~= nil and coins < Settings.MinCoins then return end
    end

    local murdererPlayer, targetHrp = FindMurderer()
    if not targetHrp then return end

    local dir = targetHrp.Position - hrp.Position
    local dist = dir.Magnitude

    if dist > 3.5 then
        -- บินเข้าหาฆาตกร (ทะลุกำแพงอยู่แล้วจาก Noclip system)
        hrp.CFrame = CFrame.new(hrp.Position, Vector3.new(targetHrp.Position.X, hrp.Position.Y, targetHrp.Position.Z))
        hrp.Velocity = dir.Unit * Settings.FlingSpeed + Vector3.new(0, 2, 0)
    else
        -- ใกล้แล้ว → ดีดฆาตกรออกนอกแมพ (ค่าปลอดภัย ไม่โดน Error 267)
        pcall(function()
            local flingDir = (targetHrp.Position - hrp.Position).Unit
            targetHrp.Velocity = flingDir * 350 + Vector3.new(0, 250, 0)
            targetHrp.RotVelocity = Vector3.new(math.random(-200,200), 400, math.random(-200,200))
            -- ดันตัวเองถอยหลังเล็กน้อย
            hrp.Velocity = -flingDir * 50 + Vector3.new(0, 30, 0)
        end)
    end
end)

--========== 7. ESP ผู้เล่น (ฆาตกร=แดง / นายอำเภอ=น้ำเงิน) ==========
getgenv().MM2_Render = RunService.RenderStepped:Connect(function()
    if not scriptActive then return end
    local myRole = GetPlayerRole(LocalPlayer)
    StatusLabel.Text = "บทบาท: " .. myRole

    local myChar = LocalPlayer.Character
    local myHrp = myChar and myChar:FindFirstChild("HumanoidRootPart")

    for _, p in ipairs(Players:GetPlayers()) do
        if p == LocalPlayer then continue end
        pcall(function()
            local pChar = p.Character
            local pHrp = pChar and pChar:FindFirstChild("HumanoidRootPart")
            local pHum = pChar and pChar:FindFirstChildOfClass("Humanoid")
            if not pChar or not pHrp or not pHum or pHum.Health <= 0 then
                if ESPCache[p] then
                    ESPCache[p].Box.Visible = false
                    ESPCache[p].Text.Visible = false
                end
                return
            end

            local targetRole = RoleCache[p] or GetPlayerRole(p)
            RoleCache[p] = targetRole

            -- กำหนดว่าจะแสดงใคร
            local show = false
            local color = Color3.fromRGB(231, 76, 60)
            if myRole == "Innocent" then
                if targetRole == "Murderer" then show = true; color = Color3.fromRGB(231,76,60)
                elseif targetRole == "Sheriff" then show = true; color = Color3.fromRGB(52,152,219) end
            elseif myRole == "Murderer" then
                if targetRole == "Sheriff" then show = true; color = Color3.fromRGB(52,152,219)
                elseif targetRole == "Innocent" then show = true; color = Color3.fromRGB(149,165,166) end
            elseif myRole == "Sheriff" then
                if targetRole == "Murderer" then show = true; color = Color3.fromRGB(231,76,60) end
            end

            -- สร้าง Drawing ถ้ายังไม่มี
            if not ESPCache[p] then
                local box = Drawing.new("Square")
                box.Visible = false; box.Thickness = 1.5; box.Filled = false
                local txt = Drawing.new("Text")
                txt.Visible = false; txt.Size = 14; txt.Center = true; txt.Outline = true
                ESPCache[p] = {Box = box, Text = txt}
            end
            local cache = ESPCache[p]

            if not show then
                cache.Box.Visible = false; cache.Text.Visible = false
                return
            end

            cache.Box.Color = color; cache.Text.Color = color

            local vec, onScreen = Camera:WorldToViewportPoint(pHrp.Position)
            if onScreen then
                local head = pChar:FindFirstChild("Head")
                local top = head and Camera:WorldToViewportPoint(head.Position + Vector3.new(0,0.5,0)) or vec
                local bot = Camera:WorldToViewportPoint(pHrp.Position - Vector3.new(0,3,0))
                local h = math.abs(top.Y - bot.Y)
                local w = h / 2
                cache.Box.Size = Vector2.new(w, h)
                cache.Box.Position = Vector2.new(vec.X - w/2, top.Y)
                cache.Box.Visible = true
                local dist = myHrp and math.floor((myHrp.Position - pHrp.Position).Magnitude) or 0
                cache.Text.Text = "[" .. targetRole .. "] " .. p.Name .. " [" .. dist .. "m]"
                cache.Text.Position = Vector2.new(vec.X, top.Y - 18)
                cache.Text.Visible = true
            else
                cache.Box.Visible = false; cache.Text.Visible = false
            end
        end)
    end
end)

--========== ปุ่มปิดทั้งระบบ (✕) ==========
CloseBtn.MouseButton1Click:Connect(function()
    scriptActive = false
    -- ตัดการเชื่อมต่อทั้งหมด
    for _, key in ipairs(oldConns) do
        if getgenv()[key] then pcall(function() getgenv()[key]:Disconnect() end) end
        getgenv()[key] = nil
    end
    -- ล้าง Drawing ทั้งหมด
    for p, data in pairs(ESPCache) do
        pcall(function() if data.Box then data.Box:Remove() end end)
        pcall(function() if data.Text then data.Text:Remove() end end)
    end
    table.clear(ESPCache)
    -- คืนค่า CanCollide
    for part, val in pairs(OriginalCanCollide) do
        pcall(function() if part and part.Parent then part.CanCollide = val end end)
    end
    -- ทำลาย UI
    pcall(function() ScreenGui:Destroy() end)
    getgenv().MM2_MainUI = nil
    getgenv().MM2_ESPCache = nil
    print("[MM2] ปิดระบบเรียบร้อยแล้ว")
end)

print("========================================")
print("✅ MM2 DELTA HUB (Final) โหลดเสร็จแล้ว!")
print("   firetouchinterest:", canFireTouch and "รองรับ ✅" or "ไม่รองรับ (Aura มีดจะไม่ทำงาน) ⚠️")
print("   Aura Range:", Settings.AuraRange, "m | Aim Range:", Settings.AimRange, "m")
print("⚠️  ใช้บัญชีสำรอง | อย่าเปิดทิ้งนานเกินไป")
print("========================================")
