--!strict

local UIModule = {}

function UIModule.createMenu(playerGui)
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "ModularUniversalMenu"
    ScreenGui.Parent = playerGui

    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainMenu"
    MainFrame.Size = UDim2.new(0.3, 0, 0.5, 0)
    MainFrame.Position = UDim2.new(0.35, 0, 0.25, 0)
    MainFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    MainFrame.BorderSizePixel = 0
    MainFrame.Active = true
    MainFrame.Draggable = true
    MainFrame.Parent = ScreenGui

    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Name = "Title"
    TitleLabel.Size = UDim2.new(1, 0, 0.1, 0)
    TitleLabel.Position = UDim2.new(0, 0, 0, 0)
    TitleLabel.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    TitleLabel.Font = Enum.Font.SourceSansBold
    TitleLabel.TextSize = 24
    TitleLabel.Text = "Modular Universal Menu"
    TitleLabel.BorderSizePixel = 0
    TitleLabel.Parent = MainFrame

    local CloseButton = Instance.new("TextButton")
    CloseButton.Name = "CloseButton"
    CloseButton.Size = UDim2.new(0.1, 0, 0.1, 0)
    CloseButton.Position = UDim2.new(0.9, 0, 0, 0)
    CloseButton.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
    CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    CloseButton.Font = Enum.Font.SourceSansBold
    CloseButton.TextSize = 20
    CloseButton.Text = "X"
    CloseButton.BorderSizePixel = 0
    CloseButton.Parent = MainFrame

    local WelcomeText = Instance.new("TextLabel")
    WelcomeText.Name = "WelcomeText"
    WelcomeText.Size = UDim2.new(0.8, 0, 0.2, 0)
    WelcomeText.Position = UDim2.new(0.1, 0, 0.3, 0)
    WelcomeText.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    WelcomeText.TextColor3 = Color3.fromRGB(255, 255, 255)
    WelcomeText.Font = Enum.Font.SourceSans
    WelcomeText.TextSize = 18
    WelcomeText.TextWrapped = true
    WelcomeText.TextXAlignment = Enum.TextXAlignment.Center
    WelcomeText.TextYAlignment = Enum.TextYAlignment.Center
    WelcomeText.Text = "Welcome to your modular Universal Menu! This is a basic example. You can expand it with more features."
    WelcomeText.BorderSizePixel = 0
    WelcomeText.Parent = MainFrame

    return ScreenGui, MainFrame, CloseButton
end

return UIModule
