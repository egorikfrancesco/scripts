local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local character = player.Character or player.CharacterAdded:Wait()
local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

player.CharacterAdded:Connect(function(newChar)
    character = newChar
    humanoidRootPart = character:WaitForChild("HumanoidRootPart")
end)

local savedCFrame = nil
local originalCFrame = nil

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.Q and humanoidRootPart then
        humanoidRootPart.CFrame = humanoidRootPart.CFrame * CFrame.new(0, 0, -10)
    end
end)

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "TPGui"
screenGui.ResetOnSpawn = false
screenGui.Parent = game:GetService("CoreGui")

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 220, 0, 240)
mainFrame.Position = UDim2.new(0, 20, 0.5, -120)
mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Parent = screenGui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 12)
corner.Parent = mainFrame

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 50)
title.BackgroundTransparency = 1
title.Text = "🚀 Sab Modded TP"
title.TextColor3 = Color3.new(1, 1, 1)
title.TextScaled = true
title.Font = Enum.Font.GothamBold
title.Parent = mainFrame

local forwardBtn = Instance.new("TextButton")
forwardBtn.Size = UDim2.new(0.9, 0, 0, 45)
forwardBtn.Position = UDim2.new(0.05, 0, 0, 60)
forwardBtn.BackgroundColor3 = Color3.fromRGB(0, 162, 255)
forwardBtn.Text = "Forward 10 studs"
forwardBtn.TextColor3 = Color3.new(1, 1, 1)
forwardBtn.TextScaled = true
forwardBtn.Font = Enum.Font.Gotham
forwardBtn.Parent = mainFrame

local fwdCorner = Instance.new("UICorner")
fwdCorner.CornerRadius = UDim.new(0, 8)
fwdCorner.Parent = forwardBtn

local setBtn = Instance.new("TextButton")
setBtn.Size = UDim2.new(0.9, 0, 0, 45)
setBtn.Position = UDim2.new(0.05, 0, 0, 115)
setBtn.BackgroundColor3 = Color3.fromRGB(0, 255, 128)
setBtn.Text = "Set Base Location"
setBtn.TextColor3 = Color3.new(1, 1, 1)
setBtn.TextScaled = true
setBtn.Font = Enum.Font.Gotham
setBtn.Parent = mainFrame

local setCorner = Instance.new("UICorner")
setCorner.CornerRadius = UDim.new(0, 8)
setCorner.Parent = setBtn

local tpBtn = Instance.new("TextButton")
tpBtn.Size = UDim2.new(0.9, 0, 0, 45)
tpBtn.Position = UDim2.new(0.05, 0, 0, 170)
tpBtn.BackgroundColor3 = Color3.fromRGB(255, 162, 0)
tpBtn.Text = "Teleport To Base"
tpBtn.TextColor3 = Color3.new(1, 1, 1)
tpBtn.TextScaled = true
tpBtn.Font = Enum.Font.Gotham
tpBtn.Parent = mainFrame

local tpCorner = Instance.new("UICorner")
tpCorner.CornerRadius = UDim.new(0, 8)
tpCorner.Parent = tpBtn

local statusLabel = Instance.new("TextLabel")
statusLabel.Size = UDim2.new(1, 0, 0, 30)
statusLabel.Position = UDim2.new(0, 0, 1, -30)
statusLabel.BackgroundTransparency = 1
statusLabel.Text = "Binds [Q=Forward]"
statusLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
statusLabel.TextScaled = true
statusLabel.Font = Enum.Font.Gotham
statusLabel.Parent = mainFrame

local function tweenBtn(btn, targetColor)
    TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = targetColor}):Play()
end

forwardBtn.MouseButton1Click:Connect(function()
        humanoidRootPart.CFrame = humanoidRootPart.CFrame * CFrame.new(0, 0, -10)
    end
end)

setBtn.MouseButton1Click:Connect(function()
    if humanoidRootPart then
        savedCFrame = humanoidRootPart.CFrame
        tweenBtn(setBtn, Color3.fromRGB(0, 200, 100))
        statusLabel.Text = "Location Set"
        statusLabel.TextColor3 = Color3.fromRGB(0, 255, 128)
        task.wait(0.2)
        tweenBtn(setBtn, Color3.fromRGB(0, 255, 128))
    end
end)

-- Teleport There + Автоматический возврат через 3 секунды
tpBtn.MouseButton1Click:Connect(function()
    if not humanoidRootPart then return end
    if not savedCFrame then
        statusLabel.Text = "No location saved!"
        statusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
        tweenBtn(tpBtn, Color3.fromRGB(200, 100, 0))
        task.wait(0.2)
        tweenBtn(tpBtn, Color3.fromRGB(255, 162, 0))
        return
    end

    -- Сохраняем текущую позицию (откуда телепортируемся)
    originalCFrame = humanoidRootPart.CFrame

    -- Телепортируемся на сохранённую точку
    tweenBtn(tpBtn, Color3.fromRGB(200, 120, 0))
    humanoidRootPart.CFrame = savedCFrame
    statusLabel.Text = "Teleported!"
    statusLabel.TextColor3 = Color3.fromRGB(0, 255, 255)
    task.wait(0.2)
    tweenBtn(tpBtn, Color3.fromRGB(255, 162, 0))

    -- Ждём 3 секунды и возвращаемся обратно
    task.wait(0.7)

    humanoidRootPart.CFrame = originalCFrame
    statusLabel.Text = "Returned back!"
    statusLabel.TextColor3 = Color3.fromRGB(255, 200, 0)
end)

spawn(function()
    while true do
        task.wait(4)
        if statusLabel.Text ~= "Ready! [Q=Forward]" then
            statusLabel.Text = "Ready! [Q=Forward]"
            statusLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
        end
    end
end)
