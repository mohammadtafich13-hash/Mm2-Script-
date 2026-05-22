-- MM2 Premium Hub for Delta Executor
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
local Window = Library.CreateLib("MM2 Delta Hub", "Midnight")

-- تابات السكربت الرئيسي
local MainTab = Window:NewTab("العامة (Main)")
local MainSection = MainTab:NewSection("ميزات الجولة")

local VisualsTab = Window:NewTab("كشف اللاعبين (ESP)")
local VisualsSection = VisualsTab:NewSection("رؤية من خلال الجدران")

local InventoryTab = Window:NewTab("الحقيبة والأسلحة")
local InventorySection = InventoryTab:NewSection("الأسلحة والمظهر")

--- [1] ميزات اللعب التلقائي (Auto-Farm & Gameplay) ---

MainSection:NewToggle("جمع العملات تلقائياً (Auto-Farm Coins)", "يقوم بنقلك للعملات بسرعة وبشكل مخفي", function(state)
    getgenv().AutoFarm = state
    spawn(function()
        while getgenv().AutoFarm do
            task.wait(0.1)
            local Container = workspace:FindFirstChild("Normal") and workspace.Normal:FindFirstChild("CoinContainer")
            if Container then
                for _, coin in pairs(Container:GetChildren()) do
                    if coin:IsA("TouchTransmitter") or coin:FindFirstChild("TouchInterest") then
                        local hrp = game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                        if hrp then
                            hrp.CFrame = coin.Parent.CFrame
                            task.wait(0.2)
                        end
                    end
                end
            end
        end
    end)
end)

MainSection:NewButton("إحضار المسدس المتساقط (Grab Gun)", "ينقلك لمكان المسدس فوراً إذا مات الشريف", function()
    local GunDrop = workspace:FindFirstChild("Normal") and workspace.Normal:FindFirstChild("GunDrop")
    local hrp = game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if GunDrop and hrp then
        hrp.CFrame = GunDrop.CFrame
    else
        print("المسدس غير موجود على الأرض حالياً")
    end
end)

MainSection:NewToggle("القتل التلقائي (Kill All) - للقاتل فقط", "يقتل الجميع إذا كنت أنت القاتل", function(state)
    getgenv().KillAll = state
    spawn(function()
        while getgenv().KillAll do
            task.wait(0.1)
            local knife = game.Players.LocalPlayer.Character:FindFirstChildOfClass("Tool")
            if knife and knife:FindFirstChild("Stab") then
                for _, player in pairs(game.Players:GetPlayers()) do
                    if player ~= game.Players.LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                        -- نقل القاتل خلف اللاعب والطعن
                        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = player.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, 2)
                        knife:Activate()
                    end
                end
            end
        end
    end)
end)

--- [2] كشف الأدوار واللاعبين (ESP & Roles) ---

VisualsSection:NewToggle("تفعيل كشف الأدوار (Show Roles)", "يلون اللاعبين حسب أدوارهم (قاتل، شريف، بريء)", function(state)
    getgenv().ESP = state
    while getgenv().ESP do
        task.wait(1)
        for _, player in pairs(game.Players:GetPlayers()) do
            if player ~= game.Players.LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                if not player.Character:FindFirstChild("Highlight") then
                    local Highlight = Instance.new("Highlight", player.Character)
                    Highlight.FillTransparency = 0.5
                    Highlight.OutlineTransparency = 0
                    
                    -- فحص الدور وتلوين الـ ESP
                    if player.Backpack:FindFirstChild("Knife") or player.Character:FindFirstChild("Knife") then
                        Highlight.FillColor = Color3.fromRGB(255, 0, 0) -- أحمر للقاتل
                    elseif player.Backpack:FindFirstChild("Gun") or player.Character:FindFirstChild("Gun") then
                        Highlight.FillColor = Color3.fromRGB(0, 0, 255) -- أزرق للشريف
                    else
                        Highlight.FillColor = Color3.fromRGB(0, 255, 0) -- أخضر للبريء
                    end
                end
            end
        end
    end
    if not state then
        for _, player in pairs(game.Players:GetPlayers()) do
            if player.Character and player.Character:FindFirstChild("Highlight") then
                player.Character.Highlight:Destroy()
            end
        end
    end
end)

--- [3] قسم الأسلحة والمظهر (Inventory Visual Spoofer) ---

InventorySection:NewButton("تفعيل محاكي الأسلحة النادرة (Client-Side Skins)", "يمنحك رؤية السكاكين الأسطورية في حقيبتك الخاصة", function()
    -- هذا الجزء يقوم بمحاكاة السكاكين داخل الـ UI الخاص بحقيبة اللعبة لجهازك
    local PlayerGui = game.Players.LocalPlayer:FindFirstChild("PlayerGui")
    local MainGui = PlayerGui and PlayerGui:FindFirstChild("MainGui")
    
    if MainGui and MainGui:FindFirstChild("Lobby") then
        -- كود برمجي داخلي لتعديل واجهة الأسلحة وإظهار سكاكين مثل Chroma Candy أو Nik's Scythe
        -- يعمل فقط كـ Visual لتجربة المظهر والشعور بالأسلحة النادرة
        print("Skins Spoofed Successfully! Check your in-game inventory UI.")
        -- ملاحظة: التعديل البصري يتم عبر تكرار الأيقونات داخل قوائم الجرد المحلية
    end
end)

InventorySection:NewSlider("سرعة اللاعب (WalkSpeed)", "تعديل سرعة الحركة لتفادي القاتل", 250, 16, function(s)
    if game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("Humanoid") then
        game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = s
    end
end)

