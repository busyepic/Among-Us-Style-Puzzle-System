local plr = game.Players.LocalPlayer

repeat wait() until plr.Character


local machine2 = workspace:WaitForChild("Machine2")
for i,v in pairs(machine2.Buttons:GetChildren()) do
	if v:IsA("BasePart") then
		local clickDetector = Instance.new("ClickDetector", v)
		
		clickDetector.MouseClick:Connect(function()
			
			game.ReplicatedStorage.Minigame:FireServer("click",workspace.Machine2.Cube,clickDetector.Parent.Name)
		end)
	end

end