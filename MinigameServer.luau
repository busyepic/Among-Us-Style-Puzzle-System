local db
local canClick = false

local numList = {"1","2","3","4","5","6","7","8","9"}
local order = {}
local num = 1

local currentOrder = 1

local tweenService = game:GetService("TweenService")

local goals = {Color = Color3.fromRGB(0, 115, 255)}

local goalsEnd = {Color = Color3.fromRGB(17,17,17)}



local clickgoals = {Color = Color3.fromRGB(255,255,255)}

local clickgoalsEnd = {Color = Color3.fromRGB(128, 128, 130)}

local redGoals = {Color = Color3.fromRGB(255, 0, 4)}

local greenGoals = {Color = Color3.fromRGB(4, 255, 0)}


local info = TweenInfo.new(1,Enum.EasingStyle.Quad, Enum.EasingDirection.InOut)

local fasterinfo = TweenInfo.new(0.5,Enum.EasingStyle.Quad, Enum.EasingDirection.InOut)



-- num will be the amount you have to do in total for this round
-- currentOrder will be whic order of buttons youre in
local function giveOrder(machine)
	local randNum = math.random(1,#numList)

	
	table.insert(order, numList[randNum])
	table.remove(numList,randNum)
	canClick = false
	for i=1,num,1 do
		

		print(order)
		local buttons = machine.Parent.ButtonIcons
		local currentButton = buttons:FindFirstChild(order[i])
		
		local tweenIn = tweenService:Create(currentButton,info,goals)
		currentButton.Material = Enum.Material.Neon
		tweenIn:Play()
		
		wait(2)
		


		local tweenOut = tweenService:Create(currentButton,info,goalsEnd)

		tweenOut:Play()
		currentButton.Material = Enum.Material.SmoothPlastic
		
	end
	canClick = true
end

local function all(machine, goals, goalsEnd)
	for i,v in pairs(machine.Parent.ButtonIcons:GetChildren()) do
		v.Material = Enum.Material.Neon
		local tween = tweenService:Create(v, info, goals)
		
		tween:Play()
	end
	wait(1)
	for i,v in pairs(machine.Parent.ButtonIcons:GetChildren()) do
		v.Material = Enum.Material.SmoothPlastic
		local tween = tweenService:Create(v, info, goalsEnd)

		tween:Play()
	end
end
local toolStored = nil
game.ReplicatedStorage.Minigame.OnServerEvent:Connect(function(plr, indicator, machine, button)
	
	if indicator == "start" then
		print("stored")
		for i,v in pairs(plr.Character:GetChildren()) do
			if v:IsA("Tool") then
				v.Parent = plr.Backpack
				toolStored = v
			end
		end
		
		
		wait(1)
		canClick = false
		
		giveOrder(machine)
		
	elseif indicator == "click" and canClick == true then
		game.ReplicatedStorage:FindFirstChild(button):Play()
		local clickingButton = machine.Parent.Buttons:FindFirstChild(button)
		clickingButton.Material = Enum.Material.Neon
		local tween = tweenService:Create(clickingButton, fasterinfo, clickgoals)
		tween:Play()
		tween.Completed:Connect(function()
			tween = tweenService:Create(clickingButton, fasterinfo, clickgoalsEnd)
			tween:Play()
			clickingButton.Material = Enum.Material.SmoothPlastic
		end)
		
		if button == order[currentOrder] then
			if num == 5 and currentOrder == 5 then
				workspace.Generator.GeneratorsDone.Value += 1
				all(machine,greenGoals,greenGoals)
				plr:SetAttribute("Minigame", false)
				
				machine.ProximityPrompt:Destroy()
				machine.Highlight:Destroy()
				
				order = {}
				numList = {"1","2","3","4","5","6","7","8","9"}

				num = 1 
				currentOrder = 1
				wait(1)
				return
			end
		
			if currentOrder == #order then
				currentOrder = 1
				num += 1
				giveOrder(machine)
				
			else
				currentOrder += 1
			end
			
		else
			all(machine,redGoals,goalsEnd)
			wait(0.5)
			
			order = {}
			numList = {"1","2","3","4","5","6","7","8","9"}
			
			num = 1 
			currentOrder = 1
			
			giveOrder(machine)
			
			
		end
		
	elseif indicator == "end" then
		
		if toolStored ~= nil then
			plr.Character.Humanoid:EquipTool(toolStored)
			toolStored = nil
		end
		
		local current = order[currentOrder]
		
		
		currentOrder = 1
		num = 1
		local button = machine.Parent.ButtonIcons:FindFirstChild(current)
		
		button.Color = Color3.fromRGB(17,17,17)
		button.Material = Enum.Material.SmoothPlastic
		
		order = {}
		numList = {"1","2","3","4","5","6","7","8","9"}
		return
	end
end)

