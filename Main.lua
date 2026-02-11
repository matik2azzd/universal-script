--!strict
-- Universal Script Improved
-- Smooth Animations | Custom UI Library | Animated Loader
-- Created by Manus

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")

-- [[ UI LIBRARY ]]
local CustomLib = {}
local Theme = {
    Background = Color3.fromRGB(15, 15, 15),
    Secondary = Color3.fromRGB(20, 20, 20),
    Accent = Color3.fromRGB(0, 170, 255),
    Text = Color3.fromRGB(255, 255, 255),
    DarkText = Color3.fromRGB(160, 160, 160),
    Border = Color3.fromRGB(35, 35, 35),
    Hover = Color3.fromRGB(45, 45, 45),
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
        Size = UDim2.new(0, 320, 0, 180),
        Position = UDim2.new(0.5, -160, 0.5, -90),
        BackgroundColor3 = Theme.Background,
        BorderSizePixel = 0,
        ClipsDescendants = true,
        Parent = ScreenGui
    })

    self:Create("UICorner", { CornerRadius = UDim.new(0, 12), Parent = Main })
    local Stroke = self:Create("UIStroke", { Color = Theme.Border, Thickness = 1.5, Parent = Main })

    local Title = self:Create("TextLabel", {
        Size = UDim2.new(1, 0, 0, 50),
        BackgroundTransparency = 1,
        Text = title or "UNIVERSAL SCRIPT",
        TextColor3 = Theme.Text,
        TextSize = 20,
        Font = Theme.TitleFont,
        Parent = Main
    })

    local Status = self:Create("TextLabel", {
        Size = UDim2.new(1, 0, 0, 20),
        Position = UDim2.new(0, 0, 0.45, 0),
        BackgroundTransparency = 1,
        Text = "Initializing...",
        TextColor3 = Theme.DarkText,
        TextSize = 14,
        Font = Theme.Font,
        Parent = Main
    })

    local ProgressBack = self:Create("Frame", {
        Size = UDim2.new(0.8, 0, 0, 6),
        Position = UDim2.new(0.1, 0, 0.75, 0),
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
    Stroke.Transparency = 1
    Main.Position = UDim2.new(0.5, -160, 0.6, -90)
    
    self:Tween(Main, 0.8, {BackgroundTransparency = 0, Position = UDim2.new(0.5, -160, 0.5, -90)})
    self:Tween(Stroke, 0.8, {Transparency = 0})
    self:Tween(Title, 0.8, {TextTransparency = 0})
    self:Tween(Status, 0.8, {TextTransparency = 0})
    self:Tween(ProgressBack, 0.8, {BackgroundTransparency = 0})
    self:Tween(ProgressBar, 0.8, {BackgroundTransparency = 0})

    local loader = {}
    function loader:UpdateStatus(text, progress)
        Status.Text = text
        CustomLib:Tween(ProgressBar, 0.4, {Size = UDim2.new(progress, 0, 1, 0)})
    end

    function loader:Close()
        CustomLib:Tween(Main, 0.6, {BackgroundTransparency = 1, Position = UDim2.new(0.5, -160, 0.4, -90)})
        CustomLib:Tween(Stroke, 0.6, {Transparency = 1})
        task.wait(0.6)
        ScreenGui:Destroy()
    end

    return loader
end

function CustomLib:CreateWindow(title)
    local ScreenGui = self:Create("ScreenGui", {
        Name = "UniversalMenu",
        Parent = CoreGui,
        IgnoreGuiInset = true
    })

    local Main = self:Create("Frame", {
        Name = "Main",
        Size = UDim2.new(0, 450, 0, 320),
        Position = UDim2.new(0.5, -225, 0.5, -160),
        BackgroundColor3 = Theme.Background,
        BorderSizePixel = 0,
        Parent = ScreenGui
    })

    self:Create("UICorner", { CornerRadius = UDim.new(0, 10), Parent = Main })
    self:Create("UIStroke", { Color = Theme.Border, Thickness = 1.5, Parent = Main })

    local TopBar = self:Create("Frame", {
        Size = UDim2.new(1, 0, 0, 45),
        BackgroundColor3 = Theme.Secondary,
        BorderSizePixel = 0,
        Parent = Main
    })

    self:Create("UICorner", { CornerRadius = UDim.new(0, 10), Parent = TopBar })
    self:Create("Frame", { Size = UDim2.new(1, 0, 0, 10), Position = UDim2.new(0, 0, 1, -10), BackgroundColor3 = Theme.Secondary, BorderSizePixel = 0, Parent = TopBar })

    local Title = self:Create("TextLabel", {
        Size = UDim2.new(1, -60, 1, 0),
        Position = UDim2.new(0, 20, 0, 0),
        BackgroundTransparency = 1,
        Text = title,
        TextColor3 = Theme.Text,
        TextSize = 18,
        Font = Theme.TitleFont,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = TopBar
    })

    local CloseBtn = self:Create("TextButton", {
        Size = UDim2.new(0, 30, 0, 30),
        Position = UDim2.new(1, -40, 0, 7),
        BackgroundTransparency = 1,
        Text = "×",
        TextColor3 = Theme.DarkText,
        TextSize = 28,
        Font = Enum.Font.SourceSans,
        Parent = TopBar
    })

    CloseBtn.MouseButton1Click:Connect(function()
        ScreenGui:Destroy()
    end)

    local Content = self:Create("ScrollingFrame", {
        Size = UDim2.new(1, -30, 1, -65),
        Position = UDim2.new(0, 15, 0, 55),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ScrollBarThickness = 2,
        ScrollBarImageColor3 = Theme.Accent,
        CanvasSize = UDim2.new(0, 0, 0, 0),
        AutomaticCanvasSize = Enum.AutomaticSize.Y,
        Parent = Main
    })

    self:Create("UIListLayout", { Padding = UDim.new(0, 8), SortOrder = Enum.SortOrder.LayoutOrder, Parent = Content })

    -- Dragging
    local dragging, dragInput, dragStart, startPos
    TopBar.InputBegan:Connect(function(input)
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

    local window = {}

    function window:AddButton(text, callback)
        local Btn = CustomLib:Create("TextButton", {
            Size = UDim2.new(1, 0, 0, 40),
            BackgroundColor3 = Theme.Secondary,
            BorderSizePixel = 0,
            Text = text,
            TextColor3 = Theme.Text,
            TextSize = 14,
            Font = Theme.Font,
            Parent = Content
        })

        CustomLib:Create("UICorner", { CornerRadius = UDim.new(0, 6), Parent = Btn })
        CustomLib:Create("UIStroke", { Color = Theme.Border, Thickness = 1, Parent = Btn })

        Btn.MouseButton1Click:Connect(callback)
        Btn.MouseEnter:Connect(function() CustomLib:Tween(Btn, 0.3, {BackgroundColor3 = Theme.Hover}) end)
        Btn.MouseLeave:Connect(function() CustomLib:Tween(Btn, 0.3, {BackgroundColor3 = Theme.Secondary}) end)
    end

    function window:AddToggle(text, default, callback)
        local ToggleFrame = CustomLib:Create("Frame", {
            Size = UDim2.new(1, 0, 0, 40),
            BackgroundColor3 = Theme.Secondary,
            BorderSizePixel = 0,
            Parent = Content
        })
        CustomLib:Create("UICorner", { CornerRadius = UDim.new(0, 6), Parent = ToggleFrame })
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
            Size = UDim2.new(0, 34, 0, 18),
            Position = UDim2.new(1, -45, 0.5, -9),
            BackgroundColor3 = default and Theme.Accent or Theme.Border,
            BorderSizePixel = 0,
            Parent = ToggleFrame
        })
        CustomLib:Create("UICorner", { CornerRadius = UDim.new(1, 0), Parent = Box })

        local Dot = CustomLib:Create("Frame", {
            Size = UDim2.new(0, 14, 0, 14),
            Position = UDim2.new(0, default and 18 or 2, 0.5, -7),
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
            CustomLib:Tween(Dot, 0.3, {Position = UDim2.new(0, enabled and 18 or 2, 0.5, -7)})
            callback(enabled)
        end)
    end

    return window
end

-- [[ EXECUTION ]]
local Loader = CustomLib:InitLoader("UNIVERSAL SCRIPT")

task.wait(1)
Loader:UpdateStatus("Loading modules...", 0.2)
task.wait(0.8)
Loader:UpdateStatus("Fetching configuration...", 0.4)
task.wait(0.6)
Loader:UpdateStatus("Initializing UI Engine...", 0.7)
task.wait(0.9)
Loader:UpdateStatus("Finalizing files...", 0.9)
task.wait(0.5)
Loader:UpdateStatus("Ready!", 1)
task.wait(0.5)

Loader:Close()

local Window = CustomLib:CreateWindow("Universal Script | v1.0")
Window:AddButton("Enable Fly", function() print("Fly Enabled") end)
Window:AddToggle("Speed Hack", false, function(state) print("Speed Hack:", state) end)
Window:AddToggle("Infinite Jump", true, function(state) print("Infinite Jump:", state) end)
Window:AddButton("ESP", function() print("ESP Enabled") end)
