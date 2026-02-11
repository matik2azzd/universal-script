--!strict

local Fusion = require(game.ReplicatedStorage.Fusion)
local New = Fusion.New
local Children = Fusion.Children

local ScreenGui = New("ScreenGui") {
	Name = "UniversalMenu",
	Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui"),

	[Children] = {
		New("Frame") {
			Name = "MainMenu",
			Size = UDim2.new(0.3, 0, 0.5, 0),
			Position = UDim2.new(0.35, 0, 0.25, 0),
			BackgroundColor3 = Color3.fromRGB(40, 40, 40),
			BorderSizePixel = 0,
			Draggable = true,

			[Children] = {
				New("TextLabel") {
					Name = "Title",
					Size = UDim2.new(1, 0, 0.1, 0),
					Position = UDim2.new(0, 0, 0, 0),
					BackgroundColor3 = Color3.fromRGB(60, 60, 60),
					TextColor3 = Color3.fromRGB(255, 255, 255),
					Font = Enum.Font.SourceSansBold,
					TextSize = 24,
					Text = "Universal Menu",
					BorderSizePixel = 0,
				},
				New("TextButton") {
					Name = "CloseButton",
					Size = UDim2.new(0.1, 0, 0.1, 0),
					Position = UDim2.new(0.9, 0, 0, 0),
					BackgroundColor3 = Color3.fromRGB(200, 0, 0),
					TextColor3 = Color3.fromRGB(255, 255, 255),
					Font = Enum.Font.SourceSansBold,
					TextSize = 20,
					Text = "X",
					BorderSizePixel = 0,
					[Fusion.OnEvent("MouseButton1Click")] = function()
						ScreenGui:Destroy()
					end,
				},
				New("TextLabel") {
					Name = "WelcomeText",
					Size = UDim2.new(0.8, 0, 0.2, 0),
					Position = UDim2.new(0.1, 0, 0.3, 0),
					BackgroundColor3 = Color3.fromRGB(50, 50, 50),
					TextColor3 = Color3.fromRGB(255, 255, 255),
					Font = Enum.Font.SourceSans,
					TextSize = 18,
					TextWrapped = true,
					TextXAlignment = Enum.TextXAlignment.Center,
					TextYAlignment = Enum.TextYAlignment.Center,
					Text = "Welcome to your Universal Menu! This is a basic example. You can expand it with more features.",
					BorderSizePixel = 0,
				},
			}
		}
	}
}

-- To use this script:
-- 1. Insert Fusion into ReplicatedStorage. You can get it from the Fusion GitHub page or Roblox Library.
-- 2. Place this script in StarterPlayerScripts or anywhere it will run on the client.
-- 3. Ensure the PlayerGui is accessible when the script runs.
