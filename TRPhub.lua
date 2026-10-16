-- [[ MM2 Mobile Script for Delta Executor ]] --
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- ป้องกันเปิดซ้ำ
if CoreGui:FindFirstChild("MM2_Mobile_UI") then
    CoreGui.MM2_Mobile_UI:Destroy()
end

-- สร้าง ScreenGui หลัก
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "MM2_Mobile_UI"
ScreenGui.Parent = CoreGui
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- 1. ไอคอนลอย (Floating Icon) สำหรับเปิด/ปิด UI (ปรับขนาดให้กดง่ายบนมือถือ)
local FloatingIcon = Instance.new("TextButton")
FloatingIcon.Name = "FloatingIcon"
FloatingIcon.Parent = ScreenGui
FloatingIcon.BackgroundColor3 = Color3.fromRGB(30, 30, 45)
FloatingIcon.Position = UDim2.new(0, 20, 0.4, 0)
FloatingIcon.Size = UDim2.new(0, 55, 0, 55)
FloatingIcon.Font = Enum.Font.FredokaOne
FloatingIcon.Text = "MM2"
FloatingIcon.TextColor3 = Color3.fromRGB(0, 255, 200)
FloatingIcon.TextSize = 16
FloatingIcon.AutoButtonColor = true

local IconCorner = Instance.new("UICorner")
IconCorner.CornerRadius = UDim.new(1, 0)
IconCorner.Parent = FloatingIcon

local IconStroke = Instance.new("UIStroke")
IconStroke.Color = Color3.fromRGB(0, 255, 200)
IconStroke.Thickness = 2
IconStroke.Parent = FloatingIcon

-- 2. หน้าต่าง UI หลัก (Main Frame)
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
MainFrame.Position = UDim2.new(0.5, -160, 0.5, -140)
MainFrame.Size = UDim2.new(0, 320, 0, 280)
MainFrame.Visible = false

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 12)
MainCorner.Parent = MainFrame

local MainStroke = Instance.new("UIStroke")
MainStroke.Color = Color3.fromRGB(40, 40, 60)
MainStroke.Thickness = 2
MainStroke.Parent = MainFrame

-- 3. แถบหัวข้อ UI (TopBar)
local TopBar = Instance.new("Frame")
TopBar.Name = "TopBar"
TopBar.Parent = MainFrame
TopBar.BackgroundColor3 = Color3.fromRGB(25, 25, 40)
TopBar.Size = UDim2.new(1, 0, 0, 45)

local TopCorner = Instance.new("UICorner")
TopCorner.CornerRadius = UDim.new(0, 12)
TopCorner.Parent = TopBar

local Title = Instance.new("TextLabel")
Title.Parent = TopBar
Title.BackgroundTransparency = 1
Title.Position = UDim2.new(0, 15, 0, 0)
Title.Size = UDim2.new(0.8, 0, 1, 0)
Title.Font = Enum.Font.SourceSansBold
Title.Text = "MM2 Mobile Menu"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 18
Title.TextXAlignment = Enum.TextXAlignment.Left

-- 4. ปุ่มกากบาท (Close Button) มุมขวาบน สำหรับปิดระบบทั้งหมด
local CloseButton = Instance.new("TextButton")
CloseButton.Name = "CloseButton"
CloseButton.Parent = TopBar
CloseButton.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
CloseButton.Position = UDim2.new(1, -40, 0.5, -14)
CloseButton.Size = UDim2.new(0, 28, 0, 28)
CloseButton.Font = Enum.Font.SourceSansBold
CloseButton.Text = "X"
CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseButton.TextSize = 16

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0, 8)
CloseCorner.Parent = CloseButton

-- 5. ตัวเลือกเปิดปิด ESP
local ToggleContainer = Instance.new("Frame")
ToggleContainer.Parent = MainFrame
ToggleContainer.BackgroundTransparency = 1
ToggleContainer.Position = UDim2.new(0, 15, 0, 65)
ToggleContainer.Size = UDim2.new(1, -30, 0, 45)

local ToggleLabel = Instance.new("TextLabel")
ToggleLabel.Parent = ToggleContainer
ToggleLabel.BackgroundTransparency = 1
ToggleLabel.Size = UDim2.new(0.7, 0, 1, 0)
ToggleLabel.Font = Enum.Font.SourceSans
ToggleLabel.Text = "Enable Role ESP"
ToggleLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
ToggleLabel.TextSize = 16
ToggleLabel.TextXAlignment = Enum.TextXAlignment.Left

local ToggleButton = Instance.new("TextButton")
ToggleButton.Parent = ToggleContainer
ToggleButton.BackgroundColor3 = Color3.fromRGB(0, 255, 100)
ToggleButton.Position = UDim2.new(1, -55, 0.5, -14)
ToggleButton.Size = UDim2.new(0, 55, 0, 28)
ToggleButton.Font = Enum.Font.SourceSansBold
ToggleButton.Text = "ON"
ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleButton.TextSize = 14

local ToggleCorner = Instance.new("UICorner")
ToggleCorner.CornerRadius = UDim.new(1, 0)
ToggleCorner.Parent = ToggleButton

-- 6. ตัวเลือกเปิดปิด Aura Kill (200m)
local AuraContainer = Instance.new("Frame")
AuraContainer.Parent = MainFrame
AuraContainer.BackgroundTransparency = 1
AuraContainer.Position = UDim2.new(0, 15, 0, 125)
AuraContainer.Size = UDim2.new(1, -30, 0, 45)

local AuraLabel = Instance.new("TextLabel")
AuraLabel.Parent = AuraContainer
AuraLabel.BackgroundTransparency = 1
AuraLabel.Size = UDim2.new(0.7, 0, 1, 0)
AuraLabel.Font = Enum.Font.SourceSans
AuraLabel.Text = "Aura Kill (200m)"
AuraLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
AuraLabel.TextSize = 16
AuraLabel.TextXAlignment = Enum.TextXAlignment.Left

local AuraButton = Instance.new("TextButton")
AuraButton.Parent = AuraContainer
AuraButton.BackgroundColor3 = Color3.fromRGB(0, 255, 100)
AuraButton.Position = UDim2.new(1, -55, 0.5, -14)
AuraButton.Size = UDim2.new(0, 55, 0, 28)
AuraButton.Font = Enum.Font.SourceSansBold
AuraButton.Text = "ON"
AuraButton.TextColor3 = Color3.fromRGB(255, 255, 255)
AuraButton.TextSize = 14

local AuraCorner = Instance.new("UICorner")
AuraCorner.CornerRadius = UDim.new(1, 0)
AuraCorner.Parent = AuraButton

-- สถานะสวิตช์
local espEnabled = true
local auraEnabled = true

ToggleButton.MouseButton1Click:Connect(function()
    espEnabled = not espEnabled
    ToggleButton.Text = espEnabled and "ON" or "OFF"
    ToggleButton.BackgroundColor3 = espEnabled and Color3.fromRGB(0, 255, 100) or Color3.fromRGB(100, 100, 100)
end)

AuraButton.MouseButton1Click:Connect(function()
    auraEnabled = not auraEnabled
    AuraButton.Text = auraEnabled and "ON" or "OFF"
    AuraButton.BackgroundColor3 = auraEnabled and Color3.fromRGB(0, 255, 100) or Color3.fromRGB(100, 100, 100)
end)

-- กดไอคอนลอยเพื่อเปิด/ปิดหน้าต่าง UI
FloatingIcon.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
end)

-- ระบบลากไอคอนลอยผ่านหน้าจอสัมผัสมือถือ (Touch-Friendly)
local dragging, dragStart, startPos
FloatingIcon.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = FloatingIcon.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        FloatingIcon.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

-- ฟังก์ชันเช็คบทบาท
local function getRole(player)
    local backpack = player:FindFirstChild("Backpack")
    local character = player.Character
    
    if not character then return "Innocent", Color3.fromRGB(0, 255, 0) end

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
end

-- เงื่อนไขการมองเห็น ESP
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

-- ESP Cache & Setup
local espCache = {}
local function createESP(player)
    if player == LocalPlayer then return end

    local box = Drawing.new("Square")
    box.Visible = false
    box.Color = Color3.fromRGB(255, 255, 255)
    box.Thickness = 1.5
    box.Filled = false

    local text = Drawing.new("Text")
    text.Visible = false
    text.Center = true
    text.Outline = true
    text.Color = Color3.fromRGB(255, 255, 255)
    text.Size = 16

    espCache[player] = {Box = box, Text = text}

    local function removeESP()
        if espCache[player] then
            espCache[player].Box:Remove()
            espCache[player].Text:Remove()
            espCache[player] = nil
        end
    end

    player.CharacterRemoving:Connect(removeESP)
    player.Destroying:Connect(removeESP)
end

for _, player in ipairs(Players:GetPlayers()) do
    createESP(player)
end

local playerAddedConn = Players.PlayerAdded:Connect(createESP)
local playerRemovingConn = Players.PlayerRemoving:Connect(function(player)
    if espCache[player] then
        espCache[player].Box:Remove()
        espCache[player].Text:Remove()
        espCache[player] = nil
    end
end)

-- ระบบ Aura Kill (เมื่อคลิกฟันมีด รัศมี 200 เมตร)
local toolActivatedConn
local function setupAuraKill()
    local character = LocalPlayer.Character
    if not character then return end
    
    local knife = character:FindFirstChild("Knife")
    if knife then
        if toolActivatedConn then toolActivatedConn:Disconnect() end
        
        toolActivatedConn = knife.Activated:Connect(function()
            if not auraEnabled then return end
            local myRole, _ = getRole(LocalPlayer)
            if myRole ~= "Murderer" then return end
            
            local myRoot = character:FindFirstChild("HumanoidRootPart")
            if not myRoot then return end
            
            for _, player in ipairs(Players:GetPlayers()) do
                if player ~= LocalPlayer then
                    local targetChar = player.Character
                    local targetRoot = targetChar and targetChar:FindFirstChild("HumanoidRootPart")
                    local targetHum = targetChar and targetChar:FindFirstChild("Humanoid")
                    
                    if targetRoot and targetHum and targetHum.Health > 0 then
                        local distance = (myRoot.Position - targetRoot.Position).Magnitude
                        if distance <= 200 then
                            pcall(function()
                                firetouchinterest(targetRoot, knife.Handle, 0)
                                firetouchinterest(targetRoot, knife.Handle, 1)
                            end)
                        end
                    end
                end
            end
        end)
    end
end

LocalPlayer.CharacterAdded:Connect(function(newChar)
    newChar.ChildAdded:Connect(function(child)
        if child.Name == "Knife" then
            task.wait(0.5)
            setupAuraKill()
        end
    end)
end)

if LocalPlayer.Character then
    setupAuraKill()
end

-- ลูป Render สำหรับ ESP
local runConnection = RunService.RenderStepped:Connect(function()
    if not espEnabled then
        for _, esp in pairs(espCache) do
            esp.Box.Visible = false
            esp.Text.Visible = false
        end
        return
    end

    local myRole, _ = getRole(LocalPlayer)

    for player, esp in pairs(espCache) do
        local character = player.Character
        local humanoidRootPart = character and character:FindFirstChild("HumanoidRootPart")
        local humanoid = character and character:FindFirstChild("Humanoid")

        if character and humanoidRootPart and humanoid and humanoid.Health > 0 then
            local targetRole, roleColor = getRole(player)
            
            if canSeeRole(myRole, targetRole) then
                local vector, onScreen = Camera:WorldToViewportPoint(humanoidRootPart.Position)

                if onScreen then
                    local distance = (Camera.CFrame.Position - humanoidRootPart.Position).Magnitude
                    local head = character:FindFirstChild("Head")
                    local boxHeight = head and math.abs(Camera:WorldToViewportPoint(head.Position + Vector3.new(0, 0.5, 0)).Y - Camera:WorldToViewportPoint(humanoidRootPart.Position - Vector3.new(0, 3, 0)).Y) or 50
                    local boxWidth = boxHeight / 2

                    esp.Box.Size = Vector2.new(boxWidth, boxHeight)
                    esp.Box.Position = Vector2.new(vector.X - boxWidth / 2, vector.Y - boxHeight / 2)
                    esp.Box.Color = roleColor
                    esp.Box.Visible = true

                    esp.Text.Text = string.format("[%s] [%dm]", targetRole, math.floor(distance))
                    esp.Text.Position = Vector2.new(vector.X, (vector.Y - boxHeight / 2) - 20)
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
            esp.Box.Visible = false
            esp.Text.Visible = false
        end
    end
end)

-- ปุ่มกากบาท (Close Button) มุมขวาบน สำหรับปิดและลบระบบทั้งหมด
CloseButton.MouseButton1Click:Connect(function()
    if runConnection then runConnection:Disconnect() end
    if playerAddedConn then playerAddedConn:Disconnect() end
    if playerRemovingConn then playerRemovingConn:Disconnect() end
    if toolActivatedConn then toolActivatedConn:Disconnect() end

    for _, esp in pairs(espCache) do
        if esp.Box then esp.Box:Remove() end
        if esp.Text then esp.Text:Remove() end
    end
    espCache = {}

    ScreenGui:Destroy()
end)
