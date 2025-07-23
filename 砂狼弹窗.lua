local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local SoundService = game:GetService("SoundService")
local RunService = game:GetService("RunService")

Httadmin = {}
local GUI_NAME = "NotificationGui"
local activeNotifications = {}

local CONFIG = {
    WIDTH = 250,
    HEIGHT = 75,
    SPACING = 8,
    OFFSET = Vector2.new(20, 20),
    BACKGROUND_TRANSPARENCY = 0.5,
    CORNER_RADIUS = 2,
    PROGRESS_BAR = {
        HEIGHT = 4,
        COLOR = Color3.fromRGB(0, 255, 0),
        CORNER_RADIUS = 1
    },
    TITLE = {
        FONT = Enum.Font.GothamBold,
        SIZE = 18,
        COLOR = Color3.fromRGB(255, 255, 255),
        OFFSET = 8
    },
    MESSAGE = {
        FONT = Enum.Font.Gotham,
        SIZE = 14,
        COLOR = Color3.fromRGB(220, 220, 220),
        OFFSET = 30
    },
    ICON = {
        SIZE = UDim2.new(0, 24, 0, 24),
        OFFSET = 8
    },
    ANIMATION = {
        DURATION = 0.3,
        EASING_STYLE = Enum.EasingStyle.Quad,
        EASING_DIRECTION = Enum.EasingDirection.Out
    }
}

local blendColors = {
    Color3.fromRGB(0, 255, 255), 
    Color3.fromRGB(255, 0, 255), 
    Color3.fromRGB(255, 105, 180)
}

local function interpolateColors(colors, t)
    local count = #colors
    local segment = math.floor(t * count) % count + 1
    local nextSegment = (segment % count) + 1
    local alpha = (t * count) % 1

    local c1 = colors[segment]
    local c2 = colors[nextSegment]

    return Color3.new(
        c1.R + (c2.R - c1.R) * alpha,
        c1.G + (c2.G - c1.G) * alpha,
        c1.B + (c2.B - c1.B) * alpha
    )
end

local function initializeGui()
    local player = Players.LocalPlayer
    local playerGui = player:WaitForChild("PlayerGui")
    local gui = playerGui:FindFirstChild(GUI_NAME)
    if not gui then
        gui = Instance.new("ScreenGui")
        gui.Name = GUI_NAME
        gui.IgnoreGuiInset = true
        gui.ResetOnSpawn = false
        gui.DisplayOrder = 1000
        gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
        gui.Parent = playerGui
    end
    return gui
end

local function updateNotificationsPosition()
    for index, notification in ipairs(activeNotifications) do
        local yOffset = (CONFIG.HEIGHT + CONFIG.SPACING) * (index - 1)
        notification.frame:TweenPosition(
            UDim2.new(1, -CONFIG.OFFSET.X, 1, -CONFIG.OFFSET.Y - yOffset),
            CONFIG.ANIMATION.EASING_DIRECTION,
            CONFIG.ANIMATION.EASING_STYLE,
            CONFIG.ANIMATION.DURATION,
            true
        )
    end
end

local function createProgressAnimation(frame, duration)
    local progressBar = Instance.new("Frame")
    progressBar.Size = UDim2.new(1, 0, 0, CONFIG.PROGRESS_BAR.HEIGHT)
    progressBar.Position = UDim2.new(0, 0, 1, -CONFIG.PROGRESS_BAR.HEIGHT)
    progressBar.BackgroundTransparency = 1
    progressBar.ClipsDescendants = true
    progressBar.ZIndex = 11
    progressBar.Parent = frame

    local fill = Instance.new("Frame")
    fill.Size = UDim2.new(1, 0, 1, 0)
    fill.Position = UDim2.new(0, 0, 0, 0)
    fill.AnchorPoint = Vector2.new(0, 0)
    fill.BackgroundColor3 = CONFIG.PROGRESS_BAR.COLOR
    fill.ZIndex = 12
    fill.Parent = progressBar

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, CONFIG.PROGRESS_BAR.CORNER_RADIUS)
    corner.Parent = fill

    TweenService:Create(fill, TweenInfo.new(duration, Enum.EasingStyle.Linear), {
        Size = UDim2.new(0, 0, 1, 0)
    }):Play()

    return RunService.RenderStepped:Connect(function()
        -- 混合颜色不需要渐变这里
    end)
end

function Httadmin.send(title, message, duration, iconId)
    local sound = Instance.new("Sound")
    sound.SoundId = "rbxassetid://6647898215"
    sound.Volume = 10
    sound.Parent = SoundService
    sound:Play()
    sound.Ended:Connect(function()
        sound:Destroy()
    end)

    duration = duration or 4
    local gui = initializeGui()

    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, CONFIG.WIDTH, 0, CONFIG.HEIGHT)
    frame.Position = UDim2.new(1, -CONFIG.OFFSET.X, 1, -CONFIG.OFFSET.Y)
    frame.AnchorPoint = Vector2.new(1, 1)
    frame.BackgroundColor3 = Color3.new(0, 0, 0)
    frame.BackgroundTransparency = CONFIG.BACKGROUND_TRANSPARENCY
    frame.BorderSizePixel = 0
    frame.ZIndex = 10
    frame.Parent = gui

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, CONFIG.CORNER_RADIUS)
    corner.Parent = frame

    local stroke = Instance.new("UIStroke")
    stroke.Thickness = 2
    stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    stroke.Color = blendColors[1]
    stroke.Parent = frame

    local colorTime = 0
    local strokeConnection
    strokeConnection = RunService.RenderStepped:Connect(function(dt)
        colorTime += dt * 0.3
        stroke.Color = interpolateColors(blendColors, colorTime % 1)
        if not frame or not frame.Parent then
            strokeConnection:Disconnect()
        end
    end)

    local iconOffset = 0
    if iconId then
        local icon = Instance.new("ImageLabel")
        icon.Size = CONFIG.ICON.SIZE
        icon.Position = UDim2.new(0, CONFIG.ICON.OFFSET, 0, CONFIG.ICON.OFFSET)
        icon.BackgroundTransparency = 1
        icon.Image = iconId
        icon.ImageTransparency = 1
        icon.ZIndex = 11
        icon.Parent = frame
        iconOffset = 40
        TweenService:Create(icon, TweenInfo.new(CONFIG.ANIMATION.DURATION), {ImageTransparency = 0}):Play()
    end

    local titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.new(1, -(iconOffset + 8), 0, 24)
    titleLabel.Position = UDim2.new(0, iconOffset > 0 and 40 or 8, 0, CONFIG.TITLE.OFFSET)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = title or "Notification"
    titleLabel.Font = CONFIG.TITLE.FONT
    titleLabel.TextSize = CONFIG.TITLE.SIZE
    titleLabel.TextColor3 = CONFIG.TITLE.COLOR
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.TextTransparency = 1
    titleLabel.ZIndex = 11
    titleLabel.Parent = frame

    local messageLabel = Instance.new("TextLabel")
    messageLabel.Size = UDim2.new(1, -(iconOffset + 8), 1, -32)
    messageLabel.Position = UDim2.new(0, iconOffset > 0 and 40 or 8, 0, CONFIG.MESSAGE.OFFSET)
    messageLabel.BackgroundTransparency = 1
    messageLabel.Text = message or ""
    messageLabel.Font = CONFIG.MESSAGE.FONT
    messageLabel.TextSize = CONFIG.MESSAGE.SIZE
    messageLabel.TextColor3 = CONFIG.MESSAGE.COLOR
    messageLabel.TextWrapped = true
    messageLabel.TextXAlignment = Enum.TextXAlignment.Left
    messageLabel.TextYAlignment = Enum.TextYAlignment.Top
    messageLabel.TextTransparency = 1
    messageLabel.ZIndex = 11
    messageLabel.Parent = frame

    TweenService:Create(titleLabel, TweenInfo.new(CONFIG.ANIMATION.DURATION), {TextTransparency = 0}):Play()
    TweenService:Create(messageLabel, TweenInfo.new(CONFIG.ANIMATION.DURATION), {TextTransparency = 0}):Play()

    local progressConnection = createProgressAnimation(frame, duration)

    local notification = {
        frame = frame,
        createdAt = os.time()
    }
    table.insert(activeNotifications, notification)
    updateNotificationsPosition()

    task.delay(duration, function()
        local fadeOut = TweenService:Create(frame, TweenInfo.new(CONFIG.ANIMATION.DURATION), {
            BackgroundTransparency = 1
        })
        TweenService:Create(titleLabel, TweenInfo.new(CONFIG.ANIMATION.DURATION), {TextTransparency = 1}):Play()
        TweenService:Create(messageLabel, TweenInfo.new(CONFIG.ANIMATION.DURATION), {TextTransparency = 1}):Play()
        fadeOut:Play()

        fadeOut.Completed:Connect(function()
            if progressConnection then progressConnection:Disconnect() end
            if strokeConnection then strokeConnection:Disconnect() end
            frame:Destroy()
            for i, v in ipairs(activeNotifications) do
                if v == notification then
                    table.remove(activeNotifications, i)
                    break
                end
            end
            updateNotificationsPosition()
        end)
    end)
end
