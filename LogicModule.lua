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
