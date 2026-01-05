local LP = game.Players.LocalPlayer
local UIS = game:GetService("UserInputService")
local RS = game:GetService("RunService")
local TS = game:GetService("TweenService")
local Mouse = LP:GetMouse()

local ScreenGui = Instance.new("ScreenGui", LP.PlayerGui)
ScreenGui.Name = "Venom_V18_Final"
ScreenGui.ResetOnSpawn = false

-- Хранилище
_G.Flags = {}
_G.SavedPos = nil

-- ГЛАВНОЕ ОКНО (Glassmorphism)
local Main = Instance.new("Frame", ScreenGui)
Main.Size = UDim2.new(0, 620, 0, 430)
Main.Position = UDim2.new(0.5, -310, 0.5, -215)
Main.BackgroundColor3 = Color3.fromRGB(10, 10, 12)
Main.BackgroundTransparency = 0.15
Main.BorderSizePixel = 0
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 12)

local Stroke = Instance.new("UIStroke", Main)
Stroke.Thickness = 1.5
Stroke.Color = Color3.fromRGB(0, 255, 150)
Stroke.Transparency = 0.3

-- САЙДБАР (Скролл вкладок)
local Sidebar = Instance.new("ScrollingFrame", Main)
Sidebar.Size = UDim2.new(0, 160, 1, -20)
Sidebar.Position = UDim2.new(0, 10, 0, 10)
Sidebar.BackgroundTransparency = 1
Sidebar.CanvasSize = UDim2.new(0, 0, 1.2, 0)
Sidebar.ScrollBarThickness = 0
local SideLayout = Instance.new("UIListLayout", Sidebar)
SideLayout.Padding = UDim.new(0, 6)

local Container = Instance.new("Frame", Main)
Container.Size = UDim2.new(1, -190, 1, -20)
Container.Position = UDim2.new(0, 180, 0, 10)
Container.BackgroundTransparency = 1

local Pages = {}

-- Создание плавающей кнопки для мобайл
local function CreateFloat(name, callback)
    local F = Instance.new("TextButton", ScreenGui)
    F.Size = UDim2.new(0, 90, 0, 35)
    F.Position = UDim2.new(0.2, 0, 0.2, 0)
    F.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    F.BackgroundTransparency = 0.2
    F.Text = name
    F.TextColor3 = Color3.fromRGB(0, 255, 150)
    F.Font = "GothamBold"
    F.TextSize = 11
    F.Visible = false
    Instance.new("UICorner", F).CornerRadius = UDim.new(0, 8)
    Instance.new("UIStroke", F).Color = Color3.fromRGB(0, 255, 150)

    -- Dragging
    local dragStart, startPos, dragging
    F.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true; dragStart = input.Position; startPos = F.Position
        end
    end)
    F.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            F.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
    F.InputEnded:Connect(function() dragging = false end)
    F.MouseButton1Click:Connect(callback)
    return F
end

local function AddPage(name)
    local P = Instance.new("ScrollingFrame", Container)
    P.Size = UDim2.new(1, 0, 1, 0)
    P.BackgroundTransparency = 1
    P.Visible = false
    P.ScrollBarThickness = 0
    Instance.new("UIListLayout", P).Padding = UDim.new(0, 8)
    
    local B = Instance.new("TextButton", Sidebar)
    B.Size = UDim2.new(1, -10, 0, 38)
    B.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    B.Text = name
    B.TextColor3 = Color3.fromRGB(200, 200, 200)
    B.Font = "GothamBold"
    Instance.new("UICorner", B)
    
    B.MouseButton1Click:Connect(function()
        for _,pg in pairs(Pages) do pg.Visible = false end
        for _,btn in pairs(Sidebar:GetChildren()) do if btn:IsA("TextButton") then btn.TextColor3 = Color3.fromRGB(200,200,200) end end
        P.Visible = true
        B.TextColor3 = Color3.fromRGB(0, 255, 150)
    end)
    Pages[name] = P
    return P
end

-- Кнопка (Функция)
local function AddFunc(page, name, isToggle, callback)
    local Frame = Instance.new("Frame", page)
    Frame.Size = UDim2.new(1, -5, 0, 45)
    Frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    Frame.BackgroundTransparency = 0.6
    Instance.new("UICorner", Frame)

    local MainBtn = Instance.new("TextButton", Frame)
    MainBtn.Size = UDim2.new(0.75, 0, 1, 0)
    MainBtn.BackgroundTransparency = 1
    MainBtn.Text = "  " .. name .. (isToggle and ": OFF" or "")
    MainBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    MainBtn.Font = "Gotham"
    MainBtn.TextXAlignment = "Left"
    MainBtn.TextSize = 13

    local float = CreateFloat(name, function()
        if isToggle then
            _G.Flags[name] = not _G.Flags[name]
            MainBtn.Text = "  " .. name .. ": " .. (_G.Flags[name] and "ON" or "OFF")
            callback(_G.Flags[name])
        else
            callback()
        end
    end)

    local Pin = Instance.new("TextButton", Frame)
    Pin.Size = UDim2.new(0.2, 0, 0.7, 0)
    Pin.Position = UDim2.new(0.78, 0, 0.15, 0)
    Pin.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    Pin.Text = "PIN"
    Pin.Font = "GothamBold"
    Pin.TextSize = 10
    Pin.TextColor3 = Color3.fromRGB(255, 255, 255)
    Instance.new("UICorner", Pin)

    Pin.MouseButton1Click:Connect(function()
        float.Visible = not float.Visible
        Pin.BackgroundColor3 = float.Visible and Color3.fromRGB(0, 255, 150) or Color3.fromRGB(45, 45, 45)
    end)

    MainBtn.MouseButton1Click:Connect(function()
        if isToggle then
            _G.Flags[name] = not _G.Flags[name]
            MainBtn.Text = "  " .. name .. ": " .. (_G.Flags[name] and "ON" or "OFF")
            callback(_G.Flags[name])
        else
            callback()
        end
    end)
end

-- ==========================================
-- КАТЕГОРИИ И ФУНКЦИИ
-- ==========================================

local Combat = AddPage("Combat")
AddFunc(Combat, "Anti-Knockback", true, function(v) _G.AntiKB = v end)
AddFunc(Combat, "Auto-Clicker", true, function(v) _G.AC = v end)
AddFunc(Combat, "Kill Aura (Legit)", true, function(v) _G.Aura = v end)
AddFunc(Combat, "Reach (Melee)", true, function(v) _G.Reach = v end)
AddFunc(Combat, "Hitbox Head", true, function(v) 
    for _,p in pairs(game.Players:GetPlayers()) do if p.Character then p.Character.Head.Size = v and Vector3.new(4,4,4) or Vector3.new(1,1,1) end end
end)

local Move = AddPage("Movement")
AddFunc(Move, "Noclip", true, function(v) _G.Noclip = v end)
AddFunc(Move, "Infinite Jump", true, function(v) _G.InfJ = v end)
AddFunc(Move, "Fly (Hold E)", true, function(v) _G.Fly = v end)
AddFunc(Move, "Speed Hack (100)", true, function(v) LP.Character.Humanoid.WalkSpeed = v and 100 or 16 end)
AddFunc(Move, "Jump Power (200)", true, function(v) LP.Character.Humanoid.JumpPower = v and 200 or 50 end)
AddFunc(Move, "No-Slowdown", true, function(v) _G.NoSlow = v end)
AddFunc(Move, "Spider-Man", true, function(v) _G.Spider = v end)

local TP = AddPage("Teleports")
AddFunc(TP, "Save Position", false, function() _G.SavedPos = LP.Character.HumanoidRootPart.CFrame; print("Saved!") end)
AddFunc(TP, "TP to Saved", false, function() if _G.SavedPos then LP.Character.HumanoidRootPart.CFrame = _G.SavedPos end end)
AddFunc(TP, "Click TP (Ctrl)", true, function(v) _G.ClickTP = v end)
AddFunc(TP, "TP to Random Player", false, function() 
    local plrs = game.Players:GetPlayers()
    local r = plrs[math.random(1, #plrs)]
    LP.Character.HumanoidRootPart.CFrame = r.Character.HumanoidRootPart.CFrame
end)

local Visuals = AddPage("Visuals")
AddFunc(Visuals, "ESP Highlight", true, function(v) _G.ESP = v end)
AddFunc(Visuals, "Fullbright", true, function(v) game.Lighting.Brightness = v and 4 or 2 end)
AddFunc(Visuals, "Remove Textures", false, function() for _,v in pairs(workspace:GetDescendants()) do if v:IsA("BasePart") then v.Material = "SmoothPlastic" end end end)
AddFunc(Visuals, "Third Person", true, function(v) LP.CameraMaxZoomDistance = v and 100 or 12.8 end)
AddFunc(Visuals, "Rainbow Character", true, function(v) _G.Rainbow = v end)

local Misc = AddPage("Misc")
AddFunc(Misc, "Anti-AFK", true, function() LP.Idled:Connect(function() game:GetService("VirtualUser"):Button2Down(Vector2.new(0,0),workspace.CurrentCamera.CFrame) end) end)
AddFunc(Misc, "Rejoin Server", false, function() game:GetService("TeleportService"):Teleport(game.PlaceId, LP) end)
AddFunc(Misc, "Infinite Yield", false, function() loadstring(game:HttpGet('https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source'))() end)
AddFunc(Misc, "Reset Character", false, function() LP.Character:BreakJoints() end)
AddFunc(Misc, "Server Hop", false, function() end)

-- ==========================================
-- ЛОГИКА (RunService)
-- ==========================================

RS.Stepped:Connect(function()
    if _G.Noclip and LP.Character then
        for _,v in pairs(LP.Character:GetDescendants()) do if v:IsA("BasePart") then v.CanCollide = false end end
    end
    if _G.AntiKB and LP.Character and LP.Character:FindFirstChild("HumanoidRootPart") then
        local r = LP.Character.HumanoidRootPart
        r.AssemblyLinearVelocity = Vector3.new(0, UIS:IsKeyDown(Enum.KeyCode.Space) and r.AssemblyLinearVelocity.Y or 0, 0)
        r.AssemblyAngularVelocity = Vector3.new(0,0,0)
    end
    if _G.Fly and LP.Character and UIS:IsKeyDown(Enum.KeyCode.E) then
        LP.Character.HumanoidRootPart.Velocity = Vector3.new(0, 50, 0)
    end
end)

UIS.JumpRequest:Connect(function() if _G.InfJ then LP.Character.Humanoid:ChangeState("Jumping") end end)

UIS.InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.Insert then ScreenGui.Enabled = not ScreenGui.Enabled end
    if _G.ClickTP and input.UserInputType == Enum.UserInputType.MouseButton1 and UIS:IsKeyDown(Enum.KeyCode.LeftControl) then
        LP.Character.HumanoidRootPart.CFrame = CFrame.new(Mouse.Hit.p + Vector3.new(0,3,0))
    end
end)

-- Автокликер
RS.RenderStepped:Connect(function()
    if _G.AC then
        local t = LP.Character:FindFirstChildOfClass("Tool")
        if t then t:Activate() end
    end
end)

-- Драг меню
local dStart, sPos, dragging
Main.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true; dStart = input.Position; sPos = Main.Position
    end
end)
UIS.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dStart
        Main.Position = UDim2.new(sPos.X.Scale, sPos.X.Offset + delta.X, sPos.Y.Scale, sPos.Y.Offset + delta.Y)
    end
end)
UIS.InputEnded:Connect(function() dragging = false end)

Pages["Combat"].Visible = true
print("Venom V18 Loaded! Mobile & PC support active.")
