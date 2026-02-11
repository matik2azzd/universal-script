--!strict

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- Create the ScreenGui
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "CustomUniversalMenu"
ScreenGui.Parent = PlayerGui

-- Create the main frame
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainMenu"
MainFrame.Size = UDim2.new(0.3, 0, 0.5, 0) -- 30% width, 50% height
MainFrame.Position = UDim2.new(0.35, 0, 0.25, 0) -- Centered
MainFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true -- Make it active for dragging
MainFrame.Draggable = true -- Allow dragging
MainFrame.Parent = ScreenGui

-- Create the title bar
local TitleLabel = Instance.new("TextLabel")
TitleLabel.Name = "Title"
TitleLabel.Size = UDim2.new(1, 0, 0.1, 0)
TitleLabel.Position = UDim2.new(0, 0, 0, 0)
TitleLabel.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleLabel.Font = Enum.Font.SourceSansBold
TitleLabel.TextSize = 24
TitleLabel.Text = "Custom Universal Menu"
TitleLabel.BorderSizePixel = 0
TitleLabel.Parent = MainFrame

-- Create the close button
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

-- Connect the close button to destroy the ScreenGui
CloseButton.MouseButton1Click:Connect(function()
	ScreenGui:Destroy()
end)

-- Create a welcome text label
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
WelcomeText.Text = "Welcome to your custom Universal Menu! This is a basic example. You can expand it with more features."
WelcomeText.BorderSizePixel = 0
WelcomeText.Parent = MainFrame

-- You can add more UI elements here, for example:
-- local NewButton = Instance.new("TextButton")
-- NewButton.Name = "ExampleButton"
-- NewButton.Size = UDim2.new(0.8, 0, 0.1, 0)
-- NewButton.Position = UDim2.new(0.1, 0, 0.6, 0)
-- NewButton.Text = "Click Me!"
-- NewButton.Parent = MainFrame
-- NewButton.MouseButton1Click:Connect(function()
--     print("Button clicked!")
-- end)

-- Instructions for legitimate use:
-- 1. Save this script as a LocalScript in Roblox Studio.
-- 2. Place the LocalScript under StarterPlayerScripts or StarterGui.
-- 3. Run your game in Roblox Studio to see the menu.
