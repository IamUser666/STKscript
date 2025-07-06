local Player = game:GetService("Players").LocalPlayer
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local GuiService = game:GetService("GuiService")
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local TweenService = game:GetService("TweenService")

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
        Clones = false,
        Free = false
    }
}

-- Функции перемещения меню
local dragging = false
local dragStartPos, buttonStartPos

MenuButton.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch then
        dragging = false
        dragStartPos = input.Position
        buttonStartPos = MenuButton.Position
    end
end)

MenuButton.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch then
        if (input.Position - dragStartPos).Magnitude > 5 then
            dragging = true
        end
    end
end)

MenuButton.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch then
        if not dragging then
            ScrollContainer.Visible = not ScrollContainer.Visible
            ScrollContainer.Position = UDim2.new(0, MenuButton.AbsolutePosition.X + 60, 0, MenuButton.AbsolutePosition.Y)
        end
    end
    dragging = false
end)

UserInputService.TouchMoved:Connect(function(input, processed)
    if dragging and not processed then
        local delta = input.Position - dragStartPos
        MenuButton.Position = UDim2.new(
            0, buttonStartPos.X.Offset + delta.X,
            0, buttonStartPos.Y.Offset + delta.Y
        )
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

createToggle("Power", "Clones", "Clones", UDim2.new(0, 0, 0, 30), PowerFrame, function(state)
    settings.Power.Clones = state
    if state then
        initCloneSystem()
    else
        removeCloneSystem()
    end
end)

createToggle("Power", "Free", "Free", UDim2.new(0, 0, 0, 60), PowerFrame, function(state)
    settings.Power.Free = state
    if state then
        activateFreeCamera()
    else
        deactivateFreeCamera()
    end
end)

-- ESP Функционал
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

local function createESP(player)
    if player == Player then return end
    if not player.Character then return end
    
    local highlight = Instance.new("Highlight")
    highlight.Adornee = player.Character
    highlight.Enabled = false
    highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    highlight.Parent = player.Character
    
    local head = player.Character:FindFirstChild("Head")
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
    
    trackedPlayers[player] = {
        Highlight = highlight,
        DistanceLabel = distanceLabel
    }
end

local function removeESP(player)
    if trackedPlayers[player] then
        pcall(function()
            trackedPlayers[player].Highlight:Destroy()
            if trackedPlayers[player].DistanceLabel and trackedPlayers[player].DistanceLabel.Parent then
                trackedPlayers[player].DistanceLabel.Parent:Destroy()
            end
        end)
        trackedPlayers[player] = nil
    end
end

local function updateESP()
    if not Player.Character then return end
    
    for player, data in pairs(trackedPlayers) do
        if player.Character and Player.Character then
            local char = player.Character
            local root = char:FindFirstChild("HumanoidRootPart")
            local myRoot = Player.Character:FindFirstChild("HumanoidRootPart")
            
            if root and myRoot then
                local distance = (root.Position - myRoot.Position).Magnitude
                local isPlayerKiller = isKiller(player)
                
                -- Обновление подсветки
                data.Highlight.Enabled = (isPlayerKiller and settings.ESP.ShowKiller) or 
                                        (not isPlayerKiller and settings.ESP.ShowInnocent)
                
                -- Установка цвета
                data.Highlight.FillColor = isPlayerKiller and Color3.new(1, 0, 0) or Color3.new(0, 1, 0)
                data.Highlight.OutlineColor = isPlayerKiller and Color3.new(1, 0.5, 0.5) or Color3.new(0.5, 1, 0.5)
                
                -- Обновление дистанции
                data.DistanceLabel.Visible = settings.ESP.ShowDistance
                data.DistanceLabel.Text = string.format("%.1fm", distance)
                data.DistanceLabel.TextColor3 = isPlayerKiller and Color3.new(1, 0, 0) or Color3.new(0, 1, 0)
            end
        end
    end
end

-- Обработка игроков
Players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(function(char)
        createESP(player)
    end)
end)

Players.PlayerRemoving:Connect(function(player)
    removeESP(player)
end)

-- Инициализация существующих игроков
for _, player in ipairs(Players:GetPlayers()) do
    if player ~= Player then
        if player.Character then
            createESP(player)
        else
            player.CharacterAdded:Once(function()
                createESP(player)
            end)
        end
    end
end

-- Цикл обновления ESP
RunService.Heartbeat:Connect(updateESP)

-- =====================================
-- Power: Clones System (Исправленная)
-- =====================================
local cloneUI = nil
local cloneButton = nil
local switchButton = nil
local originalCharacter = nil
local cloneCharacter = nil
local isInClone = false
local hiddenLocation = Vector3.new(0, -500, 0)

local function createCloneUI()
    -- Панель управления клонами
    cloneUI = Instance.new("Frame")
    cloneUI.Name = "CloneControls"
    cloneUI.Size = UDim2.new(0, 200, 0, 120)
    cloneUI.Position = UDim2.new(0.5, -100, 0.5, -60) -- По центру экрана
    cloneUI.BackgroundTransparency = 0.7
    cloneUI.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
    cloneUI.ZIndex = 50
    cloneUI.Parent = PhoneGUI
    
    -- Кнопка создания клона
    cloneButton = Instance.new("TextButton")
    cloneButton.Name = "CloneButton"
    cloneButton.Size = UDim2.new(0.9, 0, 0.4, 0)
    cloneButton.Position = UDim2.new(0.05, 0, 0.05, 0)
    cloneButton.Text = "Create Clone"
    cloneButton.TextSize = 16
    cloneButton.BackgroundColor3 = Color3.new(0.3, 0.3, 0.7)
    cloneButton.ZIndex = 51
    cloneButton.Parent = cloneUI
    
    -- Кнопка переключения
    switchButton = Instance.new("TextButton")
    switchButton.Name = "SwitchButton"
    switchButton.Size = UDim2.new(0.9, 0, 0.4, 0)
    switchButton.Position = UDim2.new(0.05, 0, 0.55, 0)
    switchButton.Text = "Switch to Clone"
    switchButton.TextSize = 16
    switchButton.BackgroundColor3 = Color3.new(0.7, 0.3, 0.3)
    switchButton.Visible = false
    switchButton.ZIndex = 51
    switchButton.Parent = cloneUI
    
    -- Настройка перемещения
    local draggingCloneUI = false
    local dragStartPos, uiStartPos
    
    cloneUI.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch then
            draggingCloneUI = true
            dragStartPos = input.Position
            uiStartPos = cloneUI.Position
        end
    end)
    
    cloneUI.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch then
            draggingCloneUI = false
        end
    end)
    
    UserInputService.TouchMoved:Connect(function(input, processed)
        if draggingCloneUI and not processed then
            local delta = input.Position - dragStartPos
            cloneUI.Position = UDim2.new(
                uiStartPos.X.Scale, uiStartPos.X.Offset + delta.X,
                uiStartPos.Y.Scale, uiStartPos.Y.Offset + delta.Y
            )
        end
    end)
end

local function createClone()
    if not Player.Character then return end
    originalCharacter = Player.Character
    
    -- Создаем клона
    cloneCharacter = originalCharacter:Clone()
    
    -- Позиционируем клона
    local root = originalCharacter:FindFirstChild("HumanoidRootPart")
    if root then
        local cloneRoot = cloneCharacter:FindFirstChild("HumanoidRootPart")
        if cloneRoot then
            cloneRoot.CFrame = root.CFrame * CFrame.new(5, 0, 0)
        end
    end
    
    -- Убираем скрипты из клона
    for _, script in ipairs(cloneCharacter:GetDescendants()) do
        if script:IsA("LocalScript") or script:IsA("Script") then
            script:Destroy()
        end
    end
    
    cloneCharacter.Parent = Workspace
    switchButton.Visible = true
end

local function switchBody()
    if not originalCharacter or not cloneCharacter then return end
    
    if isInClone then
        -- Возвращаемся в оригинальное тело
        Player.Character = originalCharacter
        
        -- Возвращаем основное тело на место
        local root = originalCharacter:FindFirstChild("HumanoidRootPart")
        local cloneRoot = cloneCharacter:FindFirstChild("HumanoidRootPart")
        if root and cloneRoot then
            root.CFrame = cloneRoot.CFrame
        end
        
        -- Прячем клона под карту
        if cloneRoot then
            cloneRoot.CFrame = CFrame.new(hiddenLocation)
        end
        
        switchButton.Text = "Switch to Clone"
        isInClone = false
    else
        -- Переходим в тело клона
        Player.Character = cloneCharacter
        
        -- Прячем основное тело под карту
        local root = originalCharacter:FindFirstChild("HumanoidRootPart")
        if root then
            root.CFrame = CFrame.new(hiddenLocation)
        end
        
        switchButton.Text = "Switch to Main"
        isInClone = true
    end
    
    -- Обновляем камеру
    Workspace.CurrentCamera.CameraSubject = Player.Character:FindFirstChild("Humanoid")
end

local function handleCharacterDeath(character)
    if character == originalCharacter and isInClone then
        -- Если умирает оригинальное тело, а мы в клоне
        originalCharacter = cloneCharacter
        cloneCharacter = nil
        isInClone = false
        switchButton.Visible = false
    elseif character == cloneCharacter and isInClone then
        -- Если умирает клон, а мы в нем
        Player.Character = originalCharacter
        isInClone = false
        cloneCharacter = nil
        switchButton.Visible = false
    end
end

local function initCloneSystem()
    if cloneUI then return end
    createCloneUI()
    
    cloneButton.MouseButton1Click:Connect(function()
        if not cloneCharacter then
            createClone()
        end
    end)
    
    switchButton.MouseButton1Click:Connect(function()
        if cloneCharacter then
            switchBody()
        end
    end)
    
    Player.CharacterAdded:Connect(function(character)
        if character == originalCharacter then return end
        
        if character == cloneCharacter then
            cloneCharacter = character
            if isInClone then
                Player.Character = cloneCharacter
            end
        else
            originalCharacter = character
            if not isInClone then
                Player.Character = originalCharacter
            end
        end
    end)
    
    Player.CharacterRemoving:Connect(handleCharacterDeath)
end

local function removeCloneSystem()
    if cloneUI then
        cloneUI:Destroy()
        cloneUI = nil
    end
    
    if cloneCharacter then
        cloneCharacter:Destroy()
        cloneCharacter = nil
    end
    
    if isInClone and originalCharacter then
        Player.Character = originalCharacter
        isInClone = false
    end
end

-- =====================================
-- Power: Free Camera System (Исправленная)
-- =====================================
local freeCameraActive = false
local cameraControls = nil
local cameraConnection = nil
local cameraMoveConnection = nil
local originalCameraType = nil
local cameraCFrame = nil
local moveVector = Vector3.new(0, 0, 0)
local moveSpeed = 10

local function createCameraControls()
    cameraControls = Instance.new("Frame")
    cameraControls.Name = "CameraControls"
    cameraControls.Size = UDim2.new(0, 200, 0, 200)
    cameraControls.Position = UDim2.new(0.5, -100, 0.5, -100) -- По центру экрана
    cameraControls.BackgroundTransparency = 0.7
    cameraControls.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
    cameraControls.ZIndex = 50
    cameraControls.Parent = PhoneGUI
    
    -- Кнопки движения
    local forward = Instance.new("TextButton")
    forward.Text = "W"
    forward.Size = UDim2.new(0, 50, 0, 50)
    forward.Position = UDim2.new(0.5, -25, 0, 10)
    forward.BackgroundColor3 = Color3.new(0.4, 0.4, 0.4)
    forward.TextSize = 20
    forward.ZIndex = 51
    forward.Parent = cameraControls
    
    local back = Instance.new("TextButton")
    back.Text = "S"
    back.Size = UDim2.new(0, 50, 0, 50)
    back.Position = UDim2.new(0.5, -25, 0.7, -60)
    back.BackgroundColor3 = Color3.new(0.4, 0.4, 0.4)
    back.TextSize = 20
    back.ZIndex = 51
    back.Parent = cameraControls
    
    local left = Instance.new("TextButton")
    left.Text = "A"
    left.Size = UDim2.new(0, 50, 0, 50)
    left.Position = UDim2.new(0.1, 0, 0.35, -25)
    left.BackgroundColor3 = Color3.new(0.4, 0.4, 0.4)
    left.TextSize = 20
    left.ZIndex = 51
    left.Parent = cameraControls
    
    local right = Instance.new("TextButton")
    right.Text = "D"
    right.Size = UDim2.new(0, 50, 0, 50)
    right.Position = UDim2.new(0.7, -50, 0.35, -25)
    right.BackgroundColor3 = Color3.new(0.4, 0.4, 0.4)
    right.TextSize = 20
    right.ZIndex = 51
    right.Parent = cameraControls
    
    -- Кнопка остановки
    local stopButton = Instance.new("TextButton")
    stopButton.Text = "Stop"
    stopButton.Size = UDim2.new(0, 70, 0, 40)
    stopButton.Position = UDim2.new(0.65, 0, 0.7, -20)
    stopButton.BackgroundColor3 = Color3.new(0.8, 0.2, 0.2)
    stopButton.TextSize = 16
    stopButton.ZIndex = 51
    stopButton.Parent = cameraControls
    
    -- Настройка перемещения
    local draggingCamera = false
    local dragStartPos, uiStartPos
    
    cameraControls.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch then
            draggingCamera = true
            dragStartPos = input.Position
            uiStartPos = cameraControls.Position
        end
    end)
    
    cameraControls.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch then
            draggingCamera = false
        end
    end)
    
    UserInputService.TouchMoved:Connect(function(input, processed)
        if draggingCamera and not processed then
            local delta = input.Position - dragStartPos
            cameraControls.Position = UDim2.new(
                uiStartPos.X.Scale, uiStartPos.X.Offset + delta.X,
                uiStartPos.Y.Scale, uiStartPos.Y.Offset + delta.Y
            )
        end
    end)
    
    -- Обработка движения
    forward.MouseButton1Down:Connect(function()
        moveVector = Vector3.new(moveVector.X, moveVector.Y, -1)
    end)
    
    forward.MouseButton1Up:Connect(function()
        moveVector = Vector3.new(moveVector.X, moveVector.Y, 0)
    end)
    
    back.MouseButton1Down:Connect(function()
        moveVector = Vector3.new(moveVector.X, moveVector.Y, 1)
    end)
    
    back.MouseButton1Up:Connect(function()
        moveVector = Vector3.new(moveVector.X, moveVector.Y, 0)
    end)
    
    left.MouseButton1Down:Connect(function()
        moveVector = Vector3.new(-1, moveVector.Y, moveVector.Z)
    end)
    
    left.MouseButton1Up:Connect(function()
        moveVector = Vector3.new(0, moveVector.Y, moveVector.Z)
    end)
    
    right.MouseButton1Down:Connect(function()
        moveVector = Vector3.new(1, moveVector.Y, moveVector.Z)
    end)
    
    right.MouseButton1Up:Connect(function()
        moveVector = Vector3.new(0, moveVector.Y, moveVector.Z)
    end)
    
    -- Обработка высоты
    local function handleHeightChange(y)
        moveVector = Vector3.new(moveVector.X, y, moveVector.Z)
    end
    
    -- Кнопка остановки
    stopButton.MouseButton1Click:Connect(function()
        settings.Power.Free = false
        deactivateFreeCamera()
    end)
    
    return {
        Forward = forward,
        Back = back,
        Left = left,
        Right = right,
        Stop = stopButton
    }
end

local function activateFreeCamera()
    if freeCameraActive then return end
    if not Workspace.CurrentCamera then return end
    
    -- Сохраняем оригинальное состояние камеры
    originalCameraType = Workspace.CurrentCamera.CameraType
    cameraCFrame = Workspace.CurrentCamera.CFrame
    freeCameraActive = true
    
    -- Активируем свободную камеру
    Workspace.CurrentCamera.CameraType = Enum.CameraType.Scriptable
    
    -- Создаем элементы управления
    createCameraControls()
    
    -- Цикл движения камеры
    cameraConnection = RunService.Heartbeat:Connect(function(deltaTime)
        if freeCameraActive and cameraCFrame then
            local moveDelta = moveVector * moveSpeed * deltaTime * 10
            cameraCFrame = cameraCFrame * CFrame.new(moveDelta)
            Workspace.CurrentCamera.CFrame = cameraCFrame
        end
    end)
end

local function deactivateFreeCamera()
    if not freeCameraActive then return end
    
    freeCameraActive = false
    moveVector = Vector3.new(0, 0, 0)
    
    -- Восстанавливаем камеру
    if originalCameraType then
        Workspace.CurrentCamera.CameraType = originalCameraType
    end
    
    -- Возвращаем управление персонажу
    if Player.Character then
        Workspace.CurrentCamera.CameraSubject = Player.Character:FindFirstChild("Humanoid")
    end
    
    -- Убираем элементы управления
    if cameraControls then
        cameraControls:Destroy()
        cameraControls = nil
    end
    
    -- Отключаем соединение
    if cameraConnection then
        cameraConnection:Disconnect()
        cameraConnection = nil
    end
end

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