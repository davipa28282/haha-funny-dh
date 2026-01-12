--     LOADSTRINGs --
pcall(function()loadstring(game:HttpGet('https://raw.githubusercontent.com/davipa28282/haha-funny-dh/refs/heads/main/dhAC.lua'))()
end)
--[[loadstring for scripts
	loadstring(game:HttpGet('https://raw.githubusercontent.com/davipa28282/haha-funny-dh/refs/heads/main/main.lua'))()
]]
--     VARIABLES   --
local Players = game:GetService('Players')
local lp = Players.LocalPlayer
local targ = false
local tcon
local selfg
local mg
local m = game:GetService("ReplicatedStorage"):WaitForChild("MainEvent")
--     UNC FIXES   --
sethiddenproperty = sethiddenproperty or function() end
--     ShortCuts   --
function noti(title,text,buttons)
	local buttonsz = 0
	local tab = {
		Title = title,
		Text = text,
		Duration = 5,
		Callback = function(t)
			if buttons then
				local b = buttons[t]
				if b then
					b()
				end
			end
		end,
	}
	if buttons then
		for i,v in pairs(buttons) do
			tab['Button'.. buttonsz+1] = i
			buttonsz+=1
		end
	end
	game:GetService('StarterGui'):SetCore("SendNotification", tab)
end
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
	if n ~= 'random' then
		for _,v in pairs(Players:GetPlayers()) do
			if v.Name:lower() == n:lower() or v.DisplayName:lower() == n:lower() then
				return v
			end
		end
	else
		local ps = {}
		for _,v in pairs(Players:GetPlayers()) do
			if v ~= lp then
				table.insert(ps,v)
			end
		end
		return ps[math.random(1,#ps)]
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
function forcefollow(plrname, time,retur,knock)
	retur = retur or true
	time = time or 1
	local t = getp(plrname)

	if t then
		local t = safeChar(t)
		local self = safeChar(lp)
		local th = t:FindFirstChild('HumanoidRootPart')
		local sh = self:FindFirstChild('HumanoidRootPart')
		local ticksafe = tick()
		local old = sh.CFrame
		local fist = gettool('combat')
		if knock then
			fist.Parent = self
			fist:Activate()
			task.wait(1)
		end
		while tick() - ticksafe < time do
			task.wait()
			sh.Velocity = Vector3.zero
			sh.CFrame = CFrame.new(th.Position) * CFrame.new(0,-7,1) * CFrame.Angles(math.rad(90),0,0)
			sethiddenproperty(sh,'PhysicsRepRootPart',th)
		end
		sethiddenproperty(sh,'PhysicsRepRootPart',nil)
		if retur then
			task.wait(0.5)
			sh.CFrame = old
		end
		if knock then
			fist.Parent = lp.Backpack
		end
		sh.Velocity = Vector3.zero
		return t
	end
end
cmdController.Commands = {
	knock = function(caller,plr)
		if plr ~= lp then
			forcefollow(plr,2,false,true)
		end
	end,
	sky = function(caller,plr)
		if plr ~= lp then
			local sh = safeChar(lp)
			local h = sh.HumanoidRootPart
			local v = tick()
			local c = getp(plr)
			if not c then
				return
			end
			c = safeChar(c)
			if not c then return end
			c = c.HumanoidRootPart
			local o = h.CFrame
			while tick() - v < 5 do
				task.wait()
				h.CFrame = CFrame.new(c.Position) * CFrame.new(0,-3,0) * CFrame.Angles(math.rad(90),math.rad(65),0)
				sethiddenproperty(h,'PhysicsRepRootPart',c)
				sh.HumanoidRootPart.RotVelocity = Vector3.new(0,0,0)
				sh.HumanoidRootPart.Velocity = Vector3.new(0,0,0)
			end
			h.CFrame = o
			sethiddenproperty(sh,'PhysicsRepRootPart',nil)
			task.wait()
			for i = 0,1*100/2 do
				task.wait()
				sh.HumanoidRootPart.Velocity = Vector3.new(0,0,0)
			end
		end
	end,
	fling = function(caller,plr)
		local self = safeChar(lp)
		local h = self:FindFirstChild('HumanoidRootPart')
		local o = h.CFrame
		local t = getp(plr)
		if not t then return end
		local fchar = safeChar(t)
		if not fchar then return end
		local torso = fchar:FindFirstChild('UpperTorso')
		local tih = tick()
		h.CFrame = CFrame.new(torso.Position + Vector3.new(0,7,10))
		local mag = h.Position
		while tick() - tih < 7 and torso and h and (torso.Position - mag).Magnitude < 50 do
			sethiddenproperty(h,'PhysicsRepRootPart',torso)
			h.RotVelocity = Vector3.new(0,5000,0)
			h.CFrame = CFrame.new(torso.Position + Vector3.new(0,0,0)) * CFrame.Angles(math.rad(90),0,0)
			task.wait()
		end
		sethiddenproperty(h,'PhysicsRepRootPart',h)
		for _=1,4*100/2 do
			task.wait()
			h.RotVelocity = Vector3.zero
			h.Velocity = Vector3.zero
			h.CFrame = o
		end
	end,
	bring = function(caller,plr)
		local self = safeChar(lp)
		local h = self:FindFirstChild('HumanoidRootPart')
		if caller ~= lp and getp(plr) == lp and h then
			local t = caller.Character
			if t then
				local hr = t:FindFirstChild('HumanoidRootPart')
				if hr then
					h.CFrame = hr.CFrame
				end
			end
			return
		end
		local o = h.CFrame
		local fchar = forcefollow(plr,2,false,true)
		if not fchar then return end
		local torso = fchar:FindFirstChild('UpperTorso')
		local tih = tick()
		local ftick = tick()
		while tick() - tih < 4 and not fchar:FindFirstChild('GRABBING_CONSTRAINT') and torso and h do
			sethiddenproperty(h,'PhysicsRepRootPart',torso)
			h.CFrame = CFrame.new(torso.Position + Vector3.new(0,5,0))
			if tick() - ftick > 0.25 then
				m:FireServer('Grabbing',false)
				ftick = tick()
			end
			task.wait()
		end
		sethiddenproperty(h,'PhysicsRepRootPart',h)
		h.CFrame = o
	end,
	stomp = function(caller,plr)
		local self = safeChar(lp)
		local h = self:FindFirstChild('HumanoidRootPart')
		local o = h.CFrame
		local fchar = forcefollow(plr,2,false,true)
		if not fchar then return end
		local torso = fchar:FindFirstChild('UpperTorso')
		local tih = tick()
		local ftick = tick()
		h.CFrame = CFrame.new(torso.Position + Vector3.new(0,2,6))
		while tick() - tih < 4 and torso and h do
			sethiddenproperty(h,'PhysicsRepRootPart',torso)
			h.Velocity = Vector3.zero
			h.CFrame = CFrame.new(torso.Position + Vector3.new(0,5,0))
			if tick() - ftick > 0.25 then
				m:FireServer('Stomp')
				ftick = tick()
			end
			task.wait()	
		end
		sethiddenproperty(h,'PhysicsRepRootPart',h)
		h.CFrame = o
	end
}
local old = false
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
	re = function()
		local self = safeChar(lp)
		self:FindFirstChildOfClass('Humanoid').Health = 1
		self:FindFirstChildOfClass('Humanoid').Health = 0
		lp.CharacterAppearanceLoaded:Wait()
		self = safeChar(lp)
		local shp = self:FindFirstChild('HumanoidRootPart')
		if shp and old then
			Vector3.new(0,10,0)
			shp.CFrame = old
		end	
	end,
	to = function(_,p)
		local plr = getp(p)
		if plr then
			local ch = safeChar(plr)
			local chp = ch:FindFirstChild('HumanoidRootPart')	
			local self = safeChar(lp)
			local shp = self:FindFirstChild('HumanoidRootPart')
			old = shp.CFrame
			if chp and shp then
				Vector3.new(0,10,0)
				shp.CFrame = chp.CFrame
			end
		end
	end,
	back = function()
		local self = safeChar(lp)
		local shp = self:FindFirstChild('HumanoidRootPart')
		if shp and old then
			Vector3.new(0,10,0)
			shp.CFrame = old
		end	
	end,
	knock = function(_,p)
		cmdController.Commands.knock(lp,p)
	end,
	bring = function(_,p)
		cmdController.Commands.bring(lp,p)
	end,
	stomp = function(_,p)
		cmdController.Commands.stomp(lp,p)
	end,
	fling = function(_,p)
		cmdController.Commands.fling(lp,p)
	end,
	sky = function(_,p)
		cmdController.Commands.sky(lp,p)
	end,
	['prefix'] = function(_,p)
		prefix = p
	end,
	stop = function()
		if mg then
			mg:Disconnect()
		end
		if tcon then
			tcon:Disconnect()
		end
		if selfg then
			selfg:Disconnect()
		end
	end,
	select = function(_,plr)
		if tcon then
			tcon:Disconnect()
		end
		local plrf = getp(plr)
		if plrf then
			tcon = cmdController:Hook(plrf)
		end
	end,
}
local lp = game.Players.LocalPlayer
local cg = nil

local function connectKO(s, bf)
	local val = bf:FindFirstChild('K.O')
	if not val then return end

	if mg then mg:Disconnect() end
	mg = val.Changed:Connect(function()
		if val.Value then
			cmdController.lCommands.re() -- Define this if missing
			mg:Disconnect()
		end
	end)
end

local s = safeChar(lp)
local bf = s:FindFirstChild('BodyEffects')
if bf then connectKO(s, bf) end

s:FindFirstChildOfClass('Humanoid').Died:Connect(function()
	cg = s.HumanoidRootPart.CFrame
end)

lp.CharacterAppearanceLoaded:Connect(function(newChar)
	s = safeChar(lp)
	s:PivotTo(cg or CFrame.new()) -- Default if no cg

	bf = s:FindFirstChild('BodyEffects')
	if bf then
		connectKO(s, bf)
		for i = 1, 10 do -- Clean loop
			task.wait(0.2)
			if s.Parent then s:PivotTo(cg) end
		end
	end
end)

function cmdController:Hook(plr)
	local cmdTable = cmdController.Commands
	if plr == lp then
		cmdTable = cmdController.lCommands
	else
		targ = plr
	end
	return plr.Chatted:Connect(function(msg)
		local split = msg:split(' ')
		if split[1]:sub(0,#prefix) == prefix then
			local stringp = split[1]:sub(#prefix+1)
			local cmd = cmdTable[stringp]
			if cmd then
				table.remove(split,1)
				if plr ~= lp then
					noti('SELECTOR',plr.Name..' used '.. stringp)
				end
				task.spawn(function()
					cmd(plr,table.unpack(split))
				end)
			end
		end
	end)
end
if targ then
	tcon = cmdController:Hook(targ)
end
selfg = cmdController:Hook(lp)
