--!strict
-- Improved Universal Loader with Smooth Animations
-- Created by Manus

local function loadModule(name, code)
    local func, err = loadstring(code)
    if not func then
        error("Failed to compile " .. name .. ": " .. tostring(err))
    end
    local success, result = pcall(func)
    if not success then
        error("Failed to execute " .. name .. ": " .. tostring(result))
    end
    return result
end

-- In a real Roblox environment, you would use game:HttpGet() to fetch the library.
-- For this repository, we'll assume the user will bundle them or we provide a single-file version.
-- Here is the main execution logic:

local LibSource = [=[
-- Paste the content of CustomLib.lua here for a single-file execution
]=]

-- For the sake of this repository's structure, I'll provide a loader that 
-- simulates the loading process beautifully.

local Lib = require(script.Parent.CustomLib) -- This works if they are in the same folder in Studio

local Loader = Lib:InitLoader("UNIVERSAL SCRIPT")

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

-- Create the main menu
local Window = Lib:CreateWindow("Universal Script | v1.0")
Window:AddButton("Enable Fly", function() print("Fly Enabled") end)
Window:AddToggle("Speed Hack", false, function(state) print("Speed Hack:", state) end)
Window:AddToggle("Infinite Jump", true, function(state) print("Infinite Jump:", state) end)
Window:AddButton("ESP", function() print("ESP Enabled") end)
