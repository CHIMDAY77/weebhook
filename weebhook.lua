--[[ 
    MODERN JOB ID JOINER v3.0
    Tính năng: Tự động lọc ID + Nút Dán/Xóa nhanh
    Hỗ trợ: PC & Mobile (Delta, Fluxus, Hydrogen...)
    Tác giả: Gemini Helper
]]

local TweenService = game:GetService("TweenService")
local TeleportService = game:GetService("TeleportService")
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")

-- 1. DỌN DẸP UI CŨ
if CoreGui:FindFirstChild("SmartJoinerV3") then
    CoreGui.SmartJoinerV3:Destroy()
end

-- 2. THIẾT LẬP GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "SmartJoinerV3"
ScreenGui.Parent = CoreGui
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

local Colors = {
    Bg = Color3.fromRGB(20, 20, 25),
    Input = Color3.fromRGB(35, 35, 40),
    Accent = Color3.fromRGB(0, 140, 255), -- Xanh dương sáng
    Text = Color3.fromRGB(240, 240, 240),
    Red = Color3.fromRGB(255, 60, 60),
    Green = Color3.fromRGB(60, 220, 100)
}

-- == MAIN FRAME ==
local MainFrame = Instance.new("Frame")
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Colors.Bg
MainFrame.Position = UDim2.new(0.5, -150, 0.3, 0) -- Giữa màn hình
MainFrame.Size = UDim2.new(0, 300, 0, 150) -- Kích thước gọn
MainFrame.ClipsDescendants = true

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 10)
MainCorner.Parent = MainFrame

local MainStroke = Instance.new("UIStroke")
MainStroke.Parent = MainFrame
MainStroke.Color = Colors.Accent
MainStroke.Thickness = 1.5
MainStroke.Transparency = 0.6

-- DRAGGABLE (Kéo thả)
local DragFrame = Instance.new("Frame")
DragFrame.Parent = MainFrame
DragFrame.BackgroundTransparency = 1
DragFrame.Size = UDim2.new(1, 0, 1, 0)
local dragging, dragInput, dragStart, startPos
DragFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = MainFrame.Position
        input.Changed:Connect(function() if input.UserInputState == Enum.UserInputState.End then dragging = false end end)
    end
end)
DragFrame.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then dragInput = input end
end)
UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        local delta = input.Position - dragStart
        MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

-- == HEADER ==
local Title = Instance.new("TextLabel")
Title.Parent = MainFrame
Title.BackgroundTransparency = 1
Title.Position = UDim2.new(0, 12, 0, 8)
Title.Size = UDim2.new(1, -50, 0, 20)
Title.Font = Enum.Font.GothamBold
Title.Text = "SERVER HOPPER v3"
Title.TextColor3 = Colors.Accent
Title.TextSize = 14
Title.TextXAlignment = Enum.TextXAlignment.Left

-- Nút Thu Nhỏ (-)
local MiniBtn = Instance.new("TextButton")
MiniBtn.Parent = MainFrame
MiniBtn.BackgroundColor3 = Colors.Input
MiniBtn.Position = UDim2.new(1, -30, 0, 8)
MiniBtn.Size = UDim2.new(0, 20, 0, 20)
MiniBtn.Font = Enum.Font.GothamBold
MiniBtn.Text = "_"
MiniBtn.TextColor3 = Colors.Text
MiniBtn.TextSize = 14
local MiniCorner = Instance.new("UICorner")
MiniCorner.CornerRadius = UDim.new(0, 4)
MiniCorner.Parent = MiniBtn

-- == HÀNG NHẬP LIỆU (Input Row) ==
-- 1. Ô Nhập (Chiếm 65%)
local InputBox = Instance.new("TextBox")
InputBox.Parent = MainFrame
InputBox.BackgroundColor3 = Colors.Input
InputBox.Position = UDim2.new(0.04, 0, 0.3, 0)
InputBox.Size = UDim2.new(0.65, 0, 0, 35)
InputBox.Font = Enum.Font.Gotham
InputBox.PlaceholderText = "Paste ID..."
InputBox.Text = ""
InputBox.TextColor3 = Colors.Text
InputBox.TextSize = 12
InputBox.TextTruncate = Enum.TextTruncate.AtEnd
local InputCorner = Instance.new("UICorner")
InputCorner.CornerRadius = UDim.new(0, 6)
InputCorner.Parent = InputBox
local Pad = Instance.new("UIPadding")
Pad.PaddingLeft = UDim.new(0, 8)
Pad.Parent = InputBox

-- 2. Nút Dán (Paste) - Chiếm 12%
local PasteBtn = Instance.new("TextButton")
PasteBtn.Parent = MainFrame
PasteBtn.BackgroundColor3 = Colors.Accent
PasteBtn.Position = UDim2.new(0.71, 0, 0.3, 0)
PasteBtn.Size = UDim2.new(0.11, 0, 0, 35)
PasteBtn.Font = Enum.Font.GothamBold
PasteBtn.Text = "📋" -- Icon Paste
PasteBtn.TextColor3 = Color3.new(1,1,1)
PasteBtn.TextSize = 16
local PasteCorner = Instance.new("UICorner")
PasteCorner.CornerRadius = UDim.new(0, 6)
PasteCorner.Parent = PasteBtn

-- 3. Nút Xóa (Del) - Chiếm 12%
local DelBtn = Instance.new("TextButton")
DelBtn.Parent = MainFrame
DelBtn.BackgroundColor3 = Colors.Red
DelBtn.Position = UDim2.new(0.84, 0, 0.3, 0)
DelBtn.Size = UDim2.new(0.11, 0, 0, 35)
DelBtn.Font = Enum.Font.GothamBold
DelBtn.Text = "✖" -- Icon X
DelBtn.TextColor3 = Color3.new(1,1,1)
DelBtn.TextSize = 16
local DelCorner = Instance.new("UICorner")
DelCorner.CornerRadius = UDim.new(0, 6)
DelCorner.Parent = DelBtn

-- == NÚT JOIN ==
local JoinBtn = Instance.new("TextButton")
JoinBtn.Parent = MainFrame
JoinBtn.BackgroundColor3 = Colors.Accent
JoinBtn.Position = UDim2.new(0.04, 0, 0.65, 0)
JoinBtn.Size = UDim2.new(0.92, 0, 0, 35)
JoinBtn.Font = Enum.Font.GothamBold
JoinBtn.Text = "JOIN SERVER"
JoinBtn.TextColor3 = Color3.new(1,1,1)
JoinBtn.TextSize = 14
local JoinCorner = Instance.new("UICorner")
JoinCorner.CornerRadius = UDim.new(0, 6)
JoinCorner.Parent = JoinBtn

-- == ICON THU NHỎ (Floating) ==
local FloatIcon = Instance.new("TextButton")
FloatIcon.Name = "FloatIcon"
FloatIcon.Parent = ScreenGui
FloatIcon.BackgroundColor3 = Colors.Bg
FloatIcon.Position = UDim2.new(0.1, 0, 0.2, 0)
FloatIcon.Size = UDim2.new(0, 40, 0, 40)
FloatIcon.Font = Enum.Font.GothamBold
FloatIcon.Text = "J"
FloatIcon.TextColor3 = Colors.Accent
FloatIcon.TextSize = 20
FloatIcon.Visible = false
FloatIcon.Draggable = true
local IconCorner = Instance.new("UICorner")
IconCorner.CornerRadius = UDim.new(1, 0)
IconCorner.Parent = FloatIcon
local IconStroke = Instance.new("UIStroke")
IconStroke.Parent = FloatIcon
IconStroke.Color = Colors.Accent
IconStroke.Thickness = 2

-- == LOGIC ==

-- Hiệu ứng bấm nút
local function ripple(obj)
    local t = TweenService:Create(obj, TweenInfo.new(0.1), {Size = UDim2.new(obj.Size.X.Scale, -2, obj.Size.Y.Scale, -2)})
    t:Play()
    t.Completed:Connect(function() 
        TweenService:Create(obj, TweenInfo.new(0.1), {Size = UDim2.new(obj.Size.X.Scale, 0, obj.Size.Y.Scale, 0)}):Play() 
    end)
end

-- Chức năng Paste (Sử dụng getclipboard)
PasteBtn.MouseButton1Click:Connect(function()
    ripple(PasteBtn)
    -- Thử lấy dữ liệu từ clipboard
    local success, clip = pcall(function() return getclipboard() end)
    if success and clip then
        InputBox.Text = clip
    else
        InputBox.PlaceholderText = "Không hỗ trợ!"
        wait(1)
        InputBox.PlaceholderText = "Paste ID..."
    end
end)

-- Chức năng Xóa
DelBtn.MouseButton1Click:Connect(function()
    ripple(DelBtn)
    InputBox.Text = ""
end)

-- Chức năng Join (Tự lọc ID)
JoinBtn.MouseButton1Click:Connect(function()
    ripple(JoinBtn)
    local rawText = InputBox.Text
    -- Pattern lọc UUID chuẩn
    local jobId = string.match(rawText, "%x%x%x%x%x%x%x%x%-%x%x%x%x%-%x%x%x%x%-%x%x%x%x%-%x%x%x%x%x%x%x%x%x%x%x%x")
    
    if jobId then
        JoinBtn.Text = "CONNECTING..."
        JoinBtn.BackgroundColor3 = Colors.Green
        local s, e = pcall(function()
            TeleportService:TeleportToPlaceInstance(game.PlaceId, jobId, Players.LocalPlayer)
        end)
        if not s then
            JoinBtn.Text = "FAILED"
            JoinBtn.BackgroundColor3 = Colors.Red
            warn(e)
            wait(2)
            JoinBtn.Text = "JOIN SERVER"
            JoinBtn.BackgroundColor3 = Colors.Accent
        end
    else
        JoinBtn.Text = "INVALID ID"
        JoinBtn.BackgroundColor3 = Colors.Red
        wait(1)
        JoinBtn.Text = "JOIN SERVER"
        JoinBtn.BackgroundColor3 = Colors.Accent
    end
end)

-- Thu nhỏ / Phóng to
MiniBtn.MouseButton1Click:Connect(function() MainFrame.Visible = false; FloatIcon.Visible = true end)
FloatIcon.MouseButton1Click:Connect(function() FloatIcon.Visible = false; MainFrame.Visible = true end)
