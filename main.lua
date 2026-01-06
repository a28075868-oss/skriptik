local LP = game.Players.LocalPlayer
local UIS = game:GetService("UserInputService")
local RS = game:GetService("RunService")
local TS = game:GetService("TweenService")
local Mouse = LP:GetMouse()

-- Хранилище настроек
_G.Flags = {}
_G.SavedPos = nil

-- Функция плавной анимации
local function Animate(obj, info, goal)
    TS:Create(obj, TweenInfo.new(info, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), goal):Play()
end

-- ==========================================
-- 1. СИСТЕМА ПЛАВАЮЩИХ КНОПОК (ЧИТАБЕЛЬНЫЕ)
-- ==========================================
local function CreateMobileBind(name, callback, isToggle)
    local BindGui = Instance.new("ScreenGui", LP.PlayerGui)
    BindGui.Name = "Bind_" .. name
    
    local BButton = Instance.new("TextButton", BindGui)
    BButton.Size = UDim2.new(0, 70, 0, 70)
    BButton.Position = UDim2.new(0.1, 0, 0.5, 0)
    BButton.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
    BButton.BackgroundTransparency = 0.2
    BButton.Text = string.sub(name, 1, 5):upper()
    BButton.TextColor3 = Color3.new(1, 1, 1)
    BButton.Font = "GothamBold"
    BButton.TextSize = 14
    
    local BStroke = Instance.new("UIStroke", BButton)
    BStroke.Color = Color3.fromRGB(0, 255, 150)
    BStroke.Thickness = 2
    
    Instance.new("UICorner", BButton).CornerRadius = UDim.new(0, 15)

    -- Dragging Logic
    local dS, sP, dG;
    BButton.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
            dG = true; dS = i.Position; sP = BButton.Position
        end
    end)
    UIS.InputChanged:Connect(function(i)
        if dG and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
            local d = i.Position - dS
            BButton.Position = UDim2.new(sP.X.Scale, sP.X.Offset + d.X, sP.Y.Scale, sP.Y.Offset + d.Y)
        end
    end)
    UIS.InputEnded:Connect(function() dG = false end)

    BButton.MouseButton1Click:Connect(function()
        if isToggle then
            _G.Flags[name] = not _G.Flags[name]
            Animate(BButton, 0.3, {TextColor3 = _G.Flags[name] and Color3.fromRGB(0, 255, 150) or Color3.new(1,1,1)})
            callback(_G.Flags[name])
        else
            callback()
        end
    end)
    return BindGui
end

-- ==========================================
-- 2. ГЛАВНЫЙ ИНТЕРФЕЙС (PREMIUM GLASS)
-- ==========================================
local ScreenGui = Instance.new("ScreenGui", LP.PlayerGui)
ScreenGui.Name = "Venom_Ultimate_V18"
ScreenGui.ResetOnSpawn = false

local Main = Instance.new("Frame", ScreenGui)
Main.Size = UDim2.new(0, 750, 0, 500)
Main.Position = UDim2.new(0.5, -375, 0.5, -250)
Main.BackgroundColor3 = Color3.fromRGB(13, 13, 15)
Main.BorderSizePixel = 0
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 20)

local MStroke = Instance.new("UIStroke", Main)
MStroke.Color = Color3.fromRGB(0, 255, 150)
MStroke.Thickness = 1.5; MStroke.Transparency = 0.4

-- Шапка (Header)
local Header = Instance.new("Frame", Main)
Header.Size = UDim2.new(1, 0, 0, 70); Header.BackgroundTransparency = 1
local Title = Instance.new("TextLabel", Header)
Title.Size = UDim2.new(0, 300, 1, 0); Title.Position = UDim2.new(0, 25, 0, 0); Title.Text = "VENOM V18 ULTIMATE"; Title.TextColor3 = Color3.fromRGB(0, 255, 150); Title.Font = "GothamBold"; Title.TextSize = 24; Title.TextXAlignment = "Left"; Title.BackgroundTransparency = 1

local Close = Instance.new("TextButton", Header)
Close.Size = UDim2.new(0, 40, 0, 40); Close.Position = UDim2.new(1, -50, 0.5, -20); Close.BackgroundColor3 = Color3.fromRGB(255, 65, 65); Close.Text = "×"; Close.TextColor3 = Color3.new(1,1,1); Close.TextSize = 30; Close.Font = "GothamBold"; Instance.new("UICorner", Close).CornerRadius = UDim.new(1, 0)
Close.MouseButton1Click:Connect(function() ScreenGui.Enabled = false end)

-- Сайдбар (Sidebar)
local Sidebar = Instance.new("ScrollingFrame", Main)
Sidebar.Size = UDim2.new(0, 190, 1, -90); Sidebar.Position = UDim2.new(0, 15, 0, 75); Sidebar.BackgroundTransparency = 1; Sidebar.ScrollBarThickness = 0
Instance.new("UIListLayout", Sidebar).Padding = UDim.new(0, 10)

-- Контейнер страниц
local Container = Instance.new("Frame", Main)
Container.Size = UDim2.new(1, -240, 1, -90); Container.Position = UDim2.new(0, 220, 0, 75); Container.BackgroundTransparency = 1
local Pages = {}

local function AddPage(name)
    local P = Instance.new("ScrollingFrame", Container)
    P.Size = UDim2.new(1, 0, 1, 0); P.BackgroundTransparency = 1; P.Visible = false; P.ScrollBarThickness = 2; P.CanvasSize = UDim2.new(0, 0, 3, 0)
    Instance.new("UIListLayout", P).Padding = UDim.new(0, 12)
    
    local B = Instance.new("TextButton", Sidebar)
    B.Size = UDim2.new(1, -10, 0, 50); B.BackgroundColor3 = Color3.fromRGB(25, 25, 30); B.Text = name; B.TextColor3 = Color3.fromRGB(160, 160, 160); B.Font = "GothamBold"; B.TextSize = 14; Instance.new("UICorner", B)
    
    B.MouseButton1Click:Connect(function()
        for _,pg in pairs(Pages) do pg.Visible = false end; P.Visible = true
        for _,btn in pairs(Sidebar:GetChildren()) do if btn:IsA("TextButton") then btn.TextColor3 = Color3.fromRGB(160, 160, 160) end end
        B.TextColor3 = Color3.fromRGB(0, 255, 150)
    end)
    Pages[name] = P; return P
end

local function AddFunc(page, name, isToggle, callback)
    local Frame = Instance.new("Frame", page)
    Frame.Size = UDim2.new(1, -15, 0, 75); Frame.BackgroundColor3 = Color3.fromRGB(30, 30, 35); Frame.BorderSizePixel = 0; Instance.new("UICorner", Frame)
    
    local Indicator = Instance.new("Frame", Frame) -- Та самая неоновая полоска
    Indicator.Size = UDim2.new(0, 6, 0, 35); Indicator.Position = UDim2.new(0, 0, 0.5, -17.5); Indicator.BackgroundColor3 = Color3.fromRGB(200, 50, 50); Instance.new("UICorner", Indicator)

    local MainBtn = Instance.new("TextButton", Frame)
    MainBtn.Size = UDim2.new(0.65, 0, 1, 0); MainBtn.BackgroundTransparency = 1; MainBtn.Text = "     " .. name; MainBtn.TextColor3 = Color3.new(1,1,1); MainBtn.Font = "GothamBold"; MainBtn.TextSize = 16; MainBtn.TextXAlignment = "Left"

    local BindBtn = Instance.new("TextButton", Frame)
    BindBtn.Size = UDim2.new(0, 85, 0, 35); BindBtn.Position = UDim2.new(1, -95, 0.5, -17.5); BindBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 55); BindBtn.Text = "BIND"; BindBtn.TextColor3 = Color3.new(1,1,1); BindBtn.Font = "GothamBold"; BindBtn.TextSize = 12; Instance.new("UICorner", BindBtn)
    
    local bindGui = nil
    BindBtn.MouseButton1Click:Connect(function()
        if not bindGui then
            bindGui = CreateMobileBind(name, callback, isToggle); BindBtn.BackgroundColor3 = Color3.fromRGB(0, 255, 150); BindBtn.TextColor3 = Color3.new(0,0,0)
        else
            bindGui:Destroy(); bindGui = nil; BindBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 55); BindBtn.TextColor3 = Color3.new(1,1,1)
        end
    end)

    MainBtn.MouseButton1Click:Connect(function()
        if isToggle then
            _G.Flags[name] = not _G.Flags[name]
            Animate(Indicator, 0.3, {BackgroundColor3 = _G.Flags[name] and Color3.fromRGB(0, 255, 150) or Color3.fromRGB(200, 50, 50)})
            callback(_G.Flags[name])
        else
            callback()
        end
    end)
end

-- ==========================================
-- КАТЕГОРИИ И ВСЕ ФУНКЦИИ
-- ==========================================
local Comb = AddPage("COMBAT")
AddFunc(Comb, "Anti-Knockback", true, function(v) _G.AntiKB = v end)
AddFunc(Comb, "Kill Aura", true, function(v) _G.Aura = v end)
AddFunc(Comb, "Hitbox Head", true, function(v) _G.Hitbox = v end)
AddFunc(Comb, "Auto-Clicker", true, function(v) _G.AC = v end)

local Move = AddPage("MOVEMENT")
AddFunc(Move, "Noclip Master", true, function(v) _G.Noclip = v end)
AddFunc(Move, "Fly V2 (Hold)", true, function(v) _G.Fly = v end)
AddFunc(Move, "Speed Hack (100)", true, function(v) LP.Character.Humanoid.WalkSpeed = v and 100 or 16 end)
AddFunc(Move, "Jump Power (200)", true, function(v) LP.Character.Humanoid.JumpPower = v and 200 or 50 end)
AddFunc(Move, "Infinite Jump", true, function(v) _G.InfJ = v end)
AddFunc(Move, "Gravity Switch", true, function(v) workspace.Gravity = v and 40 or 196.2 end)

local Tele = AddPage("TELEPORTS")
AddFunc(Tele, "Save Position", false, function() _G.SavedPos = LP.Character.HumanoidRootPart.CFrame end)
AddFunc(Tele, "TP to Saved", false, function() if _G.SavedPos then LP.Character.HumanoidRootPart.CFrame = _G.SavedPos end end)
AddFunc(Tele, "Click TP (Ctrl)", true, function(v) _G.ClickTP = v end)
AddFunc(Tele, "TP Destiny (Kick)", false, function() if _G.SavedPos then LP.Character.HumanoidRootPart.CFrame = _G.SavedPos; task.wait(5); LP:Kick("Destiny TP") end end)

local Visu = AddPage("VISUALS")
AddFunc(Visu, "Box ESP 2D", true, function(v)
    _G.BoxESP = v
    task.spawn(function()
        while _G.BoxESP do
            for _, p in pairs(game.Players:GetPlayers()) do
                if p ~= LP and p.Character and p.Character:FindFirstChild("HumanoidRootPart") and not p.Character:FindFirstChild("VenomBox") then
                    local bg = Instance.new("BillboardGui", p.Character); bg.Name = "VenomBox"; bg.AlwaysOnTop = true; bg.Size = UDim2.new(4, 0, 5.5, 0)
                    local fr = Instance.new("Frame", bg); fr.Size = UDim2.new(1, 0, 1, 0); fr.BackgroundTransparency = 1; local st = Instance.new("UIStroke", fr); st.Color = Color3.fromRGB(0, 255, 150); st.Thickness = 2
                end
            end
            task.wait(1)
        end
        for _, p in pairs(game.Players:GetPlayers()) do if p.Character and p.Character:FindFirstChild("VenomBox") then p.Character.VenomBox:Destroy() end end
    end)
end)
AddFunc(Visu, "Fullbright", true, function(v) game.Lighting.Brightness = v and 4 or 2 end)
AddFunc(Visu, "FOV 120", true, function(v) workspace.CurrentCamera.FieldOfView = v and 120 or 70 end)

local Misc = AddPage("MISC")
AddFunc(Misc, "Fast Steal (Instant)", true, function(v) _G.FastSteal = v end)
AddFunc(Misc, "Infinite Yield", false, function() loadstring(game:HttpGet('https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source'))() end)
AddFunc(Misc, "Rejoin Server", false, function() game:GetService("TeleportService"):Teleport(game.PlaceId, LP) end)

-- ==========================================
-- ОСНОВНАЯ ЛОГИКА ОБРАБОТКИ
-- ==========================================
RS.Stepped:Connect(function()
    -- Anti-Knockback (Original)
    if _G.AntiKB and LP.Character and LP.Character:FindFirstChild("HumanoidRootPart") then
        local r = LP.Character.HumanoidRootPart
        r.AssemblyLinearVelocity = Vector3.new(0, UIS:IsKeyDown(Enum.KeyCode.Space) and r.AssemblyLinearVelocity.Y or 0, 0)
        r.AssemblyAngularVelocity = Vector3.new(0,0,0)
    end
    -- Noclip
    if _G.Noclip and LP.Character then
        for _,v in pairs(LP.Character:GetDescendants()) do if v:IsA("BasePart") then v.CanCollide = false end end
    end
    -- Hitbox
    if _G.Hitbox then
        for _,p in pairs(game.Players:GetPlayers()) do
            if p ~= LP and p.Character and p.Character:FindFirstChild("Head") then p.Character.Head.Size = Vector3.new(4,4,4); p.Character.Head.CanCollide = false end
        end
    end
    -- Fly
    if _G.Fly and LP.Character then LP.Character.HumanoidRootPart.Velocity = Vector3.new(0, 50, 0) end
    -- Fast Steal
    if _G.FastSteal then for _,p in pairs(workspace:GetDescendants()) do if p:IsA("ProximityPrompt") then p.HoldDuration = 0 end end end
end)

UIS.JumpRequest:Connect(function() if _G.InfJ then LP.Character.Humanoid:ChangeState("Jumping") end end)

-- Меню на Insert
UIS.InputBegan:Connect(function(input) if input.KeyCode == Enum.KeyCode.Insert then ScreenGui.Enabled = not ScreenGui.Enabled end end)

-- Drag Main Menu
local dS, sP, dG; Main.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then dG=true; dS=i.Position; sP=Main.Position end end)
UIS.InputChanged:Connect(function(i) if dG and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then local d=i.Position-dS; Main.Position=UDim2.new(sP.X.Scale, sP.X.Offset+d.X, sP.Y.Scale, sP.Y.Offset+d.Y) end end)
UIS.InputEnded:Connect(function() dG = false end)

Pages["COMBAT"].Visible = true
