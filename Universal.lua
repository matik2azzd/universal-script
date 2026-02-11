--!strict
-- PURPLE.EXE | Universal Script Premium V4.7.0
-- INTERNAL VISUALS | FIXED TABS | FIXED DRAGGING | FULL ESP
-- Created by Manus

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- [[ SETTINGS ]]
local Settings = {
    Aimbot = { Enabled = false, Smoothness = 0.15, FOV = 150, ShowFOV = true },
    Visuals = { ESP = false, Tracers = false, Boxes = false, Names = false, NightMode = false, FieldOfView = 70 },
    Menu = { Visible = true, ToggleKey = Enum.KeyCode.Insert }
}

-- [[ UI LIBRARY ]]
local CustomLib = {}
local Theme = {
    Background = Color3.fromRGB(10, 10, 12),
    Secondary = Color3.fromRGB(15, 15, 18),
    Accent = Color3.fromRGB(160, 32, 240),
    Glow = Color3.fromRGB(180, 50, 255),
    Text = Color3.fromRGB(255, 255, 255),
    DarkText = Color3.fromRGB(140, 140, 150),
    Border = Color3.fromRGB(30, 30, 35),
    Hover = Color3.fromRGB(40, 40, 50),
    Font = Enum.Font.GothamMedium,
    TitleFont = Enum.Font.GothamBold
}

function CustomLib:Tween(object, time, properties)
    local info = TweenInfo.new(time, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
    local tween = TweenService:Create(object, info, properties)
    tween:Play()
    return tween
end

function CustomLib:Create(className, properties)
    local instance = Instance.new(className)
    for i, v in pairs(properties) do
        if i ~= "Parent" then instance[i] = v end
    end
    instance.Parent = properties.Parent
    return instance
end

-- [[ DRAGGING SYSTEM ]]
local function MakeDraggable(topbar, object)
    local dragging, dragInput, dragStart, startPos
    topbar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = object.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then dragging = false end
            end)
        end
    end)
    topbar.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then dragInput = input end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            object.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
end

-- [[ LOADER IMPLEMENTATION ]]
function CustomLib:InitLoader(title)
    local ScreenGui = self:Create("ScreenGui", { Name = "UniversalLoader", Parent = CoreGui, IgnoreGuiInset = true })
    local Main = self:Create("Frame", { Name = "Main", Size = UDim2.new(0, 350, 0, 200), Position = UDim2.new(0.5, -175, 0.5, -100), BackgroundColor3 = Theme.Background, BorderSizePixel = 0, ClipsDescendants = true, Parent = ScreenGui })
    self:Create("UICorner", { CornerRadius = UDim.new(0, 15), Parent = Main })
    local Glow = self:Create("UIStroke", { Color = Theme.Accent, Thickness = 2, Parent = Main })
    local Title = self:Create("TextLabel", { Size = UDim2.new(1, 0, 0, 60), BackgroundTransparency = 1, Text = title, TextColor3 = Theme.Text, TextSize = 22, Font = Theme.TitleFont, Parent = Main })
    local Status = self:Create("TextLabel", { Size = UDim2.new(1, 0, 0, 20), Position = UDim2.new(0, 0, 0.5, 0), BackgroundTransparency = 1, Text = "Initializing...", TextColor3 = Theme.DarkText, TextSize = 14, Font = Theme.Font, Parent = Main })
    local ProgressBack = self:Create("Frame", { Size = UDim2.new(0.7, 0, 0, 4), Position = UDim2.new(0.15, 0, 0.75, 0), BackgroundColor3 = Theme.Border, Parent = Main })
    local ProgressBar = self:Create("Frame", { Size = UDim2.new(0, 0, 1, 0), BackgroundColor3 = Theme.Accent, Parent = ProgressBack })
    self:Create("UICorner", { CornerRadius = UDim.new(1, 0), Parent = ProgressBack })
    self:Create("UICorner", { CornerRadius = UDim.new(1, 0), Parent = ProgressBar })

    local loader = {}
    function loader:UpdateStatus(text, progress)
        Status.Text = text
        CustomLib:Tween(ProgressBar, 0.5, {Size = UDim2.new(progress, 0, 1, 0)})
    end
    function loader:Close()
        CustomLib:Tween(Main, 0.8, {BackgroundTransparency = 1, Position = UDim2.new(0.5, -175, 0.4, -100)})
        task.wait(0.8)
        ScreenGui:Destroy()
    end
    return loader
end

-- [[ AIMBOT LOGIC ]]
local FOVCircle = Drawing.new("Circle")
FOVCircle.Thickness = 1
FOVCircle.Color = Theme.Accent
FOVCircle.Filled = false
FOVCircle.Transparency = 0.5

local function GetClosestPlayer()
    local closest = nil
    local shortestDistance = Settings.Aimbot.FOV
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") and player.Character:FindFirstChild("Humanoid") and player.Character.Humanoid.Health > 0 then
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

RunService.RenderStepped:Connect(function()
    if Settings.Aimbot.Enabled then
        local target = GetClosestPlayer()
        if target and UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton2) then
            local targetPos = Camera:WorldToViewportPoint(target.Character.HumanoidRootPart.Position)
            local mousePos = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
            if mousemoverel then
                mousemoverel((targetPos.X - mousePos.X) * Settings.Aimbot.Smoothness, (targetPos.Y - mousePos.Y) * Settings.Aimbot.Smoothness)
            else
                local targetCFrame = CFrame.new(Camera.CFrame.Position, target.Character.HumanoidRootPart.Position)
                Camera.CFrame = Camera.CFrame:Lerp(targetCFrame, Settings.Aimbot.Smoothness)
            end
        end
    end
    FOVCircle.Visible = Settings.Aimbot.ShowFOV
    FOVCircle.Radius = Settings.Aimbot.FOV
    FOVCircle.Position = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
    Camera.FieldOfView = Settings.Visuals.FieldOfView
end)

-- [[ NIGHT MODE LOGIC ]]
local OriginalLighting = {
    Ambient = Lighting.Ambient,
    OutdoorAmbient = Lighting.OutdoorAmbient,
    Brightness = Lighting.Brightness,
    ClockTime = Lighting.ClockTime
}

local function SetNightMode(state)
    if state then
        Lighting.Ambient = Color3.fromRGB(0, 0, 0)
        Lighting.OutdoorAmbient = Color3.fromRGB(0, 0, 0)
        Lighting.Brightness = 0
        Lighting.ClockTime = 0
    else
        Lighting.Ambient = OriginalLighting.Ambient
        Lighting.OutdoorAmbient = OriginalLighting.OutdoorAmbient
        Lighting.Brightness = OriginalLighting.Brightness
        Lighting.ClockTime = OriginalLighting.ClockTime
    end
end

-- [[ ESP LOGIC ]]
local function CreateESP(player)
    local tracer = Drawing.new("Line")
    tracer.Visible = false
    tracer.Color = Theme.Accent
    tracer.Thickness = 1
    tracer.Transparency = 0.8

    local box = Drawing.new("Square")
    box.Visible = false
    box.Color = Theme.Accent
    box.Thickness = 1
    box.Filled = false
    box.Transparency = 0.8

    local name = Drawing.new("Text")
    name.Visible = false
    name.Color = Theme.Text
    name.Size = 14
    name.Center = true
    name.Outline = true
    name.Font = 2 -- Gotham

    local connection
    connection = RunService.RenderStepped:Connect(function()
        if player.Character and player.Character:FindFirstChild("HumanoidRootPart") and player.Character:FindFirstChild("Humanoid") and player.Character.Humanoid.Health > 0 and player ~= LocalPlayer then
            local hrp = player.Character.HumanoidRootPart
            local pos, onScreen = Camera:WorldToViewportPoint(hrp.Position)
            
            if onScreen and Settings.Visuals.ESP then
                if Settings.Visuals.Tracers then
                    tracer.From = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y)
                    tracer.To = Vector2.new(pos.X, pos.Y)
                    tracer.Visible = true
                else
                    tracer.Visible = false
                end

                if Settings.Visuals.Boxes then
                    local size = (Camera:WorldToViewportPoint(hrp.Position - Vector3.new(0, 3, 0)).Y - Camera:WorldToViewportPoint(hrp.Position + Vector3.new(0, 2.6, 0)).Y)
                    box.Size = Vector2.new(size * 0.6, size)
                    box.Position = Vector2.new(pos.X - box.Size.X / 2, pos.Y - box.Size.Y / 2)
                    box.Visible = true
                else
                    box.Visible = false
                end

                if Settings.Visuals.Names then
                    name.Text = player.Name
                    name.Position = Vector2.new(pos.X, pos.Y - (box.Size.Y / 2) - 15)
                    name.Visible = true
                else
                    name.Visible = false
                end
            else
                tracer.Visible = false
                box.Visible = false
                name.Visible = false
            end
        else
            tracer.Visible = false
            box.Visible = false
            name.Visible = false
            if not player.Parent then
                tracer:Remove()
                box:Remove()
                name:Remove()
                connection:Disconnect()
            end
        end
    end)
end

for _, player in pairs(Players:GetPlayers()) do CreateESP(player) end
Players.PlayerAdded:Connect(CreateESP)

-- [[ UI IMPLEMENTATION ]]
function CustomLib:CreateWindow(title)
    local ScreenGui = self:Create("ScreenGui", { Name = "UniversalMenuV4", Parent = CoreGui, IgnoreGuiInset = true })
    local Main = self:Create("Frame", { Name = "Main", Size = UDim2.new(0, 550, 0, 380), Position = UDim2.new(0.5, -275, 0.5, -190), BackgroundColor3 = Theme.Background, BorderSizePixel = 0, Parent = ScreenGui })
    self:Create("UICorner", { CornerRadius = UDim.new(0, 12), Parent = Main })
    self:Create("UIStroke", { Color = Theme.Border, Thickness = 1.5, Parent = Main })

    local Sidebar = self:Create("Frame", { Size = UDim2.new(0, 150, 1, 0), BackgroundColor3 = Theme.Secondary, Parent = Main })
    self:Create("UICorner", { CornerRadius = UDim.new(0, 12), Parent = Sidebar })
    self:Create("Frame", { Size = UDim2.new(0, 20, 1, 0), Position = UDim2.new(1, -20, 0, 0), BackgroundColor3 = Theme.Secondary, BorderSizePixel = 0, Parent = Sidebar })

    local TitleLabel = self:Create("TextLabel", { Size = UDim2.new(1, 0, 0, 60), BackgroundTransparency = 1, Text = title, TextColor3 = Theme.Accent, TextSize = 18, Font = Theme.TitleFont, Parent = Sidebar })
    local TabContainer = self:Create("Frame", { Size = UDim2.new(1, 0, 1, -70), Position = UDim2.new(0, 0, 0, 65), BackgroundTransparency = 1, Parent = Sidebar })
    self:Create("UIListLayout", { Padding = UDim.new(0, 5), HorizontalAlignment = Enum.HorizontalAlignment.Center, Parent = TabContainer })

    local ContentArea = self:Create("Frame", { Size = UDim2.new(1, -160, 1, -20), Position = UDim2.new(0, 155, 0, 10), BackgroundTransparency = 1, Parent = Main })

    local CloseBtn = self:Create("TextButton", { Size = UDim2.new(0, 30, 0, 30), Position = UDim2.new(1, -35, 0, 5), BackgroundTransparency = 1, Text = "X", TextColor3 = Theme.DarkText, TextSize = 18, Font = Theme.Font, Parent = Main })
    CloseBtn.MouseButton1Click:Connect(function() ScreenGui:Destroy() FOVCircle:Remove() SetNightMode(false) end)

    UserInputService.InputBegan:Connect(function(input, processed)
        if not processed and input.KeyCode == Settings.Menu.ToggleKey then
            Settings.Menu.Visible = not Settings.Menu.Visible
            Main.Visible = Settings.Menu.Visible
        end
    end)

    MakeDraggable(Sidebar, Main)

    local window = { CurrentTab = nil }
    function window:CreateTab(name)
        local TabBtn = CustomLib:Create("TextButton", { Size = UDim2.new(0.9, 0, 0, 35), BackgroundTransparency = 1, Text = name, TextColor3 = Theme.DarkText, TextSize = 14, Font = Theme.Font, Parent = TabContainer })
        self:Create("UICorner", { CornerRadius = UDim.new(0, 6), Parent = TabBtn })
        
        local TabPage = CustomLib:Create("ScrollingFrame", { Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1, Visible = false, ScrollBarThickness = 0, CanvasSize = UDim2.new(0, 0, 0, 0), AutomaticCanvasSize = Enum.AutomaticSize.Y, Parent = ContentArea })
        self:Create("UIListLayout", { Padding = UDim.new(0, 10), Parent = TabPage })

        local tab = {}
        function tab:AddToggle(text, default, callback)
            local ToggleFrame = CustomLib:Create("Frame", { Size = UDim2.new(1, 0, 0, 45), BackgroundColor3 = Theme.Secondary, Parent = TabPage })
            self:Create("UICorner", { CornerRadius = UDim.new(0, 8), Parent = ToggleFrame })
            local Label = CustomLib:Create("TextLabel", { Size = UDim2.new(1, -60, 1, 0), Position = UDim2.new(0, 15, 0, 0), BackgroundTransparency = 1, Text = text, TextColor3 = Theme.Text, TextSize = 14, Font = Theme.Font, TextXAlignment = Enum.TextXAlignment.Left, Parent = ToggleFrame })
            local Box = CustomLib:Create("Frame", { Size = UDim2.new(0, 38, 0, 20), Position = UDim2.new(1, -50, 0.5, -10), BackgroundColor3 = default and Theme.Accent or Theme.Border, Parent = ToggleFrame })
            self:Create("UICorner", { CornerRadius = UDim.new(1, 0), Parent = Box })
            local Dot = CustomLib:Create("Frame", { Size = UDim2.new(0, 16, 0, 16), Position = UDim2.new(0, default and 20 or 2, 0.5, -8), BackgroundColor3 = Theme.Text, Parent = Box })
            self:Create("UICorner", { CornerRadius = UDim.new(1, 0), Parent = Dot })
            local enabled = default
            CustomLib:Create("TextButton", { Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1, Text = "", Parent = ToggleFrame }).MouseButton1Click:Connect(function()
                enabled = not enabled
                CustomLib:Tween(Box, 0.3, {BackgroundColor3 = enabled and Theme.Accent or Theme.Border})
                CustomLib:Tween(Dot, 0.3, {Position = UDim2.new(0, enabled and 20 or 2, 0.5, -8)})
                callback(enabled)
            end)
        end
        function tab:AddButton(text, callback)
            local Btn = CustomLib:Create("TextButton", { Size = UDim2.new(1, 0, 0, 40), BackgroundColor3 = Theme.Secondary, Text = text, TextColor3 = Theme.Text, TextSize = 14, Font = Theme.Font, Parent = TabPage })
            self:Create("UICorner", { CornerRadius = UDim.new(0, 8), Parent = Btn })
            Btn.MouseButton1Click:Connect(callback)
        end

        TabBtn.MouseButton1Click:Connect(function()
            if window.CurrentTab then 
                window.CurrentTab.Page.Visible = false 
                window.CurrentTab.Btn.TextColor3 = Theme.DarkText 
                window.CurrentTab.Btn.BackgroundTransparency = 1 
            end
            TabPage.Visible = true 
            TabBtn.TextColor3 = Theme.Text 
            TabBtn.BackgroundTransparency = 0 
            TabBtn.BackgroundColor3 = Theme.Hover
            window.CurrentTab = { Page = TabPage, Btn = TabBtn }
        end)
        
        if not window.CurrentTab then 
            TabPage.Visible = true 
            TabBtn.TextColor3 = Theme.Text 
            TabBtn.BackgroundTransparency = 0 
            TabBtn.BackgroundColor3 = Theme.Hover 
            window.CurrentTab = { Page = TabPage, Btn = TabBtn } 
        end
        return tab
    end
    return window
end

-- [[ EXECUTION ]]
local Loader = CustomLib:InitLoader("PURPLE GLOW")
task.wait(0.5) Loader:UpdateStatus("Bypassing Security...", 0.3)
task.wait(0.8) Loader:UpdateStatus("Injecting Modules...", 0.6)
task.wait(0.6) Loader:UpdateStatus("Loading Internal Visuals...", 0.8)
task.wait(0.5) Loader:UpdateStatus("Welcome, User!", 1)
task.wait(0.5) Loader:Close()

local Window = CustomLib:CreateWindow("PURPLE.EXE | v4.7.0")
local AimbotTab = Window:CreateTab("Aimbot")
AimbotTab:AddToggle("Enable Aimbot", false, function(v) Settings.Aimbot.Enabled = v end)
AimbotTab:AddToggle("Show FOV", true, function(v) Settings.Aimbot.ShowFOV = v end)

local VisualsTab = Window:CreateTab("Visuals")
VisualsTab:AddToggle("Master ESP", false, function(v) Settings.Visuals.ESP = v end)
VisualsTab:AddToggle("Boxes", false, function(v) Settings.Visuals.Boxes = v end)
VisualsTab:AddToggle("Names", false, function(v) Settings.Visuals.Names = v end)
VisualsTab:AddToggle("Tracers", false, function(v) Settings.Visuals.Tracers = v end)
VisualsTab:AddToggle("Night Mode", false, function(v) Settings.Visuals.NightMode = v SetNightMode(v) end)
VisualsTab:AddButton("Change FOV (Cycle)", function()
    if Settings.Visuals.FieldOfView == 70 then Settings.Visuals.FieldOfView = 90
    elseif Settings.Visuals.FieldOfView == 90 then Settings.Visuals.FieldOfView = 110
    elseif Settings.Visuals.FieldOfView == 110 then Settings.Visuals.FieldOfView = 120
    else Settings.Visuals.FieldOfView = 70 end
end)

local MiscTab = Window:CreateTab("Misc")
MiscTab:AddButton("Speed Boost", function() LocalPlayer.Character.Humanoid.WalkSpeed = 50 end)
MiscTab:AddButton("Reset Speed", function() LocalPlayer.Character.Humanoid.WalkSpeed = 16 end)
MiscTab:AddButton("Destroy UI", function() CoreGui.UniversalMenuV4:Destroy() FOVCircle:Remove() SetNightMode(false) end)
