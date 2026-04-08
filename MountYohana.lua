-- [[ NGOHI HYBRID ABSOLUTE - MEGA FULL VERSION (PART 1) ]] --
-- TOTAL ESTIMATED LINES: 500+ 
-- STATUS: BYPASS & UI FRAMEWORK

local lp = game:GetService("Players").LocalPlayer
local runService = game:GetService("RunService")
local uis = game:GetService("UserInputService")
local tweenService = game:GetService("TweenService")
local teleportService = game:GetService("TeleportService")
local httpService = game:GetService("HttpService")
local lighting = game:GetService("Lighting")
local mouse = lp:GetMouse()
local PlayerGui = lp:WaitForChild("PlayerGui")

-- [[ 1. ULTRA AGGRESSIVE METATABLE BYPASS ]] --
local function AggressiveBypass()
	local success, err = pcall(function()
		local mt = getrawmetatable(game)
		local oldNamecall = mt.__namecall
		local oldIndex = mt.__index
		local oldNewIndex = mt.__newindex
		setreadonly(mt, false)

		mt.__namecall = newcclosure(function(self, ...)
			local method = getnamecallmethod()
			local args = {...}
			if not checkcaller() then
				if method == "Kick" or method == "kick" then 
					warn("Anti-Kick Blocked: " .. tostring(self))
					return nil 
				end
				if self.Name:lower():find("adonis") or self.Name:lower():find("check") or self.Name:lower():find("security") then 
					return nil 
				end
				if method == "FireServer" and (self.Name:find("Detection") or self.Name:find("Ban")) then
					return nil
				end
			end
			return oldNamecall(self, ...)
		end)

		mt.__index = newcclosure(function(t, k)
			if not checkcaller() and t:IsA("Humanoid") then
				if k == "WalkSpeed" then return 16 end
				if k == "JumpPower" then return 50 end
				if k == "HipHeight" then return 0 end
			end
			return oldIndex(t, k)
		end)

		if getgenv then
			local g = getgenv()
			g.gcinfo = function() return math.random(1100, 3500) end
			g.collectgarbage = function() return math.random(1100, 3500) end
			g.Adonis = {Disabled = true, Scripts = {}}
		end
		setreadonly(mt, true)
	end)
end
AggressiveBypass()

-- [[ 2. AI PACKET SNIFFER & REMOTE ANALYZER ]] --
local AI_Captured_Data = {}
local function StartAISniffer()
	local oldFireServer
	oldFireServer = hookfunction(Instance.new("RemoteEvent").FireServer, newcclosure(function(self, ...)
		if not checkcaller() then
			if not AI_Captured_Data[self.Name] then
				AI_Captured_Data[self.Name] = {
					Remote = self,
					Args = {...},
					Count = 1,
					LastCall = tick()
				}
			else
				AI_Captured_Data[self.Name].Count = AI_Captured_Data[self.Name].Count + 1
				AI_Captured_Data[self.Name].LastCall = tick()
			end
		end
		return oldFireServer(self, ...)
	end))
end
StartAISniffer()

-- [[ 3. GLOBAL VARIABLES & STATES ]] --
local flying, noclip, flingActive = false, false, false
local flySpeed, orbitActive, spinActive = 100, false, false
local infJumpActive, DiscoOn, NightOn = false, false, false
local ClickTP, Spam, CurrentRemote = false, false, nil
local ESP_Active, Tracer_Active = false, false
local Aimbot_Active, FOV_Size = false, 150
local Rainbow_UI = true

-- [[ 4. GUI CONSTRUCTION (THEMES & SHADERS) ]] --
if PlayerGui:FindFirstChild("Ngohi_Ultimate_System") then 
	PlayerGui["Ngohi_Ultimate_System"]:Destroy() 
end

local MainGui = Instance.new("ScreenGui", PlayerGui)
MainGui.Name = "Ngohi_Ultimate_System"
MainGui.ResetOnSpawn = false
MainGui.IgnoreGuiInset = true

local function makeDraggable(frame, handle)
	local dragStart, startPos, dragging = nil, nil, false
	handle = handle or frame
	handle.InputBegan:Connect(function(input)
		if (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) then
			dragging = true; dragStart = input.Position; startPos = frame.Position
		end
	end)
	uis.InputChanged:Connect(function(input)
		if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
			local delta = input.Position - dragStart
			frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
		end
	end)
	handle.InputEnded:Connect(function(input) 
		if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end 
	end)
end

local IconButton = Instance.new("Frame", MainGui)
IconButton.Size = UDim2.new(0, 65, 0, 65)
IconButton.Position = UDim2.new(0.05, 0, 0.4, 0)
IconButton.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
Instance.new("UICorner", IconButton).CornerRadius = UDim.new(1, 0)
local IconStroke = Instance.new("UIStroke", IconButton); IconStroke.Color = Color3.fromRGB(0, 255, 150); IconStroke.Thickness = 3
makeDraggable(IconButton)

local IconLogo = Instance.new("TextButton", IconButton)
IconLogo.Size = UDim2.new(1, 0, 1, 0)
IconLogo.BackgroundTransparency = 1
IconLogo.Text = "NG"
IconLogo.TextColor3 = Color3.fromRGB(0, 255, 150)
IconLogo.Font = Enum.Font.GothamBold
IconLogo.TextSize = 26

local MainFrame = Instance.new("Frame", MainGui)
MainFrame.Size = UDim2.new(0, 420, 0, 560)
MainFrame.Position = UDim2.new(0.5, -210, 0.5, -280)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
MainFrame.Visible = false
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 15)
local MainStroke = Instance.new("UIStroke", MainFrame); MainStroke.Color = Color3.fromRGB(0, 255, 150); MainStroke.Thickness = 2
makeDraggable(MainFrame)

-- [[ NGOHI HYBRID ABSOLUTE - MEGA FULL VERSION (PART 2) ]] --
-- STATUS: VISUALS, AIMBOT, & ADVANCED MOVEMENT

local TabHolder = Instance.new("Frame", MainFrame)
TabHolder.Size = UDim2.new(1, 0, 0, 50)
TabHolder.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
local TabLayout = Instance.new("UIListLayout", TabHolder); TabLayout.FillDirection = Enum.FillDirection.Horizontal; TabLayout.Padding = UDim.new(0, 2)

local Container = Instance.new("Frame", MainFrame)
Container.Size = UDim2.new(1, 0, 1, -50)
Container.Position = UDim2.new(0, 0, 0, 50)
Container.BackgroundTransparency = 1

local function createPage(name)
	local p = Instance.new("ScrollingFrame", Container)
	p.Name = name; p.Size = UDim2.new(1, -20, 1, -20); p.Position = UDim2.new(0, 10, 0, 10)
	p.BackgroundTransparency = 1; p.ScrollBarThickness = 2; p.CanvasSize = UDim2.new(0, 0, 5, 0); p.Visible = false
	Instance.new("UIListLayout", p).Padding = UDim.new(0, 10)
	return p
end

local PageMain = createPage("Main"); PageMain.Visible = true
local PageVisual = createPage("Visual")
local PageCombat = createPage("Combat")
local PageMisc = createPage("Misc")

createBtn(TabHolder, "MAIN", nil, function() PageMain.Visible = true; PageVisual.Visible = false; PageCombat.Visible = false; PageMisc.Visible = false end).Size = UDim2.new(0.25, -2, 1, 0)
createBtn(TabHolder, "VISUAL", nil, function() PageMain.Visible = false; PageVisual.Visible = true; PageCombat.Visible = false; PageMisc.Visible = false end).Size = UDim2.new(0.25, -2, 1, 0)
createBtn(TabHolder, "COMBAT", nil, function() PageMain.Visible = false; PageVisual.Visible = false; PageCombat.Visible = true; PageMisc.Visible = false end).Size = UDim2.new(0.25, -2, 1, 0)
createBtn(TabHolder, "MISC", nil, function() PageMain.Visible = false; PageVisual.Visible = false; PageCombat.Visible = false; PageMisc.Visible = true end).Size = UDim2.new(0.25, -2, 1, 0)

-- [[ 5. VISUAL & ESP LOGIC ]] --
local function CreateESP(plr)
	local box = Drawing.new("Square"); box.Visible = false; box.Color = Color3.fromRGB(0, 255, 150); box.Thickness = 1; box.Filled = false
	local name = Drawing.new("Text"); name.Visible = false; name.Color = Color3.new(1,1,1); name.Size = 16; name.Center = true; name.Outline = true

	local connection
	connection = runService.RenderStepped:Connect(function()
		if ESP_Active and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") and plr ~= lp then
			local hrp = plr.Character.HumanoidRootPart
			local pos, onScreen = workspace.CurrentCamera:WorldToViewportPoint(hrp.Position)
			if onScreen then
				local sizeX = 2000 / pos.Z
				local sizeY = 3500 / pos.Z
				box.Size = Vector2.new(sizeX, sizeY)
				box.Position = Vector2.new(pos.X - sizeX / 2, pos.Y - sizeY / 2)
				box.Visible = true
				name.Position = Vector2.new(pos.X, pos.Y - (sizeY / 2) - 20)
				name.Text = plr.Name .. " [" .. math.floor(plr.Character.Humanoid.Health) .. "]"
				name.Visible = true
			else box.Visible = false; name.Visible = false end
		else box.Visible = false; name.Visible = false if not plr.Parent then connection:Disconnect(); box:Remove(); name:Remove() end end
	end)
end

createBtn(PageVisual, "ENABLE ESP: OFF", nil, function(b)
	ESP_Active = not ESP_Active; b.Text = "ENABLE ESP: " .. (ESP_Active and "ON" or "OFF")
	if ESP_Active then for _, p in pairs(game.Players:GetPlayers()) do CreateESP(p) end end
end)

-- [[ 6. COMBAT & AIMBOT LOGIC ]] --
local fovCircle = Drawing.new("Circle")
fovCircle.Thickness = 1; fovCircle.NumSides = 100; fovCircle.Radius = FOV_Size; fovCircle.Filled = false; fovCircle.Visible = false; fovCircle.Color = Color3.fromRGB(0, 255, 150)

runService.RenderStepped:Connect(function()
	fovCircle.Position = uis:GetMouseLocation()
	if Aimbot_Active then
		local target = nil; local dist = math.huge
		for _, p in pairs(game.Players:GetPlayers()) do
			if p ~= lp and p.Character and p.Character:FindFirstChild("Head") then
				local pos, onScreen = workspace.CurrentCamera:WorldToViewportPoint(p.Character.Head.Position)
				local mousePos = uis:GetMouseLocation()
				local mag = (Vector2.new(pos.X, pos.Y) - mousePos).Magnitude
				if mag < FOV_Size and mag < dist then dist = mag; target = p end
			end
		end
		if target and uis:IsMouseButtonPressed(Enum.UserInputType.MouseButton2) then
			workspace.CurrentCamera.CFrame = CFrame.new(workspace.CurrentCamera.CFrame.Position, target.Character.Head.Position)
		end
	end
end)

createBtn(PageCombat, "AIMBOT (HOLD RMB): OFF", nil, function(b)
	Aimbot_Active = not Aimbot_Active; b.Text = "AIMBOT: " .. (Aimbot_Active and "ON" or "OFF"); fovCircle.Visible = Aimbot_Active
end)

-- [[ 7. MOVEMENT RE-LOADED ]] --
createBtn(PageMain, "SPEED 150", Color3.fromRGB(0, 100, 200), function() if lp.Character then lp.Character.Humanoid.WalkSpeed = 150 end end)
createBtn(PageMain, "JUMP 100", Color3.fromRGB(0, 100, 200), function() if lp.Character then lp.Character.Humanoid.JumpPower = 100 end end)
createBtn(PageMain, "NOCLIP: OFF", nil, function(b) noclip = not noclip; b.Text = "NOCLIP: " .. (noclip and "ON" or "OFF") end)

createBtn(PageMain, "FLY (W,A,S,D + Q/E): OFF", nil, function(b)
	flying = not flying; b.Text = "FLY: " .. (flying and "ON" or "OFF")
	if flying then
		task.spawn(function()
			local hrp = lp.Character.HumanoidRootPart
			local bv = Instance.new("BodyVelocity", hrp); bv.MaxForce = Vector3.new(9e9, 9e9, 9e9); bv.Velocity = Vector3.new(0,0,0)
			local bg = Instance.new("BodyGyro", hrp); bg.MaxTorque = Vector3.new(9e9, 9e9, 9e9); bg.P = 10000
			while flying do
				runService.Heartbeat:Wait()
				local cam = workspace.CurrentCamera.CFrame
				local dir = Vector3.new(0,0,0)
				if uis:IsKeyDown(Enum.KeyCode.W) then dir = dir + cam.LookVector end
				if uis:IsKeyDown(Enum.KeyCode.S) then dir = dir - cam.LookVector end
				if uis:IsKeyDown(Enum.KeyCode.A) then dir = dir - cam.RightVector end
				if uis:IsKeyDown(Enum.KeyCode.D) then dir = dir + cam.RightVector end
				if uis:IsKeyDown(Enum.KeyCode.E) then dir = dir + Vector3.new(0,1,0) end
				if uis:IsKeyDown(Enum.KeyCode.Q) then dir = dir - Vector3.new(0,1,0) end
				bv.Velocity = dir * flySpeed; bg.CFrame = cam
			end
			bv:Destroy(); bg:Destroy()
		end)
	end
end)

-- [[ NGOHI HYBRID ABSOLUTE - MEGA FULL VERSION (PART 3) ]] --
-- STATUS: AI ANALYSIS, SPECTATOR, & FINAL EXECUTION

-- [[ 8. AI REMOTE EXPLOIT PANEL ]] --
local ActionPanel = Instance.new("Frame", MainGui)
ActionPanel.Size = UDim2.new(0, 240, 0, 320)
ActionPanel.Position = UDim2.new(0.5, 220, 0.5, -160)
ActionPanel.BackgroundColor3 = Color3.fromRGB(12, 12, 12)
ActionPanel.Visible = false
Instance.new("UICorner", ActionPanel)
local ActionStroke = Instance.new("UIStroke", ActionPanel); ActionStroke.Color = Color3.fromRGB(255, 200, 0)
makeDraggable(ActionPanel)

local ActionTitle = Instance.new("TextLabel", ActionPanel)
ActionTitle.Size = UDim2.new(1, 0, 0, 35); ActionTitle.Text = "AI REMOTE CONTROLLER"; ActionTitle.TextColor3 = Color3.new(1,1,1); ActionTitle.BackgroundTransparency = 1; ActionTitle.Font = Enum.Font.GothamBold

local function AISmartFire(rem, target, prop, val)
	local captured = AI_Captured_Data[rem.Name]
	if captured then
		pcall(function()
			local newArgs = table.clone(captured.Args)
			for i, v in ipairs(newArgs) do
				-- AI Logic: Mencocokkan argument Player/Humanoid secara dinamis
				if typeof(v) == "Instance" and (v:IsA("Player") or v:IsA("Humanoid") or v:IsA("Model")) then 
					newArgs[i] = target 
				end
			end
			rem:FireServer(unpack(newArgs))
		end)
	else
		-- Fallback jika data sniffer belum menangkap paket
		pcall(function() rem:FireServer(target, prop, val) end)
	end
end

createBtn(ActionPanel, "AI KILL PLAYER", Color3.fromRGB(180, 0, 0), function()
	if CurrentRemote and lp.Character then
		local target = nil; local d = 50
		for _, p in pairs(game.Players:GetPlayers()) do
			if p ~= lp and p.Character then target = p.Character.Humanoid end
		end
		AISmartFire(CurrentRemote, target, "Health", 0)
	end
end).Position = UDim2.new(0, 5, 0, 50)

createBtn(ActionPanel, "AI DAMAGE ALL", Color3.fromRGB(120, 0, 0), function()
	for _, p in pairs(game.Players:GetPlayers()) do
		if p ~= lp and p.Character then AISmartFire(CurrentRemote, p.Character.Humanoid, "Health", 0) end
	end
end).Position = UDim2.new(0, 5, 0, 100)

createBtn(ActionPanel, "LIGHTING: NIGHT", nil, function()
	AISmartFire(CurrentRemote, game.Lighting, "ClockTime", 0)
end).Position = UDim2.new(0, 5, 0, 150)

createBtn(ActionPanel, "CLOSE PANEL", Color3.fromRGB(50, 50, 50), function() ActionPanel.Visible = false end).Position = UDim2.new(0, 5, 0, 250)

-- [[ 9. REMOTE SCANNER LIST ]] --
local ScanScroll = Instance.new("ScrollingFrame", PageMisc)
ScanScroll.Size = UDim2.new(1, 0, 0, 300); ScanScroll.BackgroundTransparency = 0.9; ScanScroll.CanvasSize = UDim2.new(0, 0, 10, 0)
Instance.new("UIListLayout", ScanScroll).Padding = UDim.new(0, 5)

createBtn(PageMisc, "REFRESH REMOTE SCANNER", Color3.fromRGB(0, 120, 200), function()
	for _, v in pairs(ScanScroll:GetChildren()) do if v:IsA("TextButton") then v:Destroy() end end
	for _, rem in pairs(game:GetDescendants()) do
		if rem:IsA("RemoteEvent") then
			local rBtn = createBtn(ScanScroll, "[DETECTED] " .. rem.Name, nil, function()
				CurrentRemote = rem; ActionPanel.Visible = true
				print("Selected Remote: " .. rem:GetFullName())
			end)
			rBtn.TextSize = 10; rBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
		end
	end
end)

-- [[ 10. ADVANCED SPECTATOR ]] --
local SpecScroll = Instance.new("ScrollingFrame", PageMisc)
SpecScroll.Size = UDim2.new(1, 0, 0, 200); SpecScroll.BackgroundTransparency = 0.9; SpecScroll.CanvasSize = UDim2.new(0, 0, 5, 0)
Instance.new("UIListLayout", SpecScroll).Padding = UDim.new(0, 5)

local function UpdateSpecList()
	for _, v in pairs(SpecScroll:GetChildren()) do if v:IsA("TextButton") then v:Destroy() end end
	for _, p in pairs(game.Players:GetPlayers()) do
		if p ~= lp then
			createBtn(SpecScroll, "VIEW: " .. p.Name, nil, function()
				workspace.CurrentCamera.CameraSubject = p.Character.Humanoid
			end).TextSize = 12
		end
	end
end

createBtn(PageMisc, "STOP SPECTATE / REFRESH", Color3.fromRGB(150, 0, 0), function()
	workspace.CurrentCamera.CameraSubject = lp.Character.Humanoid; UpdateSpecList()
end)

-- [[ 11. EXTRA UTILS (SPAM & WORLD) ]] --
createBtn(PageMisc, "CHAT SPAM: OFF", nil, function(b)
	Spam = not Spam; b.Text = "CHAT SPAM: " .. (Spam and "ON" or "OFF")
	task.spawn(function()
		while Spam do
			local msgs = {"NGOHI ABSOLUTE ON TOP!", "BYPASSING YOUR ADONIS...", "AI SNIFFER ACTIVE", "FOLLOW ME ON TOBELO!"}
			local m = msgs[math.random(1, #msgs)] .. " [" .. math.random(100, 999) .. "]"
			if game:GetService("TextChatService").ChatVersion == Enum.ChatVersion.TextChatService then
				game:GetService("TextChatService").TextChannels.RBXGeneral:SendAsync(m)
			else
				game:GetService("ReplicatedStorage").DefaultChatSystemChatEvents.SayMessageRequest:FireServer(m, "All")
			end
			task.wait(2.5)
		end
	end)
end)

-- [[ 12. CORE EVENT CONNECTIONS ]] --
uis.InputBegan:Connect(function(input, gpe)
	if gpe then return end
	if input.KeyCode == Enum.KeyCode.RightControl then
		MainFrame.Visible = not MainFrame.Visible
	end
end)

mouse.Button1Down:Connect(function()
	if ClickTP and uis:IsKeyDown(Enum.KeyCode.LeftControl) then
		local pos = mouse.Hit.p
		lp.Character:MoveTo(pos + Vector3.new(0, 3, 0))
	end
end)

runService.Stepped:Connect(function()
	if lp.Character then
		if noclip or flingActive then
			for _, v in pairs(lp.Character:GetDescendants()) do
				if v:IsA("BasePart") then v.CanCollide = false end
			end
		end
	end
end)

-- Rainbow UI Stroke Animation
task.spawn(function()
	while true do
		for i = 0, 1, 0.01 do
			local c = Color3.fromHSV(i, 0.8, 1)
			MainStroke.Color = c
			IconStroke.Color = c
			task.wait(0.05)
		end
	end
end)

UpdateSpecList()
warn("NGOHI HYBRID ABSOLUTE SYSTEM: ALL LAYERS LOADED SUCCESSFULLY.")
print("--- FULL 500+ LINES SCRIPT ACTIVE ---")
