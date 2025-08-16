local Plr = game:GetService("Players")
local LP = Plr.LocalPlayer

local Part = Instance.new("Part", workspace)
Part.Material = Enum.Material.ForceField
Part.Anchored = true
Part.CanCollide = false
Part.CastShadow = false
Part.Shape = Enum.PartType.Ball
Part.Color = Color3.fromRGB(132, 0, 255)
Part.Transparency = 0.5

local BaseGui = Instance.new("ScreenGui", game.CoreGui)
BaseGui.Name = "BaseGui"

local TL = Instance.new("TextLabel", BaseGui)
TL.Name = "TL"
TL.Parent = BaseGui
TL.BackgroundColor3 = Color3.new(1, 1, 1)
TL.BackgroundTransparency = 1
TL.BorderColor3 = Color3.new(0, 0, 0)
TL.Position = UDim2.new(0.95, -300, 0.85, 0)
TL.Size = UDim2.new(0, 300, 0, 50)
TL.FontFace = Font.new("rbxassetid://12187370000", Enum.FontWeight.Bold)
TL.Text = ""
TL.TextColor3 = Color3.new(1, 1, 1)
TL.TextScaled = true
TL.TextSize = 14
TL.TextWrapped = true
TL.Visible = true
TL.RichText = true

local function rainbowColor(hue)
  return Color3.fromHSV(hue, 1, 1)
end

local function updateRainbowText(distance, ballSpeed, spamRadius, minDistance)
  local hue = (tick() * 0.1) % 1
  local color1 = rainbowColor(hue)
  local color2 = rainbowColor((hue + 0.3) % 1)
  local color3 = rainbowColor((hue + 0.6) % 1)
  local color4 = rainbowColor((hue + 0.9) % 1)

  TL.Text = string.format(
  "<font color='#%s'>distance: %s</font>\n"..
  "<font color='#%s'>ballSpeed: %s</font>\n"..
  "<font color='#%s'>spamRadius: %s</font>\n"..
  "<font color='#%s'>minDistance: %s</font>",
  color1:ToHex(), tostring(distance),
  color2:ToHex(), tostring(ballSpeed),
  color3:ToHex(), tostring(spamRadius),
  color4:ToHex(), tostring(minDistance)
  )
end

local last1, last2
local Cam = workspace.CurrentCamera

local function ZJ()
  local Nearest, Min = nil, math.huge
  for A, B in next, workspace.Alive:GetChildren() do
    if B.Name ~= LP.Name and B:FindFirstChild("HumanoidRootPart") then
      local distance = LP:DistanceFromCharacter(B:GetPivot().Position)
      if distance < Min then
        Min = distance
        Nearest = B
      end
    end
  end
  return Min
end

local function Parry()
  task.spawn(function() game:GetService("VirtualInputManager"):SendMouseButtonEvent(0, 0, 0, true, nil, 0) end)
end

local function GetBall()
  for a, b in next, workspace.Balls:GetChildren() do
    if b:IsA("BasePart") and b:GetAttribute("realBall") then
      return b
    end
  end
end

local function IsTarget(a)
  return a:GetAttribute("target") == LP.Name
end

local function IsSpamming(a, b)
  if not type(last1) == "number" then return false end
  if not type(last2) == "number" then return false end
  if last1 - last2 > 0.8 then
    return false
  end
  if a > b then
    return false
  end
  if #workspace.Alive:GetChildren() <= 1 then
    return false
  end
  return true
end

local function addRainbowTitleToLocalPlayer(player, titleText)
    local function addTitleToCharacter(character)
        local head = character:FindFirstChild("Head") or character:WaitForChild("Head")
        local old = head:FindFirstChild("PlayerTitle")
        if old then old:Destroy() end
        local billboardGui = Instance.new("BillboardGui")
        billboardGui.Name = "PlayerTitle"
        billboardGui.Adornee = head
        billboardGui.Size = UDim2.new(4, 0, 1, 0)
        billboardGui.StudsOffset = Vector3.new(0, 2, 0)
        billboardGui.AlwaysOnTop = true
        billboardGui.MaxDistance = 1000
        local textLabel = Instance.new("TextLabel")
        textLabel.Size = UDim2.new(1, 0, 1, 0)
        textLabel.BackgroundTransparency = 1
        textLabel.Text = titleText
        textLabel.TextScaled = true
        textLabel.Font = Enum.Font.GothamBold
        textLabel.TextWrapped = true
        textLabel.Parent = billboardGui
        local stroke = Instance.new("UIStroke")
        stroke.Thickness = 1
        stroke.Color = Color3.new(1, 1, 1)
        stroke.Parent = textLabel
        local gradient = Instance.new("UIGradient")
        gradient.Rotation = 90
        gradient.Parent = textLabel
        local connection
        connection = game:GetService("RunService").RenderStepped:Connect(function()
            local time = tick() * 0.5
            gradient.Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, Color3.fromHSV(time % 1, 1, 1)),
                ColorSequenceKeypoint.new(0.2, Color3.fromHSV((time + 0.2) % 1, 1, 1)),
                ColorSequenceKeypoint.new(0.4, Color3.fromHSV((time + 0.4) % 1, 1, 1)),
                ColorSequenceKeypoint.new(0.6, Color3.fromHSV((time + 0.6) % 1, 1, 1)),
                ColorSequenceKeypoint.new(0.8, Color3.fromHSV((time + 0.8) % 1, 1, 1)),
                ColorSequenceKeypoint.new(1, Color3.fromHSV(time % 1, 1, 1))
            })
        end)
        billboardGui.AncestryChanged:Connect(function()
            if not billboardGui:IsDescendantOf(game) then
                if connection then connection:Disconnect() end
            end
        end)
        billboardGui.Parent = head
    end
    local character = player.Character or player.CharacterAdded:Wait()
    addTitleToCharacter(character)
    player.CharacterAdded:Connect(addTitleToCharacter)
end
addRainbowTitleToLocalPlayer(LP, "ShaLang VIP")