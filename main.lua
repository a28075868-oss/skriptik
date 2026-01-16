-- КОНФИГ КЛЮЧА
local CorrectKey = "VENOMBYPPAS" -- Можешь поменять на свой пароль
local Authenticated = false

local LP = game.Players.LocalPlayer
local RS = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local TS = game:GetService("TweenService")

local Config = {
    Flags = {},
    FlyHeight = 13,
    SpeedValue = 0.65,
    AuraHeight = 11,
    AuraRadius = 35,
    HitboxSize = 25
}

-- ГРАФИЧЕСКИЙ ИНТЕРФЕЙС (MOBILE & PC)
local ScreenGui = Instance.new("ScreenGui", LP.PlayerGui)
ScreenGui.Name = "Venom_System"
ScreenGui.ResetOnSpawn = false

-- ОКНО ВВОДА КЛЮЧА
local KeyMain = Instance.new("Frame", ScreenGui)
KeyMain.Size = UDim2.new(0, 300, 0, 150)
KeyMain.Position = UDim2.new(0.5, -150, 0.5, -75)
KeyMain.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
Instance.new("UICorner", KeyMain)

local KeyInput = Instance.new("TextBox", KeyMain)
KeyInput.Size = UDim2.new(0, 200, 0, 40)
KeyInput.Position = UDim2.new(0.5, -100, 0.4, -20)
KeyInput.PlaceholderText = "Enter Key..."
KeyInput.Text = ""
KeyInput.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
KeyInput.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", KeyInput)

local KeyBtn = Instance.new("TextButton", KeyMain)
KeyBtn.Size = UDim2.new(0, 100, 0, 35)
KeyBtn.Position = UDim2.new(0.5, -50, 0.75, -15)
KeyBtn.Text = "Login"
KeyBtn.BackgroundColor3 = Color3.fromRGB(0, 255, 150)
Instance.new("UICorner", KeyBtn)

-- ГЛАВНОЕ МЕНЮ (ИЗНАЧАЛЬНО СКРЫТО)
local Main = Instance.new("Frame", ScreenGui)
Main.Size = UDim2.new(0, 400, 0, 350)
Main.Position = UDim2.new(0.5, -200, 0.5, -175)
Main.BackgroundColor3 = Color3.fromRGB(10, 10, 12)
Main.Visible = false
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 10)
local Stroke = Instance.new("UIStroke", Main)
Stroke.Color = Color3.fromRGB(0, 255, 150); Stroke.Thickness = 2

-- ПРОВЕРКА КЛЮЧА
KeyBtn.MouseButton1Click:Connect(function()
    if KeyInput.Text == CorrectKey then
        KeyMain.Visible = false
        Main.Visible = true
        Authenticated = true
    else
        KeyInput.Text = ""
        KeyInput.PlaceholderText = "WRONG KEY!"
    end
end)

local Title = Instance.new("TextLabel", Main)
Title.Size = UDim2.new(1, 0, 0, 40); Title.Text = "VENOM V18 // FINAL CORE"; Title.TextColor3 = Color3.fromRGB(0, 255, 150); Title.Font = "GothamBold"; Title.TextSize = 16; Title.BackgroundTransparency = 1

local Scroll = Instance.new("ScrollingFrame", Main)
Scroll.Size = UDim2.new(1, -20, 1, -60); Scroll.Position = UDim2.new(0, 10, 0, 50); Scroll.BackgroundTransparency = 1; Scroll.ScrollBarThickness = 0
local Grid = Instance.new("UIGridLayout", Scroll)
Grid.CellSize = UDim2.new(0, 180, 0, 40); Grid.CellPadding = UDim2.new(0, 10, 0, 10)

local function AddToggle(name, callback)
    local B = Instance.new("TextButton", Scroll)
    B.Size = UDim2.new(1, 0, 0, 40); B.BackgroundColor3 = Color3.fromRGB(20, 20, 25); B.Text = name; B.TextColor3 = Color3.fromRGB(150, 150, 150); B.Font = "GothamBold"; B.TextSize = 10
    Instance.new("UICorner", B).CornerRadius = UDim.new(0, 6)
    B.MouseButton1Click:Connect(function()
        if not Authenticated then return end
        Config.Flags[name] = not Config.Flags[name]
        TS:Create(B, TweenInfo.new(0.2), {BackgroundColor3 = Config.Flags[name] and Color3.fromRGB(0, 120, 70) or Color3.fromRGB(20, 20, 25)}):Play()
        B.TextColor3 = Config.Flags[name] and Color3.new(1, 1, 1) or Color3.fromRGB(150, 150, 150)
        callback(Config.Flags[name])
    end)
end

-- ФУНКЦИИ
AddToggle("SERVER BYPASS", function() end)
AddToggle("FLY (AUTO-FIX)", function(v) Config.Flags["Fly"] = v end)
AddToggle("AURA + MEGA HITBOX", function(v) Config.Flags["AirAura"] = v end)
AddToggle("SPEED STEALTH", function(v) Config.Flags["Speed"] = v end)
AddToggle("FAST STEAL (E)", function(v) Config.Flags["FastSteal"] = v end)
AddToggle("BLINK STEAL BASE", function(v) 
    if v then
        local hrp = LP.Character.HumanoidRootPart
        local old = hrp.CFrame
        hrp.CFrame = CFrame.new(0, 15000, 0)
        task.wait(0.1)
        hrp.CFrame = old
        LP:Kick("stole")
    end
end)
AddToggle("GOD MODE (NO HIT)", function(v) Config.Flags["God"] = v end)
AddToggle("ANTI-KNOCKBACK", function(v) Config.Flags["AntiKB"] = v end)
AddToggle("ANTI-STUN", function(v) Config.Flags["AntiStun"] = v end)
AddToggle("NOCLIP MASTER", function(v) Config.Flags["Noclip"] = v end)

-- ОСНОВНОЙ ЦИКЛ (ОБНОВЛЕННЫЙ)
RS.Heartbeat:Connect(function()
    if not Authenticated then return end
    local char = LP.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if not hrp or not hum then return end

    -- Noclip & AntiStun
    if Config.Flags["NOCLIP MASTER"] then hum:ChangeState(11) end
    if Config.Flags["ANTI-STUN"] and (hum:GetState() == Enum.HumanoidStateType.Ragdoll) then hum:ChangeState(Enum.HumanoidStateType.GettingUp) end

    -- Fast Steal (Твой метод)
    if Config.Flags["FAST STEAL (E)"] then
        for _, p in pairs(workspace:GetDescendants()) do
            if p:IsA("ProximityPrompt") then p.HoldDuration = 0 end
        end
    end

    -- God Mode
    if Config.Flags["GOD MODE (NO HIT)"] then
        for _, p in pairs(char:GetChildren()) do
            if p:IsA("BasePart") and p.Name ~= "HumanoidRootPart" then p.CanTouch = false end
        end
    end

    -- Aura & Hitbox
    local target = Config.Flags["AURA + MEGA HITBOX"] and (function()
        local cl, d = nil, Config.AuraRadius
        for _, v in pairs(game.Players:GetPlayers()) do
            if v ~= LP and v.Character and v.Character:FindFirstChild("HumanoidRootPart") and v.Character.Humanoid.Health > 0 then
                local dist = (hrp.Position - v.Character.HumanoidRootPart.Position).Magnitude
                if dist < d then d = dist; cl = v end
            end
        end
        return cl
    end)()

    if Config.Flags["AURA + MEGA HITBOX"] then
        local tool = char:FindFirstChildOfClass("Tool")
        if tool then tool:Activate() end
        for _, v in pairs(game.Players:GetPlayers()) do
            if v ~= LP and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
                local eHRP = v.Character.HumanoidRootPart
                if target and v == target then
                    eHRP.Size = Vector3.new(Config.HitboxSize, Config.HitboxSize, Config.HitboxSize)
                    eHRP.CanCollide = false
                else eHRP.Size = Vector3.new(2, 2, 1) end
            end
        end
    end

    -- ИСПРАВЛЕННЫЙ ФЛАЙ (ИЗ ТВОЕГО СКРИПТА)
    if Config.Flags["FLY (AUTO-FIX)"] then
        local bp = hrp:FindFirstChild("VenomFly") or Instance.new("BodyPosition", hrp)
        bp.Name = "VenomFly"; bp.MaxForce = Vector3.new(0, math.huge, 0); bp.P = 15000
        
        if target and Config.Flags["AURA + MEGA HITBOX"] then
            bp.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
            bp.Position = target.Character.HumanoidRootPart.Position + Vector3.new(0, Config.AuraHeight, 0)
        else
            bp.MaxForce = Vector3.new(0, math.huge, 0)
            local ray = Ray.new(hrp.Position, Vector3.new(0, -100, 0))
            local _, hitPos = workspace:FindPartOnRay(ray, char)
            bp.Position = Vector3.new(0, hitPos.Y + Config.FlyHeight, 0)
            
            if Config.Flags["SPEED STEALTH"] and hum.MoveDirection.Magnitude > 0 then
                hrp.CFrame = hrp.CFrame + (hum.MoveDirection * Config.SpeedValue)
            end
        end
        
        -- Anti-Knockback (Desync style внутри флая)
        if Config.Flags["ANTI-KNOCKBACK"] then hrp.Velocity = Vector3.new(0, 0.05, 0) end
    else
        if hrp:FindFirstChild("VenomFly") then hrp.VenomFly:Destroy() end
    end
end)

-- DRAG SYSTEM
local dG, dS, sP;
Main.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then dG=true; dS=i.Position; sP=Main.Position end end)
UIS.InputChanged:Connect(function(i) if dG and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then local d=i.Position-dS; Main.Position=UDim2.new(sP.X.Scale, sP.X.Offset+d.X, sP.Y.Scale, sP.Y.Offset+d.Y) end end)
UIS.InputEnded:Connect(function() dG = false end)
