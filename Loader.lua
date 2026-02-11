--!strict

-- This is the main script that will be executed.
-- It combines the UI, Logic, and Config modules.

-- Function to load a module from a string
local function loadModuleFromString(moduleString)
    local func = loadstring(moduleString)
    if not func then
        error("Failed to load module string")
    end
    local success, result = pcall(func)
    if not success then
        error("Error executing module string: " .. result)
    end
    return result
end

-- Embed the module code directly into this loader script
local UIModuleString = [[
--!strict

local UIModule = {}

function UIModule.createMenu(playerGui, config)
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "ModularUniversalMenu"
    ScreenGui.Parent = playerGui

    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainMenu"
    MainFrame.Size = UDim2.new(0.3, 0, 0.5, 0)
    MainFrame.Position = UDim2.new(0.35, 0, 0.25, 0)
    MainFrame.BackgroundColor3 = config.MenuBackgroundColor
    MainFrame.BorderSizePixel = 0
    MainFrame.Active = true
    MainFrame.Draggable = true
    MainFrame.Parent = ScreenGui

    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Name = "Title"
    TitleLabel.Size = UDim2.new(1, 0, 0.1, 0)
    TitleLabel.Position = UDim2.new(0, 0, 0, 0)
    TitleLabel.BackgroundColor3 = config.TitleBackgroundColor
    TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    TitleLabel.Font = Enum.Font.SourceSansBold
    TitleLabel.TextSize = 24
    TitleLabel.Text = config.MenuTitle
    TitleLabel.BorderSizePixel = 0
    TitleLabel.Parent = MainFrame

    local CloseButton = Instance.new("TextButton")
    CloseButton.Name = "CloseButton"
    CloseButton.Size = UDim2.new(0.1, 0, 0.1, 0)
    CloseButton.Position = UDim2.new(0.9, 0, 0, 0)
    CloseButton.BackgroundColor3 = config.CloseButtonColor
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
    WelcomeText.BackgroundColor3 = config.MenuBackgroundColor
    WelcomeText.TextColor3 = Color3.fromRGB(255, 255, 255)
    WelcomeText.Font = Enum.Font.SourceSans
    WelcomeText.TextSize = 18
    WelcomeText.TextWrapped = true
    WelcomeText.TextXAlignment = Enum.TextXAlignment.Center
    WelcomeText.TextYAlignment = Enum.TextYAlignment.Center
    WelcomeText.Text = config.WelcomeMessage
    WelcomeText.BorderSizePixel = 0
    WelcomeText.Parent = MainFrame

    return ScreenGui, MainFrame, CloseButton
end

return UIModule
]]

local LogicModuleString = [[
--!strict

local LogicModule = {}

function LogicModule.setupMenuLogic(screenGui, mainFrame, closeButton)
    -- Close button functionality
    closeButton.MouseButton1Click:Connect(function()
        screenGui:Destroy()
    end)

    -- Example of adding more logic:
    -- local exampleButton = mainFrame:FindFirstChild("ExampleButton")
    -- if exampleButton then
    --     exampleButton.MouseButton1Click:Connect(function()
    --         print("Example button clicked from LogicModule!")
    --     end)
    -- end
end

return LogicModule
]]

local ConfigModuleString = [[
--!strict

local ConfigModule = {}

ConfigModule.MenuTitle = "My Awesome Universal Menu"
ConfigModule.WelcomeMessage = "Hello, developer! Customize this menu to your heart's content."
ConfigModule.MenuBackgroundColor = Color3.fromRGB(50, 50, 50)
ConfigModule.TitleBackgroundColor = Color3.fromRGB(70, 70, 70)
ConfigModule.CloseButtonColor = Color3.fromRGB(255, 50, 50)

return ConfigModule
]]

-- Load the modules
local Config = loadModuleFromString(ConfigModuleString)
local UI = loadModuleFromString(UIModuleString)
local Logic = loadModuleFromString(LogicModuleString)

-- Get necessary Roblox services
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- Create the UI and set up its logic
local screenGui, mainFrame, closeButton = UI.createMenu(PlayerGui, Config)
Logic.setupMenuLogic(screenGui, mainFrame, closeButton)

print("Modular Universal Menu Loaded!")
