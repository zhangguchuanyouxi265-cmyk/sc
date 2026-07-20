-- UI作成とテレポート処理
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- UIの作成
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "TowerTPGui"
ScreenGui.Parent = PlayerGui
ScreenGui.ResetOnSpawn = false

local ToggleButton = Instance.new("TextButton")
ToggleButton.Name = "ToggleButton"
ToggleButton.Parent = ScreenGui
ToggleButton.Size = UDim2.new(0, 150, 0, 50)
ToggleButton.Position = UDim2.new(0.85, 0, 0.5, -25)
ToggleButton.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
ToggleButton.Text = "TOP TP: OFF"
ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleButton.Font = Enum.Font.SourceSansBold
ToggleButton.TextSize = 14

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 12)
UICorner.Parent = ToggleButton

-- ドラッグ機能
local dragging, dragInput, dragStart, startPos
ToggleButton.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = ToggleButton.Position
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        ToggleButton.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

ToggleButton.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = false
    end
end)

-- メインシステム
local isEnabled = false

local function isDangerous(part)
    local name = part.Name:lower()
    return name:find("lava") or name:find("kill") or name:find("dead") or name:find("death") or 
           (part.Color.R > 0.8 and part.Color.G < 0.2 and part.Color.B < 0.2)
end

local function teleportToTop()
    local char = LocalPlayer.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    if not root then return end

    local topPart = nil
    local highestY = -99999
    
    for _, v in ipairs(workspace:GetDescendants()) do
        if v:IsA("BasePart") and v.CanCollide and not isDangerous(v) and (v.Size.X > 1 or v.Size.Z > 1) then
            if v.Position.Y > highestY then
                highestY = v.Position.Y
                topPart = v
            end
        end
    end
    
    if topPart then
        root.CFrame = CFrame.new(topPart.Position + Vector3.new(0, 3, 0))
    end
end

ToggleButton.MouseButton1Click:Connect(function()
    isEnabled = not isEnabled
    ToggleButton.Text = isEnabled and "TOP TP: ON" or "TOP TP: OFF"
    ToggleButton.BackgroundColor3 = isEnabled and Color3.fromRGB(60, 255, 60) or Color3.fromRGB(255, 60, 60)
    if isEnabled then teleportToTop() end
end)

LocalPlayer.CharacterAdded:Connect(function()
    if isEnabled then
        task.wait(1)
        teleportToTop()
    end
end)
