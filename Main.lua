--!strict
-- Universal Script V2 | Purple Glow Edition
-- Premium Cheat Aesthetic | Tabbed Interface | Smooth Animations
-- Created by Manus

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local RunService = game:GetService("RunService")

-- [[ UI LIBRARY ]]
local CustomLib = {}
local Theme = {
    Background = Color3.fromRGB(10, 10, 12),
    Secondary = Color3.fromRGB(15, 15, 18),
    Accent = Color3.fromRGB(160, 32, 240), -- Purple
    Glow = Color3.fromRGB(180, 50, 255),
    Text = Color3.fromRGB(255, 255, 255),
    DarkText = Color3.fromRGB(140, 140, 150),
    Border = Color3.fromRGB(30, 30, 35),
    Hover = Color3.fromRGB(40, 40, 50),
    Font = Enum.Font.GothamMedium,
    TitleFont = Enum.Font.GothamBold
}

function CustomLib:Tween(object, time, properties)
    local tweenInfo = TweenInfo.new(time, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
    local tween = TweenService:Create(object, tweenInfo, properties)
    tween:Play()
    return tween
end

function CustomLib:Create(className, properties)
    local instance = Instance.new(className)
    for i, v in pairs(properties) do
        if i ~= "Parent" then
            instance[i] = v
        end
    end
    instance.Parent = properties.Parent
    return instance
end

function CustomLib:InitLoader(title)
    local ScreenGui = self:Create("ScreenGui", {
        Name = "UniversalLoader",
        Parent = CoreGui,
        IgnoreGuiInset = true
    })

    local Main = self:Create("Frame", {
        Name = "Main",
        Size = UDim2.new(0, 350, 0, 200),
        Position = UDim2.new(0.5, -175, 0.5, -100),
        BackgroundColor3 = Theme.Background,
        BorderSizePixel = 0,
        ClipsDescendants = true,
        Parent = ScreenGui
    })

    self:Create("UICorner", { CornerRadius = UDim.new(0, 15), Parent = Main })
    
    -- Glow Effect
    local Glow = self:Create("UIStroke", {
        Color = Theme.Accent,
        Thickness = 2,
        ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
        Parent = Main
    })

    local Title = self:Create("TextLabel", {
        Size = UDim2.new(1, 0, 0, 60),
        BackgroundTransparency = 1,
        Text = title or "UNIVERSAL SCRIPT",
        TextColor3 = Theme.Text,
        TextSize = 22,
        Font = Theme.TitleFont,
        Parent = Main
    })

    local Status = self:Create("TextLabel", {
        Size = UDim2.new(1, 0, 0, 20),
        Position = UDim2.new(0, 0, 0.5, 0),
        BackgroundTransparency = 1,
        Text = "Initializing System...",
        TextColor3 = Theme.DarkText,
        TextSize = 14,
        Font = Theme.Font,
        Parent = Main
    })

    local ProgressBack = self:Create("Frame", {
        Size = UDim2.new(0.7, 0, 0, 4),
        Position = UDim2.new(0.15, 0, 0.75, 0),
        BackgroundColor3 = Theme.Border,
        BorderSizePixel = 0,
        Parent = Main
    })

    local ProgressBar = self:Create("Frame", {
        Size = UDim2.new(0, 0, 1, 0),
        BackgroundColor3 = Theme.Accent,
        BorderSizePixel = 0,
        Parent = ProgressBack
    })

    self:Create("UICorner", { CornerRadius = UDim.new(1, 0), Parent = ProgressBack })
    self:Create("UICorner", { CornerRadius = UDim.new(1, 0), Parent = ProgressBar })

    -- Initial Animation
    Main.BackgroundTransparency = 1
    Title.TextTransparency = 1
    Status.TextTransparency = 1
    ProgressBack.BackgroundTransparency = 1
    ProgressBar.BackgroundTransparency = 1
    Glow.Transparency = 1
    Main.Position = UDim2.new(0.5, -175, 0.6, -100)
    
    self:Tween(Main, 1, {BackgroundTransparency = 0, Position = UDim2.new(0.5, -175, 0.5, -100)})
    self:Tween(Glow, 1, {Transparency = 0})
    self:Tween(Title, 1, {TextTransparency = 0})
    self:Tween(Status, 1, {TextTransparency = 0})
    self:Tween(ProgressBack, 1, {BackgroundTransparency = 0})
    self:Tween(ProgressBar, 1, {BackgroundTransparency = 0})

    local loader = {}
    function loader:UpdateStatus(text, progress)
        Status.Text = text
        CustomLib:Tween(ProgressBar, 0.5, {Size = UDim2.new(progress, 0, 1, 0)})
    end

    function loader:Close()
        CustomLib:Tween(Main, 0.8, {BackgroundTransparency = 1, Position = UDim2.new(0.5, -175, 0.4, -100)})
        CustomLib:Tween(Glow, 0.8, {Transparency = 1})
        task.wait(0.8)
        ScreenGui:Destroy()
    end

    return loader
end

function CustomLib:CreateWindow(title)
    local ScreenGui = self:Create("ScreenGui", {
        Name = "UniversalMenuV2",
        Parent = CoreGui,
        IgnoreGuiInset = true
    })

    local Main = self:Create("Frame", {
        Name = "Main",
        Size = UDim2.new(0, 550, 0, 380),
        Position = UDim2.new(0.5, -275, 0.5, -190),
        BackgroundColor3 = Theme.Background,
        BorderSizePixel = 0,
        Parent = ScreenGui
    })

    self:Create("UICorner", { CornerRadius = UDim.new(0, 12), Parent = Main })
    local MainStroke = self:Create("UIStroke", { Color = Theme.Border, Thickness = 1.5, Parent = Main })

    -- Sidebar for Tabs
    local Sidebar = self:Create("Frame", {
        Size = UDim2.new(0, 150, 1, 0),
        BackgroundColor3 = Theme.Secondary,
        BorderSizePixel = 0,
        Parent = Main
    })
    self:Create("UICorner", { CornerRadius = UDim.new(0, 12), Parent = Sidebar })
    -- Cover right corners of Sidebar
    self:Create("Frame", { Size = UDim2.new(0, 20, 1, 0), Position = UDim2.new(1, -20, 0, 0), BackgroundColor3 = Theme.Secondary, BorderSizePixel = 0, Parent = Sidebar })

    local Title = self:Create("TextLabel", {
        Size = UDim2.new(1, 0, 0, 60),
        BackgroundTransparency = 1,
        Text = title,
        TextColor3 = Theme.Accent,
        TextSize = 18,
        Font = Theme.TitleFont,
        Parent = Sidebar
    })

    local TabContainer = self:Create("Frame", {
        Size = UDim2.new(1, 0, 1, -70),
        Position = UDim2.new(0, 0, 0, 65),
        BackgroundTransparency = 1,
        Parent = Sidebar
    })
    self:Create("UIListLayout", { Padding = UDim.new(0, 5), HorizontalAlignment = Enum.HorizontalAlignment.Center, Parent = TabContainer })

    -- Content Area
    local ContentArea = self:Create("Frame", {
        Size = UDim2.new(1, -160, 1, -20),
        Position = UDim2.new(0, 155, 0, 10),
        BackgroundTransparency = 1,
        Parent = Main
    })

    -- Dragging
    local dragging, dragInput, dragStart, startPos
    Sidebar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = Main.Position
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - dragStart
            Main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)

    local window = { Tabs = {}, CurrentTab = nil }

    function window:CreateTab(name, icon)
        local TabBtn = CustomLib:Create("TextButton", {
            Size = UDim2.new(0.9, 0, 0, 35),
            BackgroundColor3 = Theme.Secondary,
            BackgroundTransparency = 1,
            Text = name,
            TextColor3 = Theme.DarkText,
            TextSize = 14,
            Font = Theme.Font,
            Parent = TabContainer
        })
        self:Create("UICorner", { CornerRadius = UDim.new(0, 6), Parent = TabBtn })

        local TabPage = CustomLib:Create("ScrollingFrame", {
            Size = UDim2.new(1, 0, 1, 0),
            BackgroundTransparency = 1,
            Visible = false,
            ScrollBarThickness = 2,
            ScrollBarImageColor3 = Theme.Accent,
            CanvasSize = UDim2.new(0, 0, 0, 0),
            AutomaticCanvasSize = Enum.AutomaticSize.Y,
            Parent = ContentArea
        })
        self:Create("UIListLayout", { Padding = UDim.new(0, 10), SortOrder = Enum.SortOrder.LayoutOrder, Parent = TabPage })

        local tab = { Page = TabPage }

        function tab:AddToggle(text, default, callback)
            local ToggleFrame = CustomLib:Create("Frame", {
                Size = UDim2.new(1, 0, 0, 45),
                BackgroundColor3 = Theme.Secondary,
                BorderSizePixel = 0,
                Parent = TabPage
            })
            CustomLib:Create("UICorner", { CornerRadius = UDim.new(0, 8), Parent = ToggleFrame })
            CustomLib:Create("UIStroke", { Color = Theme.Border, Thickness = 1, Parent = ToggleFrame })

            local Label = CustomLib:Create("TextLabel", {
                Size = UDim2.new(1, -60, 1, 0),
                Position = UDim2.new(0, 15, 0, 0),
                BackgroundTransparency = 1,
                Text = text,
                TextColor3 = Theme.Text,
                TextSize = 14,
                Font = Theme.Font,
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = ToggleFrame
            })

            local Box = CustomLib:Create("Frame", {
                Size = UDim2.new(0, 38, 0, 20),
                Position = UDim2.new(1, -50, 0.5, -10),
                BackgroundColor3 = default and Theme.Accent or Theme.Border,
                BorderSizePixel = 0,
                Parent = ToggleFrame
            })
            CustomLib:Create("UICorner", { CornerRadius = UDim.new(1, 0), Parent = Box })

            local Dot = CustomLib:Create("Frame", {
                Size = UDim2.new(0, 16, 0, 16),
                Position = UDim2.new(0, default and 20 or 2, 0.5, -8),
                BackgroundColor3 = Theme.Text,
                BorderSizePixel = 0,
                Parent = Box
            })
            CustomLib:Create("UICorner", { CornerRadius = UDim.new(1, 0), Parent = Dot })

            local enabled = default
            local Btn = CustomLib:Create("TextButton", {
                Size = UDim2.new(1, 0, 1, 0),
                BackgroundTransparency = 1,
                Text = "",
                Parent = ToggleFrame
            })

            Btn.MouseButton1Click:Connect(function()
                enabled = not enabled
                CustomLib:Tween(Box, 0.3, {BackgroundColor3 = enabled and Theme.Accent or Theme.Border})
                CustomLib:Tween(Dot, 0.3, {Position = UDim2.new(0, enabled and 20 or 2, 0.5, -8)})
                callback(enabled)
            end)
        end

        function tab:AddButton(text, callback)
            local Btn = CustomLib:Create("TextButton", {
                Size = UDim2.new(1, 0, 0, 40),
                BackgroundColor3 = Theme.Secondary,
                BorderSizePixel = 0,
                Text = text,
                TextColor3 = Theme.Text,
                TextSize = 14,
                Font = Theme.Font,
                Parent = TabPage
            })
            CustomLib:Create("UICorner", { CornerRadius = UDim.new(0, 8), Parent = Btn })
            CustomLib:Create("UIStroke", { Color = Theme.Border, Thickness = 1, Parent = Btn })

            Btn.MouseButton1Click:Connect(callback)
            Btn.MouseEnter:Connect(function() CustomLib:Tween(Btn, 0.3, {BackgroundColor3 = Theme.Hover}) end)
            Btn.MouseLeave:Connect(function() CustomLib:Tween(Btn, 0.3, {BackgroundColor3 = Theme.Secondary}) end)
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

task.wait(1)
Loader:UpdateStatus("Bypassing Security...", 0.2)
task.wait(0.8)
Loader:UpdateStatus("Injecting Modules...", 0.4)
task.wait(0.6)
Loader:UpdateStatus("Loading Aimbot Engine...", 0.7)
task.wait(0.9)
Loader:UpdateStatus("Finalizing UI...", 0.9)
task.wait(0.5)
Loader:UpdateStatus("Welcome, User!", 1)
task.wait(0.5)

Loader:Close()

local Window = CustomLib:CreateWindow("PURPLE.EXE")

local AimbotTab = Window:CreateTab("Aimbot")
AimbotTab:AddToggle("Enable Aimbot", false, function(v) print("Aimbot:", v) end)
AimbotTab:AddToggle("Silent Aim", false, function(v) print("Silent Aim:", v) end)
AimbotTab:AddToggle("Show FOV", true, function(v) print("Show FOV:", v) end)
AimbotTab:AddButton("Reset Aimbot Settings", function() print("Resetting...") end)

local VisualsTab = Window:CreateTab("Visuals")
VisualsTab:AddToggle("ESP Boxes", false, function(v) print("ESP Boxes:", v) end)
VisualsTab:AddToggle("ESP Tracers", false, function(v) print("ESP Tracers:", v) end)
VisualsTab:AddToggle("Chams", false, function(v) print("Chams:", v) end)

local MiscTab = Window:CreateTab("Misc")
MiscTab:AddToggle("Speed Hack", false, function(v) print("Speed:", v) end)
MiscTab:AddToggle("Infinite Jump", false, function(v) print("Jump:", v) end)
MiscTab:AddButton("Destroy UI", function() game:GetService("CoreGui").UniversalMenuV2:Destroy() end)
