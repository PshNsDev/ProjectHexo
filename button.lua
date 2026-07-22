local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local VirtualInputManager = game:GetService("VirtualInputManager")

local player = Players.LocalPlayer

-- Remove GUI antiga
local old = player.PlayerGui:FindFirstChild("GrindingButton")
if old then
	old:Destroy()
end

local gui = Instance.new("ScreenGui")
gui.Name = "GrindingButton"
gui.ResetOnSpawn = false
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.Parent = player.PlayerGui

-- Fundo
local background = Instance.new("Frame")
background.Name = "Main"
background.Size = UDim2.fromOffset(72, 72)
background.Position = UDim2.new(0, 25, 0.35, -36)
background.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
background.BorderSizePixel = 0
background.Active = true
background.Parent = gui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 18)
corner.Parent = background

-- Outline
local stroke = Instance.new("UIStroke")
stroke.Thickness = 3
stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
stroke.Parent = background

local gradient = Instance.new("UIGradient")
gradient.Color = ColorSequence.new({
	ColorSequenceKeypoint.new(0, Color3.fromRGB(8, 32, 92)), -- Azul escuro
	ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 255, 255)), -- Branco
})
gradient.Parent = stroke

-- Botão
local button = Instance.new("ImageButton")
button.Name = "Button"
button.BackgroundTransparency = 1
button.Size = UDim2.new(1, -14, 1, -14)
button.Position = UDim2.new(0, 7, 0, 7)
button.Image = "rbxassetid://75715950979293"
button.ScaleType = Enum.ScaleType.Fit
button.AutoButtonColor = true
button.Parent = background

-- Clique = tecla END
button.MouseButton1Click:Connect(function()
	VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.End, false, game)
	task.wait(0.05)
	VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.End, false, game)
end)

----------------------------------------------------
-- ARRASTAR (PC + MOBILE)
----------------------------------------------------

local dragging = false
local dragInput
local dragStart
local startPos

local function beginDrag(input)
	dragging = true
	dragStart = input.Position
	startPos = background.Position

	input.Changed:Connect(function()
		if input.UserInputState == Enum.UserInputState.End then
			dragging = false
		end
	end)
end

local function changed(input)
	if input.UserInputType == Enum.UserInputType.MouseMovement
	or input.UserInputType == Enum.UserInputType.Touch then
		dragInput = input
	end
end

-- Frame
background.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1
	or input.UserInputType == Enum.UserInputType.Touch then
		beginDrag(input)
	end
end)

background.InputChanged:Connect(changed)

-- Botão (como cobre todo o Frame)
button.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1
	or input.UserInputType == Enum.UserInputType.Touch then
		beginDrag(input)
	end
end)

button.InputChanged:Connect(changed)

UserInputService.InputChanged:Connect(function(input)
	if dragging and input == dragInput then
		local delta = input.Position - dragStart

		background.Position = UDim2.new(
			startPos.X.Scale,
			startPos.X.Offset + delta.X,
			startPos.Y.Scale,
			startPos.Y.Offset + delta.Y
		)
	end
end)
