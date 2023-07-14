local THICKNESS = 0.5
local COLOR = Color3.fromRGB(0, 0, 0)
local TRANSPARENCY = 0
local SHAFT_WIDTH = 25
local SHAFT_LENGTH = 50
local SEGMENTS = 50

local players = game:GetService('Players')
local replicatedStorage = game:GetService('ReplicatedStorage')

local localPlayer = players.LocalPlayer
local character = localPlayer.Character
local characterPosition = character:GetPivot().Position

local Client = require(replicatedStorage:WaitForChild('shared'):WaitForChild('remotes')).Client

local createLineEvent = Client:Get('createLine')
local createLayerEvent = Client:Get('createLayer')

local i, LAYER_NAME = -1, ''
for _, child in pairs(localPlayer:WaitForChild('Trackers'):GetChildren()) do
	local index = child:GetAttribute('index')

	if index > i then
		LAYER_NAME = child:GetAttribute('id')
		i = index
	end
end

local function draw(layerName, color, transparency, thickness, points)
	local argumentsTable = {
		layerName,
		points,
		{
			['color'] = color,
			['transparency'] = transparency,
			['thickness'] = thickness
		}
	}

	createLineEvent:CallServerAsync(
		layerName,
		points,
		{
			['color'] = color,
			['transparency'] = transparency,
			['thickness'] = thickness
		}
	)
	task.wait()
end

local centerOfPP = Vector2.new(characterPosition.X, characterPosition.Z)

local function drawCircle(layerName, color, transparency, thickness, center, radius, segments)
	local points = {}

	for i = 1, segments do
		local angle = math.rad((360 / segments) * i)
		local x = center.X + radius * math.cos(angle)
		local y = center.Y + radius * math.sin(angle)
		points[i] = Vector2.new(x, y)
	end

	draw(layerName, color, transparency, thickness, points)
	draw(layerName, color, transparency, thickness, {points[segments], points[1]})
end

local function drawSemiCircle(layerName, color, transparency, thickness, center, radius, segments, direction)
	local angleIncrement = math.pi / segments
	local points = {}

	for i = 1, segments do
		local angle = angleIncrement * i
		local x = center.X + radius * math.cos(angle + math.pi / direction)
		local y = center.Y + radius * math.sin(angle + math.pi / direction)
		points[i] = Vector2.new(x, y)
	end

	draw(layerName, color, transparency, thickness, points)
	local angle = angleIncrement * -1
	local x = center.X + radius * math.cos(angle + math.pi / direction)
	local y = center.Y + radius * math.sin(angle + math.pi / direction)
	local mathemeticalFinalPoint = Vector3.new(x, y)
	local finalPoint = Vector2.new(points[segments].X, points[1].Y - (1 / segments))
	draw(layerName, color, transparency, thickness, {points[1], finalPoint})
end

drawCircle(
	LAYER_NAME,
	COLOR,
	TRANSPARENCY,
	THICKNESS,
	centerOfPP,
	SHAFT_WIDTH / 2,
	SEGMENTS
)

drawCircle(
	LAYER_NAME,
	COLOR,
	TRANSPARENCY,
	THICKNESS,
	centerOfPP + Vector2.new(0, SHAFT_WIDTH),
	SHAFT_WIDTH / 2,
	SEGMENTS
)

local centerOfShaft = centerOfPP + Vector2.new((SHAFT_WIDTH / 2), 0)
draw(
	LAYER_NAME,
	COLOR,
	TRANSPARENCY,
	THICKNESS,
	{
		centerOfShaft + Vector2.new(0, SHAFT_WIDTH),
		centerOfShaft + Vector2.new(SHAFT_LENGTH, SHAFT_WIDTH)
	}
)

draw(
	LAYER_NAME,
	COLOR,
	TRANSPARENCY,
	THICKNESS,
	{
		centerOfShaft + Vector2.new(SHAFT_LENGTH, 0),
		centerOfShaft + Vector2.new(SHAFT_LENGTH, SHAFT_WIDTH)
	}
)

draw(
	LAYER_NAME,
	COLOR,
	TRANSPARENCY,
	THICKNESS,
	{
		centerOfShaft + Vector2.new(SHAFT_LENGTH, 0),
		centerOfShaft
	}
)

drawSemiCircle(
	LAYER_NAME,
	COLOR,
	TRANSPARENCY,
	THICKNESS,
	centerOfPP + Vector2.new(SHAFT_LENGTH + (SHAFT_WIDTH / 2), SHAFT_WIDTH / 2),
	(SHAFT_WIDTH/2),
	SEGMENTS,
	-2
)

draw(
	LAYER_NAME,
	COLOR,
	0,
	THICKNESS,
	{
		centerOfPP + Vector2.new(SHAFT_LENGTH + (SHAFT_WIDTH), SHAFT_WIDTH / 2),
		centerOfPP + Vector2.new(SHAFT_LENGTH + (SHAFT_WIDTH / 1.25), SHAFT_WIDTH / 2)
	}
)
