--[[ 
    BANANA HUB ALL-IN-ONE v4.0
    Tính năng: Webhook Premium + Job ID Joiner + FPS Optimizer
    Yêu cầu: Điền Webhook URL bên dưới
]]

-- // CẤU HÌNH //
local Webhook_URL = "https://discord.com/api/webhooks/1462798147528032399/s5vSfHQ9cRh31MdwZwJ2TDrkndATI__QilskIxpFBvm5Y4ty6AwXSKHbWbatNHceJfD5" -- <--- DÁN LINK WEBHOOK VÀO ĐÂY
local FPS_TARGET = 20

-- // SERVICES //
local TweenService = game:GetService("TweenService")
local TeleportService = game:GetService("TeleportService")
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local Data = player:WaitForChild("Data")

-- // 1. TỐI ƯU FPS & HIỆU SUẤT //
if setfpscap then
    setfpscap(FPS_TARGET)
    settings().Rendering.QualityLevel = 1
    -- RunService:Set3dRenderingEnabled(false) -- Bỏ comment nếu muốn tắt hẳn màn hình game
end

-- // 2. LOGIC LẤY THÔNG TIN ACC //
local function getItems()
    local meleeTable, swordTable = {}, {}
    local function scan(container)
        for _, item in pairs(container:GetChildren()) do
            if item:IsA("Tool") then
                if item:FindFirstChild("Melee") or item.ToolTip == "Melee" then
                    table.insert(meleeTable, "👊 " .. item.Name)
                else
                    table.insert(swordTable, "⚔️ " .. item.Name)
                end
            end
        end
    end
    scan(player.Backpack)
    if player.Character then scan(player.Character) end
    return table.concat(meleeTable, ", "), table.concat(swordTable, ", ")
end

local function SendStatusToDiscord()
    if Webhook_URL == "https://discord.com/api/webhooks/1462798147528032399/s5vSfHQ9cRh31MdwZwJ2TDrkndATI__QilskIxpFBvm5Y4ty6AwXSKHbWbatNHceJfD5" then return end
    
    local melee, swords = getItems()
    local avatarUrl = "https://www.roblox.com/headshot-thumbnail/image?userId=" .. player.UserId .. "&width=420&height=420&format=png"
    
    local payload = {
        ["username"] = "Banana Hub Premium",
        ["embeds"] = {{
            ["title"] = "🍌 **BANANA HUB - STATUS REPORT** 🍌",
            ["color"] = 16773120,
            ["thumbnail"] = { ["url"] = avatarUrl },
            ["fields"] = {
                {["name"] = "👤 **USER**", ["value"] = "```arm\n" .. player.Name .. " (" .. player.UserId .. ")```", ["inline"] = false},
                {["name"] = "📊 **STATS**", ["value"] = "⭐ **Level:** `" .. Data.Level.Value .. "`\n🧬 **Race:** `" .. Data.Race.Value .. "`\n🍎 **Fruit:** `" .. (Data.Fruit.Value ~= "" and Data.Fruit.Value or "None") .. "`", ["inline"] = false},
                {["name"] = "👊 **MELEE**", ["value"] = "```ini\n" .. (melee ~= "" and melee or "None") .. "```", ["inline"] = true},
                {["name"] = "⚔️ **SWORDS**", ["value"] = "```ini\n" .. (swords ~= "" and swords or "None") .. "```", ["inline"] = true},
                {["name"] = "💰 **CURRENCY**", ["value"] = "💵 **Beli:** " .. string.format("%.2fM", Data.Beli.Value/1000000) .. " | 💎 **Frags:** " .. Data.Fragments.Value, ["inline"] = false}
            },
            ["footer"] = {["text"] = "Updated: " .. os.date("%H:%M:%S")},
            ["timestamp"] = os.date("!%Y-%m-%dT%H:%M:%SZ")
        }}
    }

    local request = syn and syn.request or http_request or request or HttpPost
    pcall(function()
        request({Url = Webhook_URL, Method = "POST", Headers = {["Content-Type"] = "application/json"}, Body = HttpService:JSONEncode(payload)})
    end)
end

-- // 3. GIAO DIỆN GUI (JOB ID JOINER) //
if CoreGui:FindFirstChild("BananaJoinerV4") then CoreGui.BananaJoinerV4:Destroy() end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "BananaJoinerV4"
ScreenGui.Parent = CoreGui

local Colors = {
    Bg = Color3.fromRGB(25, 25, 30),
    Input = Color3.fromRGB(40, 40, 45),
    Accent = Color3.fromRGB(255, 210, 0), -- Màu vàng Banana
    Text = Color3.fromRGB(255, 255, 255),
    Red = Color3.fromRGB(255, 80, 80)
}

local MainFrame = Instance.new("Frame")
MainFrame.Name = "Main"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Colors.Bg
MainFrame.Position = UDim2.new(0.5, -150, 0.4, 0)
MainFrame.Size = UDim2.new(0, 300, 0, 160)
MainFrame.Active = true
MainFrame.Draggable = true -- Hỗ trợ kéo thả đơn giản

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 12)
MainCorner.Parent = MainFrame

local Stroke = Instance.new("UIStroke")
Stroke.Thickness = 2
Stroke.Color = Colors.Accent
Stroke.Parent = MainFrame

-- Title
local Title = Instance.new("TextLabel")
Title.Parent = MainFrame
Title.Size = UDim2.new(1, 0, 0, 35)
Title.Text = "🍌 BANANA SERVER HOPPER"
Title.Font = Enum.Font.GothamBold
Title.TextColor3 = Colors.Accent
Title.TextSize = 14
Title.BackgroundTransparency = 1

-- Input Box
local InputBox = Instance.new("TextBox")
InputBox.Parent = MainFrame
InputBox.Size = UDim2.new(0.9, 0, 0, 35)
InputBox.Position = UDim2.new(0.05, 0, 0.3, 0)
InputBox.BackgroundColor3 = Colors.Input
InputBox.PlaceholderText = "Paste Job ID here..."
InputBox.Text = ""
InputBox.TextColor3 = Colors.Text
InputBox.Font = Enum.Font.Gotham
local IC = Instance.new("UICorner")
IC.CornerRadius = UDim.new(0, 6)
IC.Parent = InputBox

-- Buttons Container
local BtnFrame = Instance.new("Frame")
BtnFrame.Parent = MainFrame
BtnFrame.Position = UDim2.new(0.05, 0, 0.6, 0)
BtnFrame.Size = UDim2.new(0.9, 0, 0, 40)
BtnFrame.BackgroundTransparency = 1

local UIList = Instance.new("UIListLayout")
UIList.Parent = BtnFrame
UIList.FillDirection = Enum.FillDirection.Horizontal
UIList.Padding = UDim.new(0, 5)
UIList.SortOrder = Enum.SortOrder.LayoutOrder

local function createBtn(text, color, size, order)
    local btn = Instance.new("TextButton")
    btn.Size = size
    btn.BackgroundColor3 = color
    btn.Text = text
    btn.Font = Enum.Font.GothamBold
    btn.TextColor3 = Color3.new(1,1,1)
    btn.LayoutOrder = order
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, 6)
    c.Parent = btn
    btn.Parent = BtnFrame
    return btn
end

local PasteBtn = createBtn("📋", Colors.Accent, UDim2.new(0.2, -5, 1, 0), 1)
local DelBtn = createBtn("✖", Colors.Red, UDim2.new(0.2, -5, 1, 0), 2)
local JoinBtn = createBtn("JOIN SERVER", Color3.fromRGB(60, 200, 100), UDim2.new(0.6, 0, 1, 0), 3)

-- Minimize Button
local MiniBtn = Instance.new("TextButton")
MiniBtn.Parent = MainFrame
MiniBtn.Size = UDim2.new(0, 25, 0, 25)
MiniBtn.Position = UDim2.new(1, -35, 0, 5)
MiniBtn.Text = "-"
MiniBtn.BackgroundColor3 = Colors.Input
MiniBtn.TextColor3 = Colors.Accent
Instance.new("UICorner", MiniBtn).CornerRadius = UDim.new(0, 5)

-- Floating Icon
local Float = Instance.new("TextButton")
Float.Parent = ScreenGui
Float.Size = UDim2.new(0, 45, 0, 45)
Float.Position = UDim2.new(0.05, 0, 0.1, 0)
Float.BackgroundColor3 = Colors.Bg
Float.Text = "🍌"
Float.TextSize = 25
Float.Visible = false
Float.Draggable = true
Instance.new("UICorner", Float).CornerRadius = UDim.new(1, 0)
Instance.new("UIStroke", Float).Color = Colors.Accent

-- // 4. LOGIC TƯƠNG TÁC //
PasteBtn.MouseButton1Click:Connect(function()
    local success, clip = pcall(function() return getclipboard() end)
    if success then InputBox.Text = clip end
end)

DelBtn.MouseButton1Click:Connect(function() InputBox.Text = "" end)

JoinBtn.MouseButton1Click:Connect(function()
    local jobId = string.match(InputBox.Text, "%x%x%x%x%x%x%x%x%-%x%x%x%x%-%x%x%x%x%-%x%x%x%x%-%x%x%x%x%x%x%x%x%x%x%x%x")
    if jobId then
        JoinBtn.Text = "CONNECTING..."
        TeleportService:TeleportToPlaceInstance(game.PlaceId, jobId, player)
    else
        JoinBtn.Text = "INVALID ID"
        task.wait(1)
        JoinBtn.Text = "JOIN SERVER"
    end
end)

MiniBtn.MouseButton1Click:Connect(function() MainFrame.Visible = false; Float.Visible = true end)
Float.MouseButton1Click:Connect(function() MainFrame.Visible = true; Float.Visible = false end)

-- // KHỞI CHẠY //
task.spawn(function()
    while true do
        SendStatusToDiscord()
        task.wait(300) -- Gửi thông báo mỗi 5 phút
    end
end)

print("🍌 Banana Hub All-In-One Loaded!")
