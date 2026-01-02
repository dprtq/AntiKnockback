local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local StarterGui = game:GetService("StarterGui")
local RunService = game:GetService("RunService")

local plr = Players.LocalPlayer

local enabled = false
local kbPercent = 0.3
local notificationsEnabled = true

local toggleKey = Enum.KeyCode.K
local menuKey = Enum.KeyCode.RightShift

local waitingForToggleKey = false
local waitingForMenuKey = false

local function notify(txt)
    if not notificationsEnabled then return end
    pcall(function()
        StarterGui:SetCore("SendNotification", {
            Title = "ANTI KB",
            Text = txt,
            Duration = 1.5
        })
    end)
end

local function setupChar(char)
    local hrp = char:WaitForChild("HumanoidRootPart", 5)
    if not hrp then return end

    local function handle(v)
        if not enabled then return end

        if v:IsA("BodyVelocity") then
            v.Velocity *= kbPercent
        elseif v:IsA("LinearVelocity") then
            v.VectorVelocity *= kbPercent
        elseif v:IsA("VectorForce") then
            v.Force *= kbPercent
        end
    end

    for _, v in ipairs(hrp:GetChildren()) do
        handle(v)
    end

    hrp.ChildAdded:Connect(handle)
end

if plr.Character then
    setupChar(plr.Character)
end
plr.CharacterAdded:Connect(setupChar)


local gui = Instance.new("ScreenGui")
gui.Name = "AntiKB_UI"
gui.Parent = game.CoreGui
gui.Enabled = true
gui.ResetOnSpawn = false

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.fromScale(0.26, 0.48) 
frame.Position = UDim2.fromScale(0.37, 0.25)
frame.BackgroundColor3 = Color3.fromRGB(30,30,30)
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true

local frameCorner = Instance.new("UICorner", frame)
frameCorner.CornerRadius = UDim.new(0, 12)

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.fromScale(1, 0.14)
title.Position = UDim2.fromScale(0,0)
title.BackgroundTransparency = 1
title.Text = "Anti Knockback"
title.TextColor3 = Color3.new(1,1,1)
title.Font = Enum.Font.GothamBold
title.TextSize = 18

local toggleBtn = Instance.new("TextButton", frame)
toggleBtn.Size = UDim2.fromScale(0.8, 0.12)
toggleBtn.Position = UDim2.fromScale(0.1, 0.16)
toggleBtn.Text = "OFF"
toggleBtn.Font = Enum.Font.GothamBold
toggleBtn.TextSize = 16
toggleBtn.TextColor3 = Color3.new(1,1,1)
toggleBtn.BackgroundColor3 = Color3.fromRGB(150,40,40)
local toggleBtnCorner = Instance.new("UICorner", toggleBtn)
toggleBtnCorner.CornerRadius = UDim.new(0, 8)

local percentLabel = Instance.new("TextLabel", frame)
percentLabel.Size = UDim2.fromScale(1, 0.08)
percentLabel.Position = UDim2.fromScale(0, 0.30)
percentLabel.BackgroundTransparency = 1
percentLabel.Text = "Knockback: 30%"
percentLabel.TextColor3 = Color3.new(1,1,1)
percentLabel.Font = Enum.Font.Gotham
percentLabel.TextSize = 14

local sliderBG = Instance.new("Frame", frame)
sliderBG.Size = UDim2.fromScale(0.8, 0.08)
sliderBG.Position = UDim2.fromScale(0.1, 0.37)
sliderBG.BackgroundColor3 = Color3.fromRGB(60,60,60)
sliderBG.BorderSizePixel = 0
local sliderBGCorners = Instance.new("UICorner", sliderBG)
sliderBGCorners.CornerRadius = UDim.new(0,6)

local sliderFill = Instance.new("Frame", sliderBG)
sliderFill.Size = UDim2.fromScale(kbPercent, 1)
sliderFill.BackgroundColor3 = Color3.fromRGB(80,160,255)
sliderFill.BorderSizePixel = 0
local sliderFillCorners = Instance.new("UICorner", sliderFill)
sliderFillCorners.CornerRadius = UDim.new(0,6)

local dragging = false
sliderBG.InputBegan:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        frame.Draggable = false
    end
end)
sliderBG.InputEnded:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
        frame.Draggable = true
    end
end)
UIS.InputChanged:Connect(function(i)
    if dragging and i.UserInputType == Enum.UserInputType.MouseMovement then
        local pct = math.clamp(
            (i.Position.X - sliderBG.AbsolutePosition.X) / sliderBG.AbsoluteSize.X,
            0, 1
        )
        kbPercent = pct
        sliderFill.Size = UDim2.fromScale(pct, 1)
        percentLabel.Text = "Knockback: " .. math.floor(pct * 100) .. "%"
    end
end)

local keyBtn = Instance.new("TextButton", frame)
keyBtn.Size = UDim2.fromScale(0.8, 0.12)
keyBtn.Position = UDim2.fromScale(0.1, 0.46)
keyBtn.Text = "Toggle Key (K)"
keyBtn.Font = Enum.Font.Gotham
keyBtn.TextSize = 14
keyBtn.TextColor3 = Color3.new(1,1,1)
keyBtn.BackgroundColor3 = Color3.fromRGB(55,55,55)
local keyBtnCorner = Instance.new("UICorner", keyBtn)
keyBtnCorner.CornerRadius = UDim.new(0,6)

keyBtn.MouseButton1Click:Connect(function()
    waitingForToggleKey = true
    keyBtn.Text = "Press key..."
end)

local menuBtn = Instance.new("TextButton", frame)
menuBtn.Size = UDim2.fromScale(0.8, 0.12)
menuBtn.Position = UDim2.fromScale(0.1, 0.59)
menuBtn.Text = "Menu Key (RightShift)"
menuBtn.Font = Enum.Font.Gotham
menuBtn.TextSize = 14
menuBtn.TextColor3 = Color3.new(1,1,1)
menuBtn.BackgroundColor3 = Color3.fromRGB(55,55,55)
local menuBtnCorner = Instance.new("UICorner", menuBtn)
menuBtnCorner.CornerRadius = UDim.new(0,6)

menuBtn.MouseButton1Click:Connect(function()
    waitingForMenuKey = true
    menuBtn.Text = "Press key..."
end)

local notifyBtn = Instance.new("TextButton", frame)
notifyBtn.Size = UDim2.fromScale(0.8, 0.12)
notifyBtn.Position = UDim2.fromScale(0.1, 0.72)
notifyBtn.Text = "Notifications: ON"
notifyBtn.Font = Enum.Font.Gotham
notifyBtn.TextSize = 14
notifyBtn.TextColor3 = Color3.new(1,1,1)
notifyBtn.BackgroundColor3 = Color3.fromRGB(55,55,55)
local notifyBtnCorner = Instance.new("UICorner", notifyBtn)
notifyBtnCorner.CornerRadius = UDim.new(0,6)

notifyBtn.MouseButton1Click:Connect(function()
    notificationsEnabled = not notificationsEnabled
    notifyBtn.Text = "Notifications: " .. (notificationsEnabled and "ON" or "OFF")
end)

local statusGui = Instance.new("ScreenGui")
statusGui.Name = "AntiKB_Status"
statusGui.Parent = game.CoreGui
statusGui.ResetOnSpawn = false

local statusFrame = Instance.new("Frame", statusGui)
statusFrame.Size = UDim2.fromOffset(140,40)
statusFrame.Position = UDim2.fromScale(0.02,0.02)
statusFrame.BackgroundColor3 = Color3.fromRGB(35,35,35)
statusFrame.BorderSizePixel = 0
statusFrame.Active = true
statusFrame.Draggable = true

local statusCorner = Instance.new("UICorner", statusFrame)
statusCorner.CornerRadius = UDim.new(0,12)

local statusLabel = Instance.new("TextLabel", statusFrame)
statusLabel.Size = UDim2.fromScale(1,1)
statusLabel.BackgroundTransparency = 1
statusLabel.TextColor3 = Color3.new(1,1,1)
statusLabel.Font = Enum.Font.GothamBold
statusLabel.TextSize = 14
statusLabel.Text = "Status: OFF"

local function setEnabled(state)
    enabled = state
    toggleBtn.Text = enabled and "ON" or "OFF"
    toggleBtn.BackgroundColor3 = enabled and Color3.fromRGB(40,150,40) or Color3.fromRGB(150,40,40)
    statusLabel.Text = "Status: " .. (enabled and "ON" or "OFF")
    notify(enabled and "ENABLED" or "DISABLED")
end

UIS.InputBegan:Connect(function(input, gp)
    if gp then return end

    if waitingForToggleKey and input.UserInputType == Enum.UserInputType.Keyboard then
        toggleKey = input.KeyCode
        waitingForToggleKey = false
        return
    end

    if waitingForMenuKey and input.UserInputType == Enum.UserInputType.Keyboard then
        menuKey = input.KeyCode
        waitingForMenuKey = false
        return
    end

    if input.KeyCode == toggleKey then
        setEnabled(not enabled)
    end

    if input.KeyCode == menuKey then
        gui.Enabled = not gui.Enabled
    end
end)

toggleBtn.MouseButton1Click:Connect(function()
    setEnabled(not enabled)
end)

RunService.RenderStepped:Connect(function()
    if not waitingForToggleKey then
        keyBtn.Text = "Toggle Key (" .. toggleKey.Name .. ")"
    end
    if not waitingForMenuKey then
        menuBtn.Text = "Menu Key (" .. menuKey.Name .. ")"
    end
end)
