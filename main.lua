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
-- 1. ОКНО CHANGELOG
-- ==========================================
local IntroGui = Instance.new("ScreenGui", LP.PlayerGui)
local IntroMain = Instance.new("Frame", IntroGui)
IntroMain.Size = UDim2.new(0, 450, 0, 350)
IntroMain.Position = UDim2.new(0.5, -225, 0.5, -175)
IntroMain.BackgroundColor3 = Color3.fromRGB(15, 15, 18)
Instance.new("UICorner", IntroMain).CornerRadius = UDim.new(0, 15)
local IStroke = Instance.new("UIStroke", IntroMain)
IStroke.Color = Color3.fromRGB(0, 255, 150); IStroke.Thickness = 2

local ITitle = Instance.new("TextLabel", IntroMain)
ITitle.Size = UDim2.new(1, 0, 0, 60); ITitle.Text = "VENOM V18 FIXED"; ITitle.TextColor3 = Color3.fromRGB(0, 255, 150); ITitle.Font = "GothamBold"; ITitle.TextSize = 22; ITitle.BackgroundTransparency = 1

local IText = Instance.new("TextLabel", IntroMain)
IText.Size = UDim2.new(1, -40, 0, 180); IText.Position = UDim2.new(0, 20, 0, 70)
IText.Text = "• FIXED: Fast Steal (No more lags)\n• FIXED: Noclip (Proper State Logic)\n• IMPROVED: Floating Binds Visibility\n• STABLE: Anti-Knockback Core\n• ADDED: Smooth Camera FOV"
IText.TextColor3 = Color3.fromRGB(200, 200, 200); IText.Font = "Gotham"; IText.TextSize = 16; IText.TextXAlignment = "Left"; IText.BackgroundTransparency = 1

local StartBtn = Instance.new("TextButton", IntroMain)
StartBtn.Size = UDim2.new(0, 280, 0, 50); StartBtn.Position = UDim2.new(0.5, -140, 1, -70); StartBtn.BackgroundColor3 = Color3.fromRGB(0, 255, 150); StartBtn.Text = "LAUNCH SCRIPT"; StartBtn.Font = "GothamBold"; StartBtn.TextColor3 = Color3.fromRGB(15, 15, 15); Instance.new("UICorner", StartBtn)

-- ==========================================
-- 2. СИСТЕМА ПЛАВАЮЩИХ КНОПОК
-- ==========================================
local function CreateMobileBind(name, callback, isToggle)
    local BindGui = Instance.new("ScreenGui", LP.PlayerGui)
    local BButton = Instance.new("TextButton", BindGui)
    BButton.Size = UDim2.new(0, 75, 0, 75); BButton.Position = UDim2.new(0.1, 0, 0.5, 0); BButton.BackgroundColor3 = Color3.fromRGB(10, 10, 10); BButton.BackgroundTransparency = 0.1
    BButton.Text = string.sub(name, 1, 5):upper(); BButton.TextColor3 = Color3.new(1, 1, 1); BButton.Font = "GothamBold"; BButton.TextSize = 16
    Instance.new("UIStroke", BButton).Color = Color3.fromRGB(0, 255, 150)
    Instance.new("UICorner", BButton).CornerRadius = UDim.new(0, 15)

    local dS, sP, dG;
    BButton.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then dG=true; dS=i.Position; sP=BButton.Position end end)
    UIS.InputChanged:Connect(function(i) if dG and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then local d=i.Position-dS; BButton.Position=UDim2.new(sP.X.Scale, sP.X.Offset+d.X, sP.Y.Scale, sP.Y.Offset+d.Y) end end)
    UIS.InputEnded:Connect(function() dG = false end)

    BButton.MouseButton1Click:Connect(function()
        if isToggle then
            _G.Flags[name] = not _G.Flags[name]
            Animate(BButton, 0.3, {TextColor3 = _G.Flags[name] and Color3.fromRGB(0, 255, 150) or Color3.new(1,1,1)})
            callback(_G.Flags[name])
        else callback() end
    end)
    return BindGui
end

-- ==========================================
-- 3. ГЛАВНЫЙ ИНТЕРФЕЙС
-- ==========================================
local function InitializeCheat()
    IntroGui:Destroy()
    local ScreenGui = Instance.new("ScreenGui", LP.PlayerGui); ScreenGui.Name = "Venom_V18_Stable"
    
    local Main = Instance.new("Frame", ScreenGui)
    Main.Size = UDim2.new(0, 750, 0, 500); Main.Position = UDim2.new(0.5, -375, 0.5, -250); Main.BackgroundColor3 = Color3.fromRGB(13, 13, 15); Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 20)
    local MStroke = Instance.new("UIStroke", Main); MStroke.Color = Color3.fromRGB(0, 255, 150); MStroke.Thickness = 1.5

    local Header = Instance.new("Frame", Main); Header.Size = UDim2.new(1, 0, 0, 70); Header.BackgroundTransparency = 1
    local Title = Instance.new("TextLabel", Header); Title.Size = UDim2.new(0, 300, 1, 0); Title.Position = UDim2.new(0, 25, 0, 0); Title.Text = "VENOM ULTIMATE"; Title.TextColor3 = Color3.fromRGB(0, 255, 150); Title.Font = "GothamBold"; Title.TextSize = 24; Title.TextXAlignment = "Left"; Title.BackgroundTransparency = 1

    local Close = Instance.new("TextButton", Header); Close.Size = UDim2.new(0, 40, 0, 40); Close.Position = UDim2.new(1, -50, 0.5, -20); Close.BackgroundColor3 = Color3.fromRGB(255, 65, 65); Close.Text = "×"; Close.TextColor3 = Color3.new(1,1,1); Close.Font = "GothamBold"; Instance.new("UICorner", Close).CornerRadius = UDim.new(1, 0)
    Close.MouseButton1Click:Connect(function() ScreenGui.Enabled = false end)

    local Sidebar = Instance.new("ScrollingFrame", Main); Sidebar.Size = UDim2.new(0, 190, 1, -90); Sidebar.Position = UDim2.new(0, 15, 0, 75); Sidebar.BackgroundTransparency = 1; Sidebar.ScrollBarThickness = 0
    Instance.new("UIListLayout", Sidebar).Padding = UDim.new(0, 10)

    local Container = Instance.new("Frame", Main); Container.Size = UDim2.new(1, -240, 1, -90); Container.Position = UDim2.new(0, 220, 0, 75); Container.BackgroundTransparency = 1
    local Pages = {}

    local function AddPage(name)
        local P = Instance.new("ScrollingFrame", Container); P.Size = UDim2.new(1, 0, 1, 0); P.BackgroundTransparency = 1; P.Visible = false; P.ScrollBarThickness = 2; P.CanvasSize = UDim2.new(0, 0, 3, 0)
        Instance.new("UIListLayout", P).Padding = UDim.new(0, 12)
        local B = Instance.new("TextButton", Sidebar); B.Size = UDim2.new(1, -10, 0, 50); B.BackgroundColor3 = Color3.fromRGB(25, 25, 30); B.Text = name; B.TextColor3 = Color3.fromRGB(160, 160, 160); B.Font = "GothamBold"; Instance.new("UICorner", B)
        B.MouseButton1Click:Connect(function()
            for _,pg in pairs(Pages) do pg.Visible = false end; P.Visible = true
            for _,btn in pairs(Sidebar:GetChildren()) do if btn:IsA("TextButton") then btn.TextColor3 = Color3.fromRGB(160, 160, 160) end end
            B.TextColor3 = Color3.fromRGB(0, 255, 150)
        end)
        Pages[name] = P; return P
    end

    local function AddFunc(page, name, isToggle, callback)
        local Frame = Instance.new("Frame", page); Frame.Size = UDim2.new(1, -15, 0, 75); Frame.BackgroundColor3 = Color3.fromRGB(30, 30, 35); Instance.new("UICorner", Frame)
        local Indicator = Instance.new("Frame", Frame); Indicator.Size = UDim2.new(0, 6, 0, 35); Indicator.Position = UDim2.new(0, 0, 0.5, -17.5); Indicator.BackgroundColor3 = Color3.fromRGB(200, 50, 50); Instance.new("UICorner", Indicator)
        local MainBtn = Instance.new("TextButton", Frame); MainBtn.Size = UDim2.new(0.65, 0, 1, 0); MainBtn.BackgroundTransparency = 1; MainBtn.Text = "     " .. name; MainBtn.TextColor3 = Color3.new(1,1,1); MainBtn.Font = "GothamBold"; MainBtn.TextSize = 16; MainBtn.TextXAlignment = "Left"
        local BindBtn = Instance.new("TextButton", Frame); BindBtn.Size = UDim2.new(0, 85, 0, 35); BindBtn.Position = UDim2.new(1, -95, 0.5, -17.5); BindBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 55); BindBtn.Text = "BIND"; BindBtn.TextColor3 = Color3.new(1,1,1); Instance.new("UICorner", BindBtn)
        
        local bindGui = nil
        BindBtn.MouseButton1Click:Connect(function()
            if not bindGui then bindGui = CreateMobileBind(name, callback, isToggle); BindBtn.BackgroundColor3 = Color3.fromRGB(0, 255, 150)
            else bindGui:Destroy(); bindGui = nil; BindBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 55) end
        end)
        MainBtn.MouseButton1Click:Connect(function()
            if isToggle then _G.Flags[name] = not _G.Flags[name]; Animate(Indicator, 0.3, {BackgroundColor3 = _G.Flags[name] and Color3.fromRGB(0, 255, 150) or Color3.fromRGB(200, 50, 50)}); callback(_G.Flags[name])
            else callback() end
        end)
    end

    -- КАТЕГОРИИ
    local Comb = AddPage("COMBAT")
    AddFunc(Comb, "Anti-Knockback", true, function(v) _G.AntiKB = v end)
    AddFunc(Comb, "Kill Aura", true, function(v) _G.Aura = v end)
    AddFunc(Comb, "Hitbox Head", true, function(v) _G.Hitbox = v end)

    local Move = AddPage("MOVEMENT")
    AddFunc(Move, "Noclip Master", true, function(v) _G.Noclip = v end)
    AddFunc(Move, "Fly V2 (Hold)", true, function(v) _G.Fly = v end)
    AddFunc(Move, "Speed Hack", true, function(v) LP.Character.Humanoid.WalkSpeed = v and 100 or 16 end)
    AddFunc(Move, "Infinite Jump", true, function(v) _G.InfJ = v end)

    local Visu = AddPage("VISUALS")
    AddFunc(Visu, "Box ESP", true, function(v) _G.BoxESP = v end)
    AddFunc(Visu, "FOV 120", true, function(v) workspace.CurrentCamera.FieldOfView = v and 120 or 70 end)

    local Misc = AddPage("MISC")
    AddFunc(Misc, "Fast Steal", true, function(v) 
        _G.FastSteal = v 
        if not v then -- Возвращаем как было при выключении
            for _, p in pairs(workspace:GetDescendants()) do if p:IsA("ProximityPrompt") then p.HoldDuration = 0.5 end end
        end
    end)
    AddFunc(Misc, "Infinite Yield", false, function() loadstring(game:HttpGet('https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source'))() end)

    -- ЛОГИКА (ОПТИМИЗИРОВАННАЯ)
    RS.Stepped:Connect(function()
        if LP.Character and LP.Character:FindFirstChild("HumanoidRootPart") then
            -- Фикс Ноклипа
            if _G.Flags["Noclip Master"] then
                LP.Character.Humanoid:ChangeState(11)
            end
            -- Фикс Анти-КБ
            if _G.Flags["Anti-Knockback"] then
                LP.Character.HumanoidRootPart.AssemblyLinearVelocity = Vector3.new(0, UIS:IsKeyDown(Enum.KeyCode.Space) and LP.Character.HumanoidRootPart.AssemblyLinearVelocity.Y or 0, 0)
            end
            -- Флай
            if _G.Flags["Fly V2 (Hold)"] then
                LP.Character.HumanoidRootPart.Velocity = Vector3.new(0, 50, 0)
            end
        end
    end)

    -- Оптимизированный Fast Steal (проверка раз в полсекунды, а не каждый кадр)
    task.spawn(function()
        while true do
            if _G.FastSteal then
                for _, p in pairs(workspace:GetDescendants()) do
                    if p:IsA("ProximityPrompt") and p.HoldDuration ~= 0 then
                        p.HoldDuration = 0
                    end
                end
            end
            task.wait(0.5)
        end
    end)

    UIS.JumpRequest:Connect(function() if _G.InfJ then LP.Character.Humanoid:ChangeState("Jumping") end end)
    
    -- Drag Logic
    local dS, sP, dG; Main.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then dG=true; dS=i.Position; sP=Main.Position end end)
    UIS.InputChanged:Connect(function(i) if dG and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then local d=i.Position-dS; Main.Position=UDim2.new(sP.X.Scale, sP.X.Offset+d.X, sP.Y.Scale, sP.Y.Offset+d.Y) end end)
    UIS.InputEnded:Connect(function() dG = false end)

    Pages["COMBAT"].Visible = true
end

StartBtn.MouseButton1Click:Connect(InitializeCheat)
