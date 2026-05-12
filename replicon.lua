local player = game.Players.LocalPlayer
local PlayerGui = player:WaitForChild("PlayerGui")
if PlayerGui:FindFirstChild("RobuxHub") then PlayerGui.RobuxHub:Destroy() end

local gui = Instance.new("ScreenGui")
gui.Name = "RobuxHub"
gui.ResetOnSpawn = false
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.ScreenInsets = Enum.ScreenInsets.None
gui.Parent = PlayerGui

local UserInputService = game:GetService("UserInputService")
local Players          = game:GetService("Players")
local RunService       = game:GetService("RunService")
local TweenService     = game:GetService("TweenService")

local WHITE_ROBUX = "rbxassetid://11560341132"
local GOLD_ROBUX  = "rbxassetid://11560341824"
local CLOSE_ICON  = "rbxassetid://4458805208"

local function parseNumber(v)
    local c = tostring(v):gsub("[^%d]","")
    return (c == "") and 0 or (tonumber(c) or 0)
end

local function formatNum(n)
    local num = type(n) == "number" and n or (tonumber(tostring(n):gsub("[^%d]","")) or 0)
    local s = tostring(math.floor(num))
    local result, count = "", 0
    for i = #s, 1, -1 do
        count += 1
        result = s:sub(i,i) .. result
        if count % 3 == 0 and i ~= 1 then result = "," .. result end
    end
    return result
end

local function round(obj, r)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, r or 8)
    c.Parent = obj
end

local function makeDraggable(frame, handle)
    local dragging, dragInput, dragStart, startPos
    handle = handle or frame
    handle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true; dragStart = input.Position; startPos = frame.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then dragging = false end
            end)
        end
    end)
    handle.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement
        or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local d = input.Position - dragStart
            frame.Position = UDim2.new(
                startPos.X.Scale, startPos.X.Offset + d.X,
                startPos.Y.Scale, startPos.Y.Offset + d.Y
            )
        end
    end)
end

local function btn(parent, text, pos, size, bg, tc, fs, zi)
    local b = Instance.new("TextButton")
    b.Text = text; b.Position = pos; b.Size = size
    b.BackgroundColor3 = bg; b.TextColor3 = tc
    b.TextSize = fs or 13; b.Font = Enum.Font.GothamBold
    b.BorderSizePixel = 0; b.AutoButtonColor = false
    b.ZIndex = zi or 1; b.Parent = parent
    return b
end

local function lbl(parent, text, pos, size, tc, fs, font, xa, zi)
    local l = Instance.new("TextLabel")
    l.Text = text; l.Position = pos; l.Size = size
    l.BackgroundTransparency = 1; l.TextColor3 = tc
    l.TextSize = fs or 13; l.Font = font or Enum.Font.GothamBold
    l.TextXAlignment = xa or Enum.TextXAlignment.Center
    l.ZIndex = zi or 1; l.Parent = parent
    return l
end

local function closeBtn(parent, pos, zi)
    local b = Instance.new("ImageButton")
    b.Size = UDim2.new(0, 26, 0, 26); b.Position = pos
    b.BackgroundTransparency = 1; b.Image = CLOSE_ICON
    b.ZIndex = zi or 1; b.Parent = parent
    return b
end

local function robuxIcon(parent, pos, size, zi)
    local i = Instance.new("ImageLabel")
    i.Size = UDim2.new(0, size, 0, size); i.Position = pos
    i.BackgroundTransparency = 1; i.Image = WHITE_ROBUX
    i.ZIndex = zi or 1; i.Parent = parent
    return i
end

local function inputBox(parent, yPos, placeholder, defaultText)
    local f = Instance.new("Frame")
    f.Size = UDim2.new(1, -28, 0, 34); f.Position = UDim2.new(0, 14, 0, yPos)
    f.BackgroundColor3 = Color3.fromRGB(16, 16, 16)
    f.BorderSizePixel = 0; f.ZIndex = 2; f.Parent = parent
    round(f, 7)
    local tb = Instance.new("TextBox")
    tb.Size = UDim2.new(1, -16, 1, 0); tb.Position = UDim2.new(0, 8, 0, 0)
    tb.BackgroundTransparency = 1
    tb.Text = defaultText or ""
    tb.PlaceholderText = placeholder or ""
    tb.PlaceholderColor3 = Color3.fromRGB(80, 70, 100)
    tb.TextColor3 = Color3.new(1, 1, 1)
    tb.Font = Enum.Font.Gotham; tb.TextSize = 13
    tb.ClearTextOnFocus = false; tb.ZIndex = 3; tb.Parent = f
    return tb
end

-- ========================
-- HEAD TAG
-- ========================
local devOn = true

local function createHeadTag(character, username, showCheck, isDev)
    local head = character:FindFirstChild("Head"); if not head then return end
    local old = head:FindFirstChild("IdentityTag"); if old then old:Destroy() end
    local totalH = isDev and 48 or 22
    local bg = Instance.new("BillboardGui"); bg.Name = "IdentityTag"
    bg.Size = UDim2.new(0, 200, 0, totalH); bg.StudsOffset = Vector3.new(0, 3, 0)
    bg.AlwaysOnTop = true; bg.LightInfluence = 0; bg.Parent = head
    local main = Instance.new("Frame")
    main.Size = UDim2.new(1, 0, 1, 0); main.BackgroundTransparency = 1; main.Parent = bg
    if isDev then
        local db = Instance.new("Frame")
        db.Size = UDim2.new(0, 86, 0, 20); db.Position = UDim2.new(0.5, -43, 0, 0)
        db.BackgroundColor3 = Color3.fromRGB(200, 40, 40); db.BorderSizePixel = 0; db.ZIndex = 2; db.Parent = main
        round(db, 4)
        local dl = Instance.new("TextLabel")
        dl.Size = UDim2.new(1, 0, 1, 0); dl.BackgroundTransparency = 1
        dl.Text = "DEVELOPER"; dl.TextColor3 = Color3.new(1, 1, 1)
        dl.Font = Enum.Font.GothamBold; dl.TextSize = 11; dl.ZIndex = 3; dl.Parent = db
    end
    local nameY = isDev and 26 or 0
    local nl = Instance.new("TextLabel")
    nl.AutomaticSize = Enum.AutomaticSize.X
    nl.Size = UDim2.new(0, 0, 0, 22); nl.Position = UDim2.new(0.5, 0, 0, nameY)
    nl.AnchorPoint = Vector2.new(0.5, 0); nl.BackgroundTransparency = 1
    nl.Text = username; nl.TextColor3 = Color3.new(1, 1, 1)
    nl.Font = Enum.Font.GothamBold; nl.TextSize = 14; nl.ZIndex = 2; nl.Parent = main
    if showCheck then
        local ico = Instance.new("ImageLabel")
        ico.Size = UDim2.new(0, 14, 0, 14); ico.BackgroundTransparency = 1
        ico.Image = "rbxassetid://11478378840"; ico.ZIndex = 3; ico.Parent = main
        task.defer(function()
            task.wait()
            local hw = nl.AbsoluteSize.X / 2
            local bw = bg.AbsoluteSize.X
            ico.Position = UDim2.new(0, bw/2 + hw + 3, 0, nameY + 4)
        end)
    end
end

-- ========================
-- FAKE AVATAR — ANY USERNAME
-- Builds the target's full character model via CreateHumanoidModelFromDescription,
-- then MOVES their parts/accessories onto our character (replacing ours),
-- and stores our original parts so Remove can swap back.
-- Our rig, HRP, Humanoid, animations stay — only visual parts change.
-- ========================

local savedParts = {}   -- our original parts stashed in a folder
local swapFolder = nil  -- hidden folder holding our originals

local function removeOverlay()
    if not swapFolder then return end
    local myChar = player.Character
    if not myChar then swapFolder:Destroy(); swapFolder = nil; savedParts = {}; return end

    -- Remove anything we put on from the target
    for _, obj in ipairs(myChar:GetChildren()) do
        if obj:GetAttribute("FakeAvatarPart") then
            obj:Destroy()
        end
    end

    -- Restore our original parts
    for _, obj in ipairs(swapFolder:GetChildren()) do
        obj.Parent = myChar
    end

    swapFolder:Destroy()
    swapFolder  = nil
    savedParts  = {}
end

-- Parts/classes that are purely visual and safe to swap
local VISUAL_CLASSES = {
    "Part", "MeshPart", "SpecialMesh", "UnionOperation",
    "Shirt", "Pants", "ShirtGraphic",
    "Accessory", "Hat",
    "BodyColors", "CharacterMesh",
    "Decal", "Texture",
}
local function isVisual(obj)
    for _, cls in ipairs(VISUAL_CLASSES) do
        if obj:IsA(cls) then return true end
    end
    return false
end

-- Parts that are structural — never touch these
local KEEP = {
    HumanoidRootPart = true,
    Humanoid         = true,
    Animator         = true,
    AnimationController = true,
}

local function spawnOverlay(targetName)
    removeOverlay()

    -- 1. Validate local character
    local myChar  = player.Character
    if not myChar then return false, "No local character" end
    local myHuman = myChar:FindFirstChildOfClass("Humanoid")
    if not myHuman then return false, "No Humanoid" end

    -- 2. Resolve target UserId
    local ok1, uid = pcall(function()
        return Players:GetUserIdFromNameAsync(targetName)
    end)
    if not ok1 or not uid then return false, "User not found: " .. targetName end

    -- 3. Get target's HumanoidDescription
    local ok2, desc = pcall(function()
        return Players:GetHumanoidDescriptionFromUserId(uid)
    end)
    if not ok2 or not desc then return false, "Could not load appearance" end

    -- 4. Build their full character model (includes body parts, accessories, clothing)
    local rigType = myHuman.RigType  -- match our own rig so Motor6Ds align
    local ok3, targetModel = pcall(function()
        return Players:CreateHumanoidModelFromDescription(desc, rigType)
    end)
    if not ok3 or not targetModel then return false, "Failed to build target model" end

    -- 5. Create a hidden stash folder for our original parts
    swapFolder = Instance.new("Folder")
    swapFolder.Name = "FakeAvatarStash"
    swapFolder.Parent = player

    -- 6. Pull OUR visual parts out into the stash
    for _, obj in ipairs(myChar:GetChildren()) do
        if isVisual(obj) and not KEEP[obj.Name] then
            obj.Parent = swapFolder
        end
    end

    -- 7. Move TARGET's visual parts onto our character
    for _, obj in ipairs(targetModel:GetChildren()) do
        if isVisual(obj) and not KEEP[obj.Name] then
            -- Tag it so removeOverlay knows what to delete
            obj:SetAttribute("FakeAvatarPart", true)
            obj.Parent = myChar
        end
    end

    -- 8. Also copy body part Mesh/Color/Texture from target's body parts onto ours
    --    (handles head shape, body mesh, skin colour)
    local BODY_PARTS = {"Head","Torso","Left Arm","Right Arm","Left Leg","Right Leg",
                        "UpperTorso","LowerTorso","LeftUpperArm","RightUpperArm",
                        "LeftLowerArm","RightLowerArm","LeftHand","RightHand",
                        "LeftUpperLeg","RightUpperLeg","LeftLowerLeg","RightLowerLeg",
                        "LeftFoot","RightFoot"}

    for _, partName in ipairs(BODY_PARTS) do
        local myPart     = myChar:FindFirstChild(partName)
        local targetPart = targetModel:FindFirstChild(partName)
        if myPart and targetPart then
            -- Copy colour
            if myPart:IsA("BasePart") then
                myPart.Color = targetPart.Color
                myPart.Material = targetPart.Material
            end
            -- Copy mesh children (SpecialMesh, SurfaceAppearance, Decal)
            for _, child in ipairs(myPart:GetChildren()) do
                if child:IsA("SpecialMesh") or child:IsA("SurfaceAppearance")
                or child:IsA("Decal") then
                    child:Destroy()
                end
            end
            for _, child in ipairs(targetPart:GetChildren()) do
                if child:IsA("SpecialMesh") or child:IsA("SurfaceAppearance")
                or child:IsA("Decal") then
                    local c = child:Clone()
                    c:SetAttribute("FakeAvatarPart", true)
                    c.Parent = myPart
                end
            end
        end
    end

    -- 9. Destroy the now-stripped target model (we've taken everything we need)
    targetModel:Destroy()

    return true, "Wearing: " .. targetName
end

-- ========================
-- SIDE PANEL
-- ========================
local SIDE_H = 530
local side = Instance.new("Frame")
side.Size = UDim2.new(0, 260, 0, SIDE_H)
side.Position = UDim2.new(0, 20, 0.5, -SIDE_H/2)
side.BackgroundColor3 = Color3.fromRGB(6, 6, 6)
side.BorderSizePixel = 0; side.Parent = gui
round(side, 14)

local sideHeader = Instance.new("Frame")
sideHeader.Size = UDim2.new(1, 0, 0, 46)
sideHeader.BackgroundColor3 = Color3.fromRGB(20, 10, 40)
sideHeader.BorderSizePixel = 0; sideHeader.ZIndex = 2; sideHeader.Parent = side
round(sideHeader, 14)
local shFix = Instance.new("Frame")
shFix.Size = UDim2.new(1, 0, 0.5, 0); shFix.Position = UDim2.new(0, 0, 0.5, 0)
shFix.BackgroundColor3 = Color3.fromRGB(20, 10, 40)
shFix.BorderSizePixel = 0; shFix.ZIndex = 2; shFix.Parent = sideHeader

lbl(sideHeader, "by KLPN777", UDim2.new(0, 14, 0, 0), UDim2.new(1, -50, 1, 0),
    Color3.fromRGB(160, 110, 230), 13, Enum.Font.GothamBold, Enum.TextXAlignment.Left, 3)

local minusBtn = closeBtn(sideHeader, UDim2.new(1, -36, 0.5, -13), 3)
makeDraggable(side, sideHeader)

lbl(side, "my discord : klpn.3", UDim2.new(0, 14, 0, 52), UDim2.new(1, -28, 0, 14),
    Color3.fromRGB(80, 60, 120), 10, Enum.Font.Gotham, Enum.TextXAlignment.Left, 2)

local function sLbl(parent, text, yPos)
    lbl(parent, text, UDim2.new(0, 14, 0, yPos), UDim2.new(1, -28, 0, 14),
        Color3.fromRGB(70, 50, 100), 9, Enum.Font.GothamBold, Enum.TextXAlignment.Left, 2)
end

-- WALLET BALANCE
sLbl(side, "ENTER AMOUNT", 72)
local balTB = inputBox(side, 88, "Amount...", "2,337,182,369")
local applyBal = btn(side, "Apply Balance", UDim2.new(0, 14, 0, 130), UDim2.new(1, -28, 0, 34),
    Color3.fromRGB(24, 65, 155), Color3.new(1, 1, 1), 13, 2)
round(applyBal, 7)

-- IDENTITY
sLbl(side, "IDENTITY (FAKE USERNAME)", 174)
local usernameInput = inputBox(side, 190, "Enter username...")

local checkRow = Instance.new("Frame")
checkRow.Size = UDim2.new(1, -28, 0, 30); checkRow.Position = UDim2.new(0, 14, 0, 232)
checkRow.BackgroundColor3 = Color3.fromRGB(16, 16, 16)
checkRow.BorderSizePixel = 0; checkRow.ZIndex = 2; checkRow.Parent = side
round(checkRow, 7)

local checkToggle = Instance.new("TextButton")
checkToggle.Size = UDim2.new(0, 20, 0, 20); checkToggle.Position = UDim2.new(0, 8, 0.5, -10)
checkToggle.BackgroundColor3 = Color3.fromRGB(24, 65, 155)
checkToggle.BorderSizePixel = 0; checkToggle.Text = ""; checkToggle.ZIndex = 3; checkToggle.Parent = checkRow
round(checkToggle, 4)

local checkMark = lbl(checkToggle, "✓", UDim2.new(0, 0, 0, 0), UDim2.new(1, 0, 1, 0),
    Color3.new(1, 1, 1), 13, Enum.Font.GothamBold, Enum.TextXAlignment.Center, 4)
lbl(checkRow, "Show checkmark next to username", UDim2.new(0, 34, 0, 0), UDim2.new(1, -42, 1, 0),
    Color3.fromRGB(170, 140, 230), 11, Enum.Font.Gotham, Enum.TextXAlignment.Left, 3)

local checkmarkEnabled = true
checkToggle.MouseButton1Click:Connect(function()
    checkmarkEnabled = not checkmarkEnabled
    checkMark.Text = checkmarkEnabled and "✓" or ""
    checkToggle.BackgroundColor3 = checkmarkEnabled
        and Color3.fromRGB(24, 65, 155) or Color3.fromRGB(35, 25, 50)
end)

local applyUserBtn = btn(side, "Apply Username", UDim2.new(0, 14, 0, 270), UDim2.new(1, -28, 0, 34),
    Color3.fromRGB(150, 25, 25), Color3.new(1, 1, 1), 13, 2)
round(applyUserBtn, 7)

local previewLbl = lbl(side, "", UDim2.new(0, 14, 0, 310), UDim2.new(1, -28, 0, 16),
    Color3.fromRGB(160, 140, 200), 11, Enum.Font.Gotham, Enum.TextXAlignment.Left, 2)

applyUserBtn.MouseButton1Click:Connect(function()
    local uname = usernameInput.Text; if uname == "" then return end
    previewLbl.Text = "Preview: " .. uname .. (checkmarkEnabled and " ✓" or "")
    local char = player.Character or player.CharacterAdded:Wait()
    createHeadTag(char, uname, checkmarkEnabled, devOn)
end)

local devBtn = btn(side, "DEV TAGS: ON", UDim2.new(0, 14, 0, 332), UDim2.new(1, -28, 0, 34),
    Color3.fromRGB(105, 82, 16), Color3.fromRGB(240, 195, 55), 12, 2)
round(devBtn, 7)
devBtn.MouseButton1Click:Connect(function()
    devOn = not devOn
    devBtn.Text = devOn and "DEV TAGS: ON" or "DEV TAGS: OFF"
    devBtn.BackgroundColor3 = devOn and Color3.fromRGB(105, 82, 16) or Color3.fromRGB(50, 50, 50)
    devBtn.TextColor3 = devOn and Color3.fromRGB(240, 195, 55) or Color3.fromRGB(140, 140, 140)
    local char = player.Character
    if char and usernameInput.Text ~= "" then
        createHeadTag(char, usernameInput.Text, checkmarkEnabled, devOn)
    end
end)

-- ========================
-- FAKE AVATAR SECTION
-- ========================
local divFake = Instance.new("Frame")
divFake.Size = UDim2.new(1, -28, 0, 1); divFake.Position = UDim2.new(0, 14, 0, 378)
divFake.BackgroundColor3 = Color3.fromRGB(40, 25, 70)
divFake.BorderSizePixel = 0; divFake.ZIndex = 2; divFake.Parent = side

sLbl(side, "FAKE AVATAR - APPLY TO SELF", 386)

local fakeAvatarInput = inputBox(side, 402, "Any Roblox username...")

local spawnAvatarBtn = btn(side, "Apply Avatar", UDim2.new(0, 14, 0, 444),
    UDim2.new(0, 116, 0, 34), Color3.fromRGB(25, 145, 55), Color3.new(1, 1, 1), 12, 2)
round(spawnAvatarBtn, 7)

local removeAvatarBtn = btn(side, "Remove", UDim2.new(0, 136, 0, 444),
    UDim2.new(1, -150, 0, 34), Color3.fromRGB(120, 20, 20), Color3.new(1, 1, 1), 12, 2)
round(removeAvatarBtn, 7)

local fakeStatusLbl = lbl(side, "", UDim2.new(0, 14, 0, 484), UDim2.new(1, -28, 0, 30),
    Color3.fromRGB(120, 200, 120), 10, Enum.Font.Gotham, Enum.TextXAlignment.Left, 2)
fakeStatusLbl.TextWrapped = true

-- Spawn button: works for ANY Roblox username
spawnAvatarBtn.MouseButton1Click:Connect(function()
    local targetName = fakeAvatarInput.Text
    if targetName == "" then
        fakeStatusLbl.Text = "Enter a username!"
        fakeStatusLbl.TextColor3 = Color3.fromRGB(255, 100, 100)
        return
    end

    -- Disable button while loading to prevent double-clicks
    spawnAvatarBtn.Text = "Loading..."
    spawnAvatarBtn.BackgroundColor3 = Color3.fromRGB(15, 80, 30)

    fakeStatusLbl.Text = "Fetching " .. targetName .. "..."
    fakeStatusLbl.TextColor3 = Color3.fromRGB(200, 200, 100)

    task.spawn(function()
        local ok, msg = spawnOverlay(targetName)

        -- Re-enable button
        spawnAvatarBtn.Text = "Apply Avatar"
        spawnAvatarBtn.BackgroundColor3 = Color3.fromRGB(25, 145, 55)

        if ok then
            fakeStatusLbl.Text = "✓ " .. msg
            fakeStatusLbl.TextColor3 = Color3.fromRGB(100, 220, 100)
        else
            fakeStatusLbl.Text = "✗ " .. msg
            fakeStatusLbl.TextColor3 = Color3.fromRGB(255, 100, 100)
        end
    end)
end)

removeAvatarBtn.MouseButton1Click:Connect(function()
    removeOverlay()
    fakeStatusLbl.TextColor3 = Color3.fromRGB(180, 180, 180)
    fakeStatusLbl.Text = "Restored your avatar"
    fakeStatusLbl.TextColor3 = Color3.fromRGB(180, 180, 180)
end)

local giftOpenBtn = btn(side, "Gift Robux", UDim2.new(0, 14, 1, -50),
    UDim2.new(1, -28, 0, 40), Color3.fromRGB(25, 145, 55), Color3.new(1, 1, 1), 14, 2)
round(giftOpenBtn, 8)

local minimized = false
minusBtn.MouseButton1Click:Connect(function()
    minimized = not minimized
    for _, child in ipairs(side:GetChildren()) do
        if child ~= sideHeader then child.Visible = not minimized end
    end
    side.Size = minimized and UDim2.new(0, 260, 0, 46) or UDim2.new(0, 260, 0, SIDE_H)
end)

-- ========================
-- GIFT MODAL
-- ========================
local modal = Instance.new("Frame")
modal.Size = UDim2.new(0, 340, 0, 600)
modal.Position = UDim2.new(0.5, -170, 0.5, -300)
modal.BackgroundColor3 = Color3.fromRGB(20, 21, 24)
modal.BorderSizePixel = 0; modal.Visible = false; modal.ZIndex = 10; modal.Parent = gui
round(modal, 16); makeDraggable(modal)

local searchRow = Instance.new("Frame")
searchRow.Size = UDim2.new(1, 0, 0, 56)
searchRow.BackgroundColor3 = Color3.fromRGB(28, 30, 34)
searchRow.BorderSizePixel = 0; searchRow.ZIndex = 11; searchRow.Parent = modal
round(searchRow, 16)
local srFix = Instance.new("Frame")
srFix.Size = UDim2.new(1, 0, 0.5, 0); srFix.Position = UDim2.new(0, 0, 0.5, 0)
srFix.BackgroundColor3 = Color3.fromRGB(28, 30, 34)
srFix.BorderSizePixel = 0; srFix.ZIndex = 11; srFix.Parent = searchRow

local searchAvatarIcon = Instance.new("ImageLabel")
searchAvatarIcon.Size = UDim2.new(0, 32, 0, 32)
searchAvatarIcon.Position = UDim2.new(0, 10, 0.5, -16)
searchAvatarIcon.BackgroundTransparency = 1
searchAvatarIcon.Image = ""; searchAvatarIcon.ZIndex = 12; searchAvatarIcon.Parent = searchRow
round(searchAvatarIcon, 16)

local searchInput = Instance.new("TextBox")
searchInput.Size = UDim2.new(1, -90, 1, 0); searchInput.Position = UDim2.new(0, 50, 0, 0)
searchInput.BackgroundTransparency = 1; searchInput.PlaceholderText = "Search username..."
searchInput.Text = ""; searchInput.TextColor3 = Color3.new(1, 1, 1)
searchInput.Font = Enum.Font.GothamBold; searchInput.TextSize = 14
searchInput.ClearTextOnFocus = false; searchInput.ZIndex = 12; searchInput.Parent = searchRow

local closeGift = closeBtn(searchRow, UDim2.new(1, -36, 0.5, -13), 12)

local avatarImg = Instance.new("ImageLabel")
avatarImg.Size = UDim2.new(0, 88, 0, 88); avatarImg.Position = UDim2.new(0.5, -44, 0, 66)
avatarImg.BackgroundTransparency = 1; avatarImg.Image = ""; avatarImg.ZIndex = 11; avatarImg.Parent = modal
round(avatarImg, 10)

local robuxLine = lbl(modal, "", UDim2.new(0, 0, 0, 164), UDim2.new(1, 0, 0, 22),
    Color3.fromRGB(210, 210, 210), 14, Enum.Font.GothamBold, Enum.TextXAlignment.Center, 11)
local nameLine = lbl(modal, "", UDim2.new(0, 0, 0, 186), UDim2.new(1, 0, 0, 26),
    Color3.fromRGB(235, 235, 235), 18, Enum.Font.GothamBold, Enum.TextXAlignment.Center, 11)
local atLine = lbl(modal, "", UDim2.new(0, 0, 0, 213), UDim2.new(1, 0, 0, 18),
    Color3.fromRGB(100, 100, 100), 12, Enum.Font.Gotham, Enum.TextXAlignment.Center, 11)

local tierData = {
    {amt="20,000",  gold=false},
    {amt="50,000",  gold=false},
    {amt="200,000", gold=true},
    {amt="500,000", gold=true},
}
local tierBtns = {}
local amtBox

for i, t in ipairs(tierData) do
    local col = (i-1) % 2
    local row2 = math.floor((i-1) / 2)
    local tb = Instance.new("Frame")
    tb.Size = UDim2.new(0, 148, 0, 64)
    tb.Position = UDim2.new(0, 14 + col*162, 0, 244 + row2*74)
    tb.BackgroundColor3 = Color3.fromRGB(28, 30, 34)
    tb.BorderSizePixel = 0; tb.ZIndex = 11; tb.Parent = modal
    round(tb, 10)
    if t.gold then
        for ix, ox in ipairs({34, 56, 78}) do
            local sz = ix == 2 and 22 or 18
            local ico = Instance.new("ImageLabel")
            ico.Size = UDim2.new(0, sz, 0, sz); ico.Position = UDim2.new(0, ox, 0, 7)
            ico.BackgroundTransparency = 1; ico.Image = GOLD_ROBUX
            ico.ZIndex = 12; ico.Parent = tb
        end
    else
        local ico = Instance.new("ImageLabel")
        ico.Size = UDim2.new(0, 22, 0, 22); ico.Position = UDim2.new(0, 55, 0, 7)
        ico.BackgroundTransparency = 1; ico.Image = WHITE_ROBUX
        ico.ZIndex = 12; ico.Parent = tb
    end
    lbl(tb, t.amt.." Robux", UDim2.new(0, 0, 0, 36), UDim2.new(1, 0, 0, 22),
        Color3.fromRGB(180, 180, 180), 12, Enum.Font.GothamBold, Enum.TextXAlignment.Center, 12)
    local ca = btn(tb, "", UDim2.new(0, 0, 0, 0), UDim2.new(1, 0, 1, 0),
        Color3.fromRGB(28, 30, 34), Color3.new(0, 0, 0), 1, 13)
    ca.BackgroundTransparency = 1; round(ca, 10)
    table.insert(tierBtns, {frame=tb, click=ca, amt=t.amt})
end

local customRow = Instance.new("Frame")
customRow.Size = UDim2.new(1, -28, 0, 44); customRow.Position = UDim2.new(0, 14, 0, 402)
customRow.BackgroundColor3 = Color3.fromRGB(28, 30, 34)
customRow.BorderSizePixel = 0; customRow.ZIndex = 11; customRow.Parent = modal
round(customRow, 9)

local customIconImg = Instance.new("ImageLabel")
customIconImg.Size = UDim2.new(0, 22, 0, 22); customIconImg.Position = UDim2.new(0, 10, 0.5, -11)
customIconImg.BackgroundTransparency = 1; customIconImg.Image = WHITE_ROBUX
customIconImg.ZIndex = 12; customIconImg.Parent = customRow

local customPlaceholder = lbl(customRow, "Custom Amount", UDim2.new(0, 40, 0, 0),
    UDim2.new(1, -50, 1, 0), Color3.fromRGB(90, 90, 90), 13, Enum.Font.Gotham, Enum.TextXAlignment.Left, 12)

amtBox = Instance.new("TextBox")
amtBox.Size = UDim2.new(1, -50, 1, 0); amtBox.Position = UDim2.new(0, 40, 0, 0)
amtBox.BackgroundTransparency = 1; amtBox.Text = ""; amtBox.PlaceholderText = ""
amtBox.TextColor3 = Color3.new(1, 1, 1); amtBox.Font = Enum.Font.GothamBold
amtBox.TextSize = 14; amtBox.ClearTextOnFocus = false; amtBox.ZIndex = 13; amtBox.Parent = customRow

amtBox:GetPropertyChangedSignal("Text"):Connect(function()
    customPlaceholder.Visible = amtBox.Text == ""
    local raw = amtBox.Text:gsub("[^%d]","")
    if raw ~= "" then robuxLine.Text = formatNum(tonumber(raw) or 0).." Robux" end
end)

for _, t in ipairs(tierBtns) do
    t.click.MouseButton1Click:Connect(function()
        for _, b in ipairs(tierBtns) do b.frame.BackgroundColor3 = Color3.fromRGB(28, 30, 34) end
        t.frame.BackgroundColor3 = Color3.fromRGB(22, 45, 70)
        amtBox.Text = t.amt:gsub(",",""); customPlaceholder.Visible = false
        robuxLine.Text = t.amt.." Robux"
    end)
end

local confirmBtn = btn(modal, "CONFIRM GIFT", UDim2.new(0, 14, 0, 460),
    UDim2.new(1, -28, 0, 52), Color3.fromRGB(28, 170, 65), Color3.new(1, 1, 1), 15, 11)
round(confirmBtn, 10)

local currentUserId   = nil
local currentUsername = ""

local function searchUser(username)
    if username == "" then return end
    nameLine.Text = "Searching..."; atLine.Text = ""; avatarImg.Image = ""
    robuxLine.Text = ""; searchAvatarIcon.Image = ""; currentUserId = nil
    local ok, uid = pcall(function() return Players:GetUserIdFromNameAsync(username) end)
    if not ok then nameLine.Text = "User not found"; return end
    currentUserId = uid; currentUsername = username
    nameLine.Text = username; atLine.Text = "@"..username
    local raw = amtBox.Text:gsub("[^%d]","")
    if raw ~= "" then robuxLine.Text = formatNum(tonumber(raw) or 0).." Robux" end
    local tok, thumb = pcall(function()
        return Players:GetUserThumbnailAsync(uid, Enum.ThumbnailType.AvatarBust, Enum.ThumbnailSize.Size100x100)
    end)
    if tok then avatarImg.Image = thumb; searchAvatarIcon.Image = thumb end
end

searchInput.FocusLost:Connect(function(enter) if enter then searchUser(searchInput.Text) end end)
closeGift.MouseButton1Click:Connect(function() modal.Visible = false end)
giftOpenBtn.MouseButton1Click:Connect(function() modal.Visible = true end)

-- ========================
-- OVERLAY
-- ========================
local overlay = Instance.new("Frame")
overlay.Size = UDim2.new(1, 0, 1, 0)
overlay.BackgroundColor3 = Color3.fromRGB(0, 0, 0); overlay.BackgroundTransparency = 0.45
overlay.BorderSizePixel = 0; overlay.Visible = false; overlay.ZIndex = 30; overlay.Parent = gui

-- ========================
-- BUY PROMPT
-- ========================
local buyPrompt = Instance.new("Frame")
buyPrompt.Size = UDim2.new(0, 390, 0, 200)
buyPrompt.Position = UDim2.new(0.5, -195, 0.5, -100)
buyPrompt.BackgroundColor3 = Color3.fromRGB(4, 4, 4)
buyPrompt.BorderSizePixel = 0; buyPrompt.Visible = false; buyPrompt.ZIndex = 31; buyPrompt.Parent = gui
round(buyPrompt, 12); makeDraggable(buyPrompt)

lbl(buyPrompt, "Buy", UDim2.new(0, 16, 0, 13), UDim2.new(0, 60, 0, 22),
    Color3.new(1, 1, 1), 17, Enum.Font.GothamBold, Enum.TextXAlignment.Left, 32)

local buyXBtn = closeBtn(buyPrompt, UDim2.new(1, -34, 0, 10), 32)

local buyBalIcon = Instance.new("ImageLabel")
buyBalIcon.Size = UDim2.new(0, 18, 0, 18)
buyBalIcon.Position = UDim2.new(1, -116 - 22, 0, 14)
buyBalIcon.BackgroundTransparency = 1; buyBalIcon.Image = WHITE_ROBUX
buyBalIcon.ZIndex = 33; buyBalIcon.Parent = buyPrompt

local buyBalAmt = lbl(buyPrompt, "0",
    UDim2.new(1, -116, 0, 12),
    UDim2.new(0, 82, 0, 22),
    Color3.fromRGB(210, 210, 210), 13, Enum.Font.GothamBold, Enum.TextXAlignment.Left, 33)

local buyDiv = Instance.new("Frame")
buyDiv.Size = UDim2.new(1, 0, 0, 1); buyDiv.Position = UDim2.new(0, 0, 0, 44)
buyDiv.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
buyDiv.BorderSizePixel = 0; buyDiv.ZIndex = 32; buyDiv.Parent = buyPrompt

local itemIcon = Instance.new("ImageLabel")
itemIcon.Size = UDim2.new(0, 54, 0, 54); itemIcon.Position = UDim2.new(0, 14, 0, 55)
itemIcon.BackgroundTransparency = 1; itemIcon.Image = WHITE_ROBUX
itemIcon.ZIndex = 32; itemIcon.Parent = buyPrompt
round(itemIcon, 10)

local itemName = lbl(buyPrompt, "", UDim2.new(0, 80, 0, 60), UDim2.new(1, -94, 0, 22),
    Color3.new(1, 1, 1), 14, Enum.Font.GothamBold, Enum.TextXAlignment.Left, 32)

local priceIconImg = Instance.new("ImageLabel")
priceIconImg.Size = UDim2.new(0, 18, 0, 18); priceIconImg.Position = UDim2.new(0, 80, 0, 88)
priceIconImg.BackgroundTransparency = 1; priceIconImg.Image = WHITE_ROBUX
priceIconImg.ZIndex = 33; priceIconImg.Parent = buyPrompt

local priceAmt = lbl(buyPrompt, "0", UDim2.new(0, 102, 0, 87), UDim2.new(0, 200, 0, 22),
    Color3.fromRGB(180, 180, 180), 14, Enum.Font.GothamBold, Enum.TextXAlignment.Left, 32)

-- Cooldown buy button
local buyBtnBg = Instance.new("Frame")
buyBtnBg.Size = UDim2.new(1, -28, 0, 44); buyBtnBg.Position = UDim2.new(0, 14, 1, -56)
buyBtnBg.BackgroundColor3 = Color3.fromRGB(18, 42, 100)
buyBtnBg.BorderSizePixel = 0; buyBtnBg.ZIndex = 32; buyBtnBg.Parent = buyPrompt
round(buyBtnBg, 9)

local clipFrame = Instance.new("Frame")
clipFrame.Size = UDim2.new(1, 0, 1, 0); clipFrame.BackgroundTransparency = 1
clipFrame.ClipsDescendants = true; clipFrame.ZIndex = 33; clipFrame.Parent = buyBtnBg

local buyFill = Instance.new("Frame")
buyFill.Size = UDim2.new(0, 0, 1, 0)
buyFill.BackgroundColor3 = Color3.fromRGB(0, 200, 255)
buyFill.BorderSizePixel = 0; buyFill.ZIndex = 34; buyFill.Parent = clipFrame
round(buyFill, 9)

lbl(buyBtnBg, "Buy", UDim2.new(0, 0, 0, 0), UDim2.new(1, 0, 1, 0),
    Color3.new(1, 1, 1), 18, Enum.Font.GothamBold, Enum.TextXAlignment.Center, 35)
local buyBtn = btn(buyBtnBg, "", UDim2.new(0, 0, 0, 0), UDim2.new(1, 0, 1, 0),
    Color3.fromRGB(0, 0, 0), Color3.new(1, 1, 1), 1, 36)
buyBtn.BackgroundTransparency = 1

-- ========================
-- SUCCESS PROMPT
-- ========================
local successPrompt = Instance.new("Frame")
successPrompt.Size = UDim2.new(0, 390, 0, 225)
successPrompt.Position = UDim2.new(0.5, -195, 0.5, -112)
successPrompt.BackgroundColor3 = Color3.fromRGB(4, 4, 4)
successPrompt.BorderSizePixel = 0; successPrompt.Visible = false; successPrompt.ZIndex = 31; successPrompt.Parent = gui
round(successPrompt, 12)

lbl(successPrompt, "Purchase completed", UDim2.new(0, 16, 0, 16), UDim2.new(1, -50, 0, 24),
    Color3.new(1, 1, 1), 16, Enum.Font.GothamBold, Enum.TextXAlignment.Left, 32)
local sXBtn = closeBtn(successPrompt, UDim2.new(1, -34, 0, 12), 32)

local sDiv = Instance.new("Frame")
sDiv.Size = UDim2.new(1, 0, 0, 1); sDiv.Position = UDim2.new(0, 0, 0, 48)
sDiv.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
sDiv.BorderSizePixel = 0; sDiv.ZIndex = 32; sDiv.Parent = successPrompt

local checkCircle = Instance.new("Frame")
checkCircle.Size = UDim2.new(0, 54, 0, 54); checkCircle.Position = UDim2.new(0.5, -27, 0, 64)
checkCircle.BackgroundColor3 = Color3.fromRGB(4, 4, 4)
checkCircle.BorderSizePixel = 0; checkCircle.ZIndex = 32; checkCircle.Parent = successPrompt
round(checkCircle, 27)
local cs = Instance.new("UIStroke"); cs.Color = Color3.fromRGB(200, 200, 200); cs.Thickness = 2; cs.Parent = checkCircle
lbl(checkCircle, "✓", UDim2.new(0, 0, 0, 0), UDim2.new(1, 0, 1, 0),
    Color3.new(1, 1, 1), 24, Enum.Font.GothamBold, Enum.TextXAlignment.Center, 33)

local successMsg = lbl(successPrompt, "", UDim2.new(0, 16, 0, 128), UDim2.new(1, -32, 0, 36),
    Color3.fromRGB(200, 200, 200), 13, Enum.Font.Gotham, Enum.TextXAlignment.Center, 32)
successMsg.TextWrapped = true

local okBtn = btn(successPrompt, "Ok", UDim2.new(0, 16, 0, 172), UDim2.new(1, -32, 0, 40),
    Color3.fromRGB(0, 162, 255), Color3.new(1, 1, 1), 16, 32)
round(okBtn, 8)

-- ========================
-- LOGIC
-- ========================
local COOLDOWN = 3
local cooldownDone = false
local cooldownActive = false

-- Store the original centred position of buyPrompt so we can animate from it
local BUY_ORIGIN_POS = buyPrompt.Position  -- UDim2.new(0.5, -195, 0.5, -100)

local function closeAll()
    overlay.Visible        = false
    buyPrompt.Visible      = false
    successPrompt.Visible  = false
    -- Position & transparency reset (animation restores children itself, but guard here too)
    buyPrompt.Position             = BUY_ORIGIN_POS
    buyPrompt.BackgroundTransparency = 0
    cooldownDone  = false
    cooldownActive = false
    buyFill.Size  = UDim2.new(0, 0, 1, 0)
end

local function startCooldown()
    if cooldownActive then return end
    cooldownActive = true; cooldownDone = false
    buyFill.Size = UDim2.new(0, 0, 1, 0)
    for i = 1, 60 do
        if not buyPrompt.Visible then break end
        buyFill.Size = UDim2.new(i/60, 0, 1, 0)
        task.wait(COOLDOWN / 60)
    end
    buyFill.Size = UDim2.new(1, 0, 1, 0)
    cooldownDone = true
    cooldownActive = false
end

local function spawnRobuxBurst()
    local char = player.Character
    if not char then return end

    local root = char:FindFirstChild("HumanoidRootPart")
    if not root then return end

    for i = 1, 15 do
        task.spawn(function()
            local bill = Instance.new("BillboardGui")
            bill.Size = UDim2.new(0, 40, 0, 40)
            bill.StudsOffset = Vector3.new(
                math.random(-3,3),
                math.random(2,5),
                math.random(-3,3)
            )
            bill.AlwaysOnTop = true
            bill.Parent = root

            local img = Instance.new("ImageLabel")
            img.Size = UDim2.new(1,0,1,0)
            img.BackgroundTransparency = 1
            img.Image = WHITE_ROBUX
            img.Parent = bill

            local start = bill.StudsOffset
            local goal = start + Vector3.new(
                math.random(-2,2),
                math.random(3,6),
                math.random(-2,2)
            )

            local startTime = tick()
            local duration = 1

            local conn
            conn = RunService.RenderStepped:Connect(function()
                local alpha = math.clamp((tick() - startTime) / duration, 0, 1)

                bill.StudsOffset = start:Lerp(goal, alpha)
                img.ImageTransparency = alpha
                img.Rotation += 4

                if alpha >= 1 then
                    conn:Disconnect()
                    bill:Destroy()
                end
            end)
        end)

        task.wait(0.04)
    end
end

local function animateBuyToSuccess(cost, uname)
    local slideDuration = 0.32
    local tweenInfo = TweenInfo.new(slideDuration, Enum.EasingStyle.Quad, Enum.EasingDirection.In)

    local slideGoal = UDim2.new(
        BUY_ORIGIN_POS.X.Scale, BUY_ORIGIN_POS.X.Offset,
        BUY_ORIGIN_POS.Y.Scale, BUY_ORIGIN_POS.Y.Offset + 48
    )

    -- Snapshot originals so we can restore after the animation
    -- key = GuiObject, value = { bg, text, image }
    local snapshots = {}
    local function snapshot(d)
        local s = { bg = d.BackgroundTransparency }
        if d:IsA("TextLabel") or d:IsA("TextButton") then
            s.text = d.TextTransparency
        end
        if d:IsA("ImageLabel") or d:IsA("ImageButton") then
            s.img = d.ImageTransparency
        end
        snapshots[d] = s
    end

    snapshot(buyPrompt)
    for _, d in ipairs(buyPrompt:GetDescendants()) do
        if d:IsA("GuiObject") then snapshot(d) end
    end

    -- Build tweens with ONLY valid (non-nil) properties per type
    local allTweens = {}

    -- Main frame: slide + fade background
    table.insert(allTweens, TweenService:Create(buyPrompt, tweenInfo, {
        Position             = slideGoal,
        BackgroundTransparency = 1,
    }))

    for _, d in ipairs(buyPrompt:GetDescendants()) do
        if d:IsA("TextLabel") or d:IsA("TextButton") then
            table.insert(allTweens, TweenService:Create(d, tweenInfo, {
                BackgroundTransparency = 1,
                TextTransparency       = 1,
            }))
        elseif d:IsA("ImageLabel") or d:IsA("ImageButton") then
            table.insert(allTweens, TweenService:Create(d, tweenInfo, {
                BackgroundTransparency = 1,
                ImageTransparency      = 1,
            }))
        elseif d:IsA("Frame") then
            table.insert(allTweens, TweenService:Create(d, tweenInfo, {
                BackgroundTransparency = 1,
            }))
        end
    end

    -- Play all tweens simultaneously
    for _, t in ipairs(allTweens) do t:Play() end
    allTweens[1].Completed:Wait()   -- wait on the main frame tween

    -- ── Hide prompt ──────────────────────────────────────────────────────────
    buyPrompt.Visible = false

    -- ── Fully restore ALL transparencies so the next purchase works ──────────
    buyPrompt.Position             = BUY_ORIGIN_POS
    buyPrompt.BackgroundTransparency = snapshots[buyPrompt].bg
    for _, d in ipairs(buyPrompt:GetDescendants()) do
        local s = snapshots[d]
        if s then
            d.BackgroundTransparency = s.bg
            if s.text ~= nil then
                (d :: TextLabel).TextTransparency = s.text
            end
            if s.img ~= nil then
                (d :: ImageLabel).ImageTransparency = s.img
            end
        end
    end

    -- ── Show success ─────────────────────────────────────────────────────────
    successMsg.Text = "You have successfully gifted " .. formatNum(cost) .. " Robux @" .. uname
    successPrompt.Visible = true
end

local function showBuyPrompt()
    local rawAmt = amtBox.Text:gsub("[^%d]",""); if rawAmt == "" then rawAmt = "1000" end
    local uname = (currentUsername ~= "" and currentUsername)
        or (searchInput.Text ~= "" and searchInput.Text) or "Player"
    local amtNum = tonumber(rawAmt) or 1000
    local fmtAmt = formatNum(amtNum)
    itemName.Text = fmtAmt .. " Robux @" .. uname
    priceAmt.Text = fmtAmt
    buyBalAmt.Text = formatNum(parseNumber(balTB.Text))

    -- Fully reset buyPrompt before showing so previous animation doesn't leave it invisible
    buyPrompt.Position             = BUY_ORIGIN_POS
    buyPrompt.BackgroundTransparency = 0
    for _, d in ipairs(buyPrompt:GetDescendants()) do
        if d:IsA("TextLabel") or d:IsA("TextButton") then
            d.TextTransparency       = 0
            d.BackgroundTransparency = 1   -- text elements are background-transparent by design
        elseif d:IsA("ImageLabel") or d:IsA("ImageButton") then
            d.ImageTransparency      = 0
            d.BackgroundTransparency = 1
        elseif d:IsA("Frame") then
            -- frames that are meant to be visible keep their original BT;
            -- we can't know original per-frame BT here, so only reset fully-transparent ones
            -- The animation restores non-zero BT frames itself, so this is a safety net
        end
    end

    overlay.Visible        = true
    buyPrompt.Visible      = true
    successPrompt.Visible  = false
    cooldownDone           = false
    cooldownActive         = false
    buyFill.Size           = UDim2.new(0, 0, 1, 0)
    task.spawn(startCooldown)
end

buyBtn.MouseButton1Click:Connect(function()
    if not cooldownDone or cooldownActive then return end

    local cost = parseNumber(amtBox.Text)
    local newBal = math.max(0, parseNumber(balTB.Text) - cost)
    balTB.Text = formatNum(newBal)
    buyBalAmt.Text = formatNum(newBal)

    local uname = (currentUsername ~= "" and currentUsername)
        or (searchInput.Text ~= "" and searchInput.Text) or "Player"

task.spawn(function()
    spawnRobuxBurst()
    animateBuyToSuccess(cost, uname)
end)

confirmBtn.MouseButton1Click:Connect(function()
    if searchInput.Text ~= "" and currentUserId == nil then
        searchUser(searchInput.Text); task.wait(0.5)
    end
    modal.Visible = false
    showBuyPrompt()
end)

buyXBtn.MouseButton1Click:Connect(function() closeAll(); modal.Visible = true end)
okBtn.MouseButton1Click:Connect(closeAll)
sXBtn.MouseButton1Click:Connect(closeAll) 
