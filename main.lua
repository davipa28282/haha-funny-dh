--     LOADSTRINGs --
loadstring(game:HttpGet('https://raw.githubusercontent.com/gazakov/dahoodACbypass/refs/heads/main/script.lua'))()
--[[
THE CODE LOADSTRING BTW:
loadstring(game:HttpGet('https://raw.githubusercontent.com/davipa28282/haha-funny-dh/refs/heads/main/main.lua'))()
]]
--     VARIABLES   --
local Players = game:GetService('Players')
local lp = Players.LocalPlayer
local targ = false
local tcon
local m = game:GetService("ReplicatedStorage"):WaitForChild("MainEvent")
--     UNC FIXES   --
sethiddenproperty = sethiddenproperty or function() end
--     ShortCuts   --
local function clamp3(vec,num)
	return Vector3.new(
		math.clamp(vec.X, -num, num),
		math.clamp(vec.Y, -num, num),
		math.clamp(vec.Z, -num, num)
	)
end
--     MODULES     --
local cmdController = {}
local prefix = '!'
function safeChar(plr)
	return plr.Character or plr.CharacterAdded:Wait()
end
function getp(n)
	for _,v in pairs(Players:GetPlayers()) do
		if v.Name:lower() == n:lower() or v.DisplayName:lower() == n:lower() then
			return v
		end
	end
end
function gettool(n)
	local function find(inst)
		for _,v in pairs(inst:GetChildren()) do
			if v:IsA('Tool') and v.Name:lower() == n:lower() then
				return v
			end
		end
	end
	local c = find(lp.Backpack)
	if c then
		return c
	end
	c = find(safeChar(lp))
	if c then
		return c
	end
end
function forcefollow(plrname, glue, time,retur)
	retur = retur or true
	glue = glue or false
	time = time or 1
	local t = getp(plrname)
	if t then
		local t = safeChar(t)
		local self = safeChar(lp)
		local th = t:FindFirstChild('HumanoidRootPart')
		local sh = self:FindFirstChild('HumanoidRootPart')
		local ticksafe = tick()
		local old = sh.CFrame
		while tick() - ticksafe < time do
			task.wait()
			sh.Velocity = Vector3.zero
			sh.CFrame = th.CFrame * CFrame.new(0,-7,1) * CFrame.Angles(math.rad(90),0,0)
			if glue then
				sethiddenproperty(sh,'PhysicsRepRootPart',th)
			end
		end
		if retur then
			task.wait(0.5)
			sh.CFrame = old
		end
		sh.Velocity = Vector3.zero
		return t
	end
end
cmdController.Commands = {
	knock = function(plr,g)
		local self = safeChar(lp)
		local fist = gettool('combat')
		fist.Parent = self
		fist:Activate()
		task.wait(1)
		local fchar = forcefollow(plr,g,2,false)
		local torso = fchar:WaitForChild('UpperTorso')
	end,
	bring = function(plr,g)
		local self = safeChar(lp)
		local h = self:WaitForChild('HumanoidRootPart')
		local fist = gettool('combat')
		fist.Parent = self
		fist:Activate()
		task.wait(1)
		local fchar = forcefollow(plr,g,2,false)
		local torso = fchar:WaitForChild('UpperTorso')
		local tih = tick()
		local bf = fchar:WaitForChild('BodyEffects')
		local grb = bf.Grabbed
		while tick() - tih < 2 or grb.Value do
			h.CFrame = torso.CFrame * CFrame.new(0,1.5,0)
			m:FireServer('Grabbing',false)
			task.wait()
		end
	end,
}
cmdController.lCommands = {
	funnyspit = function()
		local ch = safeChar(lp)
		local p = ch:FindFirstChild('HumanoidRootPart')
		p.CFrame *= CFrame.new(0,0.9,0)
		p.Anchored = true
		local a = Instance.new('Animation')
		a.AnimationId = 'rbxassetid://134857797122316'
		local l = ch:FindFirstChildOfClass('Humanoid'):LoadAnimation(a)
		l:Play(0)
		l:AdjustSpeed(0)
		l.Priority = Enum.AnimationPriority.Action4
		task.wait()
		for i = 1,5 do
			m:FireServer("Stomp",true)
			task.wait(0.7)
		end
		p.Anchored = false
		l:Stop(0)
	end,
	knock = function(p)
		cmdController.Commands.knock(p,true)
	end,
	bring = function(p)
		cmdController.Commands.bring(p,true)
	end,
	select = function(plr)
		local plrf = getp(plr)
		if plrf then
			if tcon then
				tcon:Disconnect()
			end
			tcon = cmdController:Hook(plrf)
		end
	end,
}
function cmdController:Hook(plr)
	local cmdTable = cmdController.Commands
	if plr == lp then
		cmdTable = cmdController.lCommands
	else
		targ = plr
	end
	return plr.Chatted:Once(function(msg)
		local split = msg:split(' ')
		if split[1]:sub(0,#prefix) == prefix then
			local stringp = split[1]:sub(#prefix+1)
			local cmd = cmdTable[stringp]
			if cmd then
				table.remove(split,1)
				task.spawn(function()
					cmd(table.unpack(split))
				end)
			end
		end
	end)
end
if targ then
	tcon = cmdController:Hook(targ)
end
cmdController:Hook(lp)
