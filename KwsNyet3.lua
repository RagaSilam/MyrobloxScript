-- [[ DELTA V8 ULTIMATE - STABLE & BYPASS EDITION ]] --
local lp = game:GetService("Players").LocalPlayer
local runService = game:GetService("RunService")
local uis = game:GetService("UserInputService")
local mouse = lp:GetMouse()
local PlayerGui = lp:WaitForChild("PlayerGui")

-- [[ STATES ]] --
local flying, noclip, flingActive, flySpeed = false, false, false, 100
local infJumpActive, orbitActive = false, false
local orbitParts = {}

-- Cleanup UI Lama
if PlayerGui:FindFirstChild("DeltaV8_Ultimate") then PlayerGui["DeltaV8_Ultimate"]:Destroy() end

-- [[ GUI SYSTEM ]] --
local ScreenGui = Instance.new("ScreenGui", PlayerGui)
ScreenGui.Name = "DeltaV8_Ultimate"
ScreenGui.ResetOnSpawn = false

local function makeDraggable(frame, handle)
	local dragStart, startPos, dragging
	handle.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = true; dragStart = input.Position; startPos = frame.Position
		end
	end)
	uis.InputChanged:Connect(function(input)
		if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
			local delta = input.Position - dragStart
			frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
		end
	end)
	uis.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then dragging = false end
	end)
end

local IconButton = Instance.new("Frame", ScreenGui)
IconButton.Size = UDim2.new(0, 60, 0, 60); IconButton.Position = UDim2.new(0.05, 0, 0.4, 0)
IconButton.BackgroundColor3 = Color3.fromRGB(15, 15, 15); IconButton.Active = true
Instance.new("UICorner", IconButton).CornerRadius = UDim.new(1, 0)
Instance.new("UIStroke", IconButton).Color = Color3.fromRGB(0, 255, 150)
makeDraggable(IconButton, IconButton)

local IconLogo = Instance.new("TextButton", IconButton)
IconLogo.Size = UDim2.new(1, 0, 1, 0); IconLogo.BackgroundTransparency = 1; IconLogo.Text = "W"
IconLogo.TextColor3 = Color3.fromRGB(0, 255, 150); IconLogo.Font = Enum.Font.GothamBold; IconLogo.TextSize = 25

local Main = Instance.new("Frame", ScreenGui)
Main.Size = UDim2.new(0, 260, 0, 420); Main.Position = UDim2.new(0.5, -130, 0.5, -210)
Main.BackgroundColor3 = Color3.fromRGB(10, 10, 10); Main.Visible = false
Instance.new("UICorner", Main); Instance.new("UIStroke", Main).Color = Color3.fromRGB(0, 255, 150)
makeDraggable(Main, Main)

IconLogo.MouseButton1Click:Connect(function() Main.Visible = not Main.Visible end)

local Container = Instance.new("ScrollingFrame", Main)
Container.Size = UDim2.new(1, -10, 1, -20); Container.Position = UDim2.new(0, 5, 0, 10)
Container.BackgroundTransparency = 1; Container.CanvasSize = UDim2.new(0, 0, 1.8, 0)
Instance.new("UIListLayout", Container).Padding = UDim.new(0, 6)

local function createBtn(txt, func)
	local b = Instance.new("TextButton", Container)
	b.Size = UDim2.new(1, -5, 0, 35); b.Text = txt
	b.BackgroundColor3 = Color3.fromRGB(35, 35, 35); b.TextColor3 = Color3.new(1, 1, 1)
	b.Font = Enum.Font.SourceSansBold; Instance.new("UICorner", b)
	b.MouseButton1Click:Connect(function() func(b) end)
	return b
end

-- [[ FITUR UTAMA ]] --

createBtn("FLY (SPACE=UP / Q=DOWN)", function(b)
	flying = not flying
	b.BackgroundColor3 = flying and Color3.fromRGB(0, 120, 255) or Color3.fromRGB(35, 35, 35)

	if flying then
		task.spawn(function()
			local char = lp.Character
			if not char then return end
			local hrp = char:WaitForChild("HumanoidRootPart")
			local hum = char:WaitForChild("Humanoid")
			hum.PlatformStand = true
			local bg = Instance.new("BodyGyro", hrp); bg.P = 9e4; bg.MaxTorque = Vector3.new(9e9, 9e9, 9e9); bg.CFrame = hrp.CFrame
			local bv = Instance.new("BodyVelocity", hrp); bv.Velocity = Vector3.new(0, 0, 0); bv.MaxForce = Vector3.new(9e9, 9e9, 9e9)

			while flying and char.Parent do
				runService.Heartbeat:Wait()
				local cam = workspace.CurrentCamera.CFrame
				local dir = Vector3.new(0, 0, 0)
				if uis:IsKeyDown(Enum.KeyCode.W) then dir = dir + cam.LookVector end
				if uis:IsKeyDown(Enum.KeyCode.S) then dir = dir - cam.LookVector end
				if uis:IsKeyDown(Enum.KeyCode.A) then dir = dir - cam.RightVector end
				if uis:IsKeyDown(Enum.KeyCode.D) then dir = dir + cam.RightVector end
				if uis:IsKeyDown(Enum.KeyCode.Space) then dir = dir + Vector3.new(0, 1, 0) end
				if uis:IsKeyDown(Enum.KeyCode.Q) then dir = dir - Vector3.new(0, 1, 0) end
				bv.Velocity = dir * flySpeed; bg.CFrame = cam
			end
			bg:Destroy(); bv:Destroy(); hum.PlatformStand = false
		end)
	end
end)

-- FITUR STABLE TOUCH FLING FIX --
createBtn("STABLE TOUCH FLING", function(b)
	if not firetouchinterest then 
		b.Text = "BUTUH EXECUTOR (DELTA)!"; task.wait(1); b.Text = "STABLE TOUCH FLING"
		return 
	end

	local function GetClosest()
		local t, d = nil, 100
		for _, v in pairs(game.Players:GetPlayers()) do
			if v ~= lp and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
				local dist = (lp.Character.HumanoidRootPart.Position - v.Character.HumanoidRootPart.Position).Magnitude
				if dist < d then d = dist; t = v end
			end
		end
		return t
	end

	local target = GetClosest()
	if target and not flingActive then
		flingActive = true
		b.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
		local hrp = lp.Character.HumanoidRootPart
		local oldPos = hrp.CFrame

		-- Anti-Recoil: Set Massless
		for _, v in pairs(lp.Character:GetDescendants()) do
			if v:IsA("BasePart") then v.Massless = true v.Velocity = Vector3.new(0,0,0) end
		end

		-- Paku Bumi (Anchor)
		local anchorV = Instance.new("BodyVelocity", hrp)
		anchorV.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
		anchorV.Velocity = Vector3.new(0, 0, 0)

		local anchorG = Instance.new("BodyGyro", hrp)
		anchorG.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
		anchorG.CFrame = hrp.CFrame

		task.spawn(function()
			local start = tick()
			while tick() - start < 1.5 do
				runService.Heartbeat:Wait()
				if target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
					local tHRP = target.Character.HumanoidRootPart

					-- Posisi mengambang dikit biar gak kejepit lantai
					hrp.CFrame = tHRP.CFrame * CFrame.new(0, 0.5, 0) * CFrame.Angles(0, math.rad(tick()*5000 % 360), 0)
					hrp.RotVelocity = Vector3.new(0, 35000, 0)

					for i = 1, 50 do
						firetouchinterest(hrp, tHRP, 0)
						firetouchinterest(hrp, tHRP, 1)
					end
				end
			end

			-- Cleanup
			anchorV:Destroy(); anchorG:Destroy()
			flingActive = false
			hrp.RotVelocity = Vector3.new(0,0,0); hrp.Velocity = Vector3.new(0,0,0)
			hrp.CFrame = oldPos
			for _, v in pairs(lp.Character:GetDescendants()) do
				if v:IsA("BasePart") then v.Massless = false end
			end
			b.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
		end)
	end
end)

createBtn("ORBIT SHIELD", function(b)
	orbitActive = not orbitActive
	b.BackgroundColor3 = orbitActive and Color3.fromRGB(0, 255, 200) or Color3.fromRGB(35, 35, 35)
	if orbitActive then
		for i = 1, 3 do
			local p = Instance.new("Part", lp.Character); p.Size = Vector3.new(0.6, 0.6, 0.6); p.CanCollide = false
			p.Material = Enum.Material.Neon; p.Color = Color3.fromHSV(i/3, 1, 1); table.insert(orbitParts, p)
		end
		task.spawn(function()
			local a = 0
			while orbitActive do
				runService.Heartbeat:Wait(); a = a + 0.1
				for i, p in pairs(orbitParts) do
					if lp.Character and lp.Character:FindFirstChild("HumanoidRootPart") then
						p.CFrame = lp.Character.HumanoidRootPart.CFrame * CFrame.new(math.cos(a + (i*2)) * 6, 0, math.sin(a + (i*2)) * 6)
					end
				end
			end
			for _, v in pairs(orbitParts) do v:Destroy() end
			orbitParts = {}
		end)
	end
end)

createBtn("NOCLIP", function(b)
	noclip = not noclip
	b.BackgroundColor3 = noclip and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(35, 35, 35)
end)

createBtn("INF JUMP", function(b)
	infJumpActive = not infJumpActive
	b.BackgroundColor3 = infJumpActive and Color3.fromRGB(255, 200, 0) or Color3.fromRGB(35, 35, 35)
end)

createBtn("DESTROY GUI", function() ScreenGui:Destroy() end)

-- [[ LOOPS ]] --
runService.Stepped:Connect(function()
	if lp.Character then
		for _, v in pairs(lp.Character:GetDescendants()) do
			if v:IsA("BasePart") then v.CanCollide = not (noclip or flingActive) end
		end
	end
end)

uis.JumpRequest:Connect(function()
	if infJumpActive and lp.Character:FindFirstChild("Humanoid") then lp.Character.Humanoid:ChangeState("Jumping") end
end)

print("DELTA V8 ULTIMATE - FULLY LOADED")
