local Players = game:GetService("Players")
local RS = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local TS = game:GetService("TweenService")
local TeleportService = game:GetService("TeleportService")
local Lighting = game:GetService("Lighting")
local ProximityPromptService = game:GetService("ProximityPromptService")

local LP = Players.LocalPlayer
local KeysURL = "https://raw.githubusercontent.com/a28075868-oss/skriptik/main/keys.txt"
local Authenticated = false

-- ПЕРЕМЕННЫЕ STEAL
local pos1 = nil
local beam1, part1, beam2, part2
local targetPositions = {
    Vector3.new(-481.88, -3.79, 138.02), Vector3.new(-481.75, -3.79, 89.18),
    Vector3.new(-481.82, -3.79, 30.95), Vector3.new(-481.75, -3.79, -17.79),
    Vector3.new(-481.80, -3.79, -76.06), Vector3.new(-481.72, -3.79, -124.70),
    Vector3.new(-337.45, -3.85, -124.72), Vector3.new(-337.37, -3.85, -76.07),
    Vector3.new(-337.46, -3.79, -17.72), Vector3.new(-337.41, -3.79, 30.92),
    Vector3.new(-337.32, -3.79, 89.02), Vector3.new(-337.27, -3.79, 137.90),
    Vector3.new(-337.45, -3.79, 196.29), Vector3.new(-337.37, -3.79, 244.91),
    Vector3.new(-481.72, -3.79, 196.21), Vector3.new(-481.76, -3.79, 244.92)
}

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
local SuccessColor = Color3.fromRGB(46, 204, 113)
local JoinBtnColor = Color3.fromRGB(43, 125, 255)

-- УТИЛИТЫ
local function Create(class, props)
    local obj = Instance.new(class)
    for i, v in pairs(props) do obj[i] = v end
    return obj
end

local function Tween(obj, goal, time)
    TS:Create(obj, TweenInfo.new(time or 0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), goal):Play()
end

local function Drag(f)
    local d, ds, sp
    f.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then d=true; ds=i.Position; sp=f.Position end end)
    UIS.InputChanged:Connect(function(i) if d and i.UserInputType == Enum.UserInputType.MouseMovement then local del=i.Position-ds; f.Position=UDim2.new(sp.X.Scale, sp.X.Offset+del.X, sp.Y.Scale, sp.Y.Offset+del.Y) end end)
    UIS.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then d=false end end)
end

local function createBeam(position, color, index)
    if not LP.Character or not LP.Character:FindFirstChild("HumanoidRootPart") then return end
    local p = Instance.new("Part", workspace)
    p.Size = Vector3.new(1,1,1); p.Anchored = true; p.CanCollide = false; p.Transparency = 1; p.CFrame = CFrame.new(position)
    local a0 = Instance.new("Attachment", p)
    local a1 = Instance.new("Attachment", LP.Character.HumanoidRootPart)
    local b = Instance.new("Beam", workspace)
    b.Attachment0 = a0; b.Attachment1 = a1; b.Width0 = 0.1; b.Width1 = 0.1; b.Color = ColorSequence.new(color); b.FaceCamera = true
    if index == 1 then if beam1 then beam1:Destroy(); part1:Destroy() end; beam1, part1 = b, p
    else if beam2 then beam2:Destroy(); part2:Destroy() end; beam2, part2 = b, p end
end

local ScreenGui = Create("ScreenGui", {Parent = LP.PlayerGui, ResetOnSpawn = false, Name = "VenomUI_Ultimate"})

-- === УВЕДОМЛЕНИЯ ===
local NotifContainer = Create("Frame", {Parent = ScreenGui, Size = UDim2.new(0, 250, 0.8, 0), Position = UDim2.new(1, -260, 0, 45), BackgroundTransparency = 1})
Create("UIListLayout", {Parent = NotifContainer, Padding = UDim.new(0, 8), VerticalAlignment = "Top", HorizontalAlignment = "Right"})

local function Notify(text)
    local n = Create("Frame", {Parent = NotifContainer, Size = UDim2.new(0, 250, 0, 45), BackgroundColor3 = BgColor})
    Create("UICorner", {Parent = n, CornerRadius = UDim.new(0, 10)})
    Create("UIStroke", {Parent = n, Color = AccentColor, Thickness = 2})
    Create("TextLabel", {Parent = n, Size = UDim2.new(1, -20, 1, 0), Position = UDim2.new(0, 10, 0, 0), Text = text, TextColor3 = Color3.new(1,1,1), Font = "GothamBold", TextSize = 14, BackgroundTransparency = 1, TextXAlignment = "Left"})
    task.delay(3, function() n:Destroy() end)
end

-- === BRAINROT FINDER (ПО ФОТО 1 В 1) ===
local TF = Create("Frame", {Parent = ScreenGui, Size = UDim2.new(0, 720, 0, 500), Position = UDim2.new(0.5, -360, 0.5, -250), BackgroundColor3 = Color3.fromRGB(20, 20, 24), Visible = false, ZIndex = 50})
Create("UICorner", {Parent = TF, CornerRadius = UDim.new(0, 8)})
Drag(TF)

local TFHeader = Create("Frame", {Parent = TF, Size = UDim2.new(1, 0, 0, 60), BackgroundTransparency = 1, ZIndex = 51})
Create("TextLabel", {Parent = TFHeader, Size = UDim2.new(0, 300, 1, 0), Position = UDim2.new(0, 20, 0, 0), Text = "Pet Auto Joiner", TextColor3 = Color3.new(1,1,1), Font = "GothamBold", TextSize = 22, BackgroundTransparency = 1, TextXAlignment = "Left", ZIndex = 52})
local RunningTag = Create("Frame", {Parent = TFHeader, Size = UDim2.new(0, 110, 0, 34), Position = UDim2.new(1, -130, 0.5, -17), BackgroundColor3 = SuccessColor, ZIndex = 52})
Create("UICorner", {Parent = RunningTag, CornerRadius = UDim.new(0, 6)})
Create("TextLabel", {Parent = RunningTag, Size = UDim2.new(1, 0, 1, 0), Text = "RUNNING", TextColor3 = Color3.new(1,1,1), Font = "GothamBold", TextSize = 13, BackgroundTransparency = 1, ZIndex = 53})

local TFLeft = Create("Frame", {Parent = TF, Size = UDim2.new(0, 200, 1, -80), Position = UDim2.new(0, 15, 0, 65), BackgroundTransparency = 1, ZIndex = 51})
local AutoJoinBtn = Create("TextButton", {Parent = TFLeft, Size = UDim2.new(1, 0, 0, 45), Position = UDim2.new(0,0,0,0), BackgroundColor3 = Color3.fromRGB(35, 45, 40), Text = "AUTO JOIN: ON", TextColor3 = SuccessColor, Font = "GothamBold", TextSize = 14, ZIndex = 52})
Create("UICorner", {Parent = AutoJoinBtn})

local function NewTFLabel(txt, y, color)
    return Create("TextLabel", {Parent = TFLeft, Size = UDim2.new(1, 0, 0, 20), Position = UDim2.new(0, 0, 0, y), Text = txt, TextColor3 = color or Color3.fromRGB(180, 180, 180), Font = "GothamBold", TextSize = 12, BackgroundTransparency = 1, TextXAlignment = "Left", ZIndex = 52})
end
NewTFLabel("MONEY THRESHOLD (M)", 60)
local MonInp = Create("TextBox", {Parent = TFLeft, Size = UDim2.new(1, 0, 0, 40), Position = UDim2.new(0, 0, 0, 85), BackgroundColor3 = Color3.fromRGB(30, 30, 35), Text = "100", TextColor3 = Color3.new(1,1,1), Font = "GothamBold", ZIndex = 53})
Create("UICorner", {Parent = MonInp})
NewTFLabel("PLAYER COUNT", 145)
local MinP = Create("TextBox", {Parent = TFLeft, Size = UDim2.new(0, 95, 0, 35), Position = UDim2.new(0, 0, 0, 175), BackgroundColor3 = Color3.fromRGB(30, 30, 35), Text = "3", TextColor3 = Color3.new(1,1,1), ZIndex = 53})
local MaxP = Create("TextBox", {Parent = TFLeft, Size = UDim2.new(0, 95, 0, 35), Position = UDim2.new(1, -95, 0, 175), BackgroundColor3 = Color3.fromRGB(30, 30, 35), Text = "7", TextColor3 = Color3.new(1,1,1), ZIndex = 53})
Create("UICorner", {Parent = MinP}); Create("UICorner", {Parent = MaxP})
local TFApply = Create("TextButton", {Parent = TFLeft, Size = UDim2.new(1, 0, 0, 45), Position = UDim2.new(0, 0, 0, 230), BackgroundColor3 = JoinBtnColor, Text = "APPLY SETTINGS", TextColor3 = Color3.new(1,1,1), Font = "GothamBold", TextSize = 14, ZIndex = 53})
Create("UICorner", {Parent = TFApply})

local TFRight = Create("Frame", {Parent = TF, Size = UDim2.new(1, -240, 1, -80), Position = UDim2.new(0, 225, 0, 65), BackgroundTransparency = 1, ZIndex = 51})
local TableHeader = Create("Frame", {Parent = TFRight, Size = UDim2.new(1, 0, 0, 30), BackgroundTransparency = 1, ZIndex = 52})
local function AddColTitle(txt, x, size)
    Create("TextLabel", {Parent = TableHeader, Size = UDim2.new(size, 0, 1, 0), Position = UDim2.new(x, 0, 0, 0), Text = txt, TextColor3 = Color3.fromRGB(150, 150, 150), Font = "GothamBold", TextSize = 12, BackgroundTransparency = 1, ZIndex = 53})
end
AddColTitle("PET", 0, 0.3); AddColTitle("PLAYERS", 0.3, 0.2); AddColTitle("MONEY/s", 0.5, 0.25); AddColTitle("ACTION", 0.75, 0.25)

local TFScroll = Create("ScrollingFrame", {Parent = TFRight, Size = UDim2.new(1, 0, 1, -35), Position = UDim2.new(0, 0, 0, 35), BackgroundTransparency = 1, CanvasSize = UDim2.new(0,0,0,0), AutomaticCanvasSize = "Y", ScrollBarThickness = 3, ZIndex = 52})
Create("UIListLayout", {Parent = TFScroll, Padding = UDim.new(0, 5)})

local function AddTFServer(pet, plys, money)
    local Row = Create("Frame", {Parent = TFScroll, Size = UDim2.new(1, -5, 0, 50), BackgroundColor3 = Color3.fromRGB(26, 26, 32), ZIndex = 53})
    Create("UICorner", {Parent = Row, CornerRadius = UDim.new(0, 4)})
    Create("TextLabel", {Parent = Row, Size = UDim2.new(0.3, 0, 1, 0), Position = UDim2.new(0, 10, 0, 0), Text = pet, TextColor3 = Color3.new(0.9,0.9,0.9), Font = "Gotham", TextSize = 13, BackgroundTransparency = 1, TextXAlignment = "Left", ZIndex = 54})
    Create("TextLabel", {Parent = Row, Size = UDim2.new(0.2, 0, 1, 0), Position = UDim2.new(0.3, 0, 0, 0), Text = plys, TextColor3 = Color3.new(0.8,0.8,0.8), Font = "Gotham", TextSize = 13, BackgroundTransparency = 1, ZIndex = 54})
    Create("TextLabel", {Parent = Row, Size = UDim2.new(0.25, 0, 1, 0), Position = UDim2.new(0.5, 0, 0, 0), Text = money, TextColor3 = SuccessColor, Font = "GothamBold", TextSize = 13, BackgroundTransparency = 1, ZIndex = 54})
    local JBtn = Create("TextButton", {Parent = Row, Size = UDim2.new(0, 100, 0, 32), Position = UDim2.new(0.75, 5, 0.5, -16), BackgroundColor3 = JoinBtnColor, Text = "JOIN", TextColor3 = Color3.new(1,1,1), Font = "GothamBold", TextSize = 13, ZIndex = 55})
    Create("UICorner", {Parent = JBtn, CornerRadius = UDim.new(0, 4)})
    JBtn.MouseButton1Click:Connect(function() TeleportService:Teleport(game.PlaceId, LP) end)
end

AddTFServer("La Secret...", "6/8", "$1B/s")
AddTFServer("Los Mobilis", "7/8", "$154M/s")
AddTFServer("Los Burritos", "7/8", "$110.5M/s")
AddTFServer("Esok Sekolah", "6/8", "$255M/s")
AddTFServer("Eviledon", "7/8", "$551.2M/s")
AddTFServer("Spaghetti...", "6/8", "$660M/s")

-- === ВАТЕРМАРКА ===
local Watermark = Create("Frame", {Parent = ScreenGui, Size = UDim2.new(0, 180, 0, 32), Position = UDim2.new(1, -185, 0, 5), BackgroundColor3 = BgColor})
Create("UICorner", {Parent = Watermark, CornerRadius = UDim.new(0, 6)})
Create("UIStroke", {Parent = Watermark, Color = AccentColor, Thickness = 2})
Create("TextLabel", {Parent = Watermark, Size = UDim2.new(1, 0, 1, 0), Text = "VENOM ULTIMATE", TextColor3 = AccentColor, Font = "GothamBold", TextSize = 14, BackgroundTransparency = 1})

-- === ГЛАВНОЕ МЕНЮ ===
local Main = Create("Frame", {Parent = ScreenGui, Size = UDim2.new(0, 580, 0, 420), Position = UDim2.new(0.5, -290, 0.5, -210), BackgroundColor3 = BgColor, Visible = false})
Create("UICorner", {Parent = Main, CornerRadius = UDim.new(0, 15)})
Create("UIStroke", {Parent = Main, Color = AccentColor, Thickness = 2})
Drag(Main)

local Sidebar = Create("Frame", {Parent = Main, Size = UDim2.new(0, 170, 1, 0), BackgroundColor3 = Color3.fromRGB(20,20,25)})
Create("UICorner", {Parent = Sidebar, CornerRadius = UDim.new(0, 15)})
Create("TextLabel", {Parent = Sidebar, Size = UDim2.new(1, 0, 0, 70), Text = "VENOM V18", TextColor3 = AccentColor, Font = "GothamBold", TextSize = 24, BackgroundTransparency = 1})

local TabHolder = Create("Frame", {Parent = Sidebar, Size = UDim2.new(1, 0, 1, -80), Position = UDim2.new(0, 0, 0, 80), BackgroundTransparency = 1})
Create("UIListLayout", {Parent = TabHolder, Padding = UDim.new(0, 8), HorizontalAlignment = "Center"})

local PageHolder = Create("Frame", {Parent = Main, Size = UDim2.new(1, -190, 1, -20), Position = UDim2.new(0, 180, 0, 10), BackgroundTransparency = 1})

local Pages = {}
local function CreatePage(name)
    local p = Create("ScrollingFrame", {Parent = PageHolder, Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1, Visible = false, ScrollBarThickness = 0, AutomaticCanvasSize = "Y"})
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
local StealPg = CreatePage("STEAL")
local VisualPg = CreatePage("VISUAL")
local MiscPg = CreatePage("MISC")
local FinderPg = CreatePage("FINDER")

-- === FINDER UI (MINI) ===
local FinderMini = Create("Frame", {Parent = ScreenGui, Size = UDim2.new(0, 250, 0, 150), Position = UDim2.new(0.5, 300, 0.5, -75), BackgroundColor3 = BgColor, Visible = false})
Create("UICorner", {Parent = FinderMini, CornerRadius = UDim.new(0, 15)})
Create("UIStroke", {Parent = FinderMini, Color = AccentColor, Thickness = 2})
local FInput = Create("TextBox", {Parent = FinderMini, Size = UDim2.new(0, 210, 0, 40), Position = UDim2.new(0.5, -105, 0.4, 0), BackgroundColor3 = SectionBg, TextColor3 = Color3.new(1,1,1), PlaceholderText = "PLAYER NICK...", Font = "GothamBold"})
local FBtn = Create("TextButton", {Parent = FinderMini, Size = UDim2.new(0, 210, 0, 40), Position = UDim2.new(0.5, -105, 0.75, 0), BackgroundColor3 = AccentColor, Text = "JOIN PLAYER", TextColor3 = Color3.new(1,1,1), Font = "GothamBold"})
Create("UICorner", {Parent = FBtn}); Drag(FinderMini)

-- ВКЛАДКА STEAL
local StealStatus = Create("TextLabel", {Parent = StealPg, Size = UDim2.new(1, -10, 0, 40), Text = "Status: Idle", TextColor3 = SuccessColor, Font = "GothamBold", TextSize = 16, BackgroundTransparency = 1})
local SetHomeBtn = Create("TextButton", {Parent = StealPg, Size = UDim2.new(1, -10, 0, 50), BackgroundColor3 = AccentColor, Text = "SET HOME POS", TextColor3 = Color3.new(1,1,1), Font = "GothamBold", TextSize = 16})
Create("UICorner", {Parent = SetHomeBtn})

SetHomeBtn.MouseButton1Click:Connect(function()
    local hrp = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
    if hrp then
        pos1 = hrp.CFrame
        createBeam(hrp.Position, AccentColor, 1)
        StealStatus.Text = "Home Saved!"
        task.wait(1); StealStatus.Text = "Waiting for Steal..."
    end
end)

local function AddToggle(name, page, callback)
    local f = Create("Frame", {Parent = page, Size = UDim2.new(1, -10, 0, 55), BackgroundColor3 = SectionBg})
    Create("UICorner", {Parent = f, CornerRadius = UDim.new(0, 12)})
    Create("TextLabel", {Parent = f, Size = UDim2.new(1, -70, 1, 0), Position = UDim2.new(0, 20, 0, 0), Text = name, TextColor3 = Color3.new(1,1,1), Font = "GothamBold", TextSize = 16, TextXAlignment = "Left", BackgroundTransparency = 1})
    local btn = Create("TextButton", {Parent = f, Size = UDim2.new(0, 50, 0, 26), Position = UDim2.new(1, -65, 0.5, -13), BackgroundColor3 = Color3.fromRGB(40,40,45), Text = ""})
    Create("UICorner", {Parent = btn, CornerRadius = UDim.new(1, 0)})
    local circ = Create("Frame", {Parent = btn, Size = UDim2.new(0, 22, 0, 22), Position = UDim2.new(0, 2, 0.5, -11), BackgroundColor3 = Color3.new(1,1,1)})
    Create("UICorner", {Parent = circ, CornerRadius = UDim.new(1, 0)})
    btn.MouseButton1Click:Connect(function()
        Config.Flags[name] = not Config.Flags[name]
        Tween(circ, {Position = Config.Flags[name] and UDim2.new(1, -24, 0.5, -11) or UDim2.new(0, 2, 0.5, -11)})
        Tween(btn, {BackgroundColor3 = Config.Flags[name] and AccentColor or Color3.fromRGB(40,40,45)})
        callback(Config.Flags[name])
    end)
end

AddToggle("Kill Aura", CombatPg, function() end)
AddToggle("God Mode", CombatPg, function() end)
AddToggle("Fly Mode", MovePg, function() end)
AddToggle("Infinite Jump", MovePg, function() end)
AddToggle("Anti-Knockback", MovePg, function() end)
AddToggle("Fullbright", VisualPg, function(v) Lighting.Brightness = v and 2 or 1; Lighting.GlobalShadows = not v end)
AddToggle("ESP Boxes", VisualPg, function() end)
AddToggle("Tracers", VisualPg, function() end)
AddToggle("Noclip Master", MiscPg, function() end)
AddToggle("Finder UI", FinderPg, function(v) FinderMini.Visible = v end)
AddToggle("Brainrot Finder", FinderPg, function(v) TF.Visible = v end)

-- ОКНО КЛЮЧА
local KeyMain = Create("Frame", {Parent = ScreenGui, Size = UDim2.new(0, 350, 0, 220), Position = UDim2.new(0.5, -175, 0.5, -110), BackgroundColor3 = BgColor})
Create("UICorner", {Parent = KeyMain, CornerRadius = UDim.new(0, 15)})
Create("UIStroke", {Parent = KeyMain, Color = AccentColor, Thickness = 2})
local KeyInput = Create("TextBox", {Parent = KeyMain, Size = UDim2.new(0, 280, 0, 50), Position = UDim2.new(0.5, -140, 0.4, 0), BackgroundColor3 = SectionBg, TextColor3 = Color3.new(1,1,1), PlaceholderText = "ENTER KEY...", Font = "GothamBold"})
local KeyBtn = Create("TextButton", {Parent = KeyMain, Size = UDim2.new(0, 280, 0, 50), Position = UDim2.new(0.5, -140, 0.75, 0), BackgroundColor3 = AccentColor, Text = "LOGIN", TextColor3 = Color3.new(1,1,1), Font = "GothamBold"})
Create("UICorner", {Parent = KeyBtn}); Drag(KeyMain)

KeyBtn.MouseButton1Click:Connect(function()
    KeyBtn.Text = "CHECKING..."
    local success, result = pcall(function() return game:HttpGet(KeysURL) end)
    if success then
        for key in string.gmatch(result, "[^\r\n]+") do
            if KeyInput.Text == key then
                Authenticated = true; KeyMain.Visible = false; Main.Visible = true; CombatPg.Visible = true
                Notify("Authenticated! Welcome.")
                return
            end
        end
        KeyBtn.Text = "WRONG KEY"
    else KeyBtn.Text = "CON. ERROR" end
    task.wait(1); KeyBtn.Text = "LOGIN"
end)

-- ЛОГИКА STEAL
ProximityPromptService.PromptButtonHoldEnded:Connect(function(prompt, who)
    if who ~= LP or not pos1 then return end
    if prompt.Name == "Steal" or prompt.ActionText == "Steal" then
        task.wait(0.5)
        local char = LP.Character
        if char and char:FindFirstChild("HumanoidRootPart") then
            char.HumanoidRootPart.CFrame = pos1
            StealStatus.Text = "Success Teleport!"
        end
    end
end)

-- ЦИКЛЫ
UIS.JumpRequest:Connect(function()
    if Config.Flags["Infinite Jump"] and LP.Character then
        LP.Character:FindFirstChildOfClass("Humanoid"):ChangeState("Jumping")
    end
end)

task.spawn(function()
    while task.wait(1) do
        if Authenticated then
            local hrp = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
            if hrp then
                local dist, target = math.huge, nil
                for _, v in ipairs(targetPositions) do
                    local d = (hrp.Position - v).Magnitude
                    if d < dist then dist = d; target = v end
                end
                if target then createBeam(target, Color3.fromRGB(255, 140, 0), 2) end
            end
        end
    end
end)
