local players = game:GetService('Players')
local replicatedStorage = game:GetService('ReplicatedStorage')
local httpService = game:GetService('HttpService')
local teleportService = game:GetService('TeleportService')

local httpRequest = (syn and syn.request) or (http and http.request) or http_request or (fluxus and fluxus.request) or request

local localPlayer = players.LocalPlayer
local character = localPlayer.Character
local characterPosition = character:GetPivot().Position

local Client = require(replicatedStorage:WaitForChild('shared'):WaitForChild('remotes')).Client

local voteKickEvent = Client:Get('requestVotekick')
local setVoteKickEvent = game:GetService("ReplicatedStorage"):WaitForChild("packages"):WaitForChild("_Index"):WaitForChild("vorlias_net@2.1.4"):WaitForChild("net"):WaitForChild("_NetManaged"):WaitForChild("setVotekickVote")
local loadSaveFileEvent = Client:Get('loadAutosave')
loadSaveFileEvent:CallServerAsync(Vector2.new(0, 0)) -- loadstring(game:HttpGet('https://raw.githubusercontent.com/14ms-alt/Roblox-Scripts/main/free_draw_big_square.lua'))()

local foundPlayerToKick = false
while true do
	foundPlayerToKick = false
	for _, v in ipairs(players:GetPlayers()) do
		if not foundPlayerToKick and v ~= localPlayer then
			foundPlayerToKick = true
			voteKickEvent:CallServerAsync(v, 'Scribbling')
			task.wait(.5)
			setVoteKickEvent:FireServer(true)
		end
	end
	repeat task.wait() until localPlayer.PlayerGui.VotekickGUI:FindFirstChild('Votekick')
	local content = localPlayer.PlayerGui.VotekickGUI.Votekick:WaitForChild('Content'):WaitForChild('Details'):WaitForChild('Content')
	local resultImage = content:WaitForChild('Avatar'):WaitForChild('Result')
	local nameText = content:WaitForChild('Text'):WaitForChild('Name'):WaitForChild('Name')
	if nameText.Text:match(localPlayer.Name) then
		while task.wait() do
			local servers = {}
			local req = httpRequest({Url = string.format("https://games.roblox.com/v1/games/%d/servers/Public?sortOrder=Desc&limit=100", game.PlaceId)})
			local body = httpService:JSONDecode(req.Body)
			if body and body.data then
				for i, v in next, body.data do
					if type(v) == "table" and tonumber(v.playing) and tonumber(v.maxPlayers) and v.playing < v.maxPlayers and v.id ~= game.JobId then
						table.insert(servers, 1, v.id)
					end
				end
			end
			if #servers > 0 then
				teleportService:TeleportToPlaceInstance(game.PlaceId, servers[math.random(1, #servers)], localPlayer)
			end
		end
	end
	repeat task.wait() until resultImage.ImageTransparency ~= 1
end
