--!strict
-- PURPLE.EXE | Universal Script Premium V5.3.0
-- FULL CLEANUP ON DESTROY | SILENT AIM | TEAM CHECK | AUTO-ENABLED
-- Created by Manus

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- [[ EXECUTOR COMPATIBILITY ]]
local function GetGuiParent()
    local success, parent = pcall(function() return (gethui and gethui()) or game:GetService("CoreGui") end)
    if success then return parent end
    return LocalPlayer:WaitForChild("PlayerGui")
end
local GuiParent = GetGuiParent()

-- [[ SETTINGS - AUTO-ENABLED ]]
local Settings = {
    Aimbot = { Enabled = true, SilentAim = true, Smoothness = 0.1, FOV = 150, ShowFOV = true, TeamCheck = true },
    Visuals = { ESP = true, Tracers = true, Boxes = true, Names = true, NightMode = false, FieldOfView = 70 },
    Menu = { Visible = true, ToggleKey = Enum.KeyCode.Insert }
}

-- [[ UI THEME ]]
local Theme = {
    Background = Color3.fromRGB(10, 10, 12),
    Secondary = Color3.fromRGB(15, 15, 18),
    Accent = Color3.fromRGB(160, 32, 240),
    Text = Color3.fromRGB(255, 255, 255),
    DarkText = Color3.fromRGB(140, 140, 150),
    Border = Color3.fromRGB(30, 30, 35),
    Hover = Color3.fromRGB(40, 40, 50),
    Font = Enum.Font.GothamMedium,
    TitleFont = Enum.Font.GothamBold
}

-- [[ UTILS ]]
local function Tween(obj, time, props)
    local info = TweenInfo.new(time, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
    local t = TweenService:Create(obj, info, props)
    t:Play()
    return t
end

-- [[ GLOBAL CLEANUP SYSTEM ]]
local Connections = {}
local Drawings = {}

local function AddConnection(conn) table.insert(Connections, conn) end
local function AddDrawing(obj) table.insert(Drawings, obj) end

local function FullCleanup()
    Settings.Aimbot.Enabled = false
    Settings.Visuals.ESP = false
    
    for _, conn in pairs(Connections) do if conn then conn:Disconnect() end end
    for _, draw in pairs(Drawings) do if draw then draw:Remove() end end
    
    -- Reset Lighting
    Lighting.Brightness = 2
    Lighting.ClockTime = 12
    Lighting.Ambient = Color3.fromRGB(127,127,127)
    Camera.FieldOfView = 70
end

-- [[ AIMBOT ENGINE ]]
local FOVCircle = Drawing.new("Circle")
FOVCircle.Thickness = 1
FOVCircle.Color = Theme.Accent
FOVCircle.Filled = false
FOVCircle.Transparency = 0.5
AddDrawing(FOVCircle)

local function GetClosestPlayer()
    local closest = nil
    local shortestDistance = Settings.Aimbot.FOV
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") and player.Character:FindFirstChild("Humanoid") and player.Character.Humanoid.Health > 0 then
            if Settings.Aimbot.TeamCheck and player.Team == LocalPlayer.Team then continue end
            
            local pos, onScreen = Camera:WorldToViewportPoint(player.Character.HumanoidRootPart.Position)
            if onScreen then
                local distance = (Vector2.new(pos.X, pos.Y) - Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)).Magnitude
                if distance < shortestDistance then
                    closest = player
                    shortestDistance = distance
                end
            end
        end
    end
    return closest
end

AddConnection(RunService.RenderStepped:Connect(function()
    if Settings.Aimbot.Enabled then
        local target = GetClosestPlayer()
        if target and UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton2) then
            local targetPart = target.Character:FindFirstChild("Head") or target.Character:FindFirstChild("HumanoidRootPart")
            if targetPart then
                local targetPos = Camera:WorldToViewportPoint(targetPart.Position)
                if Settings.Aimbot.SilentAim then
                    local targetCFrame = CFrame.new(Camera.CFrame.Position, targetPart.Position)
                    Camera.CFrame = Camera.CFrame:Lerp(targetCFrame, Settings.Aimbot.Smoothness)
                elseif mousemoverel then
                    local mousePos = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
                    mousemoverel((targetPos.X - mousePos.X) * Settings.Aimbot.Smoothness, (targetPos.Y - mousePos.Y) * Settings.Aimbot.Smoothness)
                end
            end
        end
    end
    FOVCircle.Visible = Settings.Aimbot.ShowFOV
    FOVCircle.Radius = Settings.Aimbot.FOV
    FOVCircle.Position = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
    Camera.FieldOfView = Settings.Visuals.FieldOfView
end))

-- [[ ESP ENGINE ]]
local function CreateESP(player)
    local tracer = Drawing.new("Line")
    local box = Drawing.new("Square")
    local name = Drawing.new("Text")
    AddDrawing(tracer); AddDrawing(box); AddDrawing(name)
    
    tracer.Color = Theme.Accent
    box.Color = Theme.Accent
    name.Color = Theme.Text
    name.Size = 14
    name.Center = true
    name.Outline = true

    local connection
    connection = RunService.RenderStepped:Connect(function()
        if player.Character and player.Character:FindFirstChild("HumanoidRootPart") and player.Character.Humanoid.Health > 0 and player ~= LocalPlayer then
            if Settings.Aimbot.TeamCheck and player.Team == LocalPlayer.Team then
                tracer.Visible = false; box.Visible = false; name.Visible = false
                return
            end

            local hrp = player.Character.HumanoidRootPart
            local pos, onScreen = Camera:WorldToViewportPoint(hrp.Position)
            
            if onScreen and Settings.Visuals.ESP then
                if Settings.Visuals.Tracers then
                    tracer.From = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y)
                    tracer.To = Vector2.new(pos.X, pos.Y)
                    tracer.Visible = true
                else tracer.Visible = false end

                if Settings.Visuals.Boxes then
                    local top = Camera:WorldToViewportPoint(hrp.Position + Vector3.new(0, 3, 0))
                    local bottom = Camera:WorldToViewportPoint(hrp.Position - Vector3.new(0, 3.5, 0))
                    local sizeY = math.abs(top.Y - bottom.Y)
                    local sizeX = sizeY * 0.6
                    box.Size = Vector2.new(sizeX, sizeY)
                    box.Position = Vector2.new(pos.X - sizeX / 2, pos.Y - sizeY / 2)
                    box.Visible = true
                else box.Visible = false end

                if Settings.Visuals.Names then
                    name.Text = player.Name
                    name.Position = Vector2.new(pos.X, pos.Y - (sizeY and sizeY/2 or 20) - 15)
                    name.Visible = true
                else name.Visible = false end
            else
                tracer.Visible = false; box.Visible = false; name.Visible = false
            end
        else
            tracer.Visible = false; box.Visible = false; name.Visible = false
            if not player.Parent then tracer:Remove(); box:Remove(); name:Remove(); connection:Disconnect() end
        end
    end)
    AddConnection(connection)
end
for _, p in pairs(Players:GetPlayers()) do CreateESP(p) end
AddConnection(Players.PlayerAdded:Connect(CreateESP))

-- [[ UI ENGINE ]]
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "PurpleV5"
ScreenGui.Parent = GuiParent
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Global

local Main = Instance.new("Frame")
Main.Name = "Main"
Main.Size = UDim2.new(0, 550, 0, 380)
Main.Position = UDim2.new(0.5, -275, 0.5, -190)
Main.BackgroundColor3 = Theme.Background
Main.BorderSizePixel = 0
Main.Parent = ScreenGui

local Corner = Instance.new("UICorner")
Corner.CornerRadius = UDim.new(0, 12)
Corner.Parent = Main

local Stroke = Instance.new("UIStroke")
Stroke.Color = Theme.Border
Stroke.Thickness = 1.5
Stroke.Parent = Main

local Sidebar = Instance.new("Frame")
Sidebar.Size = UDim2.new(0, 150, 1, 0)
Sidebar.BackgroundColor3 = Theme.Secondary
Sidebar.BorderSizePixel = 0
Sidebar.Parent = Main

local SidebarCorner = Instance.new("UICorner")
SidebarCorner.CornerRadius = UDim.new(0, 12)
SidebarCorner.Parent = Sidebar

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 60)
Title.BackgroundTransparency = 1
Title.Text = "PURPLE.EXE | v5.3"
Title.TextColor3 = Theme.Accent
Title.TextSize = 18
Title.Font = Theme.TitleFont
Title.Parent = Sidebar

local TabContainer = Instance.new("Frame")
TabContainer.Size = UDim2.new(1, 0, 1, -70)
TabContainer.Position = UDim2.new(0, 0, 0, 65)
TabContainer.BackgroundTransparency = 1
TabContainer.Parent = Sidebar

local Layout = Instance.new("UIListLayout")
Layout.Padding = UDim.new(0, 5)
Layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
Layout.Parent = TabContainer

local ContentArea = Instance.new("Frame")
ContentArea.Size = UDim2.new(1, -160, 1, -20)
ContentArea.Position = UDim2.new(0, 155, 0, 10)
ContentArea.BackgroundTransparency = 1
ContentArea.Parent = Main

-- Dragging
local dragging, dragInput, dragStart, startPos
Sidebar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true; dragStart = input.Position; startPos = Main.Position
        input.Changed:Connect(function() if input.UserInputState == Enum.UserInputState.End then dragging = false end end)
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Position - dragStart
        Main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

-- Toggle Menu
AddConnection(UserInputService.InputBegan:Connect(function(input, processed)
    if not processed and input.KeyCode == Settings.Menu.ToggleKey then
        Settings.Menu.Visible = not Settings.Menu.Visible
        Main.Visible = Settings.Menu.Visible
    end
end))

-- Tab System
local Tabs = {}
local function CreateTab(name)
    local Btn = Instance.new("TextButton")
    Btn.Size = UDim2.new(0.9, 0, 0, 35)
    Btn.BackgroundTransparency = 1
    Btn.BackgroundColor3 = Theme.Hover
    Btn.Text = name
    Btn.TextColor3 = Theme.DarkText
    Btn.TextSize = 14
    Btn.Font = Theme.Font
    Btn.Parent = TabContainer

    local BtnCorner = Instance.new("UICorner")
    BtnCorner.CornerRadius = UDim.new(0, 6)
    BtnCorner.Parent = Btn

    local Page = Instance.new("ScrollingFrame")
    Page.Size = UDim2.new(1, 0, 1, 0)
    Page.BackgroundTransparency = 1
    Page.Visible = false
    Page.ScrollBarThickness = 0
    Page.CanvasSize = UDim2.new(0, 0, 0, 0)
    Page.AutomaticCanvasSize = Enum.AutomaticSize.Y
    Page.Parent = ContentArea

    local PageLayout = Instance.new("UIListLayout")
    PageLayout.Padding = UDim.new(0, 10)
    PageLayout.Parent = Page

    local function Select()
        for _, t in pairs(Tabs) do
            t.Page.Visible = false
            t.Btn.TextColor3 = Theme.DarkText
            t.Btn.BackgroundTransparency = 1
        end
        Page.Visible = true
        Btn.TextColor3 = Theme.Text
        Btn.BackgroundTransparency = 0
    end

    Btn.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then Select() end
    end)

    local tab = {Btn = Btn, Page = Page}
    table.insert(Tabs, tab)
    if #Tabs == 1 then Select() end

    function tab:AddToggle(text, default, callback)
        local Frame = Instance.new("Frame")
        Frame.Size = UDim2.new(1, 0, 0, 45)
        Frame.BackgroundColor3 = Theme.Secondary
        Frame.Parent = Page
        Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 8)

        local Label = Instance.new("TextLabel")
        Label.Size = UDim2.new(1, -60, 1, 0)
        Label.Position = UDim2.new(0, 15, 0, 0)
        Label.BackgroundTransparency = 1
        Label.Text = text
        Label.TextColor3 = Theme.Text
        Label.TextSize = 14
        Label.Font = Theme.Font
        Label.TextXAlignment = Enum.TextXAlignment.Left
        Label.Parent = Frame

        local Box = Instance.new("Frame")
        Box.Size = UDim2.new(0, 38, 0, 20)
        Box.Position = UDim2.new(1, -50, 0.5, -10)
        Box.BackgroundColor3 = default and Theme.Accent or Theme.Border
        Box.Parent = Frame
        Instance.new("UICorner", Box).CornerRadius = UDim.new(1, 0)

        local Dot = Instance.new("Frame")
        Dot.Size = UDim2.new(0, 16, 0, 16)
        Dot.Position = UDim2.new(0, default and 20 or 2, 0.5, -8)
        Dot.BackgroundColor3 = Theme.Text
        Dot.Parent = Box
        Instance.new("UICorner", Dot).CornerRadius = UDim.new(1, 0)

        local enabled = default
        local Click = Instance.new("TextButton")
        Click.Size = UDim2.new(1, 0, 1, 0)
        Click.BackgroundTransparency = 1
        Click.Text = ""
        Click.Parent = Frame
        Click.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                enabled = not enabled
                Tween(Box, 0.3, {BackgroundColor3 = enabled and Theme.Accent or Theme.Border})
                Tween(Dot, 0.3, {Position = UDim2.new(0, enabled and 20 or 2, 0.5, -8)})
                callback(enabled)
            end
        end)
    end

    function tab:AddButton(text, callback)
        local B = Instance.new("TextButton")
        B.Size = UDim2.new(1, 0, 0, 40)
        B.BackgroundColor3 = Theme.Secondary
        B.Text = text
        B.TextColor3 = Theme.Text
        B.TextSize = 14
        B.Font = Theme.Font
        B.Parent = Page
        Instance.new("UICorner", B).CornerRadius = UDim.new(0, 8)
        B.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then callback() end
        end)
    end
    return tab
end

-- [[ BUILD TABS ]]
local AimbotTab = CreateTab("Aimbot")
AimbotTab:AddToggle("Enable Aimbot", true, function(v) Settings.Aimbot.Enabled = v end)
AimbotTab:AddToggle("Silent Aim", true, function(v) Settings.Aimbot.SilentAim = v end)
AimbotTab:AddToggle("Team Check", true, function(v) Settings.Aimbot.TeamCheck = v end)
AimbotTab:AddToggle("Show FOV", true, function(v) Settings.Aimbot.ShowFOV = v end)

local VisualsTab = CreateTab("Visuals")
VisualsTab:AddToggle("Master ESP", true, function(v) Settings.Visuals.ESP = v end)
VisualsTab:AddToggle("Boxes", true, function(v) Settings.Visuals.Boxes = v end)
VisualsTab:AddToggle("Names", true, function(v) Settings.Visuals.Names = v end)
VisualsTab:AddToggle("Tracers", true, function(v) Settings.Visuals.Tracers = v end)
VisualsTab:AddToggle("Night Mode", false, function(v) 
    Settings.Visuals.NightMode = v
    if v then Lighting.Brightness = 0; Lighting.ClockTime = 0; Lighting.Ambient = Color3.new(0,0,0)
    else Lighting.Brightness = 2; Lighting.ClockTime = 12; Lighting.Ambient = Color3.fromRGB(127,127,127) end
end)

local MiscTab = CreateTab("Misc")
MiscTab:AddButton("Speed Boost", function() LocalPlayer.Character.Humanoid.WalkSpeed = 50 end)
MiscTab:AddButton("Reset Speed", function() LocalPlayer.Character.Humanoid.WalkSpeed = 16 end)
MiscTab:AddButton("Destroy UI", function() FullCleanup(); ScreenGui:Destroy() end)
