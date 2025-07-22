LOADING.Name = "LOADING"
LOADING.Parent = MAIN
LOADING.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
LOADING.BackgroundTransparency = 1.000
LOADING.Position = UDim2.new(0.378, 0,0.43, 0)
LOADING.Size = UDim2.new(0, 169, 0, 44)
LOADING.Font = Enum.Font.SourceSansItalic
LOADING.Text = "加载中…"
LOADING.TextColor3 = Color3.fromRGB(0, 0, 255)
LOADING.TextSize = 20.000
LOADING.TextWrapped = true
wait(1)
LOADING.Text = "获取数据..."
BAR:TweenSize(UDim2.new(0, 150,0, 15), Enum.EasingDirection.Out, Enum.EasingStyle.Quart, .3, true)
wait(1)
LOADING.Text = "你好 " ..game.Players.LocalPlayer.DisplayName.. " ，来自: ".. code
BAR:TweenSize(UDim2.new(0, 200,0, 15), Enum.EasingDirection.Out, Enum.EasingStyle.Quart, .3, true)
wait(1)
LOADING.Text = "检查游戏..."
BAR:TweenSize(UDim2.new(0, 250,0, 15), Enum.EasingDirection.Out, Enum.EasingStyle.Quart, .3, true)
wait(1)
LOADING.Text = "欢迎使用名脚本"
BAR:TweenSize(UDim2.new(0, 260,0, 15), Enum.EasingDirection.Out, Enum.EasingStyle.Quart, .3, true)
wait(1)
LOADING.Text = "谢谢使用"
BAR:TweenSize(UDim2.new(0, 285,0, 15), Enum.EasingDirection.Out, Enum.EasingStyle.Quart, .3, true)
wait(1)
MAIN:TweenSize(UDim2.new(0,0,0,5),"Out","Quad",1,true)
LOGO:Destroy()
TITLE:Destroy()
LOADING:Destroy()
BAR:Destroy()
wait(1)
MAIN:Destroy()
wait(1)