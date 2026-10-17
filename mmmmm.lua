-- [[ MM2 Somtank Ultimate Massive Hub - Clean & Safe Final Version ]] --
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

local isMobile = UserInputService.TouchEnabled and not UserInputService.MouseEnabled

if CoreGui:FindFirstChild("MM2_Clean_Massive_Hub") then
    CoreGui.MM2_Clean_Massive_Hub:Destroy()
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "MM2_Clean_Massive_Hub"
ScreenGui.Parent = CoreGui
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

local scriptActive = true

-- 1. ไอคอนลอย (Floating Icon)
local FloatingIcon = Instance.new("TextButton")
FloatingIcon.Name = "FloatingIcon"
FloatingIcon.Parent = ScreenGui
FloatingIcon.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
FloatingIcon.Position = UDim2.new(0, 25, 0.4, 0)
FloatingIcon.Size = isMobile and UDim2.new(0, 60, 0, 60) or UDim2.new(0, 50, 0, 50)
FloatingIcon.Font = Enum.Font.FredokaOne
FloatingIcon.Text = "🃏"
FloatingIcon.TextColor3 = Color3.fromRGB(255, 255, 255)
FloatingIcon.TextSize = 24

local IconCorner = Instance.new("UICorner")
IconCorner.CornerRadius = UDim.new(1, 0)
IconCorner.Parent = FloatingIcon

local IconStroke = Instance.new("UIStroke")
IconStroke.Color = Color3.fromRGB(138, 43, 226)
IconStroke.Thickness = 2.5
IconStroke.Parent = FloatingIcon

-- 2. หน้าต่าง UI หลัก
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 25)
MainFrame.Position = UDim2.new(0.5, -260, 0.5, -180)
MainFrame.Size = UDim2.new(0, 520, 0, 360)
MainFrame.Visible = false

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 10)
MainCorner.Parent = MainFrame

local MainStroke = Instance.new("UIStroke")
MainStroke.Color = Color3.fromRGB(70, 50, 100)
MainStroke.Thickness = 2
MainStroke.Parent = MainFrame

-- 3. แถบหัวข้อด้านบน (TopBar)
local TopBar = Instance.new("Frame")
TopBar.Parent = MainFrame
TopBar.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
TopBar.Size = UDim2.new(1, 0, 0, 40)

local TopCorner = Instance.new("UICorner")
TopCorner.CornerRadius = UDim.new(0, 10)
TopCorner.Parent = TopBar

local Title = Instance.new("TextLabel")
Title.Parent = TopBar
Title.BackgroundTransparency = 1
Title.Position = UDim2.new(0, 15, 0, 0)
Title.Size = UDim2.new(0.8, 0, 1, 0)
Title.Font = Enum.Font.SourceSansBold
Title.Text = "MM2 | Somtank (CLEAN & SECURED EDITION)"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 14
Title.TextXAlignment = Enum.TextXAlignment.Left

-- 4. ปุ่มกากบาท (Close Button)
local CloseButton = Instance.new("TextButton")
CloseButton.Parent = TopBar
CloseButton.BackgroundColor3 = Color3.fromRGB(220, 50, 50)
CloseButton.Position = UDim2.new(1, -35, 0.5, -12)
CloseButton.Size = UDim2.new(0, 24, 0, 24)
CloseButton.Font = Enum.Font.SourceSansBold
CloseButton.Text = "X"
CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseButton.TextSize = 14

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0, 6)
CloseCorner.Parent = CloseButton

-- 5. พื้นที่แสดงเนื้อหาฟังก์ชัน (Container)
local ContainerFrame = Instance.new("ScrollingFrame")
ContainerFrame.Parent = MainFrame
ContainerFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
ContainerFrame.BorderSizePixel = 0
ContainerFrame.Position = UDim2.new(0, 12, 0, 50)
ContainerFrame.Size = UDim2.new(1, -24, 1, -60)
ContainerFrame.CanvasSize = UDim2.new(0, 0, 3.2, 0)
ContainerFrame.ScrollBarThickness = 5

local ContentLayout = Instance.new("UIListLayout")
ContentLayout.Parent = ContainerFrame
ContentLayout.SortOrder = Enum.SortOrder.LayoutOrder
ContentLayout.Padding = UDim.new(0, 8)

local function addSection(text)
    local lbl = Instance.new("TextLabel")
    lbl.Parent = ContainerFrame
    lbl.BackgroundTransparency = 1
    lbl.Size = UDim2.new(1, -10, 0, 28)
    lbl.Font = Enum.Font.SourceSansBold
    lbl.Text = "✦ " .. text .. " ✦"
    lbl.TextColor3 = Color3.fromRGB(180, 100, 255)
    lbl.TextSize = 15
    lbl.TextXAlignment = Enum.TextXAlignment.Left
end

local function addToggle(titleText, callback)
    local frame = Instance.new("Frame")
    frame.Parent = ContainerFrame
    frame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
    frame.Size = UDim2.new(1, -12, 0, 40)
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = frame
    
    local label = Instance.new("TextLabel")
    label.Parent = frame
    label.BackgroundTransparency = 1
    label.Position = UDim2.new(0, 12, 0, 0)
    label.Size = UDim2.new(0.65, 0, 1, 0)
    label.Font = Enum.Font.SourceSans
    label.Text = titleText
    label.TextColor3 = Color3.fromRGB(230, 230, 230)
    label.TextSize = 14
    label.TextXAlignment = Enum.TextXAlignment.Left
    
    local btn = Instance.new("TextButton")
    btn.Parent = frame
    btn.BackgroundColor3 = Color3.fromRGB(0, 200, 100)
    btn.Position = UDim2.new(1, -55, 0.5, -12)
    btn.Size = UDim2.new(0, 45, 0, 24)
    btn.Font = Enum.Font.SourceSansBold
    btn.Text = "ON"
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.TextSize = 12
    
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(1, 0)
    btnCorner.Parent = btn
    
    local state = true
    btn.MouseButton1Click:Connect(function()
        state = not state
        btn.Text = state and "ON" or "OFF"
        btn.BackgroundColor3 = state and Color3.fromRGB(0, 200, 100) or Color3.fromRGB(70, 70, 85)
        if callback then callback(state) end
    end)
    return frame
end

local function addButton(titleText, callback)
    local btn = Instance.new("TextButton")
    btn.Parent = ContainerFrame
    btn.BackgroundColor3 = Color3.fromRGB(32, 32, 45)
    btn.Size = UDim2.new(1, -12, 0, 38)
    btn.Font = Enum.Font.SourceSansBold
    btn.Text = "  " .. titleText
    btn.TextColor3 = Color3.fromRGB(245, 245, 245)
    btn.TextSize = 14
    btn.TextXAlignment = Enum.TextXAlignment.Left

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = btn

    btn.MouseButton1Click:Connect(function()
        if callback then callback() end
    end)
    return btn
end

-- ฟังก์ชันวาร์ปเคลื่อนที่แบบสมูท (โปรดใช้งานด้วยความระมัดระวังเรื่องระบบตรวจจับของเกม)
local function safeTeleportTo(targetCFrame)
    pcall(function()
        local character = LocalPlayer.Character
        local rootPart = character and character:FindFirstChild("HumanoidRootPart")
        if not rootPart then return end
        local tweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Linear, Enum.EasingDirection.Out)
        local tween = TweenService:Create(rootPart, tweenInfo, {CFrame = targetCFrame + Vector3.new(0, 3, 0)})
        tween:Play()
    end)
end

-- บรรจุฟังก์ชันลงเมนูหลัก
addSection("ระบบต่อสู้ & ฆาตกร")
local espEnabled = true
local killAuraEnabled = true
local noclipEnabled = false

addToggle("Kill Aura (200m Range - Murderer)", function(state) killAuraEnabled = state end)
addToggle("Enable Role ESP (Box & Dist)", function(state) espEnabled = state end)

addSection("ระบบตัวละคร")
addToggle("เดินทะลุกำแพง (Noclip)", function(state) noclipEnabled = state end)

addSection("ระบบวาร์ปด่วน (ใช้อย่างระมัดระวัง)")
addButton("วาร์ปไปหา ฆาตกร (TP to Murderer)", function()
    pcall(function()
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LocalPlayer then
                local bp = player:FindFirstChild("Backpack")
                local char = player.Character
                if char and (char:FindFirstChild("Knife") or (bp and bp:FindFirstChild("Knife"))) then
                    local targetRoot = char:FindFirstChild("HumanoidRootPart")
                    if targetRoot then
                        safeTeleportTo(targetRoot.CFrame)
                        break
                    end
                end
            end
        end
    end)
end)

addButton("วาร์ปไปหา นายอำเภอ (TP to Sheriff)", function()
    pcall(function()
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LocalPlayer then
                local bp = player:FindFirstChild("Backpack")
                local char = player.Character
                local droppedGun = workspace:FindFirstChild("GunDrop")
                if char and (char:FindFirstChild("Gun") or (bp and bp:FindFirstChild("Gun")) or player.Name == tostring(droppedGun)) then
                    local targetRoot = char:FindFirstChild("HumanoidRootPart")
                    if targetRoot then
                        safeTeleportTo(targetRoot.CFrame)
                        break
                    end
                end
            end
        end
    end)
end)

addSection("เครื่องมือช่วยเหลือ")
addButton("รีเซ็ตตัวละครด่วน (Fast Reset)", function()
    local char = LocalPlayer.Character
    if char and char:FindFirstChild("Humanoid") then
        char.Humanoid.Health = 0
    end
end)

-- ควบคุมเปิด-ปิด UI
FloatingIcon.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
end)

CloseButton.MouseButton1Click:Connect(function()
    scriptActive = false
    ScreenGui:Destroy()
end)

-- ลากไอคอนลอย
local dragging, dragStart, startPos
FloatingIcon.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = FloatingIcon.Position
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        FloatingIcon.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

-- ระบบตรวจสอบบทบาทที่แม่นยำ
local espCache = {}
local function getRole(player)
    local success, role = pcall(function()
        local backpack = player:FindFirstChild("Backpack")
        local character = player.Character
        if not character then return "Innocent", Color3.fromRGB(0, 255, 0) end

        if player:FindFirstChild("Role") then
            local rVal = player.Role.Value
            if rVal == "Murderer" then return "Murderer", Color3.fromRGB(255, 0, 0) end
            if rVal == "Sheriff" then return "Sheriff", Color3.fromRGB(0, 0, 255) end
        end

        local hasKnife = (character:FindFirstChild("Knife") or (backpack and backpack:FindFirstChild("Knife")))
        local hasGun = (character:FindFirstChild("Gun") or (backpack and backpack:FindFirstChild("Gun")))
        local droppedGun = workspace:FindFirstChild("GunDrop")

        if hasKnife then
            return "Murderer", Color3.fromRGB(255, 0, 0)
        elseif hasGun or (player.Name == tostring(droppedGun)) then
            return "Sheriff", Color3.fromRGB(0, 0, 255)
        else
            return "Innocent", Color3.fromRGB(0, 255, 0)
        end
    end)
    if success then return role, Color3.fromRGB(0, 255, 0) end
    return "Innocent", Color3.fromRGB(0, 255, 0)
end

local function canSeeRole(myRole, targetRole)
    if myRole == "Murderer" then
        return (targetRole == "Innocent" or targetRole == "Sheriff")
    elseif myRole == "Sheriff" then
        return (targetRole == "Murderer")
    elseif myRole == "Innocent" then
        return (targetRole == "Sheriff" or targetRole == "Murderer")
    end
    return false
end

-- สร้างและล้าง ESP อัตโนมัติเมื่อผู้เล่นออกจากเกม
local function createESP(player)
    if player == LocalPlayer then return end
    if espCache[player] then return end

    pcall(function()
        local box = Drawing.new("Square")
        box.Visible = false
        box.Thickness = 1.5
        box.Filled = false

        local text = Drawing.new("Text")
        text.Visible = false
        text.Center = true
        text.Outline = true
        text.Size = 15

        espCache[player] = {Box = box, Text = text}

        local function removeESP()
            if espCache[player] then
                if espCache[player].Box then espCache[player].Box:Remove() end
                if espCache[player].Text then espCache[player].Text:Remove() end
                espCache[player] = nil
            end
        end

        player.CharacterRemoving:Connect(removeESP)
        player.Destroying:Connect(removeESP)
    end)
end

for _, player in ipairs(Players:GetPlayers()) do
    createESP(player)
end
Players.PlayerAdded:Connect(createESP)
Players.PlayerRemoving:Connect(function(player)
    if espCache[player] then
        pcall(function()
            if espCache[player].Box then espCache[player].Box:Remove() end
            if espCache[player].Text then espCache[player].Text:Remove() end
        end)
        espCache[player] = nil
    end
end)

local canFireTouch = type(firetouchinterest) == "function"

-- ลูปการทำงานหลัก (RenderStepped)
RunService.RenderStepped:Connect(function()
    if not scriptActive then return end

    pcall(function()
        local myRole, _ = getRole(LocalPlayer)
        local char = LocalPlayer.Character
        local rootPart = char and char:FindFirstChild("HumanoidRootPart")

        -- 1. Kill Aura 200m
        if killAuraEnabled and myRole == "Murderer" and rootPart and canFireTouch then
            local knife = char:FindFirstChild("Knife")
            if knife and knife:FindFirstChild("Handle") then
                for _, player in ipairs(Players:GetPlayers()) do
                    if player ~= LocalPlayer then
                        local tChar = player.Character
                        local tRoot = tChar and tChar:FindFirstChild("HumanoidRootPart")
                        local tHum = tChar and tChar:FindFirstChild("Humanoid")
                        if tRoot and tHum and tHum.Health > 0 then
                            if (rootPart.Position - tRoot.Position).Magnitude <= 200 then
                                firetouchinterest(tRoot, knife.Handle, 0)
                                firetouchinterest(tRoot, knife.Handle, 1)
                            end
                        end
                    end
                end
            end
        end

        -- 2. อัปเดต ESP
        for player, esp in pairs(espCache) do
            local character = player.Character
            local hrp = character and character:FindFirstChild("HumanoidRootPart")
            local hum = character and character:FindFirstChild("Humanoid")

            if espEnabled and character and hrp and hum and hum.Health > 0 then
                local targetRole, roleColor = getRole(player)
                if canSeeRole(myRole, targetRole) then
                    local vector, onScreen = Camera:WorldToViewportPoint(hrp.Position)
                    if onScreen then
                        local dist = (Camera.CFrame.Position - hrp.Position).Magnitude
                        local head = character:FindFirstChild("Head")
                        local h = head and math.abs(Camera:WorldToViewportPoint(head.Position + Vector3.new(0, 0.5, 0)).Y - Camera:WorldToViewportPoint(hrp.Position - Vector3.new(0, 3, 0)).Y) or 50
                        local w = h / 2

                        esp.Box.Size = Vector2.new(w, h)
                        esp.Box.Position = Vector2.new(vector.X - w/2, vector.Y - h/2)
                        esp.Box.Color = roleColor
                        esp.Box.Visible = true

                        esp.Text.Text = string.format("[%s] [%dm]", targetRole, math.floor(dist))
                        esp.Text.Position = Vector2.new(vector.X, (vector.Y - h/2) - 18)
                        esp.Text.Color = roleColor
                        esp.Text.Visible = true
                    else
                        esp.Box.Visible = false
                        esp.Text.Visible = false
                    end
                else
                    esp.Box.Visible = false
                    esp.Text.Visible = false
                end
            else
                if esp.Box then esp.Box.Visible = false end
                if esp.Text then esp.Text.Visible = false end
            end
        end
    end)
end)

-- ลูป Noclip
RunService.Stepped:Connect(function()
    if not scriptActive then return end
    if noclipEnabled then
        pcall(function()
            local character = LocalPlayer.Character
            if character then
                for _, part in ipairs(character:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = false
                    end
                end
            end
        end)
    end
end)

print("MM2 Somtank Clean & Secured Hub Loaded Successfully!")
