local checkInterval = 0.5 
local systemActive = true 
local uiVisible = true    

local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")

if CoreGui:FindFirstChild("AutoAcceptUI") then
    CoreGui.AutoAcceptUI:Destroy()
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "AutoAcceptUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = CoreGui

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 160, 0, 75)
MainFrame.Position = UDim2.new(0.02, 0, 0.4, 0) 
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true 
MainFrame.Parent = ScreenGui

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 8)
UICorner.Parent = MainFrame

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 25)
Title.BackgroundTransparency = 1
Title.Text = "Auto Accept (Delta Fix)"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 12
Title.Font = Enum.Font.SourceSansBold
Title.Parent = MainFrame

local StatusDot = Instance.new("Frame")
StatusDot.Size = UDim2.new(0, 10, 0, 10)
StatusDot.Position = UDim2.new(0, 15, 0, 42)
StatusDot.BackgroundColor3 = Color3.fromRGB(0, 255, 100) 
StatusDot.BorderSizePixel = 0
StatusDot.Parent = MainFrame

local DotCorner = Instance.new("UICorner")
DotCorner.CornerRadius = UDim.new(1, 0)
DotCorner.Parent = StatusDot

local ToggleBtn = Instance.new("TextButton")
ToggleBtn.Size = UDim2.new(0, 110, 0, 30)
ToggleBtn.Position = UDim2.new(0, 35, 0, 32)
ToggleBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
ToggleBtn.Text = "Status: ON"
ToggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleBtn.TextSize = 13
ToggleBtn.Font = Enum.Font.SourceSansBold
ToggleBtn.Parent = MainFrame

local BtnCorner = Instance.new("UICorner")
BtnCorner.CornerRadius = UDim.new(0, 6)
BtnCorner.Parent = ToggleBtn

local HideBtn = Instance.new("TextButton")
HideBtn.Size = UDim2.new(0, 25, 0, 25)
HideBtn.Position = UDim2.new(0.02, 0, 0.4, -30) 
HideBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
HideBtn.Text = "👁️"
HideBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
HideBtn.TextSize = 14
HideBtn.Parent = ScreenGui

local HideCorner = Instance.new("UICorner")
HideCorner.CornerRadius = UDim.new(0, 6)
HideCorner.Parent = HideBtn

local function updateUI()
    if systemActive then
        ToggleBtn.Text = "Status: ON"
        TweenService:Create(StatusDot, TweenInfo.new(0.3), {BackgroundColor3 = Color3.fromRGB(0, 255, 100)}):Play()
    else
        ToggleBtn.Text = "Status: OFF"
        TweenService:Create(StatusDot, TweenInfo.new(0.3), {BackgroundColor3 = Color3.fromRGB(255, 50, 50)}):Play()
    end
end

ToggleBtn.MouseButton1Click:Connect(function()
    systemActive = not systemActive
    updateUI()
end)

HideBtn.MouseButton1Click:Connect(function()
    uiVisible = not uiVisible
    MainFrame.Visible = uiVisible
    if uiVisible then
        HideBtn.Text = "👁️"
        HideBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    else
        HideBtn.Text = "❌"
        HideBtn.BackgroundColor3 = Color3.fromRGB(100, 30, 30) 
    end
end)

local function deltaExecuteClick(button)
    button:Activate()
    
    if firesignal then
        firesignal(button.MouseButton1Click)
        firesignal(button.MouseButton1Down)
    end
    
    if getconnections then
        for _, connection in ipairs(button.MouseButton1Click:GetConnections()) do
            connection:Fire()
        end
        for _, connection in ipairs(button.Activated:GetConnections()) do
            connection:Fire()
        end
    end
end

task.spawn(function()
    while true do
        task.wait(checkInterval)
        
        if systemActive then
            for _, object in ipairs(CoreGui:GetDescendants()) do
                if object:IsA("TextButton") and object.Visible then
                    if object.Text == "Accept" or string.find(string.lower(object.Name), "accept") then
                        local parentName = object.Parent and string.lower(object.Parent.Name) or ""
                        local grandParentName = (object.Parent and object.Parent.Parent) and string.lower(object.Parent.Parent.Name) or ""
                        
                        if string.find(parentName, "notification") or string.find(grandParentName, "notification") or string.find(parentName, "friend") then
                            deltaExecuteClick(object)
                            task.wait(0.2)
                        end
                    end
                end
            end
        end
    end
end)

print("--- Auto Accept (Delta Mobile Fix) Loaded ---")
