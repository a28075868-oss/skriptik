local Players = game:GetService("Players")
local RS = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local TS = game:GetService("TweenService")
local TeleportService = game:GetService("TeleportService")
local Lighting = game:GetService("Lighting")

local LP = Players.LocalPlayer
local CorrectKey = "VENOMBYPPAS"
local Authenticated = false

local Config = {
    Flags = {},
    FlyHeight = 13,
    SpeedValue = 0.7,
    AuraRadius = 35,
    HitboxSize = 25
}

-- ЦВЕТА
local AccentColor = Color3.fromRGB(0, 191, 255)
local BgColor = Color3.fromRGB(15, 15, 18)
local SectionBg = Color3.fromRGB(25, 25, 30)

-- УТИЛИТЫ
local function Create(class, props)
    local obj = Instance.new(class)
    for i, v in pairs(props) do obj[i] = v end
    return obj
end

local function Tween(obj, goal, time)
    TS:Create(obj, TweenInfo.new(time or 0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), goal):Play()
end

local ScreenGui = Create("ScreenGui", {Parent = LP.PlayerGui, ResetOnSpawn = false, Name = "VenomUI"})

-- === ИСПРАВЛЕННАЯ ВАТЕРМАРКА (В САМОМ ВЕРХУ) ===
local Watermark = Create("Frame", {
    Parent = ScreenGui,
    Size = UDim2.new(0, 180, 0, 32),
    Position = UDim2.new(1, -185, 0, 5), -- Поднята в самый верх
    BackgroundColor3 = BgColor,
    ZIndex = 100,
    BorderSizePixel = 0
})
Create("UICorner", {Parent = Watermark, CornerRadius = UDim.new(0, 6)})
Create("UIStroke", {Parent = Watermark, Color = AccentColor, Thickness = 2})

local WatermarkText = Create("TextLabel", {
    Parent = Watermark,
    Size = UDim2.new(1, 0, 1, 0),
    Text = "VENOM PREMIUM",
    TextColor3 = AccentColor,
    Font = "GothamBold",
    TextSize = 14,
    BackgroundTransparency = 1,
    ZIndex = 101
})

-- === СИСТЕМА УВЕДОМЛЕНИЙ (ДЛЯ ВХОДА И СПЕЦ. ФУНКЦИЙ) ===
local NotifContainer = Create("Frame", {
    Parent = ScreenGui,
    Size = UDim2.new(0, 250, 0.8, 0),
    Position = UDim2.new(1, -260, 0, 45), -- Сразу под ватермаркой
    BackgroundTransparency = 1
})
local UIList = Create("UIListLayout", {
    Parent = NotifContainer,
    Padding = UDim.new(0, 8),
    VerticalAlignment = "Top",
    HorizontalAlignment = "Right"
})

local function Notify(text)
    local n = Create("Frame", {
        Parent = NotifContainer,
        Size = UDim2.new(0, 250, 0, 45),
        BackgroundColor3 = BgColor,
        Position = UDim2.new(1, 300, 0, 0)
    })
    Create("UICorner", {Parent = n, CornerRadius = UDim.new(0, 10)})
    Create("UIStroke", {Parent = n, Color = AccentColor, Thickness = 2})
    
    local t = Create("TextLabel", {
        Parent = n,
        Size = UDim2.new(1, -20, 1, 0),
        Position = UDim2.new(0, 10, 0, 0),
        Text = text,
        TextColor3 = Color3.new(1,1,1),
        Font = "GothamBold",
        TextSize = 14,
        BackgroundTransparency = 1,
        TextXAlignment = "Left"
    })

    n:TweenPosition(UDim2.new(0, 0, 0, 0), "Out", "Quart", 0.4, true)
    
    task.delay(3, function()
        local tw = TS:Create(n, TweenInfo.new(0.4, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {Position = UDim2.new(1, 300, 0, 0)})
        tw:Play()
        tw.Completed:Connect(function() n:Destroy() end)
    end)
end

-- ОКНО КЛЮЧА
local KeyMain = Create("Frame", {
    Parent = ScreenGui,
    Size = UDim2.new(0, 350, 0, 220),
    Position = UDim2.new(0.5, -175, 0.5, -110),
    BackgroundColor3 = BgColor,
    Active = true
})
Create("UICorner", {Parent = KeyMain, CornerRadius = UDim.new(0, 15)})
Create("UIStroke", {Parent = KeyMain, Color = AccentColor, Thickness = 2})

local KeyInput = Create("TextBox", {
    Parent = KeyMain, Size = UDim2.new(0, 280, 0, 50),
    Position = UDim2.new(0.5, -140, 0.4, 0),
    BackgroundColor3 = SectionBg, TextColor3 = Color3.new(1,1,1),
    PlaceholderText = "ENTER KEY...", Font = "GothamBold", TextSize = 16, Text = ""
})
Create("UICorner", {Parent = KeyInput})

local KeyBtn = Create("TextButton", {
    Parent = KeyMain, Size = UDim2.new(0, 280, 0, 50),
    Position = UDim2.new(0.5, -140, 0.75, 0),
    BackgroundColor3 = AccentColor, Text = "LOGIN",
    TextColor3 = Color3.new(1,1,1), Font = "GothamBold", TextSize = 18
})
Create("UICorner", {Parent = KeyBtn})

-- ГЛАВНОЕ МЕНЮ
local Main = Create("Frame", {
    Parent = ScreenGui,
    Size = UDim2.new(0, 580, 0, 420),
    Position = UDim2.new(0.5, -290, 0.5, -210),
    BackgroundColor3 = BgColor,
    Visible = false,
    ClipsDescendants = true
})
Create("UICorner", {Parent = Main, CornerRadius = UDim.new(0, 15)})
local MStroke = Create("UIStroke", {Parent = Main, Color = AccentColor, Thickness = 2})

local Sidebar = Create("Frame", {Parent = Main, Size = UDim2.new(0, 170, 1, 0), BackgroundColor3 = Color3.fromRGB(20,20,25)})
Create("UICorner", {Parent = Sidebar, CornerRadius = UDim.new(0, 15)})

local LogoBtn = Create("TextButton", {
    Parent = Sidebar, Size = UDim2.new(1, 0, 0, 70),
    Text = "VENOM V18", TextColor3 = AccentColor,
    Font = "GothamBold", TextSize = 24, BackgroundTransparency = 1
})

local PageHolder = Create("Frame", {Parent = Main, Size = UDim2.new(1, -190, 1, -20), Position = UDim2.new(0, 180, 0, 10), BackgroundTransparency = 1})
local TabHolder = Create("Frame", {Parent = Sidebar, Size = UDim2.new(1, 0, 1, -80), Position = UDim2.new(0, 0, 0, 80), BackgroundTransparency = 1})
Create("UIListLayout", {Parent = TabHolder, Padding = UDim.new(0, 8), HorizontalAlignment = "Center"})

-- FINDER GUI
local FinderMini = Create("Frame", {
    Parent = ScreenGui, Size = UDim2.new(0, 250, 0, 150),
    Position = UDim2.new(0.5, 300, 0.5, -75),
    BackgroundColor3 = BgColor, Visible = false
})
Create("UICorner", {Parent = FinderMini, CornerRadius = UDim.new(0, 15)})
Create("UIStroke", {Parent = FinderMini, Color = AccentColor, Thickness = 2})

local FInput = Create("TextBox", {Parent = FinderMini, Size = UDim2.new(0, 210, 0, 40), Position = UDim2.new(0.5, -105, 0.4, 0), BackgroundColor3 = SectionBg, TextColor3 = Color3.new(1,1,1), PlaceholderText = "PLAYER NICK...", Font = "GothamBold", TextSize = 14, Text = ""})
Create("UICorner", {Parent = FInput})

local FBtn = Create("TextButton", {Parent = FinderMini, Size = UDim2.new(0, 210, 0, 40), Position = UDim2.new(0.5, -105, 0.75, 0), BackgroundColor3 = AccentColor, Text = "JOIN PLAYER", TextColor3 = Color3.new(1,1,1), Font = "GothamBold", TextSize = 14})
Create("UICorner", {Parent = FBtn})

-- ЛОГИКА СВОРАЧИВАНИЯ
local Collapsed = false
LogoBtn.MouseButton1Click:Connect(function()
    Collapsed = not Collapsed
    if Collapsed then
        Tween(Main, {Size = UDim2.new(0, 580, 0, 70)})
        PageHolder.Visible = false
    else
        Tween(Main, {Size = UDim2.new(0, 580, 0, 420)})
        PageHolder.Visible = true
    end
end)

-- СИСТЕМА ВКЛАДОК
local Pages = {}
local function CreatePage(name)
    local p = Create("ScrollingFrame", {Parent = PageHolder, Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1, Visible = false, ScrollBarThickness = 0})
    Create("UIListLayout", {Parent = p, Padding = UDim.new(0, 10)})
    Pages[name] = p
    local b = Create("TextButton", {Parent = TabHolder, Size = UDim2.new(0, 150, 0, 45), BackgroundColor3 = SectionBg, Text = name, TextColor3 = Color3.new(0.8,0.8,0.8), Font = "GothamBold", TextSize = 14})
    Create("UICorner", {Parent = b, CornerRadius = UDim.new(0, 10)})
    b.MouseButton1Click:Connect(function()
        for _, pg in pairs(Pages) do pg.Visible = false end
        for _, btn in pairs(TabHolder:GetChildren()) do if btn:IsA("TextButton") then Tween(btn, {BackgroundColor3 = SectionBg}) end end
        p.Visible = true; Tween(b, {BackgroundColor3 = AccentColor})
    end)
    return p
end

local CombatPg = CreatePage("COMBAT")
local MovePg = CreatePage("MOVEMENT")
local VisualPg = CreatePage("VISUAL")
local MiscPg = CreatePage("MISC")
local FinderPg = CreatePage("FINDER")

local function AddToggle(name, page, callback)
    local f = Create("Frame", {Parent = page, Size = UDim2.new(1, -10, 0, 55), BackgroundColor3 = SectionBg})
    Create("UICorner", {Parent = f, CornerRadius = UDim.new(0, 12)})
    local t = Create("TextLabel", {Parent = f, Size = UDim2.new(1, -70, 1, 0), Position = UDim2.new(0, 20, 0, 0), Text = name, TextColor3 = Color3.new(1,1,1), Font = "GothamBold", TextSize = 16, TextXAlignment = "Left", BackgroundTransparency = 1})
    local btn = Create("TextButton", {Parent = f, Size = UDim2.new(0, 50, 0, 26), Position = UDim2.new(1, -65, 0.5, -13), BackgroundColor3 = Color3.fromRGB(40,40,45), Text = ""})
    Create("UICorner", {Parent = btn, CornerRadius = UDim.new(1, 0)})
    local circ = Create("Frame", {Parent = btn, Size = UDim2.new(0, 22, 0, 22), Position = UDim2.new(0, 2, 0.5, -11), BackgroundColor3 = Color3.new(1,1,1)})
    Create("UICorner", {Parent = circ, CornerRadius = UDim.new(1, 0)})

    btn.MouseButton1Click:Connect(function()
        Config.Flags[name] = not Config.Flags[name]
        Tween(circ, {Position = Config.Flags[name] and UDim2.new(1, -24, 0.5, -11) or UDim2.new(0, 2, 0.5, -11)})
        Tween(btn, {BackgroundColor3 = Config.Flags[name] and AccentColor or Color3.fromRGB(40,40,45)})
        
        -- Уведомления отсюда убраны
        callback(Config.Flags[name])
    end)
end

-- НАПОЛНЕНИЕ
AddToggle("Kill Aura", CombatPg, function() end)
AddToggle("God Mode", CombatPg, function() end)
AddToggle("Fly Mode", MovePg, function() end)
AddToggle("Speed Stealth", MovePg, function() end)
AddToggle("Anti-Knockback", MovePg, function() end)
AddToggle("Infinite Jump", MovePg, function() end)
AddToggle("Fullbright", VisualPg, function(v)
    Lighting.Brightness = v and 2 or 1
    Lighting.GlobalShadows = not v
end)
AddToggle("Custom Fog", VisualPg, function(v)
    Lighting.FogEnd = v and 500 or 100000
    Lighting.FogColor = AccentColor
end)
AddToggle("ESP Boxes", VisualPg, function() end)
AddToggle("Tracers", VisualPg, function() end)
AddToggle("Server Bypass", MiscPg, function() end)
AddToggle("Noclip Master", MiscPg, function() end)
AddToggle("Fast Steal (E)", MiscPg, function() end)
AddToggle("Anti-Stun", MiscPg, function() end)
AddToggle("Finder UI", FinderPg, function(v) FinderMini.Visible = v end)
AddToggle("Brainrot Finder", FinderPg, function(v) if v then Notify("Brainrot Finder: Available in Beta!") end end)

-- ЛОГИКА ВХОДА И ПЕРЕТАСКИВАНИЯ
KeyBtn.MouseButton1Click:Connect(function()
    if KeyInput.Text == CorrectKey then
        Tween(KeyMain, {Size = UDim2.new(0,0,0,0), Transparency = 1})
        task.wait(0.4); KeyMain.Visible = false; Main.Visible = true; CombatPg.Visible = true; Authenticated = true
        Notify("Authenticated! Welcome to VENOM.")
    else
        KeyBtn.Text = "WRONG KEY"; task.wait(1); KeyBtn.Text = "LOGIN"
    end
end)

FBtn.MouseButton1Click:Connect(function()
    local name = FInput.Text
    if name ~= "" then
        pcall(function()
            local id = Players:GetUserIdFromNameAsync(name)
            TeleportService:Teleport(game.PlaceId, LP, {id})
        end)
    end
end)

local function Drag(f)
    local d, ds, sp
    f.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then d=true; ds=i.Position; sp=f.Position end end)
    UIS.InputChanged:Connect(function(i) if d and i.UserInputType == Enum.UserInputType.MouseMovement then local del=i.Position-ds; f.Position=UDim2.new(sp.X.Scale, sp.X.Offset+del.X, sp.Y.Scale, sp.Y.Offset+del.Y) end end)
    UIS.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then d=false end end)
end
Drag(Main); Drag(KeyMain); Drag(FinderMini)

-- ЦИКЛ ФУНКЦИЙ
UIS.JumpRequest:Connect(function()
    if Config.Flags["Infinite Jump"] then
        LP.Character:FindFirstChildOfClass("Humanoid"):ChangeState("Jumping")
    end
end)

RS.Heartbeat:Connect(function()
    if not Authenticated then return end
    local char = LP.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    
    if Config.Flags["Fly Mode"] then
        local bp = hrp:FindFirstChild("VFly") or Create("BodyPosition", {Name = "VFly", Parent = hrp, MaxForce = Vector3.new(0, math.huge, 0), P = 15000})
        local ray = Ray.new(hrp.Position, Vector3.new(0, -100, 0))
        local _, hitPos = workspace:FindPartOnRay(ray, char)
        bp.Position = Vector3.new(0, (hitPos and hitPos.Y or 0) + Config.FlyHeight, 0)
        if Config.Flags["Speed Stealth"] and char.Humanoid.MoveDirection.Magnitude > 0 then
            hrp.CFrame = hrp.CFrame + (char.Humanoid.MoveDirection * Config.SpeedValue)
        end
    elseif hrp:FindFirstChild("VFly") then hrp.VFly:Destroy() end
    
    if Config.Flags["Anti-Knockback"] then hrp.Velocity = Vector3.new(0, hrp.Velocity.Y, 0) end
end)
