--- espLib settings


local espLib = {
    drawings = {},
    instances = {},
    espCache = {},
    chamsCache = {},
    objectCache = {},
    conns = {},
    whitelist = {}, -- insert string that is the player's name you want to whitelist (turns esp color to whitelistColor in options)
    blacklist = {}, -- insert string that is the player's name you want to blacklist (removes player from esp)
    options = {
        enabled = true,
        minScaleFactorX = 1,
        maxScaleFactorX = 10,
        minScaleFactorY = 1,
        maxScaleFactorY = 10,
        boundingBox = false, -- WARNING | Significant Performance Decrease when true
        boundingBoxDescending = true,
        font = 2,
        fontSize = 13,
        limitDistance = false,
        maxDistance = 1000,
        visibleOnly = false,
        teamCheck = false,
        teamColor = false,
        fillColor = nil,
        whitelistColor = Color3.new(1, 0, 0),
        outOfViewArrows = true,
        outOfViewArrowsFilled = true,
        outOfViewArrowsSize = 25,
        outOfViewArrowsRadius = 100,
        outOfViewArrowsColor = Color3.new(1, 1, 1),
        outOfViewArrowsTransparency = 0.5,
        outOfViewArrowsOutline = true,
        outOfViewArrowsOutlineFilled = false,
        outOfViewArrowsOutlineColor = Color3.new(1, 1, 1),
        outOfViewArrowsOutlineTransparency = 1,
        names = true,
        nameTransparency = 1,
        nameColor = Color3.new(1, 1, 1),
        boxes = true,
        boxesTransparency = 1,
        boxesColor = Color3.new(1, 0, 0),
        boxFill = false,
        boxFillTransparency = 0.5,
        boxFillColor = Color3.new(1, 0, 0),
        healthBars = true,
        healthBarsSize = 1,
        healthBarsTransparency = 1,
        healthBarsColor = Color3.new(0, 1, 0),
        healthText = true,
        healthTextTransparency = 1,
        healthTextSuffix = "%",
        healthTextColor = Color3.new(1, 1, 1),
        distance = true,
        distanceTransparency = 1,
        distanceSuffix = " Studs",
        distanceColor = Color3.new(1, 1, 1),
        tracers = false,
        tracerTransparency = 1,
        tracerColor = Color3.new(1, 1, 1),
        tracerOrigin = "Bottom", -- Available [Mouse, Top, Bottom]
        chams = true,
        chamsFillColor = Color3.new(1, 0, 0),
        chamsFillTransparency = 0.5,
        chamsOutlineColor = Color3.new(),
        chamsOutlineTransparency = 0
    },
};
-- checking for required functions
assert(syn, game.StarterGui:SetCore("SendNotification", {Title = "Error!", Text = "You are not running Synapse X! You will be allowed to run this script but you may get detected and some stuff may not work.", Duration = "8"}))

local espLib = loadstring(game:HttpGet(('https://raw.githubusercontent.com/shlexware/Sirius/request/library/esp/esp.lua'),true))()



local function Discord()
    pcall(function() syn.request({
        Url = "http://127.0.0.1:6463/rpc?v=1",
        Method = "POST",
        Headers = {
        ["Content-Type"] = "application/json",
        ["Origin"] = "https://discord.com"
    },
    Body = game:GetService("HttpService"):JSONEncode({
        cmd = "INVITE_BROWSER",
        args = {
            code = "qd42wQz3HZ"
    },
        nonce = game:GetService("HttpService"):GenerateGUID(false)
    }),
    }) 
    end)

end

local function DemeterDiscord()
    pcall(function()
        syn.request({
            Url = "http://127.0.0.1:6463/rpc?v=1",
            Method = "POST",
            Headers = {
            ["Content-Type"] = "application/json",
            ["Origin"] = "https://discord.com"
        },
        Body = game:GetService("HttpService"):JSONEncode({
            cmd = "INVITE_BROWSER",
            args = {
                code = "Z8SzT4AK"
        },
            nonce = game:GetService("HttpService"):GenerateGUID(false)
        }),
        }) 
    end)
end



local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local LocalPlayer = game:GetService("Players").LocalPlayer
local Mouse = LocalPlayer:GetMouse()
local HttpService = game:GetService("HttpService") 

local Library = {
    Connections = {}
}  

local function AddConnection(Signal, Function)
	if (not Library:IsRunning()) then return end
    local Connection = Signal:Connect(Function)
	table.insert(Library.Connections, Connection)
    return Connection
end

pcall(function()
    shared.NapkinLibrary:Destroy()
end)

local function Create(Name, Properties, Children)
    local Object = Instance.new(Name)
    for i, v in next, Properties or {} do
        Object[i] = v
    end
    for i, v in next, Children or {} do
		v.Parent = Object
	end
    return Object
end

local function Round(Number, Factor)
    local Result = math.floor(Number/Factor + (math.sign(Number) * 0.5)) * Factor
    if Result < 0 then Result = Result + Factor end
    return Result
end

local function MakeDraggable(DragPoint, Main)
    pcall(function()
        local Dragging, DragInput, MousePos, FramePos = false
        AddConnection(DragPoint.InputBegan, function(Input)
            if Input.UserInputType == Enum.UserInputType.MouseButton1 then
                Dragging = true
                MousePos = Input.Position
                FramePos = Main.Position
    
                AddConnection(Input.Changed, function()
                    if Input.UserInputState == Enum.UserInputState.End then
                        Dragging = false
                    end
                end)
            end
        end)
        AddConnection(DragPoint.InputChanged, function(Input)
            if Input.UserInputType == Enum.UserInputType.MouseMovement then
                DragInput = Input
            end
        end)
        AddConnection(UserInputService.InputChanged, function(Input)
            if Input == DragInput and Dragging then
                local Delta = Input.Position - MousePos
                Main.Position  = UDim2.new(FramePos.X.Scale,FramePos.X.Offset + Delta.X, FramePos.Y.Scale, FramePos.Y.Offset + Delta.Y)
            end
        end)
    end)
end

local WhitelistedMouse = {Enum.UserInputType.MouseButton1, Enum.UserInputType.MouseButton2,Enum.UserInputType.MouseButton3}
local BlacklistedKeys = {Enum.KeyCode.Unknown,Enum.KeyCode.W,Enum.KeyCode.A,Enum.KeyCode.S,Enum.KeyCode.D,Enum.KeyCode.Up,Enum.KeyCode.Left,Enum.KeyCode.Down,Enum.KeyCode.Right,Enum.KeyCode.Slash,Enum.KeyCode.Tab,Enum.KeyCode.Backspace,Enum.KeyCode.Escape}

local function CheckKey(Table, Key)
    for _, v in next, Table do
        if v == Key then
            return true
        end
    end
end

local function Ripple(Object)
    local Circle = Create("ImageLabel", {
        Parent = Object,
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        BackgroundTransparency = 1,
        Image = "rbxassetid://266543268",
        ImageColor3 = Color3.fromRGB(210,210,210),
        ImageTransparency = 0.88
    })
    Circle.Position = UDim2.new(0, Mouse.X - Circle.AbsolutePosition.X, 0, Mouse.Y - Circle.AbsolutePosition.Y)
    local Size = Object.AbsoluteSize.X / 1.5
    TweenService:Create(Circle, TweenInfo.new(0.5), {Position = UDim2.fromScale(math.clamp(Mouse.X - Object.AbsolutePosition.X, 0, Object.AbsoluteSize.X)/Object.AbsoluteSize.X,Object,math.clamp(Mouse.Y - Object.AbsolutePosition.Y, 0, Object.AbsoluteSize.Y)/Object.AbsoluteSize.Y) - UDim2.fromOffset(Size/2,Size/2), ImageTransparency = 1, Size = UDim2.fromOffset(Size,Size)}):Play()
    spawn(function()
        wait(0.5)
        Circle:Destroy()
    end)
end 


local GUI = Instance.new('ScreenGui')
syn.protect_gui(GUI)
GUI.Parent = game.CoreGui
shared.NapkinLibrary = GUI

function Library:IsRunning()
	return GUI.Parent == game:GetService("CoreGui")
end

task.spawn(function()
	while (Library:IsRunning()) do wait() end
	for _, Connection in next, Library.Connections do Connection:Disconnect() end
end)

local NotificationHolder = Create("Frame", {
    Position = UDim2.new(1, -15, 1, -15),
    Size = UDim2.new(0, 230, 1, -15),
	AnchorPoint = Vector2.new(1, 1),
    BackgroundTransparency = 1,
	Parent = GUI
}, {
    Create("UIListLayout", {
        HorizontalAlignment = Enum.HorizontalAlignment.Center,
        SortOrder = Enum.SortOrder.LayoutOrder,
        VerticalAlignment = Enum.VerticalAlignment.Bottom
    })
})


function Library.Notification(NotificationConfig)
	NotificationConfig.Title = NotificationConfig.Title or "Notification"
	NotificationConfig.Content = NotificationConfig.Content or "Content"
	NotificationConfig.Delay = NotificationConfig.Delay or 5

    local NotificationBody = Create("TextButton", {
        Size = UDim2.new(1, 0, 0, 0),
		BackgroundTransparency = 1,
        Text = "",
		Parent = NotificationHolder
    })

    local DurationBar = Create("Frame", {
        Parent = NotificationBody,
        Size = UDim2.new(1, -24, 0, 3),
        Position = UDim2.new(0, 12, 1, -12),
        BackgroundColor3 = Color3.fromRGB(37, 37, 37),
        BorderSizePixel = 0
    }, {
        Create("UICorner", {CornerRadius = UDim.new(0, 3)})
    })

    local NotificationFrame = Create("Frame", {
        Parent = NotificationBody,
        Size = UDim2.new(1, 0, 0, 0),
        Position = UDim2.new(1, 15, 0, 5),
        BackgroundColor3 = Color3.fromRGB(27, 27, 27)
    }, {
        Create("UICorner", {CornerRadius = UDim.new(0, 8)}),
        Create("TextLabel", {
            BackgroundTransparency = 1,
            Position = UDim2.new(0, 12, 0, 12),
            Size = UDim2.new(1, -24, 0, 10),
            Font = Enum.Font.GothamSemibold,
            Text = NotificationConfig.Title,
            TextXAlignment = Enum.TextXAlignment.Left,
            TextColor3 = Color3.fromRGB(180, 180, 180),
            TextSize = 13,
            RichText = true,
            Name = "Title"
        }),
        Create("TextLabel", {
            BackgroundTransparency = 1,
            Position = UDim2.new(0, 12, 0, 12),
            Size = UDim2.new(1, -24, 0, 10),
            Font = Enum.Font.GothamSemibold,
            Text = "",
            TextXAlignment = Enum.TextXAlignment.Right,
            TextColor3 = Color3.fromRGB(180, 180, 180),
            TextSize = 13,
            RichText = true,
            Name = "Time"
        }),
        Create("TextLabel", {
            BackgroundTransparency = 1,
            Position = UDim2.new(0, 12, 0, 11),
            Size = UDim2.new(1, -24, 1, -15),
            Font = Enum.Font.Gotham,
            Text = NotificationConfig.Content,
            TextXAlignment = Enum.TextXAlignment.Left,
            TextColor3 = Color3.fromRGB(255, 255, 255),
            TextSize = 13,
            RichText = true,
            TextWrapped = true,
            Name = "Content"
        }),
        Create("Frame", {
            Parent = NotificationBody,
            Size = UDim2.new(1, -24, 0, 3),
            Position = UDim2.new(0, 12, 1, -12),
            BackgroundColor3 = Color3.fromRGB(32, 32, 32),
            BorderSizePixel = 0
        }, {
            Create("UICorner", {CornerRadius = UDim.new(0, 3)})
        }),
        DurationBar
    })

    spawn(function()
		for i = NotificationConfig.Delay, 0, -1 do
			NotificationFrame.Time.Text = i .. "s"
			wait(1)
		end
	end)

    NotificationFrame.Size = UDim2.new(1, 0, 0, NotificationFrame.Content.TextBounds.Y + 42)
    TweenService:Create(NotificationBody,TweenInfo.new(0.25, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),{Size = UDim2.new(1, 0, 0, NotificationFrame.Content.TextBounds.Y + 48)}):Play()
    TweenService:Create(DurationBar,TweenInfo.new(NotificationConfig.Delay, Enum.EasingStyle.Linear, Enum.EasingDirection.Out),{Size = UDim2.new(0, 0, 0, 3)}):Play()
    delay(0.15, function()
        TweenService:Create(NotificationFrame,TweenInfo.new(0.25, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),{Position = UDim2.new(0,0,0,5)}):Play()
    end)
    delay(NotificationConfig.Delay, function()
        TweenService:Create(NotificationFrame,TweenInfo.new(0.25, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),{Position = UDim2.new(1,15,0,5)}):Play()
        delay(0.15, function()
            TweenService:Create(NotificationBody,TweenInfo.new(0.25, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),{Size = UDim2.new(1, 0, 0, 0)}):Play()
        end)
    end)
end    

function Library.Load(LibConfig)
    LibConfig = LibConfig or {}
    LibConfig.Title = LibConfig.Title or "Title"
    local MenuToggle = false
    local FirstTab = false
    
    if string.find(LibConfig.Title, 'AeroX') then
        print('AeroX')
        Discord()
    elseif string.find(LibConfig.Title, 'LKHUB') then
        print('LKHUB')
        Discord()
    elseif string.find(LibConfig.Title, 'rgon') then
        print(
            'Argon'
        )
        DemeterDiscord()
    elseif string.find(LibConfig.Title, 'emeter') then
        print('Demeter')
        DemeterDiscord()
    end   

    function CheckForValidScript()
        if string.find(LibConfig.Title, 'AeroX') then
            print('AeroX')
            
        elseif string.find(LibConfig.Title, 'LKHUB') then
            print('LKHUB')
        elseif string.find(LibConfig.Title, 'rgon') then
            print(
                'Argon'
            )
        elseif string.find(LibConfig.Title, 'et') then
            print('Demeter')
            
        else
            Library.Notification({Title = 'Warning', Content = 'Please do NOT attempt to crack this UI library', Delay = 5})
            task.wait(5)
            while true do end  
        end
    end

    CheckForValidScript()

    local ExitBtn = Create("TextButton", {
        BackgroundTransparency = 1,
        Position = UDim2.new(1, -34, 0, 4),
        Size = UDim2.new(1, -8, 1, -8),
        SizeConstraint = Enum.SizeConstraint.RelativeYY,
        Text = ""
    }, {
        Create("Frame", {
            AnchorPoint = Vector2.new(0.5, 0.5),
            BackgroundColor3 = Color3.fromRGB(38, 38, 38),
            BackgroundTransparency = 1,
            Position = UDim2.new(0.5, 0, 0.5, 0),
            Size = UDim2.new(0.8, 0, 0.8, 0),
            Name = "Hover"
        }, {
            Create("UICorner", {CornerRadius = UDim.new(0, 8)})
        }),
        Create("ImageLabel", {
            BackgroundTransparency = 1,
            Position = UDim2.new(0.5, -9, 0.5, -9),
            Size = UDim2.new(0, 18, 0, 18),
            Image = "rbxassetid://6235536018",
            ImageColor3 = Color3.fromRGB(180, 180, 180),
            ScaleType = Enum.ScaleType.Crop,
            Name = "Ico"
        })
    })

    AddConnection(ExitBtn.MouseEnter, function()
        TweenService:Create(ExitBtn.Hover, TweenInfo.new(0.25, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 0}):Play()
        TweenService:Create(ExitBtn.Ico, TweenInfo.new(0.25, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {ImageColor3 = Color3.fromRGB(255, 0, 68)}):Play()
    end)

    AddConnection(ExitBtn.MouseLeave, function()
        TweenService:Create(ExitBtn.Hover, TweenInfo.new(0.25, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {Size = UDim2.new(0.8, 0, 0.8, 0), BackgroundTransparency = 1}):Play()
        TweenService:Create(ExitBtn.Ico, TweenInfo.new(0.25, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {ImageColor3 = Color3.fromRGB(180, 180, 180)}):Play()
    end)
    AddConnection(ExitBtn.MouseButton1Click, function()
        shared.NapkinLibrary:Destroy()
    end)
    
    local MenuBtn = Create("TextButton", {
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 4, 0, 4),
        Size = UDim2.new(1, -8, 1, -8),
        SizeConstraint = Enum.SizeConstraint.RelativeYY,
        Text = ""
    }, {
        Create("Frame", {
            AnchorPoint = Vector2.new(0.5, 0.5),
            BackgroundColor3 = Color3.fromRGB(38, 38, 38),
            BackgroundTransparency = 1,
            Position = UDim2.new(0.5, 0, 0.5, 0),
            Size = UDim2.new(0.8, 0, 0.8, 0),
            Name = "Hover"
        }, {
            Create("UICorner", {CornerRadius = UDim.new(0, 8)})
        }),
        Create("ImageLabel", {
            BackgroundTransparency = 1,
            Position = UDim2.new(0.5, -8, 0.5, -8),
            Size = UDim2.new(0, 16, 0, 16),
            Image = "rbxassetid://7072718840",
            ImageColor3 = Color3.fromRGB(180, 180, 180),
            ScaleType = Enum.ScaleType.Crop,
            Name = "Ico"
        })
    })

    AddConnection(MenuBtn.MouseEnter, function()
        TweenService:Create(MenuBtn.Hover, TweenInfo.new(0.25, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 0}):Play()
        TweenService:Create(MenuBtn.Ico, TweenInfo.new(0.25, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {ImageColor3 = Color3.fromRGB(255, 255, 255)}):Play()
        CheckForValidScript()
    end)

    AddConnection(MenuBtn.MouseLeave, function()
        TweenService:Create(MenuBtn.Hover, TweenInfo.new(0.25, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {Size = UDim2.new(0.8, 0, 0.8, 0), BackgroundTransparency = 1}):Play()
        TweenService:Create(MenuBtn.Ico, TweenInfo.new(0.25, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {ImageColor3 = Color3.fromRGB(180, 180, 180)}):Play()
    end)
    
       

    local MenuFrame = Create("Frame", {
        BackgroundColor3 = Color3.fromRGB(27, 27, 27),
        BorderSizePixel = 0,
        Position = UDim2.new(-1, -5, 0, 0),
        Size = UDim2.new(1, 0, 1, 0)
    }, {
        Create("UICorner", {CornerRadius = UDim.new(0, 5)}),
        Create("Frame", {
            BackgroundColor3 = Color3.fromRGB(27, 27, 27),
            BorderSizePixel = 0,
            Position = UDim2.new(1, -5, 0, 0),
            Size = UDim2.new(0, 5, 1, 0)
        }),
        Create("Frame", {
            BackgroundColor3 = Color3.fromRGB(27, 27, 27),
            BorderSizePixel = 0,
            Size = UDim2.new(1, 0, 0, 5)
        }),
        Create("Frame", {
            BackgroundColor3 = Color3.fromRGB(50, 50, 50),
            BackgroundTransparency = 0.5,
            BorderSizePixel = 0,
            Position = UDim2.new(1, -1, 0, 0),
            Size = UDim2.new(0, 1, 1, 0)
        }),
        Create("Frame", {
            BackgroundColor3 = Color3.fromRGB(255, 255, 255),
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 1, 0),
            Name = "Container"
        }, {
            Create("UIPadding", {
                PaddingBottom = UDim.new(0, 10),
                PaddingTop = UDim.new(0, 10)
            }),
            Create("UIListLayout")
        })
    })

    local MainFrame = Create("Frame", {
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundColor3 = Color3.fromRGB(25, 25, 25),
        Position = UDim2.new(0.5, 0, 0.5, 0),
        Size = UDim2.new(0, 480, 0, 380),
        Parent = GUI
    }, {
        Create("UICorner", {CornerRadius = UDim.new(0, 5)}),
        Create("ImageLabel", {
            BackgroundTransparency = 1,
            Position = UDim2.new(0, -15, 0, -15),
            Size = UDim2.new(1, 30, 1, 30),
            Image = "http://www.roblox.com/asset/?id=5554236805",
            ImageColor3 = Color3.fromRGB(10, 10, 10),
            ScaleType = Enum.ScaleType.Slice,
            SliceCenter = Rect.new(23, 23, 277, 277)
        }),
        Create("Folder", {Name = "Container"}),
        Create("TextButton", {
            Size = UDim2.new(1, 0, 1, -38),
            Position = UDim2.new(0, 0, 0, 38),
            BackgroundColor3 = Color3.fromRGB(0, 0, 0),
            BackgroundTransparency = 1,
            Text = "",
            AutoButtonColor = false,
            Name = "Darken",
            BorderSizePixel = 0,
            Visible = false
        }),
        Create("Frame", {
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            ClipsDescendants = true,
            Position = UDim2.new(0, 0, 0, 36),
            Size = UDim2.new(0.4, 0, 1, -36)
        }, {
            MenuFrame
        }),
        Create("Frame", {
            BackgroundColor3 = Color3.fromRGB(27, 27, 27),
            Size = UDim2.new(1, 0, 0, 38),
            Position = UDim2.new(0, 0, 0, -1),
            Name = "TopBar"
        }, {
            Create("UICorner", {CornerRadius = UDim.new(0, 5)}),
            Create("Frame", {
                BackgroundColor3 = Color3.fromRGB(27, 27, 27),
                BorderSizePixel = 0,
                Position = UDim2.new(0, 0, 1, -5),
                Size = UDim2.new(1, 0, 0, 5)
            }),
            Create("Frame", {
                BackgroundColor3 = Color3.fromRGB(50, 50, 50),
                BackgroundTransparency = 0.4,
                BorderSizePixel = 0,
                Position = UDim2.new(0, 0, 1, 0),
                Size = UDim2.new(1, 0, 0, 1)
            }),
            Create("TextLabel", {
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 1, 0),
                Font = Enum.Font.Gotham,
                Text = LibConfig.Title,
                TextColor3 = Color3.fromRGB(180, 180, 180),
                TextSize = 14,
                RichText = true
            }),
            ExitBtn,
            MenuBtn
        })
    })

    AddConnection(MenuBtn.MouseButton1Click, function()
        MenuToggle = not MenuToggle
        TweenService:Create(MenuFrame, TweenInfo.new(0.25, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {Position = MenuToggle and UDim2.new(0, 0, 0, 0) or UDim2.new(-1, -5, 0, 0)}):Play()
        TweenService:Create(MainFrame.Darken, TweenInfo.new(0.25, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {BackgroundTransparency = MenuToggle and 0.8 or 1}):Play()
        MainFrame.Darken.Visible = MenuToggle 	
    end)

    MakeDraggable(MainFrame.TopBar, MainFrame)
    
    return {AddTab = function(TabTitle)
        local TabBtn = Create("TextButton", {
            Parent = MenuFrame.Container,
            BackgroundColor3 = Color3.fromRGB(0, 150, 100),
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            Size = UDim2.new(1, 0, 0, 35),
            Text = "",
            AutoButtonColor = false
        }, {
            Create("TextLabel", {
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 10, 0, 0),
                Size = UDim2.new(1, -10, 1, 0),
                Font = Enum.Font.Gotham,
                Text = TabTitle,
                TextColor3 = Color3.fromRGB(165, 165, 165),
                TextSize = 14,
                TextXAlignment = Enum.TextXAlignment.Left,
                Name = "Title"
            })
        })

        local Container = Create("ScrollingFrame", {
            Parent = MainFrame.Container,
            Size = UDim2.new(1, 0, 1, -38),
            Position = UDim2.new(0, 0, 0, 38),
            BackgroundTransparency = 1,
            Visible = false,
            MidImage = "rbxassetid://7445543667",
            BottomImage = "rbxassetid://7445542488",
            TopImage = "rbxassetid://7445543667",
            ScrollBarImageColor3 = Color3.fromRGB(27, 27, 27),
            ScrollBarThickness = 6,
            CanvasSize = UDim2.new(0, 0, 0, 0),
            BorderSizePixel = 0
        }, {
            Create("UIPadding", {
                PaddingBottom = UDim.new(0, 14),
                PaddingTop = UDim.new(0, 14),
                PaddingLeft = UDim.new(0, 16),
                PaddingRight = UDim.new(0, 16),
            }),
            Create("UIListLayout", {Padding = UDim.new(0, 12)})
        })

        AddConnection(Container.UIListLayout:GetPropertyChangedSignal("AbsoluteContentSize"), function()
            Container.CanvasSize = UDim2.new(0,0,0,Container.UIListLayout.AbsoluteContentSize.Y + 28)
        end)

        if FirstTab == false then
            FirstTab = true
            Container.Visible = true
            TabBtn.BackgroundTransparency = 0
            TabBtn.Title.TextColor3 = Color3.fromRGB(255, 255, 255)
        end    

        AddConnection(TabBtn.MouseButton1Click, function()
            for i, v in next, MenuFrame.Container:GetChildren() do
                if v:IsA("TextButton") then
                    TweenService:Create(v, TweenInfo.new(0.25, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {BackgroundTransparency = 1}):Play()
                    TweenService:Create(v.Title, TweenInfo.new(0.25, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {TextColor3 = Color3.fromRGB(165, 165, 165)}):Play()
                end    
            end
            for i, v in next, MainFrame.Container:GetChildren() do
                if v:IsA("ScrollingFrame") then
                    v.Visible = false
                end    
            end
            TweenService:Create(TabBtn, TweenInfo.new(0.25, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {BackgroundTransparency = 0}):Play()    
            TweenService:Create(TabBtn.Title, TweenInfo.new(0.25, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {TextColor3 = Color3.fromRGB(255, 255, 255)}):Play()
            Container.Visible = true
        end)

        return {AddSection = function(SectionName) 
            local SectionContainer = Create("Frame", {
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 0, 0, 16),
                Size = UDim2.new(1, 0, 0, 0),
                Name = "Container"
            }, {
                Create("UIListLayout", {Padding = UDim.new(0, 6)})
            })

            local SectionFrame = Create("Frame", {
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 0, 0),
                Parent = Container
            }, {
                Create("TextLabel", {
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, -10, 0, 10),
                    Font = Enum.Font.GothamSemibold,
                    TextColor3 = Color3.fromRGB(165, 165, 165),
                    TextSize = 12,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Text = string.upper(SectionName)
                }),
                SectionContainer
            })

            AddConnection(SectionContainer.UIListLayout:GetPropertyChangedSignal("AbsoluteContentSize"), function()
                SectionContainer.Size = UDim2.new(1,0,0,SectionContainer.UIListLayout.AbsoluteContentSize.Y)
                SectionFrame.Size = UDim2.new(1,0,0,SectionContainer.UIListLayout.AbsoluteContentSize.Y + 16)
            end)

            return {
                AddButton = function(ButtonConfig)
                    ButtonConfig = ButtonConfig or {}
                    ButtonConfig.Name = ButtonConfig.Name or "Button"
                    ButtonConfig.Callback = ButtonConfig.Callback or function() end

                    local ButtonFrame = Create("TextButton", {
                        BackgroundColor3 = Color3.fromRGB(28, 28, 28),
                        Size = UDim2.new(1, 0, 0, 32),
                        Parent = SectionContainer,
                        AutoButtonColor = false,
                        ClipsDescendants = true,
                        Text = ""
                    }, {
                        Create("UICorner", {CornerRadius = UDim.new(0, 5)}),
                        Create("TextLabel", {
                            BackgroundTransparency = 1,
                            Position = UDim2.new(0, 10, 0, 0),
                            Size = UDim2.new(1, -10, 1, 0),
                            Font = Enum.Font.Gotham,
                            TextColor3 = Color3.fromRGB(255, 255, 255),
                            TextSize = 13,
                            TextXAlignment = Enum.TextXAlignment.Left,
                            Text = ButtonConfig.Name
                        })
                    })

                    AddConnection(ButtonFrame.MouseEnter, function()
                        TweenService:Create(ButtonFrame, TweenInfo.new(0.25, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {BackgroundColor3 = Color3.fromRGB(30, 30, 30)}):Play()
                    end)

                    AddConnection(ButtonFrame.MouseLeave, function()
                        TweenService:Create(ButtonFrame, TweenInfo.new(0.25, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {BackgroundColor3 = Color3.fromRGB(28, 28, 28)}):Play()
                    end)

                    AddConnection(ButtonFrame.MouseButton1Down, function()
                        TweenService:Create(ButtonFrame, TweenInfo.new(0.25, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {BackgroundColor3 = Color3.fromRGB(33, 33, 33)}):Play()
                    end)

                    AddConnection(ButtonFrame.MouseButton1Up, function()
                        TweenService:Create(ButtonFrame, TweenInfo.new(0.25, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {BackgroundColor3 = Color3.fromRGB(30, 30, 30)}):Play()
                        Ripple(ButtonFrame)
                        ButtonConfig.Callback()
                    end)
                end,
                AddToggle = function(ToggleConfig)
                    ToggleConfig = ToggleConfig or {}
                    ToggleConfig.Name = ToggleConfig.Name or "Toggle"
                    ToggleConfig.Default = ToggleConfig.Default or false
                    ToggleConfig.Callback = ToggleConfig.Callback or function() end

                    local Toggle = {Value = ToggleConfig.Default, Type = "Toggle"}

                    local TogglePopUp = Create("Frame", {
                        AnchorPoint = Vector2.new(0.5, 0.5),
                        BackgroundColor3 = Color3.fromRGB(0, 150, 100),
                        Position = UDim2.new(0.5, 0, 0.5, 0),
                        Size = UDim2.new(0.5, 0, 0.5, 0),
                        BackgroundTransparency = 1,
                        BorderSizePixel = 0
                    }, {
                        Create("UICorner", {CornerRadius = UDim.new(0, 5)}),
                        Create("ImageLabel", {
                            AnchorPoint = Vector2.new(0.5, 0.5),
                            BackgroundTransparency = 1,
                            Position = UDim2.new(0.5, 0, 0.5, 0),
                            Size = UDim2.new(1, -2, 1, -2),
                            Image = "http://www.roblox.com/asset/?id=6031094667",
                            ImageTransparency = 1,
                            Name = "Ico"
                        })
                    })

                    local ToggleBox = Create("Frame", {
                        AnchorPoint = Vector2.new(1, 0.5),
                        BackgroundColor3 = Color3.fromRGB(28, 28, 28),
                        Position = UDim2.new(1, -10, 0.5, 0),
                        Size = UDim2.new(0, 20, 0, 20),
                        BackgroundTransparency = 1
                    }, {
                        Create("UICorner", {CornerRadius = UDim.new(0, 5)}),
                        Create("UIStroke", {Color = Color3.fromRGB(55, 55, 55)}),
                        TogglePopUp
                    })

                    local ToggleFrame = Create("TextButton", {
                        BackgroundColor3 = Color3.fromRGB(28, 28, 28),
                        Size = UDim2.new(1, 0, 0, 32),
                        Parent = SectionContainer,
                        AutoButtonColor = false,
                        ClipsDescendants = true,
                        Text = ""
                    }, {
                        Create("UICorner", {CornerRadius = UDim.new(0, 5)}),
                        Create("TextLabel", {
                            BackgroundTransparency = 1,
                            Position = UDim2.new(0, 10, 0, 0),
                            Size = UDim2.new(1, -10, 1, 0),
                            Font = Enum.Font.Gotham,
                            TextColor3 = Color3.fromRGB(255, 255, 255),
                            TextSize = 13,
                            TextXAlignment = Enum.TextXAlignment.Left,
                            Text = ToggleConfig.Name
                        }),
                        ToggleBox
                    })

                    AddConnection(ToggleFrame.MouseEnter, function()
                        TweenService:Create(ToggleFrame, TweenInfo.new(0.25, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {BackgroundColor3 = Color3.fromRGB(30, 30, 30)}):Play()
                    end)

                    AddConnection(ToggleFrame.MouseLeave, function()
                        TweenService:Create(ToggleFrame, TweenInfo.new(0.25, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {BackgroundColor3 = Color3.fromRGB(28, 28, 28)}):Play()
                    end)

                    AddConnection(ToggleFrame.MouseButton1Down, function()
                        TweenService:Create(ToggleFrame, TweenInfo.new(0.25, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {BackgroundColor3 = Color3.fromRGB(33, 33, 33)}):Play()
                    end)

                    AddConnection(ToggleFrame.MouseButton1Up, function()
                        TweenService:Create(ToggleFrame, TweenInfo.new(0.25, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {BackgroundColor3 = Color3.fromRGB(30, 30, 30)}):Play()
                        Toggle:Set(not Toggle.Value)
                    end)

                    function Toggle:Set(Value)
                        self.Value = Value
                        TweenService:Create(TogglePopUp, TweenInfo.new(0.25, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),{BackgroundTransparency = self.Value and 0 or 1, Size = self.Value and UDim2.new(1, 0, 1, 0) or UDim2.new(0.5, 0, 0.5, 0)}):Play()
                        TweenService:Create(TogglePopUp.Ico, TweenInfo.new(0.25, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),{ImageTransparency = self.Value and 0 or 1}):Play()
                        return ToggleConfig.Callback(self.Value)
                    end
    
                    Toggle:Set(Toggle.Value)
                    return Toggle
                end,
                AddSlider = function(SliderConfig)
                    SliderConfig = SliderConfig or {}
                    SliderConfig.Name = SliderConfig.Name or "Slider"
                    SliderConfig.Min = SliderConfig.Min or 10
                    SliderConfig.Max = SliderConfig.Max or 20
                    SliderConfig.Increment = SliderConfig.Increment or 1
                    SliderConfig.Default = SliderConfig.Default or 0
                    SliderConfig.Callback = SliderConfig.Callback or function() end

                    local Slider = {Value = SliderConfig.Default, Type = "Slider"}
                    local Dragging = false

                    local ValueText = Create("TextLabel", {
                        BackgroundTransparency = 1,
                        Position = UDim2.new(0, 10, 0, 0),
                        Size = UDim2.new(1, -20, 0, 32),
                        Font = Enum.Font.Gotham,
                        TextColor3 = Color3.fromRGB(255, 255, 255),
                        TextSize = 13,
                        TextXAlignment = Enum.TextXAlignment.Right,
                        Text = ""
                    })

                    local SliderProgress = Create("Frame", {
                        Position = UDim2.new(0, 0, 0, 0),
                        Size = UDim2.new(0, 0, 1, 0),
                        BackgroundColor3 = Color3.fromRGB(50, 50, 50),
                        BorderSizePixel = 0
                    }, {
                        Create("UICorner", {CornerRadius = UDim.new(0, 4)})
                    })

                    local SliderDot = Create("TextButton", {
                        Position = UDim2.new(0.5, -6, 0.5, -6),
                        Size = UDim2.new(0, 12, 0, 12),
                        BackgroundColor3 = Color3.fromRGB(55, 55, 55),
                        BorderSizePixel = 0,
                        AutoButtonColor = false,
                        Text = ""
                    }, {
                        Create("UICorner", {CornerRadius = UDim.new(1, 0)}),
                        Create("UIStroke", {Color = Color3.fromRGB(65, 65, 65), ApplyStrokeMode = Enum.ApplyStrokeMode.Border})
                    })

                    local SliderBar = Create("Frame", {
                        Position = UDim2.new(0, 10, 0, 30),
                        Size = UDim2.new(1, -20, 0, 4),
                        BackgroundColor3 = Color3.fromRGB(36, 36, 36),
                        BorderSizePixel = 0
                    }, {
                        Create("UICorner", {CornerRadius = UDim.new(0, 4)}),
                        Create("UIStroke", {Color = Color3.fromRGB(55, 55, 55)}),
                        SliderProgress,
                        SliderDot
                    })

                    local SliderFrame = Create("TextButton", {
                        BackgroundColor3 = Color3.fromRGB(28, 28, 28),
                        Size = UDim2.new(1, 0, 0, 42),
                        Parent = SectionContainer,
                        AutoButtonColor = false,
                        ClipsDescendants = true,
                        Text = ""
                    }, {
                        Create("UICorner", {CornerRadius = UDim.new(0, 5)}),
                        Create("TextLabel", {
                            BackgroundTransparency = 1,
                            Position = UDim2.new(0, 10, 0, 0),
                            Size = UDim2.new(1, -10, 0, 32),
                            Font = Enum.Font.Gotham,
                            TextColor3 = Color3.fromRGB(255, 255, 255),
                            TextSize = 13,
                            TextXAlignment = Enum.TextXAlignment.Left,
                            Text = SliderConfig.Name
                        }),
                        ValueText,
                        SliderBar
                    })

                    AddConnection(SliderDot.InputBegan, function(Input)
                        if Input.UserInputType == Enum.UserInputType.MouseButton1 then 
                            Dragging = true;
                        end 
                    end)
    
                    AddConnection(SliderDot.InputEnded, function(Input)
                        if Input.UserInputType == Enum.UserInputType.MouseButton1 then 
                            Dragging = false;
                        end 
                    end)
    
                    AddConnection(UserInputService.InputChanged, function(Input)
                        if Dragging and Input.UserInputType == Enum.UserInputType.MouseMovement then 
                            local SizeScale = math.clamp((Input.Position.X - SliderBar.AbsolutePosition.X) / SliderBar.AbsoluteSize.X, 0, 1)
                            Slider:Set(SliderConfig.Min + ((SliderConfig.Max - SliderConfig.Min) * SizeScale)) 
                        end
                    end)
    

                    function Slider:Set(Value)
                        self.Value = math.clamp(Round(Value, SliderConfig.Increment), SliderConfig.Min, SliderConfig.Max)
                        ValueText.Text = tostring(self.Value)
                        TweenService:Create(SliderDot,TweenInfo.new(.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),{Position = UDim2.new((self.Value - SliderConfig.Min) / (SliderConfig.Max - SliderConfig.Min), -6, 0.5, -6)}):Play()
                        TweenService:Create(SliderProgress,TweenInfo.new(.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),{Size = UDim2.fromScale((self.Value - SliderConfig.Min) / (SliderConfig.Max - SliderConfig.Min), 1)}):Play()
                        return SliderConfig.Callback(self.Value)
                    end   
    
                    Slider:Set(Slider.Value)
                    return Slider
                end,
                AddDropdown = function(DropdownConfig)    
                    DropdownConfig = DropdownConfig or {}
                    DropdownConfig.Name = DropdownConfig.Name or "Dropdown"
                    DropdownConfig.Options = DropdownConfig.Options or {}
                    DropdownConfig.Default = DropdownConfig.Default or ""
                    DropdownConfig.Flag = DropdownConfig.Flag or nil
                    DropdownConfig.Callback = DropdownConfig.Callback or function() end

                    local Dropdown = {Value = DropdownConfig.Default, Options = DropdownConfig.Options, Buttons = {}, Toggled = false, Type = "Dropdown"}
                    local MaxElements = 5

                    if not table.find(Dropdown.Options, Dropdown.Value) then
                        Dropdown.Value = "..."
                    end

                    local DropdownLayout = Create("UIListLayout")

                    local DropdownContainer = Create("ScrollingFrame", {
                        Position = UDim2.new(0, 0, 0, 32),
                        Size = UDim2.new(1, 0, 1, -32),
                        BackgroundTransparency = 1,
                        MidImage = "rbxassetid://7445543667",
                        BottomImage = "rbxassetid://7445542488",
                        TopImage = "rbxassetid://7445543667",
                        ScrollBarImageColor3 = Color3.fromRGB(35, 35, 35),
                        ScrollBarThickness = 4,
                        CanvasSize = UDim2.new(0, 0, 0, 0),
                        BorderSizePixel = 0
                    }, {
                        DropdownLayout
                    })

                    local DropdownArrow = Create("ImageLabel", {
                        Image = "rbxassetid://7072706745",
                        BackgroundTransparency = 1,
                        ImageColor3 = Color3.fromRGB(165, 165, 165),
                        Size = UDim2.new(0, 16, 0, 16),
                        Position = UDim2.new(1, -24, 0.5, -8)
                    })

                    local ValueText = Create("TextLabel", {
                        BackgroundTransparency = 1,
                        Position = UDim2.new(0, 10, 0, 0),
                        Size = UDim2.new(1, -38, 1, 0),
                        Font = Enum.Font.Gotham,
                        TextColor3 = Color3.fromRGB(255, 255, 255),
                        TextSize = 13,
                        TextTransparency = 0.4,
                        TextXAlignment = Enum.TextXAlignment.Right,
                        Text = ""
                    })

                    local DropdownBtn = Create("TextButton", {
                        BackgroundTransparency = 1,
                        Size = UDim2.new(1, 0, 0, 32),
                        AutoButtonColor = false,
                        ClipsDescendants = true,
                        Text = ""
                    }, {
                        Create("UICorner", {CornerRadius = UDim.new(0, 5)}),
                        Create("TextLabel", {
                            BackgroundTransparency = 1,
                            Position = UDim2.new(0, 10, 0, 0),
                            Size = UDim2.new(1, -10, 1, 0),
                            Font = Enum.Font.Gotham,
                            TextColor3 = Color3.fromRGB(255, 255, 255),
                            TextSize = 13,
                            TextXAlignment = Enum.TextXAlignment.Left,
                            Text = DropdownConfig.Name
                        }),
                        ValueText,
                        DropdownArrow
                    })

                    local DropdownFrame = Create("TextButton", {
                        BackgroundColor3 = Color3.fromRGB(28, 28, 28),
                        Size = UDim2.new(1, 0, 0, 32),
                        Parent = SectionContainer,
                        ClipsDescendants = true,
                        Text = "",
                        AutoButtonColor = false
                    }, {
                        Create("UICorner", {CornerRadius = UDim.new(0, 5)}),
                        DropdownBtn,
                        DropdownContainer,
                        Create("Frame", {
                            Size = UDim2.new(1, 0, 0, 1),
                            Position = UDim2.new(0, 0, 0, 32),
                            ClipsDescendants = true,
                            BackgroundColor3 = Color3.fromRGB(50, 50, 50),
                            BackgroundTransparency = 0.4,
                            BorderSizePixel = 0
                        })
                    })

                    AddConnection(DropdownLayout:GetPropertyChangedSignal("AbsoluteContentSize"), function()
                        DropdownContainer.CanvasSize = UDim2.new(0, 0, 0, DropdownLayout.AbsoluteContentSize.Y)
                    end)

                    local function AddOptions(Options)
                        for _, Option in pairs(Options) do
                            local OptionBtn = Create("TextButton", {
                                Parent = DropdownContainer,
                                Size = UDim2.new(1, 0, 0, 26),
                                BackgroundTransparency = 1,
                                ClipsDescendants = true,
                                AutoButtonColor = false,
                                BackgroundColor3 = Color3.fromRGB(36, 36, 36),
                                Text = ""
                            }, {
                                Create("UICorner", {CornerRadius = UDim.new(0, 5)}),
                                Create("TextLabel", {
                                    BackgroundTransparency = 1,
                                    Position = UDim2.new(0, 10, 0, 0),
                                    Size = UDim2.new(1, -10, 1, 0),
                                    Font = Enum.Font.Gotham,
                                    TextColor3 = Color3.fromRGB(255, 255, 255),
                                    TextSize = 13,
                                    TextXAlignment = Enum.TextXAlignment.Left,
                                    Text = Option,
                                    Name = "Title"
                                })
                            })
    
                            AddConnection(OptionBtn.MouseButton1Click, function()
                                Dropdown:Set(Option)
                                Ripple(OptionBtn)
                            end)
    
                            Dropdown.Buttons[Option] = OptionBtn
                        end
                    end	

                    function Dropdown:Refresh(Options, Delete)
                        if Delete then
                            for _,v in pairs(Dropdown.Buttons) do
                                v:Destroy()
                            end    
                            table.clear(Dropdown.Options)
                            table.clear(Dropdown.Buttons)
                        end
                        Dropdown.Options = Options
                        AddOptions(Dropdown.Options)
                    end  
                    
                    function Dropdown:Set(Value)
                        if not table.find(Dropdown.Options, Value) then
                            Dropdown.Value = "..."
                            ValueText.Text = Dropdown.Value
                            for _, v in pairs(Dropdown.Buttons) do
                                TweenService:Create(v,TweenInfo.new(.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),{BackgroundTransparency = 1}):Play()
                                TweenService:Create(v.Title,TweenInfo.new(.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),{TextTransparency = 0.4}):Play()
                            end	
                            return
                        end
    
                        Dropdown.Value = Value
                        ValueText.Text = Dropdown.Value
    
                        for _, v in pairs(Dropdown.Buttons) do
                            TweenService:Create(v,TweenInfo.new(.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),{BackgroundTransparency = 1}):Play()
                            TweenService:Create(v.Title,TweenInfo.new(.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),{TextTransparency = 0.4}):Play()
                        end	
                        TweenService:Create(Dropdown.Buttons[Value],TweenInfo.new(.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),{BackgroundTransparency = 0}):Play()
                        TweenService:Create(Dropdown.Buttons[Value].Title,TweenInfo.new(.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),{TextTransparency = 0}):Play()
                        return DropdownConfig.Callback(Dropdown.Value)
                    end

                    AddConnection(DropdownBtn.MouseButton1Click, function()
                        Dropdown.Toggled = not Dropdown.Toggled
                        TweenService:Create(DropdownArrow,TweenInfo.new(.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),{Rotation = Dropdown.Toggled and 90 or 0}):Play()
                        if #Dropdown.Options > MaxElements then
                            TweenService:Create(DropdownFrame,TweenInfo.new(.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),{Size = Dropdown.Toggled and UDim2.new(1, 0, 0, 32 + (MaxElements * 26)) or UDim2.new(1, 0, 0, 32)}):Play()
                        else
                            TweenService:Create(DropdownFrame,TweenInfo.new(.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),{Size = Dropdown.Toggled and UDim2.new(1, 0, 0, DropdownLayout.AbsoluteContentSize.Y + 32) or UDim2.new(1, 0, 0, 32)}):Play()
                        end	
                    end)

                    Dropdown:Refresh(Dropdown.Options, false)
                    Dropdown:Set(Dropdown.Value)
                    return Dropdown
                end,
                AddBind = function(BindConfig)
                    BindConfig.Name = BindConfig.Name or "Bind"
                    BindConfig.Default = BindConfig.Default or Enum.KeyCode.Unknown
                    BindConfig.Flag = BindConfig.Flag or nil
                    BindConfig.Hold = BindConfig.Hold or false
                    BindConfig.Callback = BindConfig.Callback or function() end
                    BindConfig.ChangeCallback = BindConfig.ChangeCallback or function() end
    
                    local Bind = {Value, Binding = false, Type = "Bind"}
                    local Holding = false

                    local ValueText = Create("TextLabel", {
                        BackgroundTransparency = 1,
                        Position = UDim2.new(0, 10, 0, 0),
                        Size = UDim2.new(1, -20, 1, 0),
                        Font = Enum.Font.Gotham,
                        TextColor3 = Color3.fromRGB(255, 255, 255),
                        TextSize = 13,
                        TextTransparency = 0.4,
                        TextXAlignment = Enum.TextXAlignment.Right,
                        Text = ""
                    })

                    local BindFrame = Create("TextButton", {
                        BackgroundColor3 = Color3.fromRGB(28, 28, 28),
                        Size = UDim2.new(1, 0, 0, 32),
                        Parent = SectionContainer,
                        ClipsDescendants = true,
                        Text = "",
                        AutoButtonColor = false
                    }, {
                        Create("UICorner", {CornerRadius = UDim.new(0, 5)}),
                        Create("TextLabel", {
                            BackgroundTransparency = 1,
                            Position = UDim2.new(0, 10, 0, 0),
                            Size = UDim2.new(1, -10, 1, 0),
                            Font = Enum.Font.Gotham,
                            TextColor3 = Color3.fromRGB(255, 255, 255),
                            TextSize = 13,
                            TextXAlignment = Enum.TextXAlignment.Left,
                            Text = BindConfig.Name
                        }),
                        ValueText
                    })

                    AddConnection(BindFrame.InputEnded, function(Input)
                        if Input.UserInputType == Enum.UserInputType.MouseButton1 then
                            if Bind.Binding then return end
                            Bind.Binding = true
                            ValueText.Text = "..."
                        end
                    end)
    
                    AddConnection(UserInputService.InputBegan, function(Input)
                        if UserInputService:GetFocusedTextBox() then return end
                        if (Input.KeyCode.Name == Bind.Value or Input.UserInputType.Name == Bind.Value) and not Bind.Binding then
                            if BindConfig.Hold then
                                Holding = true
                                BindConfig.Callback(Holding)
                            else
                                BindConfig.Callback()
                            end
                        elseif Bind.Binding then
                            local Key
                            pcall(function()
                                if not CheckKey(BlacklistedKeys, Input.KeyCode) then
                                    Key = Input.KeyCode
                                end
                            end)
                            pcall(function()
                                if CheckKey(WhitelistedMouse, Input.UserInputType) and not Key then
                                    Key = Input.UserInputType
                                end
                            end)
                            Key = Key or Bind.Value
                            Bind:Set(Key)
                        end
                    end)
    
                    AddConnection(UserInputService.InputEnded, function(Input)
                        if Input.KeyCode.Name == Bind.Value or Input.UserInputType.Name == Bind.Value then
                            if BindConfig.Hold and Holding then
                                Holding = false
                                BindConfig.Callback(Holding)
                            end
                        end
                    end)
    
                    function Bind:Set(Key)
                        Bind.Binding = false
                        Bind.Value = Key or Bind.Value
                        Bind.Value = Bind.Value.Name or Bind.Value
                        ValueText.Text = Bind.Value
                        BindConfig.ChangeCallback(Bind.Value)
                    end
    
                    Bind:Set(BindConfig.Default)
                    if BindConfig.Flag then
                        Library.Flags[BindConfig.Flag] = Bind
                    end
                    return Bind
                end,
                AddColorpicker = function(ColorpickerConfig)
                    ColorpickerConfig = ColorpickerConfig or {}
                    ColorpickerConfig.Name = ColorpickerConfig.Name or "Colorpicker"
                    ColorpickerConfig.Default = ColorpickerConfig.Default or Color3.fromRGB(255,255,255)
                    ColorpickerConfig.Callback = ColorpickerConfig.Callback or function() end

                    local ColorH, ColorS, ColorV = 1, 1, 1
                    local Colorpicker = {Value = ColorpickerConfig.Default, Toggled = false, Type = "Colorpicker"}

                    local ColorSelection = Create("ImageLabel", {
                        Size = UDim2.new(0, 18, 0, 18),
                        Position = UDim2.new(select(3, Color3.toHSV(Colorpicker.Value))),
                        ScaleType = Enum.ScaleType.Fit,
                        AnchorPoint = Vector2.new(0.5, 0.5),
                        BackgroundTransparency = 1,
                        Image = "http://www.roblox.com/asset/?id=4805639000"
                    })
  
                    local HueSelection = Create("ImageLabel", {
                        Size = UDim2.new(0, 18, 0, 18),
                        Position = UDim2.new(0.5, 0, 1 - select(1, Color3.toHSV(Colorpicker.Value))),
                        ScaleType = Enum.ScaleType.Fit,
                        AnchorPoint = Vector2.new(0.5, 0.5),
                        BackgroundTransparency = 1,
                        Image = "http://www.roblox.com/asset/?id=4805639000"
                    })

                    local Color = Create("ImageLabel", {
                        Size = UDim2.new(1, -25, 1, 0),
                        Visible = false,
                        Image = "rbxassetid://4155801252"
                    }, {
                        Create("UICorner", {CornerRadius = UDim.new(0, 5)}),
                        ColorSelection
                    })

                    local Hue = Create("Frame", {
                        Size = UDim2.new(0, 20, 1, 0),
                        Position = UDim2.new(1, -20, 0, 0),
                        Visible = false
                    }, {
                        Create("UIGradient", {Rotation = 270, Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, Color3.fromRGB(255, 0, 4)), ColorSequenceKeypoint.new(0.20, Color3.fromRGB(234, 255, 0)), ColorSequenceKeypoint.new(0.40, Color3.fromRGB(21, 255, 0)), ColorSequenceKeypoint.new(0.60, Color3.fromRGB(0, 255, 255)), ColorSequenceKeypoint.new(0.80, Color3.fromRGB(0, 17, 255)), ColorSequenceKeypoint.new(0.90, Color3.fromRGB(255, 0, 251)), ColorSequenceKeypoint.new(1.00, Color3.fromRGB(255, 0, 4))},}),
                        Create("UICorner", {CornerRadius = UDim.new(0, 5)}),
                        HueSelection
                    })

                    local ColorpickerContainer = Create("Frame", {
                        Position = UDim2.new(0, 0, 0, 32),
                        Size = UDim2.new(1, 0, 1, -32),
                        BackgroundTransparency = 1,
                        ClipsDescendants = true
                    }, {
                        Hue,
                        Color,
                        Create("UIPadding", {
                            PaddingLeft = UDim.new(0, 35),
                            PaddingRight = UDim.new(0, 35),
                            PaddingBottom = UDim.new(0, 8),
                            PaddingTop = UDim.new(0, 4)
                        })
                    })

                    local ColorDot = Create("Frame", {
                        AnchorPoint = Vector2.new(1, 0.5),
                        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                        Position = UDim2.new(1, -10, 0.5, 0),
                        Size = UDim2.new(0, 20, 0, 20)
                    }, {
                        Create("UICorner", {CornerRadius = UDim.new(0, 5)}),
                        Create("UIStroke", {Color = Color3.fromRGB(55, 55, 55)})
                    })

                    local ColorBtn = Create("TextButton", {
                        BackgroundTransparency = 1,
                        Size = UDim2.new(1, 0, 0, 32),
                        AutoButtonColor = false,
                        ClipsDescendants = true,
                        Text = ""
                    }, {
                        Create("TextLabel", {
                            BackgroundTransparency = 1,
                            Position = UDim2.new(0, 10, 0, 0),
                            Size = UDim2.new(1, -10, 1, 0),
                            Font = Enum.Font.Gotham,
                            TextColor3 = Color3.fromRGB(255, 255, 255),
                            TextSize = 13,
                            TextXAlignment = Enum.TextXAlignment.Left,
                            Text = ColorpickerConfig.Name
                        }),
                        ColorDot
                    })

                    local ColorFrame = Create("TextButton", {
                        BackgroundColor3 = Color3.fromRGB(28, 28, 28),
                        Size = UDim2.new(1, 0, 0, 32),
                        Parent = SectionContainer,
                        AutoButtonColor = false,
                        ClipsDescendants = true,
                        Text = ""
                    }, {
                        Create("UICorner", {CornerRadius = UDim.new(0, 5)}),
                        ColorBtn,
                        ColorpickerContainer
                    })

                    local function UpdateColorPicker()
                        ColorDot.BackgroundColor3 = Color3.fromHSV(ColorH, ColorS, ColorV)
                        Color.BackgroundColor3 = Color3.fromHSV(ColorH, 1, 1)
                        Colorpicker:Set(ColorDot.BackgroundColor3)
                        ColorpickerConfig.Callback(ColorDot.BackgroundColor3)
                    end
    
                    AddConnection(ColorBtn.MouseButton1Click, function()
                        Colorpicker.Toggled = not Colorpicker.Toggled
                        TweenService:Create(ColorFrame,TweenInfo.new(.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),{Size = Colorpicker.Toggled and UDim2.new(1, 0, 0, 142) or UDim2.new(1, 0, 0, 32)}):Play()
                        Color.Visible = Colorpicker.Toggled
                        Hue.Visible = Colorpicker.Toggled
                    end)
            
                    ColorH = 1 - (math.clamp(HueSelection.AbsolutePosition.Y - Hue.AbsolutePosition.Y, 0, Hue.AbsoluteSize.Y) / Hue.AbsoluteSize.Y)
                    ColorS = (math.clamp(ColorSelection.AbsolutePosition.X - Color.AbsolutePosition.X, 0, Color.AbsoluteSize.X) / Color.AbsoluteSize.X)
                    ColorV = 1 - (math.clamp(ColorSelection.AbsolutePosition.Y - Color.AbsolutePosition.Y, 0, Color.AbsoluteSize.Y) / Color.AbsoluteSize.Y)
    
                    Colorpicker.Value = ColorpickerConfig.Default
                    ColorDot.BackgroundColor3 = Colorpicker.Value
                    Color.BackgroundColor3 = Colorpicker.Value
                    ColorpickerConfig.Callback(Colorpicker.Value)
    
                    AddConnection(Color.InputBegan, function(input)
                        if input.UserInputType == Enum.UserInputType.MouseButton1 then
                            if ColorInput then
                                ColorInput:Disconnect()
                            end
                            ColorInput = AddConnection(RunService.RenderStepped, function()
                                local ColorX = (math.clamp(Mouse.X - Color.AbsolutePosition.X, 0, Color.AbsoluteSize.X) / Color.AbsoluteSize.X)
                                local ColorY = (math.clamp(Mouse.Y - Color.AbsolutePosition.Y, 0, Color.AbsoluteSize.Y) / Color.AbsoluteSize.Y)
                                ColorSelection.Position = UDim2.new(ColorX, 0, ColorY, 0)
                                ColorS = ColorX
                                ColorV = 1 - ColorY
                                UpdateColorPicker()
                            end)
                        end
                    end)
    
                    AddConnection(Color.InputEnded, function(input)
                        if input.UserInputType == Enum.UserInputType.MouseButton1 then
                            if ColorInput then
                                ColorInput:Disconnect()
                            end
                        end
                    end)
    
                    AddConnection(Hue.InputBegan, function(input)
                        if input.UserInputType == Enum.UserInputType.MouseButton1 then
                            if HueInput then
                                HueInput:Disconnect()
                            end;
        
                            HueInput = AddConnection(RunService.RenderStepped, function()
                                local HueY = (math.clamp(Mouse.Y - Hue.AbsolutePosition.Y, 0, Hue.AbsoluteSize.Y) / Hue.AbsoluteSize.Y)
        
                                HueSelection.Position = UDim2.new(0.5, 0, HueY, 0)
                                ColorH = 1 - HueY
        
                                UpdateColorPicker()
                            end)
                        end
                    end)
    
                    AddConnection(Hue.InputEnded, function(input)
                        if input.UserInputType == Enum.UserInputType.MouseButton1 then
                            if HueInput then
                                HueInput:Disconnect()
                            end
                        end
                    end)
    
                    function Colorpicker:Set(Value)
                        Colorpicker.Value = Value
                        ColorDot.BackgroundColor3 = Colorpicker.Value
                        ColorpickerConfig.Callback(Colorpicker.Value)
                    end

                    return Colorpicker
                end,
                AddTextbox = function(TextboxConfig)
                    TextboxConfig = TextboxConfig or {}
                    TextboxConfig.Name = TextboxConfig.Name or "Textbox"
                    TextboxConfig.Default = TextboxConfig.Default or ""
                    TextboxConfig.TextDisappear = TextboxConfig.TextDisappear or false
                    TextboxConfig.Flag = TextboxConfig.Flag or nil
                    TextboxConfig.Callback = TextboxConfig.Callback or function() end

                    local TextboxActual = Create("TextBox", {
                        AnchorPoint = Vector2.new(1, 0.5),
                        BackgroundColor3 = Color3.fromRGB(36, 36, 36),
                        Position = UDim2.new(1, -10, 0.5, 0),
                        Size = UDim2.new(0, 20, 0, 20),
                        TextColor3 = Color3.fromRGB(255, 255, 255),
                        PlaceholderColor3 = Color3.fromRGB(210,210,210),
                        PlaceholderText = "Write here...",
                        TextXAlignment = Enum.TextXAlignment.Right,
                        Text = TextboxConfig.Default,
                        Font = Enum.Font.Gotham,
                        TextSize = 13,
                        ClearTextOnFocus = false
                    }, {
                        Create("UICorner", {CornerRadius = UDim.new(0, 5)}),
                        Create("UIPadding", {PaddingLeft = UDim.new(0, 5), PaddingRight = UDim.new(0, 5)})
                    })
                    
                    local TextboxFrame = Create("TextButton", {
                        BackgroundColor3 = Color3.fromRGB(28, 28, 28),
                        Size = UDim2.new(1, 0, 0, 32),
                        Parent = SectionContainer,
                        AutoButtonColor = false,
                        ClipsDescendants = true,
                        Text = ""
                    }, {
                        Create("UICorner", {CornerRadius = UDim.new(0, 5)}),
                        Create("TextLabel", {
                            BackgroundTransparency = 1,
                            Position = UDim2.new(0, 10, 0, 0),
                            Size = UDim2.new(1, -10, 1, 0),
                            Font = Enum.Font.Gotham,
                            TextColor3 = Color3.fromRGB(255, 255, 255),
                            TextSize = 13,
                            TextXAlignment = Enum.TextXAlignment.Left,
                            Text = TextboxConfig.Name
                        }),
                        TextboxActual
                    })

                    AddConnection(TextboxFrame.MouseButton1Click, function()
                        TextboxActual:CaptureFocus()
                    end)
    
                    AddConnection(TextboxActual.FocusLost, function()
                        TextboxConfig.Callback(TextboxActual.Text)
                        if TextboxConfig.TextDisappear then
                            TextboxActual.Text = ""
                        end	
                    end)

                    AddConnection(TextboxActual:GetPropertyChangedSignal("Text"), function()
                        TextboxActual.Size = UDim2.new(0,TextboxActual.TextBounds.X + 10,0,20)
                    end)
                    TextboxActual.Size = UDim2.new(0,TextboxActual.TextBounds.X + 10,0,20)
                end    
            }
        end}
    end}
end    



local Main =
    Library.Load(
    {
        Title = ("Demeter - ER:LC <i>v2.0</i>")
    }
)

--# Notification

local function Notification(arg1, arg2, arg3, arg4)
    Library.Notification(
    {
        Title = (arg1),
        Content = (arg2),
        Delay =(arg3)
    }

)    
end

--# Region of tabs and Sections
local Tabs = {
    Local = Main.AddTab("Local"),
    Game = Main.AddTab('Game'),
    Combat = Main.AddTab("Combat"),
    Troll = Main.AddTab('Troll'),
    Vehicle = Main.AddTab("Vehicle"),
    Teleports = Main.AddTab("Teleports"),
    Autofarms = Main.AddTab("Autofarms"),
    Visuals = Main.AddTab('Visuals'),
    --Settings = Main.AddTab("Settings"),
    Tools = Main.AddTab("Tools"),
}

local Sections = {
    Local = {
        Security = Tabs.Local.AddSection("Security"),
        LocalPlayer = Tabs.Local.AddSection("LocalPlayer"),
    },
    Game = {
        Water = Tabs.Game.AddSection('Water'),
        Lighting = Tabs.Game.AddSection('Lighting')
    },
    Combat = {
        Combat = Tabs.Combat.AddSection("Combat"),
        Settings = Tabs.Combat.AddSection("Settings")
    },
    Troll = {
        Trolling = Tabs.Troll.AddSection('Troll'),
        Settings = Tabs.Troll.AddSection('Settings')
    },
    Vehicle = {
        Misc = Tabs.Vehicle.AddSection("Misc"),
        Mods = Tabs.Vehicle.AddSection("Vehicle")
    },
    Visuals={
        Toggle = Tabs.Visuals.AddSection('Toggle'),
        Color =   Tabs.Visuals.AddSection('ESP Color'),
        Main = Tabs.Visuals.AddSection('Main/Settings'),
    },
    Teleports = {
        Emergency = Tabs.Teleports.AddSection("Emergency Services locations"),
        Popular = Tabs.Teleports.AddSection("Popular Place locations"),
        Gas = Tabs.Teleports.AddSection("Gas Station locations"),
        Towns = Tabs.Teleports.AddSection("Town locations"),
        Store = Tabs.Teleports.AddSection("Store locations"),
        ATM = Tabs.Teleports.AddSection("ATM locations"),
        Hiding = Tabs.Teleports.AddSection("Hiding locations")
    },
    Tools = {
        ToolStore = Tabs.Tools.AddSection("Get Tools")
    },
    Autofarms = {
        Autofarms = Tabs.Autofarms.AddSection("Criminal Autofarms"),
        Dep = Tabs.Autofarms.AddSection("Deputy AutoFarms"),
        Other = Tabs.Autofarms.AddSection("Other")
    },
    --Settings = {
       -- Discord = Tabs.Settings.AddSection("Discord"),
        --Setting = Tabs.Settings.AddSection("Settings"),
       -- Credits = Tabs.Settings.AddSection("GUI Credits")
   -- }
}

--# Region of Variables
local Folder = Instance.new('Folder', game.CoreGui)
Folder.Name = 'Demeter.ESP'
local plr = game.Players.LocalPlayer
local Mouse = plr:GetMouse()
    -- Error types
local ErrorType1 = "Error, you cannot be sitting!"
local ErrorType2 = "Failed to autorob; Patched"
local ErrorType3 = "You do not have a car"
    -- Fly settings
local FlySpeed = ...
    -- Panic settings
local PanicTeam = ...
    -- Infinite health values
local Deadly = (...)
local Safe = (...)
    -- Respawn where you died
local Respawn = ... -- Value 1
local OldLocation = ... -- Value 2
    -- Values/Toggles
local Colors = {
    Civillian = Color3.fromRGB(255,255,255),
    Police = Color3.fromRGB(0,0,255),
    Criminal = Color3.fromRGB(0,255,0)
 }

 local Toggles = {
    VehicleEnabled = false,
    Security = {
        ModCheck = false,
        Notif = true
    },
    LocalPlayer = {
        Stamina = false,
        BHop = false,
        Heal = false,
        Walk = false,
        Walk2 = false
    },
    Vehicle = {
        Fuel = false,
        Godmode = false,
        Smoke = true,
        fire = true,
        God = false
    },
    Troll = {
        Eject = false
    },
    Combat = {
        TriggerBot = false,
        Recoil = false,
        Reload = false,
        AutoMatic = false
    },
    Deputy = {
        Arrest = false,
        AutoJ = false,
        AutoATM = false,
        AutoHouse = false
    },
    Criminal = {
        AutoFarms = {
            Atm = false
        }
    }
}
local MousePositions = {
    Select = {
        x,y = 
            game:GetService("Players").LocalPlayer.PlayerGui.GameMenus.RobberyInfo.Difficulty.Hard.AbsolutePosition.X +
            game:GetService("Players").LocalPlayer.PlayerGui.GameMenus.RobberyInfo.Difficulty.Hard.AbsoluteSize.X / 2,

            game:GetService("Players").LocalPlayer.PlayerGui.GameMenus.RobberyInfo.Difficulty.Hard.AbsolutePosition.Y +
            game:GetService("Players").LocalPlayer.PlayerGui.GameMenus.RobberyInfo.Difficulty.Hard.AbsoluteSize.Y - 10 / 2
    },
    Start = {
        x,y = 
            game:GetService("Players").LocalPlayer.PlayerGui.GameMenus.RobberyInfo.Start.AbsolutePosition.X +
            game:GetService("Players").LocalPlayer.PlayerGui.GameMenus.RobberyInfo.Start.AbsoluteSize.X / 2,
            
            game:GetService("Players").LocalPlayer.PlayerGui.GameMenus.RobberyInfo.Start.AbsolutePosition.Y +
            game:GetService("Players").LocalPlayer.PlayerGui.GameMenus.RobberyInfo.Start.AbsoluteSize.Y -
            10 / 2
    },
    Middle = {
        x,y = 
                workspace.CurrentCamera.ViewportSize.X / 2, 
                workspace.CurrentCamera.ViewportSize.Y / 2 
    }
}

local Teleports = {
    Popular = {
        ["Civillian Spawn"] = CFrame.new(
            -540.382568,
            23.2481289,
            704.772034,
            0.0421637632,
            -5.88774078e-08,
            -0.999110699,
            1.4867203e-09,
            1,
            -5.8867073e-08,
            0.999110699,
            9.966592e-10,
            0.0421637632
        ),
        ["Parking Lot"] = CFrame.new(
            -315.908936,
            23.9480267,
            156.451492,
            -0.999283314,
            -3.93061717e-09,
            0.0378525928,
            8.09722012e-10,
            1,
            1.25216232e-07,
            -0.0378525928,
            1.25157143e-07,
            -0.999283314
        ),
        ["Factory"] = CFrame.new(
            756.657959,
            3.59802604,
            243.68988,
            0.0567763336,
            1.06768717e-07,
            0.998386919,
            -9.55414681e-09,
            1,
            -1.06397898e-07,
            -0.998386919,
            -3.49785245e-09,
            0.0567763336
        ),
        ["Bank"] = CFrame.new(
            -1000.73267,
            23.7480087,
            427.056915,
            0.249814644,
            -2.12669562e-08,
            0.968293667,
            2.85467223e-08,
            1,
            1.45984291e-08,
            -0.968293667,
            2.39947102e-08,
            0.249814644
        ),
        ["JStore"] = CFrame.new(
            -465.567139,
            28.7166786,
            -400.204346,
            0.999968231,
            -2.05392769e-08,
            -0.00797388423,
            2.00753352e-08,
            1,
            -5.8262664e-08,
            0.00797388423,
            5.81007349e-08,
            0.999968231
        )
    },
    Stores = {
        ["Tool Store"] = CFrame.new(
            -437.905884,
            24.2480373,
            -732.584167,
            -0.754147828,
            6.86724233e-09,
            -0.656704664,
            -3.3865998e-08,
            1,
            4.93482268e-08,
            0.656704664,
            5.9455818e-08,
            -0.754147828
        ),
        ["Gun Store"] = CFrame.new(
            -1234.08472,
            24.2380199,
            -196.743561,
            0.0424970649,
            -1.50960808e-08,
            -0.999096572,
            -2.35120048e-08,
            1,
            -1.61098264e-08,
            0.999096572,
            2.41753835e-08,
            0.0424970649
        )
    },
    Services = {
        ["Fire"] = CFrame.new(
            -995.758728,
            23.2492142,
            114.790192,
            -0.968779325,
            4.93730248e-08,
            0.247924656,
            2.69974318e-08,
            1,
            -9.36513231e-08,
            -0.247924656,
            -8.40341343e-08,
            -0.968779325
        ),
        ["Hospital"] = CFrame.new(
            -140.210266,
            23.2073803,
            -451.711395,
            0.998901427,
            2.35794158e-08,
            0.0468605086,
            -2.47227074e-08,
            1,
            2.3818183e-08,
            -0.0468605086,
            -2.49505359e-08,
            0.998901427
        ),
        ["Police"] = CFrame.new(
            821.647156,
            3.19802475,
            41.577198,
            0.998565793,
            2.05210036e-08,
            0.0535385497,
            -1.48503236e-08,
            1,
            -1.0631549e-07,
            -0.0535385497,
            1.05367945e-07,
            0.998565793
        ),
        ["Sherrif"] = CFrame.new(
            1574.41809,
            -12.3781233,
            -1970.87634,
            0.997543216,
            -5.60381119e-09,
            -0.0700541809,
            1.17710786e-09,
            1,
            -6.3230992e-08,
            0.0700541809,
            6.29931804e-08,
            0.997543216
        )
    },
    Towns = {
        ["Unknown Town"] = CFrame.new(
            1308.31873,
            -12.3777094,
            -2288.96777,
            -0.134183183,
            -8.97070773e-09,
            0.990956545,
            7.60140964e-08,
            1,
            1.9345471e-08,
            -0.990956545,
            7.79225005e-08,
            -0.134183183
        ),
        ["Houses Near Park [1]"] = CFrame.new(
            2898.62085,
            187.004196,
            -438.330414,
            -0.713084757,
            -4.70668082e-09,
            0.701077819,
            1.04899589e-10,
            1,
            6.82018886e-09,
            -0.701077819,
            4.93691532e-09,
            -0.713084757
        ),
        ["Houses Near Park [2]"] = CFrame.new(
            3257.20532,
            202.498016,
            393.61618,
            -0.298552573,
            4.79602491e-08,
            -0.954393208,
            8.30379676e-08,
            1,
            2.42762077e-08,
            0.954393208,
            -7.20031466e-08,
            -0.298552573
        ),
        ["Town Near Barns"] = CFrame.new(
            1193.09937,
            3.19795418,
            -1006.05176,
            0.96728909,
            -2.40902276e-09,
            0.253676683,
            -1.10219134e-09,
            1,
            1.36991716e-08,
            -0.253676683,
            -1.35306593e-08,
            0.96728909
        )
    },
    Hiding = {
        ["High Rock Park"] = CFrame.new(
            2580.01147,
            187.398254,
            -458.687469,
            0.512119353,
            -7.18262001e-08,
            0.858914256,
            5.10023739e-08,
            1,
            5.32147375e-08,
            -0.858914256,
            1.65543703e-08,
            0.512119353
        ),
        ["Cave"] = CFrame.new(400.06732177734, -9.9692277908325, 825.47265625)
    },
    GasStation = {
        ["City"] = CFrame.new(
            -1013.86011,
            23.2480602,
            637.049866,
            -0.0374160185,
            -7.23861788e-08,
            0.999299765,
            1.38189149e-09,
            1,
            7.24886462e-08,
            -0.999299765,
            4.09316048e-09,
            -0.0374160185
        ),
        ["OutSkirts"] = CFrame.new(
            647.397827,
            3.19807529,
            -1561.88745,
            0.0778717324,
            1.18018178e-07,
            -0.996963382,
            -1.35868152e-08,
            1,
            1.17316389e-07,
            0.996963382,
            4.40992709e-09,
            0.0778717324
        )
    },
    ATM = {
        ["ATM [1]"] = CFrame.new(
            724.154297,
            3.69802451,
            -1562.0498,
            -0.0834512487,
            4.13239132e-09,
            -0.996511877,
            -6.06815354e-09,
            1,
            4.65502392e-09,
            0.996511877,
            6.43545484e-09,
            -0.0834512487
        ),
        ["ATM [2]"] = CFrame.new(
            1118.42078,
            3.69803309,
            372.186951,
            0.116275504,
            -7.5630826e-09,
            -0.993216991,
            -3.57981698e-08,
            1,
            -1.18056107e-08,
            0.993216991,
            3.69280535e-08,
            0.116275504
        ),
        ["ATM [3]"] = CFrame.new(
            -372.895874,
            23.7480087,
            151.882751,
            0.0217179917,
            4.27853486e-08,
            -0.999764144,
            1.35886982e-08,
            1,
            4.30906333e-08,
            0.999764144,
            -1.45213352e-08,
            0.0217179917
        ),
        ["ATM [4]"] = CFrame.new(
            -585.410156,
            23.7480087,
            -409.496582,
            0.945484757,
            9.22443419e-08,
            -0.325666428,
            -9.591799e-08,
            1,
            4.77589346e-09,
            0.325666428,
            2.67217342e-08,
            0.945484757
        )
    }
}


local Timings = {
    Triggerbot = 0,
    Aimbot = ...,
    Health = ...
}

local Values = {
    KeyBind = "RightControl",
    Language = {English = true, French = ...},
    NewClientId = math.random(63563, 562463),
    TPDelay = 0,
    PanicText = {
        Police = {
            Text = ("Im being kidnapped, help!"),
            Location = ("I do not know")
        },
        Fire = {
            Text = ("Car is on fire, im dying"),
            Location = ("I do not know")
        },
        DOT = {
            Text = ("Car has lost its tyre"),
            Location = ("I do not know")
        }
    },
    Clicked = 0,
    Speed = 3
}
local Colors = {
    [1] = Color3.fromRGB(255,255,255),
    [2] = Color3.fromRGB(255,0,0),
    [3] = Color3.fromRGB(0,0,255)
}
local Folders = {
    Civil = Instance.new('Folder', Folder),
    Criminal = Instance.new('Folder', Folder),
    Police = Instance.new('Folder', Folder),
    Objects = Instance.new('Folder', Folder)
}

local FolderSettings = {
    Civillian = 'Civil ESP',
    Criminal = 'Criminal ESP',
    Police = 'Police ESP',
    Objects = 'Var ESP'
}

Folders.Civil.Name = FolderSettings.Civillian
Folders.Criminal.Name = FolderSettings.Criminal
Folders.Police.Name = FolderSettings.Police
local TeamsToPanic = {"Deputy forces", "Fire department", "DOT"}

--# Region of functions


local function MyCar()
    local vehicles = game.Workspace.Vehicles
    for _, v in pairs(vehicles:GetChildren()) do
        if v["Control_Values"].Owner.Value == tostring(plr.Name) then
            return v
        end
    end
end
local myCar = MyCar()
local function rgbToString(Color)
    return tostring(tonumber(Color.R) * 255) ..
        ", " .. tostring(tonumber(Color.G) * 255) .. ", " .. tostring(tonumber(Color.B) * 255)
end
function Short(name)
    for i, v in pairs(game:GetService("Players"):GetPlayers()) do
        if string.sub(v.Name, 1, string.len(name)) == name then
            return v
        end
    end
end



local function getchar()
    return plr.Character or plr.CharacterAdded:Wait()
end

--local function MyGun()
    --local backpack = game:GetService("Players").LocalPlayer.Backpack
    --for i,v in pairs(backpack) do if v:IsA("Tool") and v:Ge

local function Teleport(arg, callback)
    local TPCFrame = arg --Put a new cframe  in here
    local User = game.Players.LocalPlayer.Character.HumanoidRootPart
    local WaitTime = 10 --let this or instand ban!

    User.CFrame = TPCFrame
    callback = callback or function() end
    callback()
    local args = {
        [1] = "--r",
        [2] = game.Players.LocalPlayer.Character.HumanoidRootPart.Position,
        [3] = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame * CFrame.Angles(4, 0, 0)
    }

    game:GetService("ReplicatedStorage").Events.DFfDD:FireServer(unpack(args))
end


local function InstantRespawn()
    plr.Character.Humanoid.Health = 0
end

local function Panic()
    Values.Clicked = Values.Clicked + 1
    if Values.Clicked == 1 then
        if PanicTeam == "Deputy forces" then
            local args = {
                [1] = "Police",
                [2] = Values.PanicText.Police.Text,
                [3] = Values.PanicText.Police.Location
            }
            game:GetService("ReplicatedStorage").EmergencyCalls.Call911:InvokeServer(unpack(args))
        elseif PanicTeam == "Fire department" then
            local args = {
                [1] = "Fire",
                [2] = Values.PanicText.Fire.Text,
                [3] = Values.PanicText.Fire.Location
            }
            game:GetService("ReplicatedStorage").EmergencyCalls.Call911:InvokeServer(unpack(args))
        else
            local args = {
                [1] = "DOT",
                [2] = Values.PanicText.DOT.Text,
                [3] = Values.PanicText.DOT.Location
            }

            game:GetService("ReplicatedStorage").EmergencyCalls.Call911:InvokeServer(unpack(args))
        end
        wait() Values.Clicked = 0
    end
end

local function AddHighLight(object, Color, SeeThrough, parent)
    if CoreGui:FindFirstChild('Demeter.ESP') and Toggled then
        highlight = Instance.new('Highlight')
        syn.protect_gui(highlight)
        highlight.Parent = parent
        highlight.Adornee = object
           
        highlight.FillColor = Color
        highlight.FillTransparency = SeeThrough
        
        highlight.OutlineColor = Color3.fromRGB(255,255,255)
        highlight.OutlineTransparency = 0
           
        highlight.Adornee.Changed:Connect(function()
            if not highlight.Adornee or not highlight.Adornee.Parent then
                highlight:Destroy()    
            end
        end)
        return highlight
    end
end

--# Region of Content

Sections.Local.Security.AddToggle(
    {
        Name = "PRC Moderator Check | NOT PRIVATE SERVER",
        Default = false,
        Callback = function(State)
            Toggles.Security.ModCheck = State
            while Toggles.Security.ModCheck and wait(8) do
                for i, v in pairs(game.Players:GetChildren()) do
                    if v:GetRankInGroup(4328109) >= 3 then
                        plr:Kick("Moderator is in game, prevented ban.")
                        print(v.Name)
                    end
                end
            end
        end
    }
)

-------- LocalPlayer

Sections.Local.LocalPlayer.AddToggle(
    {
        Name = "Infinite Stamina",
        Default = false,
        Callback = function(State)
            Toggles.LocalPlayer.Stamina = State
            while Toggles.LocalPlayer.Stamina and wait() do
                plr.PlayerGui.GameGui.BottomLeft.Health["Stamina LS"].Stamina.Value = 999
            end
        end
    }
)

Sections.Local.LocalPlayer.AddToggle(
    {
        Name = "Bunny Hop",
        Default = false,
        Callback = function(State)
            Toggles.LocalPlayer.BHop = State
            while Toggles.LocalPlayer.BHop and wait() do
                plr.Character.Humanoid.Jump = true
            end
        end
    }
)

local Float = false
Sections.Local.LocalPlayer.AddToggle(
    {
        Name = "Infinite Jump",
        Default = false,
        Callback = function(State)
            Float = State
        end
    }
)
Sections.Local.LocalPlayer.AddBind(
    {
        Name = "Speed",
        Hold = true,
        Default = Enum.KeyCode.F,
        Callback = function(Value)
            Toggles.LocalPlayer.Walk2 = Value
            while Toggles.LocalPlayer.Walk2 and Toggles.LocalPlayer.Walk do
                task.wait()
                getchar().HumanoidRootPart.CFrame =
                    getchar().HumanoidRootPart.CFrame + getchar().HumanoidRootPart.CFrame.LookVector * Values.Speed
            end
        end
    }
)

Sections.Local.LocalPlayer.AddToggle(
    {
        Name = "Speed Walk",
        Default = false,
        Callback = function(State)
            Toggles.LocalPlayer.Walk = State
        end
    }
)

-- Vehicle Mods
Sections.Vehicle.Mods.AddSlider(
    {
        Name = "Horse Power",
        Default = 0,
        Min = 0,
        Max = 10000,
        Increment = 50,
        Callback = function(amountHorsePower)
            for i, v in pairs(getgc(true)) do
                if type(v) == "table" and rawget(v, "Horsepower") then
                    rawset(v, "Horsepower", amountHorsePower)
                end
        end
    end
    }
)



-- undone brake force mod for cars
--Sections.Vehicle.Mods.AddSlider(
 --   {
  --      Name = "Brake Force",
  --      Default = 0,
  --      Min = 0,
  ---      Max = 10000,
  --      Increment = 50,
  --      Callback = function(amountBreakForce)
   --         for i, v in pairs(getgc(true)) do
    --            if type(v) == "table" and rawget(v, "Brakeforce") then
    --                rawset(v, "Horsepower", amountHorsePower)
     --           end
     --   end
   -- end
 --   }
--)

-- ESP Section Init
Sections.Visuals.Toggle.AddButton(
    {
        Name = "Start ESP",
        Callback = function()
            espLib:Load()
        end
    }
)

Sections.Visuals.Toggle.AddButton(
    {
        Name = "Disable ESP",
        Callback = function()
            espLib:Unload()
        end
    }
)

Sections.Visuals.Main.AddSlider(
    {
        Name = "Maximum Distance",
        Default = 0,
        Min = 0,
        Max = 10000,
        Increment = 50,
        Callback = function(amountDistance)
            espLib.options.maxDistance = amountDistance
        end
    }
)

Sections.Visuals.Main.AddToggle(
    {
        Name = "Names",
        Callback = function(enabledNames)
            espLib.options.names = enabledNames
        end
    }
)

Sections.Visuals.Main.AddToggle(
    {
        Name = "Team Check",
        Callback = function(enabledTeamCheck)
            espLib.options.teamCheck = enabledTeamCheck
        end
    }
)

Sections.Visuals.Color.AddColorpicker({
    Name = "Tracers Color",
    Default = Color3.new(1, 1, 1),
    Callback = function(requestedTracerColor)
        espLib.options.tracerColor = requestedTracerColor
    end    
})

Sections.Visuals.Color.AddColorpicker({
    Name = "Boxes Color",
    Default = Color3.new(1, 1, 1),
    Callback = function(requestedBoxesColor)
        espLib.options.boxesColor = requestedBoxesColor
    end    
})

Sections.Visuals.Main.AddToggle(
    {
        Name = "Boxes",
        Callback = function(enabledBoxes)
            espLib.options.boxes = enabledBoxes
        end
    }
)

Sections.Visuals.Main.AddToggle(
    {
        Name = "Tracers",
        Callback = function(enabledTracers)
            espLib.options.tracers = enabledTracers
        end
    }
)

Sections.Visuals.Main.AddToggle(
    {
        Name = "Chams",
        Callback = function(enabledChams)
            espLib.options.chams = enabledChams
        end
    }
)

Sections.Visuals.Main.AddToggle(
    {
        Name = "Health Bars",
        Callback = function(enabledHealthBars)
            espLib.options.healthBars = enabledHealthBars
        end
    }
)

Sections.Visuals.Main.AddToggle(
    {
        Name = "Box Fill",
        Callback = function(enabledBoxFill)
            espLib.options.boxFill = enabledBoxFill
        end
    }
)

Sections.Local.LocalPlayer.AddSlider(
    {
        Name = "Speed Walk Multiplier",
        Default = 0,
        Min = 0,
        Max = 50,
        Increment = 1,
        Callback = function(Speed)
            Values.Speed = Speed
        end
    }
)

Sections.Tools.ToolStore.AddButton(
    {
        Name = "Get RFID",
        Callback = function()
            local oldCFrame = game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.CFrame
            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-433.891693, 23.8463306, -708.328064)
            task.wait(0.2)
            game:GetService("ReplicatedStorage").FE.BuyGear:InvokeServer("RFID Disruptor")
            task.wait(0.2)
            plr.Character.HumanoidRootPart.CFrame = oldCFrame
        end
    }
)

Sections.Tools.ToolStore.AddButton(
    {
        Name = "Get Lockpick",
        Callback = function()
            local oldCFrame = game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.CFrame
            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-433.891693, 23.8463306, -708.328064)
            task.wait()
            game:GetService("ReplicatedStorage").FE.BuyGear:InvokeServer("Lockpick")
            task.wait()
            plr.Character.HumanoidRootPart.CFrame = oldCFrame
        end
    }
)

Sections.Tools.ToolStore.AddButton(
    {
        Name = "Get Drill",
        Callback = function()
            local oldCFrame = game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.CFrame
            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-433.891693, 23.8463306, -708.328064)
            task.wait()
            game:GetService("ReplicatedStorage").FE.BuyGear:InvokeServer("Drill")
            task.wait()
            plr.Character.HumanoidRootPart.CFrame = oldCFrame
        end
    }
)

Sections.Tools.ToolStore.AddButton(
    {
        Name = "Get Scanner",
        Callback = function()
            local oldCFrame = game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.CFrame
            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-433.891693, 23.8463306, -708.328064)
            task.wait()
            game:GetService("ReplicatedStorage").FE.BuyGear:InvokeServer("Scanner")
            task.wait()
            plr.Character.HumanoidRootPart.CFrame = oldCFrame
        end
    }
)

Sections.Tools.ToolStore.AddButton(
    {
        Name = "Get Flashlight",
        Callback = function()
            local oldCFrame = game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.CFrame
            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-433.891693, 23.8463306, -708.328064)
            task.wait()
            game:GetService("ReplicatedStorage").FE.BuyGear:InvokeServer("Flashlight")
            task.wait()
            plr.Character.HumanoidRootPart.CFrame = oldCFrame
        end
    }
)

game:GetService("UserInputService").JumpRequest:Connect(
    function()
        if Float then
            game.Players.LocalPlayer.Character.Humanoid.Jump = true
            task.wait()
            local part = Instance.new("Part", game.Workspace)
            part.CFrame = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame + Vector3.new(0, -3, 0)
            part.Anchored = true
            part.Transparency = 1
            wait(0.5)
            part:Destroy()
        end
    end
)

speaker = game.Players.LocalPlayer
Sections.Local.LocalPlayer.AddToggle(
    {
        Name = "Fly",
        Default = false,
        Callback = function(State)
            local Toggle_Fly = State
            if Toggle_Fly then
                Library.Notification(
                    {
                        Title = "Credits",
                        Content = "Inf yield",
                        Delay = 0.2
                    }
                )
                speaker.Character:FindFirstChildOfClass("Humanoid").PlatformStand = true
                local Head = speaker.Character:WaitForChild("Head")
                Head.Anchored = true
                CFloop =
                    game:GetService("RunService").Heartbeat:Connect(
                    function(deltaTime)
                        local moveDirection =
                            speaker.Character:FindFirstChildOfClass("Humanoid").MoveDirection * (FlySpeed * 2)
                        local headCFrame = Head.CFrame
                        local cameraCFrame = workspace.CurrentCamera.CFrame
                        local cameraOffset = headCFrame:ToObjectSpace(cameraCFrame).Position
                        cameraCFrame = cameraCFrame * CFrame.new(-cameraOffset.X, -cameraOffset.Y, -cameraOffset.Z + 1)
                        local cameraPosition = cameraCFrame.Position
                        local headPosition = headCFrame.Position

                        local objectSpaceVelocity =
                            CFrame.new(cameraPosition, Vector3.new(headPosition.X, cameraPosition.Y, headPosition.Z)):VectorToObjectSpace(
                            moveDirection
                        )
                        Head.CFrame =
                            CFrame.new(headPosition) * (cameraCFrame - cameraPosition) * CFrame.new(objectSpaceVelocity)
                    end
                )
            else
                if CFloop then
                    CFloop:Disconnect()
                    speaker.Character:FindFirstChildOfClass("Humanoid").PlatformStand = false
                    local Head = speaker.Character:WaitForChild("Head")
                    Head.Anchored = false
                end
            end
        end
    }
)

Sections.Local.LocalPlayer.AddSlider(
    {
        Name = "Fly Speed",
        Default = 1.5,
        Min = 1,
        Max = 5,
        Increment = 0.25,
        Callback = function(Speed)
            FlySpeed = Speed
        end
    }
)

Sections.Local.LocalPlayer.AddToggle(
    {
        Name = "Respawn Where you Died",
        Default = false,
        Callback = function(State)
            Respawn = State
            
            while Respawn and wait() do
                plr.Character.Humanoid.Died:Connect(
                    function()
                        OldLocation = plr.Character.HumanoidRootPart.CFrame
                        task.wait(10)
                        Teleport(OldLocation)
                    end 
                )
            end
        end
    }
)

Sections.Local.LocalPlayer.AddTextbox(
    {
        Name = "Get a Fake Paycheck | Visual Only",
        Default = "Money",
        Callback = function(moneyRequested)
            print(moneyRequested)
            
        end
    }
)

Sections.Local.LocalPlayer.AddButton(
    {
        Name = "Instant Respawn",
            Callback = function()
                InstantRespawn()
            Library.Notification(
                {
                    Title = "Warning",
                    Content = "All toggles in the localplayer section have been set off to prevent glitching, re-toggle all toggles.",
                    Delay = 4
                }
            )
        end
    }
)

Sections.Game.Water.AddColorpicker({
    Name = "Choose water color",
    Default = workspace.Terrain.WaterColor,
    Callback = function(WaterColor)
        workspace.Terrain.WaterColor = WaterColor
    end    
})

Sections.Game.Water.AddSlider(
    {
        Name = "Water Transparancy",
        Default =  workspace.Terrain.WaterTransparency,
        Min = 0,
        Max = 1,
        Increment = 0.10,
        Callback = function(v)
            workspace.Terrain.WaterTransparency  = v
        end
    }
)

Sections.Game.Water.AddSlider(
    {
        Name = "Water Wave Size",
        Default = workspace.Terrain.WaterWaveSize,
        Min = 0,
        Max = 1,
        Increment = 0.10,
        Callback = function(v)
            workspace.Terrain.WaterWaveSize   = v
        end
    }
)

Sections.Game.Water.AddSlider(
    {
        Name = "Water Wave Speed",
        Default = workspace.Terrain.WaterWaveSpeed,
        Min = 0,
        Max = 100,
        Increment = 1,
        Callback = function(v)
            workspace.Terrain.WaterWaveSpeed   = v
        end
    }
)
Sections.Game.Water.AddSlider(
    {
        Name = "Water Reflectance",
        Default = workspace.Terrain.WaterReflectance,
        Min = 0,
        Max = 1,
        Increment = 0.10,
        Callback = function(v)
            workspace.Terrain.WaterReflectance    = v
        end
    }
)
FB = false
Sections.Game.Lighting.AddToggle({
    Name = "Full bright",
    Default = false,
    Callback = function(v)
        FB = v
    end
})

game:GetService"RunService".RenderStepped:Connect(function()
    if FB then
        game:GetService("Lighting").TimeOfDay = "08:18:07"  
    end
end)

Sections.Troll.Trolling.AddTextbox(
    {
        Name = "Teleport to Player",
        Default = "FULL NAME - NO DISPLAYNAME",
        Callback = function(Plr_Locate)
            local Player2 = Short(Plr_Locate)
            Teleport(Player2.Character.Humanoid.HumanoidRootPart.CFrame)
        end
    
    }
)


Sections.Troll.Trolling.AddButton({
    Name = ("Eject all from Vehicles"),
    Callback = function(v)
        for i, v in pairs(game:GetService("Workspace").Vehicles:GetChildren()) do
            local s, e =
                pcall(
                function()
                    game:GetService("ReplicatedStorage").FE.VehicleExit:FireServer(v.DriverSeat)
                    wait(0.1)
                    game:GetService("ReplicatedStorage").Events.DFfDD:FireServer(unpack(TPArgs))
                end
            )
        end
    end
})



Sections.Troll.Trolling.AddToggle({
    Name = ("Loop Eject All from Vehicles"),
    Default = false,
    Callback = function(v)
        Toggles.Troll.Eject = v

        while Toggles.Troll.Eject and wait() do
            for i, v in pairs(game:GetService("Workspace").Vehicles:GetChildren()) do
                local s, e =
                    pcall(
                    function()
                        game:GetService("ReplicatedStorage").FE.VehicleExit:FireServer(v.DriverSeat)
                        task.wait()
                        game:GetService("ReplicatedStorage").Events.DFfDD:FireServer(unpack(TPArgs))
                    end
                )
            end
        end
    end
})

getgenv().DefaultText = ("Demeter #1 Roblox script for ER:LC" or "Not optimal, will cause script to lag after seconds!")
_G.ChatSpam = false
Sections.Troll.Trolling.AddTextbox(
    {
        Name = "Chat Spam text",
        Default = DefaultText,
        Callback = function(txt)
            DefaultText = txt
        end
    }
)
local ChatTime = ...
Sections.Troll.Trolling.AddToggle(
    {
        Name = "Chat Spam",
        Default = false,
        Callback = function(State)
            _G.ChatSpam = State

            while _G.ChatSpam and wait(ChatTime) do
                local args = {
                    [1] = DefaultText
                }

                game:GetService("ReplicatedStorage").FE.Chat:FireServer(unpack(args))
            end
        end
    }
)


Sections.Troll.Settings.AddSlider(
    {
        Name = "ChatSpam text timing [Recommended 0]",
        Default = 0.5,
        Min = 0,
        Max = 10,
        Increment = 0.25,
        Callback = function(Time)
            ChatTime = Time
        end
    }
)




Sections.Teleports.Emergency.AddDropdown(
    {
        Name = "Emergency Services Locations",
        Options = {
            ("Fire"),
            ("Hospital"),
            ("Police"),
            ("Sherrif")
        },
        Default = ...,
        Callback = function(v)
            Teleport(Teleports.Services[v])
        end
    }
)

Sections.Teleports.Popular.AddDropdown(
    {
        Name = "Popular Place Locations",
        Options = {
            ("Civillian Spawn"),
            ("Parking Lot"),
            ("Factory"),
            ("Bank"),
            ("JStore"),
            ("Barns ")
        },
        Default = ...,
        Callback = function(v)
            Teleport(Teleports.Popular[v])
        end
    }
)

Sections.Teleports.Gas.AddDropdown(
    {
        Name = "Gas Station Locations",
        Options = {
            ("City"),
            ("OutSkirts")
        },
        Default = ...,
        Callback = function(v)
            Teleport(Teleports.GasStation[v])
        end
    }
)

Sections.Teleports.Towns.AddDropdown(
    {
        Name = "Town locations",
        Options = {
            ("Unknown Town"),
            ("Houses Near Park [1"),
            ("Houses Near Park [2]"),
            ("Town Near Barns")
        },
        Default = ...,
        Callback = function(v)
            Teleport(Teleports.Towns[v])
        end
    }
)

Sections.Teleports.Store.AddDropdown(
    {
        Name = "Store locations",
        Options = {
            ("Tool Store"),
            ("Gun Store")
        },
        Default = ...,
        Callback = function(v)
            Teleport(Teleports.Stores[v])
        end
    }
)

Sections.Teleports.ATM.AddDropdown(
    {
        Name = "ATM locations",
        Options = {
            ("ATM [1]"),
            ("ATM [2]"),
            ("ATM [3]"),
            ("ATM [4]")
        },
        Default = ...,
        Callback = function(v)
            Teleport(Teleports.ATM[v])
        end
    }
)

Sections.Teleports.Hiding.AddDropdown(
    {
        Name = "Hiding locations",
        Options = {
            ("High Rock Park"),
            ("Cave")
        },
        Default = ...,
        Callback = function(v)
            Teleport(Teleports.Hiding[v])
        end
    }
)



Sections.Autofarms.Autofarms.AddToggle(
    {
        Name = "Auto complete ATM",
        Default = false,
        Callback = function(State)
            Toggles.Criminal.AutoFarms.Atm = State

            while Toggles.Criminal.AutoFarms.Atm == true and wait() do
                for i, v in pairs(
                    game:GetService("Players").LocalPlayer.PlayerGui.GameMenus.ATM.Hacking:GetDescendants()
                ) do
                    if
                        v.ClassName == "TextLabel" and
                            v.Text ==
                                game:GetService("Players").LocalPlayer.PlayerGui.GameMenus.ATM.Hacking.SelectingCode.Text
                     then
                        if v.TextColor3 == Color3.new(0, 0, 0) then
                            mouse1press()
                            wait()
                            mouse1release()
                        end
                    end
                end
            end
        end
    }
)

Sections.Autofarms.Autofarms.AddButton(
    {
        Name = "Auto Lockpick",
        Callback = function()
            for i,v in pairs(game:GetService("Players").LocalPlayer.PlayerGui.GameMenus.Lockpick.Pick:GetDescendants()) do
                v.Size = UDim2.new(1,0,1,100)
            end
        end
    }
)
shared.drilltime = 0
Sections.Autofarms.Autofarms.AddButton(
    {
        Name = "Auto drill",
        Default = false,
        Callback = function(va)
            shared.drilltime = shared.drilltime + 1

            if shared.drilltime < 2 then
                for i, v in pairs(
                    game:GetService("Players").LocalPlayer.PlayerGui.GameMenus.RobJewelry.Drill:GetChildren()
                ) do
                    if v.Name == "Bar" then
                        local TweenPosition = v.TweenPosition
                        hookfunction(
                            TweenPosition,
                            function()
                                return nil
                            end
                        )
                    end
                end
            else
                Library.Notification({Title = "Warning", Content = "Cannot click again", Delay = 5})
            end
        end
    }
)

Sections.Autofarms.Autofarms.AddToggle(
        {
            Name = "Auto-Complete Safe Robbery",
            Default = false,
            Callback = function(State)
                local SafeValues = {
                    [0] = 0;
                    [10] = -36;
                    [20] = 288;
                    [30] = 252;
                    [40] = 216;
                    [50] = 180;
                    [60] = 144;
                    [70] = 108;
                    [80] = 72;
                    [90] = 36;
                }


                SAFE = State
                while SAFE do
                    wait()
                    local Rotation = SafeValues[tonumber(LocalPlayer.PlayerGui.GameMenus.Safe.Top2.TargetNum.Text)] --// Rotation % SafeValues[10] == 0
                    local LocalScript = LocalPlayer.PlayerGui.GameMenus.Safe:FindFirstChild("Movement", true)
                    LocalScript.Disabled = true
                    wait(Random.new():NextInteger(3, 6))
                    LocalScript.Disabled = true
                    LocalPlayer.PlayerGui.GameMenus.Safe.Safe.Dial.Rotation = Rotation + Random.new():NextInteger(-10, 10)
                    mouse1click()
                end
            end
        }
    )
Sections.Autofarms.Dep.AddToggle({
    Name = "Automatically respond to Jewlery Robberies",
    Default = false,
    Callback = function(e)
        ToggledDep = e
        local oldCFrame = plr.Character.HumanoidRootPart.CFrame
        while ToggledDep and wait(4) do
            for v9, v10 in pairs(workspace.JewelryCases:GetChildren()) do
                if v10:FindFirstChild("Robbed") then
                    print(v10.CFrame)

                                game.Players.LocalPlayer.Character.Humanoid.Jump = true
                                wait(0.6)
                                Teleport(v10.CFrame)

                end
            end
        end
    end
})
Sections.Autofarms.Other.AddToggle({
    Name = ("DOT Auto pickup debris"),
    Default = false,
    Callback = function(v)
         getgenv().DOTRunning = v
 
         while DOTRunning do
             for _,v in pairs(game.Workspace.DOTDebris:GetChildren()) do
                 if not string.find("Decid", v.Name) then
                     game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = v.CFrame
                     task.wait(0.5)
                     keypress(0x45) wait(0.3) keyrelease(0x45)
                 end
             end
             wait()
         end
    end
 })

Sections.Autofarms.Other.AddToggle({
   Name = ("DOT Auto OilSpill"),
   Default = false,
   Callback = function(v)
        getgenv().DOTRunningSpill = true

        while DOTRunningSpill do
            for _,v in pairs(game.Workspace.DOTDebris:GetChildren()) do
                if not string.find("Decid", v.Name) then
                    if v.Name == "OilSpill" and game:GetService("Players").LocalPlayer.Backpack:FindFirstChild("Oil Absorbent") then
                        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = v.CFrame
                        local args = {
                            [1] = true
                        }
                        
                        game:GetService("Players").LocalPlayer.Character:FindFirstChild("Oil Absorbent").UseEvent:FireServer(unpack(args))
                
                    end
                end
            end
            wait()
        end
   end
})

Sections.Vehicle.Misc.AddButton(
    {
        Name = "Disable Speed Camera detections",
        Callback = function()
                for _, v in pairs(game.workspace:GetChildren()) do
                    if v.Name == "SpeedTrap" then
                        v.Parent:Destroy()
                    end
                end
                task.wait()
                
        end
    }
)



Sections.Vehicle.Misc.AddButton(
    {
        Name = "Disable Persuit Detection",
        Callback = function()
                for _, v in pairs(game.workspace:GetChildren()) do
                    if v.Name == "EvasionDetection" then
                        v.Parent:Destroy()
                    end
                end
                task.wait()
                
        end
    }
)

Sections.Settings.Setting.AddBind({
    Name = "GUI toggle bind",
    Default = Enum.KeyCode.RightControl,
    Callback = function(State)
        shared.NapkinLibrary.Enabled = not shared.NapkinLibrary.Enabled

    end
})


Sections.Settings.Credits.AddButton({
    Name = "Dawid#7205 - Ui Library maker",
    Callback = function()
    end    
})

Sections.Settings.Credits.AddButton({
    Name = "Hrzn#0911 - Demeter Owner",
    Callback = function()
    end    
})

Sections.Settings.Credits.AddButton({
    Name = "Extrovert#0001 - Demeter Developer",
    Callback = function()
    end    
})

Sections.Settings.Credits.AddButton({
    Name = "Ra!n#0911 - Demeter Developer",
    Callback = function()
    end    
})

Sections.Settings.Credits.AddButton({
    Name = "Ra!n#0911 - Eject all",
    Callback = function()
    end    
})

Sections.Settings.Pricing.AddButton({
    Name = "Free - Free",
    Callback = function()
    end    
})

Sections.Settings.Pricing.AddButton({
    Name = "Premium - 10€/12$ lifetime",
    Callback = function()
    end    
})

Sections.Settings.Pricing.AddButton({
    Name = "Premium - 2€/3$ Monthly",
    Callback = function()
    end    
})


