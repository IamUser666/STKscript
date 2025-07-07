local Player = game:GetService("Players").LocalPlayer
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")

-- Основной GUI
local PhoneGUI = Instance.new("ScreenGui")
PhoneGUI.Name = "PhoneGUI"
PhoneGUI.ResetOnSpawn = false
PhoneGUI.DisplayOrder = 100
PhoneGUI.Parent = Player.PlayerGui

-- Кнопка меню (3 полоски)
local MenuButton = Instance.new("Frame")
MenuButton.Name = "MenuButton"
MenuButton.Size = UDim2.new(0, 50, 0, 30)
MenuButton.Position = UDim2.new(0, 10, 0, 10)
MenuButton.BackgroundTransparency = 1
MenuButton.Active = true
MenuButton.Selectable = true
MenuButton.ZIndex = 100
MenuButton.Parent = PhoneGUI

-- Линии для кнопки меню
for i = 0, 2 do
    local line = Instance.new("Frame")
    line.Size = UDim2.new(1, 0, 0, 3)
    line.Position = UDim2.new(0, 0, 0, i * 10)
    line.BackgroundColor3 = Color3.new(1, 1, 1)
    line.BorderSizePixel = 0
    line.ZIndex = 101
    line.Parent = MenuButton
end

-- Контейнер для меню с прокруткой
local ScrollContainer = Instance.new("Frame")
ScrollContainer.Name = "ScrollContainer"
ScrollContainer.Size = UDim2.new(0, 250, 0.7, 0)
ScrollContainer.Position = UDim2.new(0, 70, 0.1, 0)
ScrollContainer.BackgroundTransparency = 1
ScrollContainer.Visible = false
ScrollContainer.ZIndex = 90
ScrollContainer.Parent = PhoneGUI

-- ScrollingFrame для прокрутки меню
local MenuScroller = Instance.new("ScrollingFrame")
MenuScroller.Name = "MenuScroller"
MenuScroller.Size = UDim2.new(1, 0, 1, 0)
MenuScroller.Position = UDim2.new(0, 0, 0, 0)
MenuScroller.BackgroundColor3 = Color3.new(0, 0, 0)
MenuScroller.BackgroundTransparency = 0.3
MenuScroller.CanvasSize = UDim2.new(0, 0, 0, 800)
MenuScroller.ScrollBarThickness = 8
MenuScroller.AutomaticCanvasSize = Enum.AutomaticSize.Y
MenuScroller.Parent = ScrollContainer

-- Модуль ESP
local ESPFrame = Instance.new("Frame")
ESPFrame.Name = "ESPFrame"
ESPFrame.Size = UDim2.new(1, -10, 0, 150)
ESPFrame.Position = UDim2.new(0, 5, 0, 5)
ESPFrame.BackgroundTransparency = 1
ESPFrame.Parent = MenuScroller

local ESPTitle = Instance.new("TextLabel")
ESPTitle.Name = "ESPTitle"
ESPTitle.Size = UDim2.new(1, 0, 0, 25)
ESPTitle.Position = UDim2.new(0, 0, 0, 0)
ESPTitle.BackgroundTransparency = 1
ESPTitle.Text = "ESP"
ESPTitle.TextColor3 = Color3.new(1, 1, 1)
ESPTitle.TextSize = 20
ESPTitle.Font = Enum.Font.SourceSansBold
ESPTitle.Parent = ESPFrame

-- Модуль Power
local PowerFrame = Instance.new("Frame")
PowerFrame.Name = "PowerFrame"
PowerFrame.Size = UDim2.new(1, -10, 0, 200)
PowerFrame.Position = UDim2.new(0, 5, 0, 160)
PowerFrame.BackgroundTransparency = 1
PowerFrame.Parent = MenuScroller

local PowerTitle = Instance.new("TextLabel")
PowerTitle.Name = "PowerTitle"
PowerTitle.Size = UDim2.new(1, 0, 0, 25)
PowerTitle.Position = UDim2.new(0, 0, 0, 0)
PowerTitle.BackgroundTransparency = 1
PowerTitle.Text = "Power"
PowerTitle.TextColor3 = Color3.new(1, 1, 1)
PowerTitle.TextSize = 20
PowerTitle.Font = Enum.Font.SourceSansBold
PowerTitle.Parent = PowerFrame

-- Настройки
local settings = {
    ESP = {
        ShowKiller = false,
        ShowInnocent = false,
        ShowDistance = false
    },
    Power = {
        Untouch = false,
        Invis = false,
        NoWalls = false
    }
}

-- Функции перемещения меню
local dragging = false
local dragStartPos, buttonStartPos

MenuButton.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
        dragStartPos = input.Position
        buttonStartPos = MenuButton.Position
    end
end)

MenuButton.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseMovement then
        if (input.Position - dragStartPos).Magnitude > 5 then
            dragging = true
        end
    end
end)

MenuButton.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
        if not dragging then
            ScrollContainer.Visible = not ScrollContainer.Visible
            ScrollContainer.Position = UDim2.new(0, MenuButton.AbsolutePosition.X + 60, 0, MenuButton.AbsolutePosition.Y)
        end
    end
    dragging = false
end)

UserInputService.InputChanged:Connect(function(input, processed)
    if (input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseMovement) then
        if dragging and not processed then
            local delta = input.Position - dragStartPos
            local newPosition = UDim2.new(
                0, buttonStartPos.X.Offset + delta.X,
                0, buttonStartPos.Y.Offset + delta.Y
            )
            
            -- Ограничение перемещения в пределах экрана
            local viewportSize = Workspace.CurrentCamera.ViewportSize
            newPosition = UDim2.new(
                0, math.clamp(newPosition.X.Offset, 0, viewportSize.X - MenuButton.AbsoluteSize.X),
                0, math.clamp(newPosition.Y.Offset, 0, viewportSize.Y - MenuButton.AbsoluteSize.Y)
            )
            
            MenuButton.Position = newPosition
            
            -- Обновление позиции меню
            if ScrollContainer.Visible then
                ScrollContainer.Position = UDim2.new(0, MenuButton.AbsolutePosition.X + 60, 0, MenuButton.AbsolutePosition.Y)
            end
        end
    end
end)

-- Создание переключателей
local function createToggle(module, name, label, position, parent, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 0, 25)
    frame.Position = position
    frame.BackgroundTransparency = 1
    frame.Parent = parent

    local labelText = Instance.new("TextLabel")
    labelText.Size = UDim2.new(0.7, 0, 1, 0)
    labelText.Position = UDim2.new(0, 0, 0, 0)
    labelText.BackgroundTransparency = 1
    labelText.Text = label
    labelText.TextColor3 = Color3.new(1, 1, 1)
    labelText.TextSize = 16
    labelText.TextXAlignment = Enum.TextXAlignment.Left
    labelText.Parent = frame

    local toggleButton = Instance.new("TextButton")
    toggleButton.Name = name
    toggleButton.Size = UDim2.new(0.3, 0, 1, 0)
    toggleButton.Position = UDim2.new(0.7, 0, 0, 0)
    toggleButton.BackgroundColor3 = Color3.new(0.5, 0.5, 0.5)
    toggleButton.Text = "off"
    toggleButton.TextSize = 16
    toggleButton.Parent = frame

    toggleButton.MouseButton1Click:Connect(function()
        local newState = toggleButton.Text == "off"
        toggleButton.Text = newState and "on" or "off"
        toggleButton.BackgroundColor3 = newState and Color3.new(0, 1, 0) or Color3.new(0.5, 0.5, 0.5)
        callback(newState)
    end)
end

-- Инициализация переключателей
createToggle("ESP", "ShowKiller", "Show killer", UDim2.new(0, 0, 0, 30), ESPFrame, function(state)
    settings.ESP.ShowKiller = state
end)

createToggle("ESP", "ShowInnocent", "Show innocent", UDim2.new(0, 0, 0, 60), ESPFrame, function(state)
    settings.ESP.ShowInnocent = state
end)

createToggle("ESP", "ShowDistance", "Show distance", UDim2.new(0, 0, 0, 90), ESPFrame, function(state)
    settings.ESP.ShowDistance = state
end)

createToggle("Power", "Untouch", "Untouch", UDim2.new(0, 0, 0, 30), PowerFrame, function(state)
    settings.Power.Untouch = state
end)

createToggle("Power", "Invis", "Invis", UDim2.new(0, 0, 0, 60), PowerFrame, function(state)
    settings.Power.Invis = state
    updateInvis()
end)

createToggle("Power", "NoWalls", "No Walls", UDim2.new(0, 0, 0, 90), PowerFrame, function(state)
    settings.Power.NoWalls = state
end)

-- ESP Функционал (исправленные цвета)
local function isKiller(player)
    -- Улучшенное определение киллера
    if player:FindFirstChild("Knife") then return true end
    if player:FindFirstChild("KillerTag") then return true end
    if player:FindFirstChild("Role") and player.Role.Value == "Killer" then return true end
    
    local character = player.Character
    if character then
        if character:FindFirstChild("Knife") then return true end
        if character:FindFirstChild("KillerTag") then return true end
        
        -- Проверка по имени или тегам
        if player.Name:lower():find("killer") then return true end
        if player:GetAttribute("IsKiller") then return true end
        
        -- Проверка по цвету одежды
        local shirt = character:FindFirstChildOfClass("Shirt")
        if shirt and shirt.ShirtTemplate then
            local shirtName = shirt.ShirtTemplate:lower()
            if shirtName:find("red") or shirtName:find("blood") or shirtName:find("killer") then
                return true
            end
        end
        
        local pants = character:FindFirstChildOfClass("Pants")
        if pants and pants.PantsTemplate then
            local pantsName = pants.PantsTemplate:lower()
            if pantsName:find("red") or pantsName:find("blood") or pantsName:find("killer") then
                return true
            end
        end
    end
    
    return false
end

local trackedPlayers = {}
local espConnections = {}

local function createESP(player)
    if player == Player then return end
    if trackedPlayers[player] then return end
    
    local function setupESP(character)
        if not character then return end
        
        -- Удаляем старый ESP если есть
        if trackedPlayers[player] then
            pcall(function()
                if trackedPlayers[player].Highlight then
                    trackedPlayers[player].Highlight:Destroy()
                end
                if trackedPlayers[player].Billboard then
                    trackedPlayers[player].Billboard:Destroy()
                end
            end)
        end
        
        -- Создаем подсветку
        local highlight = Instance.new("Highlight")
        highlight.Adornee = character
        highlight.Enabled = false
        highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
        highlight.Parent = character
        
        -- Создаем метку расстояния
        local head = character:FindFirstChild("Head")
        if not head then return end
        
        local billboard = Instance.new("BillboardGui")
        billboard.Adornee = head
        billboard.Size = UDim2.new(0, 100, 0, 50)
        billboard.StudsOffset = Vector3.new(0, 3, 0)
        billboard.AlwaysOnTop = true
        billboard.Parent = head
        
        local distanceLabel = Instance.new("TextLabel")
        distanceLabel.Size = UDim2.new(1, 0, 1, 0)
        distanceLabel.BackgroundTransparency = 1
        distanceLabel.Text = ""
        distanceLabel.TextColor3 = Color3.new(1, 1, 1)
        distanceLabel.TextSize = 14
        distanceLabel.Visible = false
        distanceLabel.Parent = billboard
        
        -- Сохраняем данные ESP
        trackedPlayers[player] = {
            Highlight = highlight,
            Billboard = billboard,
            DistanceLabel = distanceLabel,
            Character = character
        }
    end
    
    -- Подключаемся к событиям персонажа
    if player.Character then
        setupESP(player.Character)
    end
    
    -- Обработка смены персонажа
    espConnections[player] = player.CharacterAdded:Connect(function(character)
        setupESP(character)
    end)
end

local function removeESP(player)
    if trackedPlayers[player] then
        pcall(function()
            if trackedPlayers[player].Highlight then
                trackedPlayers[player].Highlight:Destroy()
            end
            if trackedPlayers[player].Billboard then
                trackedPlayers[player].Billboard:Destroy()
            end
        end)
        trackedPlayers[player] = nil
    end
    
    -- Отключаем соединение
    if espConnections[player] then
        espConnections[player]:Disconnect()
        espConnections[player] = nil
    end
end

local function updateESP()
    if not Player.Character then return end
    local myRoot = Player.Character:FindFirstChild("HumanoidRootPart")
    if not myRoot then return end
    
    for player, data in pairs(trackedPlayers) do
        if player and player.Character and data.Character == player.Character then
            local char = player.Character
            local root = char:FindFirstChild("HumanoidRootPart")
            
            if root then
                local distance = (root.Position - myRoot.Position).Magnitude
                local isPlayerKiller = isKiller(player)
                
                -- Обновление подсветки
                data.Highlight.Enabled = (isPlayerKiller and settings.ESP.ShowKiller) or 
                                        (not isPlayerKiller and settings.ESP.ShowInnocent)
                
                -- Установка цвета (Киллер - красный, Невинный - зеленый)
                if isPlayerKiller then
                    data.Highlight.FillColor = Color3.new(1, 0, 0) -- Красный
                    data.Highlight.OutlineColor = Color3.new(1, 0.5, 0.5) -- Светло-красный
                else
                    data.Highlight.FillColor = Color3.new(0, 1, 0) -- Зеленый
                    data.Highlight.OutlineColor = Color3.new(0.5, 1, 0.5) -- Светло-зеленый
                end
                
                -- Обновление дистанции
                data.DistanceLabel.Visible = settings.ESP.ShowDistance
                data.DistanceLabel.Text = string.format("%.1fm", distance)
                
                -- Установка цвета текста (Киллер - красный, Невинный - зеленый)
                if isPlayerKiller then
                    data.DistanceLabel.TextColor3 = Color3.new(1, 0, 0) -- Красный
                else
                    data.DistanceLabel.TextColor3 = Color3.new(0, 1, 0) -- Зеленый
                end
            end
        else
            -- Если персонажа нет, временно отключаем ESP
            pcall(function()
                if data.Highlight then
                    data.Highlight.Enabled = false
                end
                if data.DistanceLabel then
                    data.DistanceLabel.Visible = false
                end
            end)
        end
    end
end

-- Обработка игроков
Players.PlayerAdded:Connect(function(player)
    createESP(player)
end)

Players.PlayerRemoving:Connect(function(player)
    removeESP(player)
end)

-- Инициализация существующих игроков
for _, player in ipairs(Players:GetPlayers()) do
    if player ~= Player then
        createESP(player)
    end
end

-- Цикл обновления ESP
RunService.Heartbeat:Connect(updateESP)

-- =====================================
-- Power: Untouch System (неуязвимость)
-- =====================================
local untouchConnection = nil

local function activateUntouch()
    if untouchConnection then return end
    
    untouchConnection = RunService.Heartbeat:Connect(function()
        if Player.Character then
            local humanoid = Player.Character:FindFirstChildOfClass("Humanoid")
            if humanoid then
                -- Делаем игрока неуязвимым
                humanoid.Health = 100
                humanoid.MaxHealth = 100
                
                -- Игнорируем ножи
                for _, knife in ipairs(Workspace:GetDescendants()) do
                    if knife.Name:lower():find("knife") or knife:FindFirstChild("Knife") then
                        knife.CanTouch = false
                    end
                end
            end
        end
    end)
end

local function deactivateUntouch()
    if untouchConnection then
        untouchConnection:Disconnect()
        untouchConnection = nil
    end
    
    -- Восстанавливаем возможность касания ножей
    if Player.Character then
        for _, knife in ipairs(Workspace:GetDescendants()) do
            if knife.Name:lower():find("knife") or knife:FindFirstChild("Knife") then
                knife.CanTouch = true
            end
        end
    end
end

-- =====================================
-- Power: Invis System (невидимость)
-- =====================================
local originalTransparency = {}
local originalShadows = {}

local function updateInvis()
    if not Player.Character then return end
    
    for _, part in ipairs(Player.Character:GetDescendants()) do
        if part:IsA("BasePart") then
            if settings.Power.Invis then
                -- Сохраняем оригинальные значения
                if originalTransparency[part] == nil then
                    originalTransparency[part] = part.Transparency
                end
                if originalShadows[part] == nil then
                    originalShadows[part] = part.CastShadow
                end
                
                -- Устанавливаем невидимость
                part.Transparency = 1
                part.CastShadow = false
            else
                -- Восстанавливаем оригинальные значения
                if originalTransparency[part] ~= nil then
                    part.Transparency = originalTransparency[part]
                end
                if originalShadows[part] ~= nil then
                    part.CastShadow = originalShadows[part]
                end
            end
        end
    end
end

-- =====================================
-- Power: NoWalls System (прохождение сквозь стены)
-- =====================================
local noclip = false
local noclipping = false

local function noclipLoop()
    if noclip and Player.Character then
        for _, child in ipairs(Player.Character:GetDescendants()) do
            if child:IsA("BasePart") and child.CanCollide then
                child.CanCollide = false
            end
        end
    end
end

-- Обработчик функций Power
RunService.Heartbeat:Connect(function()
    -- Untouch
    if settings.Power.Untouch then
        activateUntouch()
    else
        deactivateUntouch()
    end
    
    -- NoWalls
    if settings.Power.NoWalls and not noclipping then
        noclipping = true
        noclip = true
        noclipLoop()
    elseif not settings.Power.NoWalls and noclipping then
        noclipping = false
        noclip = false
        
        -- Восстанавливаем коллизии
        if Player.Character then
            for _, child in ipairs(Player.Character:GetDescendants()) do
                if child:IsA("BasePart") then
                    child.CanCollide = true
                end
            end
        end
    end
    
    -- Выполняем noclipLoop каждый кадр при активном NoWalls
    if settings.Power.NoWalls then
        noclipLoop()
    end
end)

-- Античит-защита
local function antiCheatProtection()
    -- Случайные задержки
    coroutine.wrap(function()
        while true do
            wait(math.random(5, 15))
            local _ = math.noise(tick())
        end
    end)()
    
    -- Переименование объектов
    for _, obj in ipairs(PhoneGUI:GetDescendants()) do
        if obj:IsA("Frame") then
            obj.Name = "UI_"..math.random(1000,9999)
        end
    end
end

-- Запускаем античит-защиту
antiCheatProtection()