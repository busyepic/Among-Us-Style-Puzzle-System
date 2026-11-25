local plr = game.Players.LocalPlayer

repeat wait() until plr.Character


local machine1 = workspace:WaitForChild("Machine1")
for i,v in pairs(machine1.Buttons:GetChildren()) do
	if v:IsA("BasePart") then
	
		local clickDetector = Instance.new("ClickDetector", v)
		
		clickDetector.MouseClick:Connect(function()
			
			game.ReplicatedStorage.Minigame:FireServer("click",workspace.Machine1.Cube,clickDetector.Parent.Name)
		end)
	end

end