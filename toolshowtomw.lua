script_version('ver 0.0.1a')
----------------- [����������] ----------------------------
require('lib.moonloader')
local liberror = {}

local ffi = require('ffi')

local res,ad = pcall(require,'ADDONS')
assert(res,'� ��� ��� ����������: ADDONS')

local res,vkeys = pcall(require,'vkeys')
assert(res,'� ��� ��� ����������: vkeys')

local res,fa = pcall(require,'fAwesome6')
assert(res,'� ��� ��� ����������: fAwesome6')

local res,sampev = pcall(require,'samp.events')
assert(res,'� ��� ��� ����������: samp.events')

local res,imgui = pcall(require,'mimgui')
assert(res,'� ��� ��� ����������: mimgui')

local requests = require('requests')
local encoding = require('encoding')

local inicfg = require 'inicfg'

encoding.default = 'CP1251'
u8 = encoding.UTF8
----------------- [JSON] ----------------------------
local ini = {
    config = {
        globalcom = 'dalboy',
        infobarcom = 'infobar',
        reset = 'resetsc',
        autocargo = false,
        autocargoprod = false,
        autocargoprodtime = false,
        autotruck = false,
        autotruckint = 0,
        skipdialog = false,
        minus_rent = false,
    },
    infobar = {
        time = 0,
        activationinfobar = false,
        salary = false,
        salaryfull = false,
        larec = false,
        rays = false,
        direct = false,
        weight = false,
        renttime = false,
        goal = false,
        pricelarec = 0,
        goalcount = 0,
        posx = 100,
        posy = 300,
        rent = 0
    },
    hotkey = {
        globaliconht = 'Numpad 7',
        infobariconht = 'Numpad 8',
        timerht = 'Numpad 9',
        repcarht = 'X',
        fillht = 'Z',
        faststopht = 'Space',
        lockht = 'L'
    },
    vc = {
        activationvc = false,
        pricelarecvc = 0,
        goalcountvc = 0,
        exchange = 0,
        convert_goal = false
    },
    log = {},
    stats_sa = {
        salary = 0,
        larec = 0,
        rays = 0,
    },
    stats_vc = {
        salary = 0,
        larec = 0,
        rays = 0,
    },
	onDay = {
		today = os.date("%a"),
		online = 0,
		afk = 0,
		full = 0
	},
	onWeek = {
		week = 1,
		online = 0,
		afk = 0,
		full = 0
	},
    myWeekOnline = {
        [0] = 0,
        [1] = 0,
        [2] = 0,
        [3] = 0,
        [4] = 0,
        [5] = 0,
        [6] = 0
    },
    pos = {
        x = 0,
        y = 0
    },
    style = {
    	round = 10.0,
    	colorW = 4279834905,
    	colorT = 4286677377
    },
    statTimers = {
    	state = false,
    	clock = true,
    	sesOnline = true,
    	sesAfk = true, 
    	sesFull = true,
  		dayOnline = true,
  		dayAfk = true,
  		dayFull = true,
		reportsDay = true,
		reportsVse = true,        
		nakazaniyaDay = true,
		nakazaniyaVse = true,
		formsDay = true,
		reportnow = true,
		formsVse = true,
		nowTime = true,
		weekOnline = true,
  		weekAfk = true,
  		weekFull = true
    },
}

local tHotKeyData = {
    edit   = nil,
    save   = {},
    lasted = os.clock(),
}

if not doesDirectoryExist('moonloader/config/') then createDirectory('moonloader/config') end
local inidir = getWorkingDirectory()..'\\config\\dalboy.json'
if not doesFileExist(inidir) then
    local f = io.open(inidir, 'w+')
    f:write(encodeJson(ini)):close()
else
    local f = io.open(inidir, 'r')
    a = f:read('*a')
    ini = decodeJson(a)
    f:close()
end

local arr = os.date("*t")

local Repository = {
	{ 
		name = "AutoReboot",
		file = "AutoReboot.lua",
		libs = {},
		desc = "�������������� ������������ �������� � ����� moonloader �� ����� �� ���������",
		--source = "https://www.blast.hk/threads/59396/",
		source = nil,
		url = "https://raw.githubusercontent.com/Maksim-Avdeenko/atools/main/AutoReboot.lua",
		cmds = {}
	},
	{ 
		name = "AirBrake",
		file = "AirBrake.lua",
		libs = {},
		desc = "��������� ������������ ����� ��������, � ������ ����� �� ��� ������.",
		source = nil,
		url = "https://raw.githubusercontent.com/Maksim-Avdeenko/atools/main/AirBrake.lua",
		cmds = { "Cheat-Code: QE " }
	},
	{ 
		name = "Click Warp",
		file = "clickwarp.lua",
		libs = {},
		desc = "�������� �� ������� ����",
		source = nil,
		url = "https://raw.githubusercontent.com/Maksim-Avdeenko/atools/main/clickwarp.lua",
		cmds = {}
	},
	{ 
		name = "WallHack",
		file = "Skeletal WH.lua",
		libs = {},
		desc = "��������� ������� ������ ������",
		source = nil,
		url = "https://raw.githubusercontent.com/Maksim-Avdeenko/atools/main/Skeletal WH.lua",
		cmds = { "/skeletal" }
	},
	{ 
		name = "Traser Shot",
		file = "Traser Shot.lua",
		libs = {},
		desc = "������� ���� �� ������",
		source = nil,
		url = "https://raw.githubusercontent.com/Maksim-Avdeenko/atools/main/Traser Shot.lua",
		cmds = { "F3" }
	}
}
 
function JSONSave()
    if doesFileExist(inidir) then
        local f = io.open(inidir, 'w+')
        if f then f:write(encodeJson(ini)):close() end
    end
end
----------------- [���������] ----------------------------
local new, str = imgui.new, ffi.string
local icons = {
    ['global'] = new.bool(),
    ['infobar'] = new.bool(),
    ['libs'] = new.bool()
}

url = requests.get("https://pastebin.com/raw/AYsckvAt")
a = decodeJson(url.text)

local box = {
    ----------------- [���������] ----------------------------
    autocargo = new.bool(ini.config.autocargo),
    autocargoprod = new.bool(ini.config.autocargoprod),
    autocargoprodtime = new.bool(ini.config.autocargoprodtime),
    autotruck = new.bool(ini.config.autotruck),
    skipdialog = new.bool(ini.config.skipdialog),
    minus_rent = new.bool(ini.config.minus_rent),

    ----------------- [�������] ----------------------------
    activationinfobar = new.bool(ini.infobar.activationinfobar),
    salary = new.bool(ini.infobar.salary),
    salaryfull = new.bool(ini.infobar.salaryfull),
    larec = new.bool(ini.infobar.larec),
    rays = new.bool(ini.infobar.rays),
    direct = new.bool(ini.infobar.direct),
    weight = new.bool(ini.infobar.weight),
    renttime = new.bool(ini.infobar.renttime),
    goal = new.bool(ini.infobar.goal),

    ----------------- [��� ����] ----------------------------
    activationvc = new.bool(ini.vc.activationvc),
    convert_goal = new.bool(ini.vc.convert_goal)
}
local autotrucklist = {'Linerunner','Tanker','RoadTrain'}
local input = {
    autotruckint = new.int(ini.config.autotruckint),
    globaliconcom = new.char[30](ini.config.globalcom),
    infobariconcom = new.char[30](ini.config.infobarcom),
    reset = new.char[30](ini.config.reset),
    time = new.int(ini.infobar.time),
    pricelarec = new.int(ini.infobar.pricelarec),
    goal = new.int(ini.infobar.goalcount),

    ----------------- [��� ����] ----------------------------
    goalcountvc = new.int(ini.vc.goalcountvc),
    pricelarecvc = new.int(ini.vc.pricelarecvc),
    exchange = new.int(ini.vc.exchange)
}

local other = {
    move = false,
    smsspawn = true,
    menu = new.int(1),
    autotruckitem = new['const char*'][#autotrucklist](autotrucklist),

    direct = '����������',
    weight = '�� ��������',
}

local navigator = {
    x = {
        {1484,' ��� �������� - ��������'},
        {1476,' ��� �������� - ����� ����'},
        {2166,' ��� ������ - ����� ����'},
        {2227,' ��� ������ - ��� ��������'}
    },
    y = {
        {304,' C�� ������ - ��� ��������'},
        {233,' C�� ������ - ��������'}
    }
}
----------------- [������� �������] ----------------------------
local hotkey_func = {
    {ini.hotkey.globaliconht,function() icons['global'][0] = not icons['global'][0] end},
    {ini.hotkey.infobariconht,function() icons['infobar'][0] = not icons['infobar'][0] end},
    {ini.hotkey.lockht,function() sampSendChat('/lock') end},
    {ini.hotkey.fillht,function() sampSendChat('/fillcar') end},
    {ini.hotkey.repcarht,function() sampSendChat('/repcar') end},
    {ini.hotkey.timerht,function() tstate() end}    
}
----------------- [������] ----------------------------
local buttonmenu = 
{{'circle_info','����������'}, 
{'gears','���������'}, 
{'AWARD','��������� �����'}, 
{'keyboard','������� �������'}, 
{'memo_circle_info','��������� ��������'},
{'city','�������������� ����'},
{'file_lines','���-���'},
{'cloud','����������'},
{'gun', '������ ������'},
{'hand', '�������������'}
--{'hand','������'}
}
local buttonmenufunc = 
{function() infoicon() end,
function() settingsicon() end,
function() ypravserv() end,
function() hotkeyicon() end,
function() infobarsettingsicon() end,
function() dopolsoft() end,
function() logicon() end,
function() updateicon() end,
function() givegunimgui() end,
function() blagodarnostimimgui() end
--function() bindermimgui() end
}

local buttoninfoicon = {
    {'timer','����������', function() tstate() end, '���������/������������� ����������'},
    {'bug','��������', function() os.execute("start t.me/painwl") end, '��� ������������� ������� �� ��������'},
    {'rotate_right','�������� ����������', function() reset_stats() end, '��� �������� /resetsc'},
    {'rotate_right','�������� ����������', function() resetCounter() end, '� ��� �������'}
}
local settingshotkey = {
    {'globaliconht','�������� ���� �������','circle_info'},
    {'infobariconht','�������','circle_info'},
    {'timerht','����������','timer'},
    {'fillht','������� ��������','fill_drip'},
    {'repcarht','������� �������','wrench'},
    {'lockht','�������� ����������','key'},
    {'faststopht','������� ������','octagon_exclamation'}
}
local settingsinfobar = {
    {'road',u8'������� ���������� ������',box.rays},
    {'road',u8'���������� ����������� �����',box.direct},
    {'truck_ramp_box',u8'���������� ����������� �����������',box.weight},
    {'truck_clock',u8'���������� ����� �� ����� ������ ����',box.renttime},
    {'bullseye_arrow',u8'���������� ����',box.goal}    
}
local settingsvc = {
    {'right_left','���� $VC',input.exchange},
    {'circle_dollar','��������� �����',input.pricelarecvc},
    {'bullseye_pointer','���� � $VC',input.goalcountvc}
}
---------------------------------------------------------
function main()
    while not isSampAvailable() do wait(0) end
    lua_thread.create(counter)
    sampRegisterChatCommand(ini.config.globalcom,function() icons['global'][0] = not icons['global'][0] end)
    sampRegisterChatCommand(ini.config.infobarcom,function() icons['infobar'][0] = not icons['infobar'][0] end)
    sampRegisterChatCommand(ini.config.reset,function() reset_stats() end)
	
    while true do
        wait(0)
        ----------------- [������] ----------------------------
        for index,id in pairs(hotkey_func) do
            if isKeysDown(id[1]) and (os.clock() - tHotKeyData.lasted > 0.1) and not sampIsCursorActive() then id[2]() end
        end
        if isKeysDown(ini.hotkey.faststopht) and (os.clock() - tHotKeyData.lasted > 0.1) and isCharInAnyCar(PLAYER_PED) and not sampIsCursorActive() then
            lockPlayerControl(true) wait(50) lockPlayerControl(false)
        end
        ---------------------------------------------------------
        if other.move then
            showCursor(true, true)
            ini.infobar.posx, ini.infobar.posy = getCursorPos()
            JSONSave()
            if wasKeyPressed(VK_SPACE) then
                JSONSave()
                other.move = false
                icons['global'][0] = true
                showCursor(false, false)
                sms('������� �������� ���������')
            end
        end
        if #liberror > 0 and sampIsLocalPlayerSpawned() and other.smsspawn then
            icons['libs'][0] = true 
            other.smsspawn = false      
        elseif #liberror == 0 and sampIsLocalPlayerSpawned() and other.smsspawn then
            print('[Dalboy] � ��� ��������� ��� ����������')
            if a['last'] > thisScript().version then
                sms('�������� ����� ������: {mc}'..a['last'])
                sms('��� ���� ��� �� �������� - ��������� �� ������� "����������"')
            else
                sms(string.format('tools howtomw ������� ����������. ���������: {mc}/%s {mr}��� {mc}%s',ini.config.globalcom,ini.hotkey.globaliconht))
				--sms(string.format('tools howtomw ������� ����������. ���������: {mc}/%s {mr}��� {mc}%s',ini.config.globalcom,ini.hotkey.globaliconht))
            end
            other.smsspawn = false
        end
    end
end
----------------- [������] ----------------------------
local childx = 465
local buttonx = 435
local resX, resY = getScreenResolution()
imgui.OnFrame(function() return icons['global'][0] end, function(player)
    imgui.SetNextWindowSize(imgui.ImVec2(900,565), imgui.Cond.Always)
	--imgui.SetNextWindowSize(imgui.ImVec2(-1,-1), imgui.Cond.Always)
    imgui.SetNextWindowPos(imgui.ImVec2(resX / 2, resY / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
    imgui.Begin("globalicon", icons['global'],imgui.WindowFlags.NoTitleBar + imgui.WindowFlags.NoResize + imgui.WindowFlags.NoMove + imgui.WindowFlags.NoScrollbar + imgui.WindowFlags.AlwaysAutoResize)
        imgui.SetCursorPosY(imgui.GetCursorPosY()+5)
        for index,id in pairs(buttonmenu) do
            if ad.PageButton(other.menu[0] == index,fa(id[1]),u8(id[2])) then other.menu[0] = index end
        end

        if other.menu[0] == 6 then
            childx = 645
            buttonx = 120
        else
            childx = 690
            buttonx = 565
        end

        imgui.SetCursorPos(imgui.ImVec2(200,10))
        imgui.BeginChild('globalchild',imgui.ImVec2(childx,545),true, imgui.WindowFlags.NoScrollbar)
            buttonmenufunc[other.menu[0]]()
            --imgui.SetCursorPos(imgui.ImVec2(buttonx,5))
            --if ad.AnimButton(fa('circle_xmark'),imgui.ImVec2(25,25)) then icons['global'][0] = false end
        imgui.EndChild()

    imgui.End()
end)

imgui.OnFrame(function() return icons['infobar'][0] end, function(player)
    if box.activationinfobar[0] then
        imgui.SetNextWindowSize(imgui.ImVec2(-1,-1), imgui.Cond.Always)
        imgui.SetNextWindowPos(imgui.ImVec2(ini.infobar.posx,ini.infobar.posy), imgui.Cond.Always, imgui.ImVec2(1, 1))
        imgui.Begin("infobar", infobaricon, imgui.WindowFlags.NoTitleBar + imgui.WindowFlags.NoResize + imgui.WindowFlags.NoScrollbar + imgui.WindowFlags.AlwaysAutoResize)
            imgui.PushFont(fontsize)
            imgui.CenterTextColoredRGB(get_clock(input.time[0]))
            imgui.PopFont()
            if not box.activationvc[0] then
                local salaryfull = ini.stats_sa.salary + (ini.stats_sa.larec*ini.infobar.pricelarec)
                local salarylarec = ini.stats_sa.larec*ini.infobar.pricelarec

                if box.salary[0] then imgui.Text(fa('circle_dollar')..u8' ��������: '..separator(ini.stats_sa.salary)..'$') end
                if box.salaryfull[0] then imgui.Text(fa('money_bill')..u8' ������ ��������: '..separator(salaryfull)..'$') end
                if box.larec[0] then 
                    imgui.Text(fa('box')..u8' ������: '..separator(ini.stats_sa.larec))
                    imgui.SameLine()
                    imgui.TextDisabled(string.format('(+%s$)',separator(salarylarec)))
                end
                if box.rays[0] then imgui.Text(fa('road')..u8' ������: '..separator(ini.stats_sa.rays)) end
                if box.direct[0] then imgui.Text(fa('road')..u8' ���������: '..u8(other.direct)) end
                if box.weight[0] then imgui.Text(fa('truck_ramp_box')..u8' �����������: '..u8(other.weight)) end
                if ini.infobar.rent >= os.time() and box.renttime[0] then
                    local time_on_rent = ini.infobar.rent - os.time()
                    imgui.Text(fa('clock')..u8' �� ����� ������: '..u8(get_clock(time_on_rent)))
                end
                if box.goal[0] then imgui.CenterTextColoredRGB(fa('bullseye_arrow')..' '..separator(salaryfull)..'$/'..separator(ini.infobar.goalcount)..'$') end
            else
                local salarylarec = ini.stats_vc.larec*ini.vc.pricelarecvc
                local salaryfull = ini.stats_vc.salary + salarylarec
                local salarylarecsa = salarylarec*ini.vc.exchange

                local salarysa = ini.stats_vc.salary*ini.vc.exchange
                local salaryfullsa = salaryfull*ini.vc.exchange

                local goalsa = ini.vc.goalcountvc*ini.vc.exchange
            
                if box.salary[0] then 
                    imgui.Text(fa('circle_dollar')..u8' ��������: '..separator(ini.stats_vc.salary)..'$VC') 
                    imgui.SameLine()
                    imgui.TextDisabled(string.format(u8'(+%s$SA)',separator(salarysa)))
                end
                if box.salaryfull[0] then 
                    imgui.Text(fa('money_bill')..u8' ������ ��������: '..separator(salaryfull)..'$VC')
                    imgui.SameLine()
                    imgui.TextDisabled(string.format(u8'(+%s$SA)',separator(salaryfullsa)))
                end
                if box.larec[0] then 
                    imgui.Text(fa('box')..u8' ������: '..separator(ini.stats_vc.larec))
                    imgui.SameLine()
                    imgui.TextDisabled(string.format('(+%s$VC | +%s$SA)',separator(salarylarec),separator(salarylarecsa)))
                end
                if box.rays[0] then imgui.Text(fa('road')..u8' ������: '..separator(ini.stats_vc.rays)) end
                if ini.infobar.rent >= os.time() and box.renttime[0] then
                    local time_on_rent = ini.infobar.rent - os.time()
                    imgui.Text(fa('clock')..u8' �� ����� ������: '..u8(get_clock(time_on_rent)))
                end
                if box.goal[0] then 
                    if box.convert_goal[0] then
                        imgui.CenterTextColoredRGB(fa('bullseye_arrow')..' '..separator(salaryfullsa)..'$SA/'..separator(goalsa)..'$SA') 
                    else
                        imgui.CenterTextColoredRGB(fa('bullseye_arrow')..' '..separator(salaryfull)..'$VC/'..separator(ini.vc.goalcountvc)..'$VC') 
                    end
                end
            end
        imgui.End()
    end
end).HideCursor = true

imgui.OnFrame(function() return icons['libs'][0] end,
    function(player)
        imgui.SetNextWindowSize(imgui.ImVec2(-1,-1), imgui.Cond.Always)
        imgui.SetNextWindowPos(imgui.ImVec2(resX / 2, resY / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
        imgui.Begin("Dalboy", icons['libs'], imgui.WindowFlags.NoResize + imgui.WindowFlags.NoScrollbar + imgui.WindowFlags.AlwaysAutoResize)
            imgui.CenterTextColoredRGB(u8'� ��� �� ��������� ��������� ����������:')
            for index,id in pairs(liberror) do
                imgui.CenterTextColoredRGB(id.name)
            end
            if imgui.Button(u8'���� ������� c ������������',imgui.ImVec2(-1,30)) then os.execute("start blast.hk/threads/179965") end
        imgui.End()
    end
)

imgui.OnInitialize(function()
    imgui.DarkTheme()
    imgui.GetIO().IniFilename = nil
    local config = imgui.ImFontConfig()
    config.MergeMode = true
    config.PixelSnapH = true
    iconRanges = imgui.new.ImWchar[3](fa.min_range, fa.max_range, 0)
    imgui.GetIO().Fonts:AddFontFromMemoryCompressedBase85TTF(fa.get_font_data_base85('light'), 15, config, iconRanges) -- solid - ��� ������, ��� �� ���� thin, regular, light � duotone
    fontsize = imgui.GetIO().Fonts:AddFontFromFileTTF(getFolderPath(0x14) .. '\\trebucbd.ttf', 20.0, nil, imgui.GetIO().Fonts:GetGlyphRangesCyrillic())
end)

----------------- [������� �����] ----------------------------

function clearchatmimgui()
    lua_thread.create(function()
	sampSendChat("/cc") 
	wait(1000) 
	sampSendChat("/a [TH] ������� ��� ������")
	end)
end

----------------- [������� ���� ������] ----------------------------

function givegunimgui()
    imgui.PushItemWidth(70)
	--imgui.Text(u8"test menu")
	if ad.AnimButton(u8"������ [ 1 ]", imgui.ImVec2(250, 25)) then sampSendChat("/givegun "..getMyId().." 1 100") end
	imgui.SameLine()
	if ad.AnimButton(u8"������ ��� ������ [ 2 ]", imgui.ImVec2(250, 25)) then sampSendChat("/givegun "..getMyId().." 2 100") end
	if ad.AnimButton(u8"����������� ������� [ 3 ]", imgui.ImVec2(250, 25)) then sampSendChat("/givegun "..getMyId().." 3 100") end
	imgui.SameLine()
	if ad.AnimButton(u8"��� [ 4 ]", imgui.ImVec2(250, 25)) then sampSendChat("/givegun "..getMyId().." 4 100") end
	if ad.AnimButton(u8"����������� ���� [ 5 ]", imgui.ImVec2(250, 25)) then sampSendChat("/givegun "..getMyId().." 5 100") end
	imgui.SameLine()
	if ad.AnimButton(u8"������ [ 6 ]", imgui.ImVec2(250, 25)) then sampSendChat("/givegun "..getMyId().." 6 100") end
	if ad.AnimButton(u8"��� [ 7 ]", imgui.ImVec2(250, 25)) then sampSendChat("/givegun "..getMyId().." 7 100") end
	imgui.SameLine()
	if ad.AnimButton(u8"������ [ 8 ]", imgui.ImVec2(250, 25)) then sampSendChat("/givegun "..getMyId().." 8 100") end
	if ad.AnimButton(u8"��������� [ 9 ]", imgui.ImVec2(250, 25)) then sampSendChat("/givegun "..getMyId().." 9 100") end
	imgui.SameLine()
	if ad.AnimButton(u8"������������� ����� [ 10 ]", imgui.ImVec2(250, 25)) then sampSendChat("/givegun "..getMyId().." 10 100") end
	if ad.AnimButton(u8"����� [ 11 ]", imgui.ImVec2(250, 25)) then sampSendChat("/givegun "..getMyId().." 11 100") end
	imgui.SameLine()
	if ad.AnimButton(u8"�������� [ 12 ]", imgui.ImVec2(250, 25)) then sampSendChat("/givegun "..getMyId().." 12 100") end
	if ad.AnimButton(u8"���������� �������� [ 13 ]", imgui.ImVec2(250, 25)) then sampSendChat("/givegun "..getMyId().." 13 100") end
	imgui.SameLine()
	if ad.AnimButton(u8"����� ������ [ 14 ]", imgui.ImVec2(250, 25)) then sampSendChat("/givegun "..getMyId().." 14 100") end
	if ad.AnimButton(u8"������ [ 15 ]", imgui.ImVec2(250, 25)) then sampSendChat("/givegun "..getMyId().." 15 100") end
	imgui.SameLine()
	if ad.AnimButton(u8"������� [ 16 ]", imgui.ImVec2(250, 25)) then sampSendChat("/givegun "..getMyId().." 16 100") end
	if ad.AnimButton(u8"������������ ��� [ 17 ]", imgui.ImVec2(250, 25)) then sampSendChat("/givegun "..getMyId().." 17 100") end
	imgui.SameLine()
	if ad.AnimButton(u8"�������� �������� [ 18 ]", imgui.ImVec2(250, 25)) then sampSendChat("/givegun "..getMyId().." 18 100") end
	if ad.AnimButton(u8"�������� 9�� [ 22 ]", imgui.ImVec2(250, 25)) then sampSendChat("/givegun "..getMyId().." 22 100") end
	imgui.SameLine()
	if ad.AnimButton(u8"�������� 9�� � ���������� [ 23 ]", imgui.ImVec2(250, 25)) then sampSendChat("/givegun "..getMyId().." 23 100") end
	if ad.AnimButton(u8"Desert Eagle [ 24 ]", imgui.ImVec2(250, 25)) then sampSendChat("/givegun "..getMyId().." 24 100") end
	imgui.SameLine()
	if ad.AnimButton(u8"������� �������� [ 25 ]", imgui.ImVec2(250, 25)) then sampSendChat("/givegun "..getMyId().." 25 100") end
	if ad.AnimButton(u8"����� [ 26 ]", imgui.ImVec2(250, 25)) then sampSendChat("/givegun "..getMyId().." 26 100") end
	imgui.SameLine()
	if ad.AnimButton(u8"�������������� �������� [ 27 ]", imgui.ImVec2(250, 25)) then sampSendChat("/givegun "..getMyId().." 27 100") end
	if ad.AnimButton(u8"��� [ 28 ]", imgui.ImVec2(250, 25)) then sampSendChat("/givegun "..getMyId().." 28 100") end
	imgui.SameLine()
	if ad.AnimButton(u8"MP5 [ 29 ]", imgui.ImVec2(250, 25)) then sampSendChat("/givegun "..getMyId().." 29 100") end
	if ad.AnimButton(u8"AK-47 [ 30 ]", imgui.ImVec2(250, 25)) then sampSendChat("/givegun "..getMyId().." 30 100") end
	imgui.SameLine()
	if ad.AnimButton(u8"�������� M4 [ 31 ]", imgui.ImVec2(250, 25)) then sampSendChat("/givegun "..getMyId().." 31 100") end
	if ad.AnimButton(u8"Tec-9 [ 32 ]", imgui.ImVec2(250, 25)) then sampSendChat("/givegun "..getMyId().." 32 100") end
	imgui.SameLine()
	if ad.AnimButton(u8"��������� ����� [ 33 ]", imgui.ImVec2(250, 25)) then sampSendChat("/givegun "..getMyId().." 33 100") end
	if ad.AnimButton(u8"����������� �������� [ 34 ]", imgui.ImVec2(250, 25)) then sampSendChat("/givegun "..getMyId().." 34 100") end
	imgui.SameLine()
	if ad.AnimButton(u8"��� [ 35 ]", imgui.ImVec2(250, 25)) then sampSendChat("/givegun "..getMyId().." 35 100") end
	if ad.AnimButton(u8"��������������� ������ HS [ 36 ]", imgui.ImVec2(250, 25)) then sampSendChat("/givegun "..getMyId().." 36 100") end
	imgui.SameLine()
	if ad.AnimButton(u8"������� [ 37 ]", imgui.ImVec2(250, 25)) then sampSendChat("/givegun "..getMyId().." 37 100") end
	if ad.AnimButton(u8"������� [ 38 ]", imgui.ImVec2(250, 25)) then sampSendChat("/givegun "..getMyId().." 38 100") end
	imgui.SameLine()
	if ad.AnimButton(u8"����� � �������� [ 39 ]", imgui.ImVec2(250, 25)) then sampSendChat("/givegun "..getMyId().."39 100") end
	if ad.AnimButton(u8"��������� � ����� [ 40 ]", imgui.ImVec2(250, 25)) then sampSendChat("/givegun "..getMyId().." 40 100") end
	imgui.SameLine()
	if ad.AnimButton(u8"��������� � ������� [ 41 ]", imgui.ImVec2(250, 25)) then sampSendChat("/givegun "..getMyId().." 41 100") end
	if ad.AnimButton(u8"������������ [ 42 ]", imgui.ImVec2(250, 25)) then sampSendChat("/givegun "..getMyId().." 42 100") end
	imgui.SameLine()
	if ad.AnimButton(u8"����������� [ 43 ]", imgui.ImVec2(250, 25)) then sampSendChat("/givegun "..getMyId().." 43 100") end
	if ad.AnimButton(u8"������ ������� ������� [ 44 ]", imgui.ImVec2(250, 25)) then sampSendChat("/givegun "..getMyId().." 44 100") end
	imgui.SameLine()
	if ad.AnimButton(u8"���������� [ 45 ]", imgui.ImVec2(250, 25)) then sampSendChat("/givegun "..getMyId().." 45 100") end
	if ad.AnimButton(u8"������� [ 46 ]", imgui.ImVec2(250, 25)) then sampSendChat("/givegun "..getMyId().." 46 100") end
end

function bindermimgui()
    imgui.PushItemWidth(70)

	imgui.Text(u8"" .. fa.HEAD_SIDE_HEART .. " Xavier Axmenberg " .. fa.MESSAGE_LINES)
end

function blagodarnostimimgui()
    imgui.PushItemWidth(70)
	imgui.CenterTextColoredRGB(u8"��������� ������������� ���� �����, �� �� ��� ��� ��������� ���������� ")
	imgui.CenterTextColoredRGB(u8"���������� ����� �������, ��� ����� ��� ������� �� ��� �����")
	imgui.Text(u8"(c) howtomw " .. fa.LAPTOP_CODE)
	imgui.Text(u8"Desseluter Axmenberg " .. fa.HANDS_HOLDING_HEART)
	imgui.Text(u8"Ketshi Supreme " .. fa.HAND_HOLDING_HEART)
	imgui.Text(u8"Xavier Axmenberg " .. fa.HEAD_SIDE_HEART)
	--imgui.Text(u8"" .. fa.HEAD_SIDE_HEART .. " Xavier Axmenberg " .. fa.MESSAGE_LINES)
end

function ypravserv()
    imgui.PushItemWidth(70)
	--imgui.Text(u8"test menu")
	if ad.AnimButton(u8"�������� ������� ���", imgui.ImVec2(180, 24)) then clearchatmimgui() end
	if imgui.Button(u8"������ ���� ������", imgui.ImVec2(180, 24)) then givegunimgui() end
	--if imgui.Button(u8"�������� �����������", imgui.ImVec2(200, 25)) then sampSendChat("/uval "..getMyId().." aleave") end
end

function infoicon()
    --imgui.SetCursorPosX(40)
    --imgui.TextColoredRGB(u8'{B57676}Dalboy - {FFFFFF}������ ��� ��������� ������ � �������� ���������')
	imgui.TextColoredRGB(u8'������, {B57676}'..getMyNick()..' {FFFFFF}[{B57676} '..getMyId()..' {FFFFFF}]')
    --imgui.CenterTextColoredRGB(u8'�� ������ �������������.',0)
	imgui.Separator()
	--imgui.TextColoredRGB(u8'����������� ����:')
	imgui.TextColoredRGB(u8'������� �����: '..os.date('[ {B57676}%H:%M:%S {FFFFFF}]'))
    imgui.TextColoredRGB(u8'������� ����: [ {B57676}'..arr.day..'.'.. arr.month..'.'.. arr.year ..' {FFFFFF}]')
	imgui.Separator()
	--imgui.TextColoredRGB(u8'Admin Tools - ������������������� ���������� ���������� �� ���� ���������� MoonLoader. \n������� �� ����� Lua. \n���� ������� - ���������� ������ ������������� ������� �� ������� ������� SA:MP, YouTube RP. \n��������� ���������������� � �������� �����������������.')
	imgui.TextColoredRGB(u8'{B57676}Admin Tools {FFFFFF}- ������������������� ���������� ���������� �� ���� ���������� MoonLoader.')
	imgui.TextColoredRGB(u8'������� �� ����� {B57676}Lua{FFFFFF}.')
	imgui.TextColoredRGB(u8'{B57676}���� ������� {FFFFFF}- ���������� ������ ������������� ������� �� ������� ������� {B57676}SA:MP{FFFFFF}, {B57676}YouTube RP{FFFFFF}.')
	imgui.TextColoredRGB(u8'��������� {B57676}���������������� {FFFFFF}� �������� {B57676}�����������������{FFFFFF}.')
	imgui.Separator()
    --imgui.SetCursorPosY(70)
    imgui.TextColoredRGB(string.format(u8'{B57676}/%s {FFFFFF}��� {B57676}%s {FFFFFF}- �������/������� �������� ���� �������',ini.config.globalcom,ini.hotkey.globaliconht))
    --imgui.TextColoredRGB(string.format(u8'{B57676}/%s {FFFFFF}��� {B57676}%s {FFFFFF}- �������� �������(���� �����������)',ini.config.infobarcom,ini.hotkey.infobariconht))
    --imgui.TextColoredRGB(string.format(u8'{B57676}/%s {FFFFFF}��� {B57676}� ���� ������� {FFFFFF}- �������� ����������',ini.config.reset))
    --imgui.SetCursorPosY(180)
	imgui.Separator()
    imgui.TextColoredRGB(u8'������� ������: {FFFFFF}[ {B57676}'..thisScript().version..' {FFFFFF}]')
	imgui.Separator()
    --imgui.SameLine(315)
    --imgui.TextColoredRGB('{B57676}blast.hk/threads/179965')
    imgui.SetCursorPosY(430)
    imgui.BeginChild('menubutton',imgui.ImVec2(-1,95),true, imgui.WindowFlags.NoScrollbar)
	--imgui.Text(u8(string.format("������� ����: %s", os.date())))
	imgui.TextColoredRGB(u8'����������� ������� howtomw')
	imgui.Separator()
	if ad.AnimButton(u8'Telegram', imgui.ImVec2(180, 24)) then thisScript():unload() end
	imgui.SameLine()
	if ad.AnimButton(u8'���������', imgui.ImVec2(180, 24)) then thisScript():unload() end
	imgui.SameLine()
	if ad.AnimButton(u8'�����', imgui.ImVec2(180, 24)) then thisScript():unload() end
	imgui.Separator()
	--if ad.AnimButton(u8'�������������', imgui.ImVec2(180, 24)) then thisScript():unload() end
	imgui.TextColoredRGB(u8'����������� �� ��������� ���������� � ������ ��������� ������������')
    imgui.EndChild()
end


function settingsicon()
    imgui.PushItemWidth(70)
	imgui.Text(u8"������� ��������� ���� �����")
    if imgui.InputTextWithHint('##global',u8'������� ����',input.globaliconcom,30) then save() end
	imgui.Text(u8"������� ��������� ��������")
    --imgui.SameLine()
    if imgui.InputTextWithHint('##infobar',u8'�������',input.infobariconcom,30) then save() end
    --imgui.SameLine()
	imgui.Text(u8"������� ������ ��������")
    if imgui.InputTextWithHint('##reset',u8'�������',input.reset,30) then save() end
    imgui.PopItemWidth()
    if ad.AnimButton(u8'������������� ������', imgui.ImVec2(180, 24)) then thisScript():reload() end
	--{'rotate_right','�������� ����������', function() resetCounter() end, '� ��� �������'}
	if ad.AnimButton(u8'��������� ������', imgui.ImVec2(180, 24)) then thisScript():unload() end
    if ad.AnimButton(fa('circle_check')..u8' ��������� ���������', imgui.ImVec2(180, 24)) then save() thisScript():reload() end
    --imgui.SetCursorPosY(245)
    --if ad.AnimButton(fa('circle_check')..u8' ��������� ���������',imgui.ImVec2(-1,25)) then thisScript():reload() end
end

function hotkeyicon()
    for index,id in pairs(settingshotkey) do
        imgui.HotKey(u8(id[2]), ini.hotkey, id[1], "��������", string.find(ini.hotkey.globaliconht, '+') and 150 or 75)
        imgui.SameLine()
        imgui.Text(fa(id[3])..' '..u8(id[2]))
    end
    imgui.Text(u8'���� ������ ��������� ������� ������� - ��� ����� ������� \n������� Backspace')
    imgui.SetCursorPosY(imgui.GetCursorPosY()+5)
    if ad.AnimButton(fa('circle_check')..u8' ��������� ���������',imgui.ImVec2(-1,25)) then thisScript():reload() end
end

function infobarsettingsicon()
    imgui.SetCursorPosX(410)
   -- if ad.AnimButton(fa('hand_pointer')) then
     --   if box.activationinfobar[0] then
     --       icons['global'][0] = false
     --       icons['infobar'][0] = true
     --       other.move = true
     --       sms('���-�� ��������� ��������� ������� ������')
     --   else
     --       sms('� ��� �������� �������.')
     --   end
    --end
    --ad.Hint('##move',u8'����������� ��������')
   -- imgui.SetCursorPosY(imgui.GetCursorPosY()-30)
    --if imgui.Checkbox(fa('toggle_on')..u8' ��������� ��������',box.activationinfobar) then save() end
    --if imgui.Checkbox(fa('money_bill')..u8' ������� ���������',box.salary) then save() end
    --imgui.SameLine()
    --if imgui.Checkbox(u8'� �������',box.salaryfull) then save() end
    --if imgui.Checkbox(fa('box')..u8' ������� ������',box.larec) then save() end
    --imgui.PushItemWidth(80)
    --if box.salaryfull[0] then
     --   imgui.SameLine()
     --   if imgui.InputInt(fa('circle_dollar')..u8' ��������� �����',input.pricelarec,0,10) then save() end
    --end
    --for index,id in pairs(settingsinfobar) do
     --   if imgui.Checkbox(fa(id[1])..' '..id[2],id[3]) then save() end
    --end
    --if box.goal[0] then
      --  imgui.SameLine()
     --   if imgui.InputInt(fa('bullseye_pointer')..u8' ����',input.goal,0,15) then save() end
    --end
    imgui.PopItemWidth()
end

function dopolsoft() 
	imgui.PushItemWidth(70)
	imgui.CenterTextColoredRGB(u8'������ ��������������� �����\n�� ������������ Admin Tools\'�')
	imgui.Separator()

	local width = imgui.GetWindowWidth()
		for i, info in ipairs(Repository) do
			if imgui.CollapsingHeader(u8(info.name)) then
	imgui.TextColoredRGB(u8"��� �����: " .. info.file)
	imgui.Separator()
			if info.source ~= nil then
				imgui.TextColoredRGB(u8"������: ")
				imgui.Separator()
				imgui.SameLine(nil, 4)
			if imgui.Link(u8(info.source .. "##" .. i)) then
				os.execute(("explorer.exe \"%s\""):format(info.source))
			end
				end

		if #info.cmds > 1 then
			imgui.TextColoredRGB(u8"������� �������: " .. table.concat(info.cmds, ", "))
			imgui.Separator()
		elseif #info.cmds == 1 then
			imgui.TextColoredRGB(u8"������� �������: " .. info.cmds[1])
			imgui.Separator()
		else
			imgui.TextColoredRGB(u8"���������: ��������������")
			imgui.Separator()
		end
			imgui.TextColoredRGB(u8"��������:")
			imgui.Separator()
			imgui.TextWrapped(u8(info.desc))

			imgui.NewLine()
		local missing = {}
			for name, lib in pairs(info.libs) do
				local exist, _ = pcall(require, lib)
				if not exist then table.insert(missing, name) end
			end

		local path = getWorkingDirectory() .. "\\" .. info.file
			if #missing > 0 then
		imgui.Button(u8("���������� ") .. fa.DOWNLOAD .. "##Repo" .. i, imgui.ImVec2(180, 24))
		imgui.Hint("notlibwarn" .. i, u8"��� ������ ���������� ������ ���������� ����!")

		imgui.TextColoredRGB(u8"{FF0000}���������� ����������:")
			for i, name in pairs(missing) do
				imgui.SameLine(nil, 4)
			if imgui.Link(u8(name)) then
				os.execute(("explorer.exe \"%s\""):format(Libs[name]))
			end
				end
			elseif not doesFileExist(path) then
			imgui.Separator()
				if imgui.Button(u8("���������� ") .. fa.DOWNLOAD .. "##Repo" .. i, imgui.ImVec2(180, 24)) then
					downloadUrlToFile(info.url, path, function (id, status, p1, p2)
						if status == STATUSEX_ENDDOWNLOAD then
							sampAddChatMessage(string.format("������ �{M}%s{W}� ������� ��������!", info.name))
						script.load(path)
				end
					end)
						end
					else
					imgui.Separator()
						imgui.Button(u8("����������� ") .. fa.FILE_CHECK .. "##Repo" .. i, imgui.ImVec2(180, 24))
						imgui.SameLine()
						if imgui.Button(u8("������� ") .. fa.DELETE_LEFT .. "##RepoDel" .. i, imgui.ImVec2(180, 24)) then
							for _, s in ipairs(script.list()) do
								if s.path == path then
							  		s:unload()
								end
							end
							os.remove(path)
							sampAddChatMessage(string.format("{FFFFFF}������ �%s� ������� �����!", info.name))
						end
					end
				else
					local ext = string.match(info.file, "(%.%a+)$")
					if ext ~= nil then
						local len = imgui.CalcTextSize(ext).x
						imgui.SameLine(width - len - 15)
						imgui.TextDisabled(ext)
					end
				end
			end
	imgui.PopItemWidth()
end

function logicon()
--imgui.CenterTextColoredRGB(u8'������ ��������������� �����\n�� ������������ Admin Tools\'�')
--imgui.TextColoredRGB(u8"��������� ������ �� ����: " .. oldStr)
--.TextColoredRGB(u8'', oldStr)
end

function updateicon()
    if a['last'] > thisScript().version then versionact = u8'{FA8072}������������' else versionact = u8'{7FFF00}����������' end
    imgui.TextColoredRGB(u8'������� ������ �������: {B57676}'..thisScript().version)
    imgui.TextColoredRGB(u8'� ��� ����������� '..versionact..u8' {FFFFFF}������ �������.')
    if a['last'] > thisScript().version then
        if ad.AnimButton(fa('cloud_exclamation')..u8' ������� � ���� �������, ��� ���������� ����������') then os.execute("start blast.hk/threads/179965") end
    end
    if a['last'] > thisScript().version then
        imgui.BeginChild('logupdate',imgui.ImVec2(-1,-1-28),true)
            imgui.CenterTextColoredRGB(u8'��������� � {7FFF00}����� ������:',0)
            imgui.Text(a['updatelog'])
        imgui.EndChild()
    end
    if imgui.CollapsingHeader(u8'��� ����������') then
        imgui.Text(a['log'])
    end
end

function save()
    if other.menu[0] == 2 then
        ini.config.autocargo = box.autocargo[0]
        ini.config.autocargoprod = box.autocargoprod[0]
        ini.config.autocargoprodtime = box.autocargoprodtime[0]
        ini.config.autotruck = box.autotruck[0]
        ini.config.skipdialog = box.skipdialog[0]
        ini.config.autotruckint = input.autotruckint[0]
        ini.config.globalcom = u8:decode(str(input.globaliconcom))
        ini.config.infobarcom = u8:decode(str(input.infobariconcom))
        ini.config.reset = u8:decode(str(input.reset))
        ini.config.minus_rent = box.minus_rent[0]
    elseif other.menu[0] == 4 then
        ini.infobar.activationinfobar = box.activationinfobar[0]
        ini.infobar.salary = box.salary[0]
        ini.infobar.salaryfull = box.salaryfull[0]
        ini.infobar.larec = box.larec[0]
        ini.infobar.rays = box.rays[0]
        ini.infobar.direct = box.direct[0]
        ini.infobar.weight = box.weight[0]
        ini.infobar.renttime = box.renttime[0]
        ini.infobar.goal = box.goal[0]
        ini.infobar.pricelarec = input.pricelarec[0]
        ini.infobar.goalcount = input.goal[0]
    elseif other.menu[0] == 5 then
        ini.vc.activationvc = box.activationvc[0]
        ini.vc.convert_goal = box.convert_goal[0]  
        ini.vc.exchange = input.exchange[0]    
        ini.vc.goalcountvc = input.goalcountvc[0]    
        ini.vc.pricelarecvc = input.pricelarecvc[0]        
    end
    JSONSave()
end

function reset_stats()
    if box.activationvc[0] then
        ini.stats_vc.salary = 0
        ini.stats_vc.larec = 0
        ini.stats_vc.rays = 0
    else
        ini.stats_sa.salary = 0
        ini.stats_sa.larec = 0
        ini.stats_sa.rays = 0
    end
    JSONSave()
end
----------------- [Samp.events] ----------------------------
function sampev.onShowDialog(id, style, title, button1, button2, text)
    ----------------- [��������� ���������] ----------------------------
    if id == 15505 and box.autotruck[0] then
        sampSendDialogResponse(15505,1,input.autotruckint[0],-1)
        return false
    end
    if id == 15506 and box.autotruck[0] then 
        sampSendDialogResponse(15506,1,-1,-1)
        return false 
    end
    ----------------- [���� ������ ��������] ----------------------------
    if id == 15558 and box.skipdialog[0] then sampSendDialogResponse(15558,1,-1,-1) return false end
    if id == 15508 and box.skipdialog[0] then sampSendDialogResponse(15508,1,-1,-1)  return false end
    ----------------- [��������� �����] ----------------------------
    if id == 15507 and box.autocargo[0] then
        local gryz = text:match('%[ �������� �������: (%d+) %]')
        local gryz2 = text:match('%[ �������� ��������: (%d+) %]')
        if gryz > '0' then 
            sampSendDialogResponse(15507,1,0,-1)
        elseif gryz == '0' and gryz2 > '0' then
            sampSendDialogResponse(15507,1,1,-1)
        end
        if gryz2 == '0' and gryz == '0' and box.autocargoprod[0] then
            sampSendDialogResponse(15507,1,2,-1)
        elseif gryz2 == '0' and gryz == '0' and os.date('%M') > '55' and box.autocargoprodtime[0] and box.autocargoprod[0] then
            sms('����� ����� 55 �����. ������ ������ �����.')
        end
        return false
    end
end

function sampev.onServerMessage(color, text)
    if text:find('���� �������� �� ����: $(%d+)') then
	    
        local salary = text:match('���� �������� �� ����: $(%d+)')
        ini.stats_sa.salary = ini.stats_sa.salary + salary
        ini.stats_sa.rays = ini.stats_sa.rays + 1
        other.direct = '����������'
        other.weight = '�� ��������'
        table.insert(ini.log,{date = os.date('%d.%m.%Y | %X'),text = '[SA] ���� ��������. ��������: '..separator(salary)..'$'})
        JSONSave()
        sms('���� ��������. �������� �� ����: {mc}'..separator(salary)..'$. {mr}����� ����������: {mc}'..separator(ini.stats_sa.salary)..'$')
        return false
    elseif text:find('���� �������� �� ����: VC$(%d+)') then
        local salary = text:match('���� �������� �� ����: VC$(%d+)')
        ini.stats_vc.salary = ini.stats_vc.salary + salary
        ini.stats_vc.rays = ini.stats_vc.rays + 1
        other.weight = '�� ��������'
        table.insert(ini.log,{date = os.date('%d.%m.%Y | %X'),text = '[VC] ���� ��������. ��������: '..separator(salary)..'$VC'})
        JSONSave()
        sms('���� ��������. �������� �� ����: {mc}'..separator(salary)..'$VC. {mr}����� ����������: {mc}'..separator(ini.stats_vc.salary)..'$VC')
        return false
    end

    if text:find('��������� ���������� ����� ����� �� ��������� �������������� ��������: $(%d+).') then
        local famsalary = text:match('��������� ���������� ����� ����� �� ��������� �������������� ��������: $(%d+)')
        ini.stats_sa.salary = ini.stats_sa.salary + famsalary
        JSONSave()
        sms('����������� � �������� �� �����: {mc}'..separator(famsalary)..'$')
        return false
    end

    if text:find("��� ��� �������� ������� '����� �������������'") then
        if box.activationvc[0] then 
            ini.stats_vc.larec = ini.stats_vc.larec + 1
            sms('��� ����� {mc}����� �������������. {mr}����� ���-��: {mc}'..separator(ini.stats_vc.larec))
            table.insert(ini.log,{date = os.date('%d.%m.%Y | %X'),text = '[VC] ����� ����� �������������'}) 
            JSONSave()
        else 
            ini.stats_sa.larec = ini.stats_sa.larec + 1
            sms('��� ����� {mc}����� �������������. {mr}����� ���-��: {mc}'..separator(ini.stats_sa.larec))
            table.insert(ini.log,{date = os.date('%d.%m.%Y | %X'),text = '[SA] ����� ����� �������������'})
            JSONSave()
        end
        return false
    end

    if text:find("����������� ���������..") then
        other.weight = '��������'
        return false
    end
    if text:find('(.+)%[ID:%d+%] ������� ��� � ������ (.+) �� (%d+)� �� (%d+)') then
        
        local nick,truck,time,money = text:match('(.+)%[ID:%d+%] ������� ��� � ������ (.+) �� (%d+)� �� (%d+)')
        local current = os.time() + time*3600
        ini.infobar.rent = current
        if box.minus_rent[0] then
            ini.stats_sa.salary = ini.stats_sa.salary - money
        end
        table.insert(ini.log,{date = os.date('%d.%m.%Y | %X'),text = string.format('%s_%s ���� � ������ %s �� %s ����� �� %s$',nick,nick1,truck,time,money)}) 
        JSONSave()
    end
    if text:find('�� ���������� ��������� (.+) �� (%d+)� �� (%d+)') then
	    
        local truck,time,money = text:match('�� ���������� ��������� (.+) �� (%d+)� �� (%d+)')
        local current = os.time() + time*3600
        if box.minus_rent[0] then
            ini.stats_sa.salary = ini.stats_sa.salary - money
        end
        ini.infobar.rent = current
        table.insert(ini.log,{date = os.date('%d.%m.%Y | %X'),text = string.format('�� ���������� %s �� %s ����� � ����. ����� �� %s$',truck,time,money)}) 
        JSONSave()
    end
end

function sampev.onSetRaceCheckpoint(type, position, nextPosition, size)
    if box.direct[0] then
        for index,id in pairs(navigator.x) do
            if math.floor(position.x) == id[1] then
                other.direct = id[2]
            end
        end
        for index,id in pairs(navigator.y) do
            if math.floor(position.y) == id[1] then
                other.direct = id[2]
            end
        end
    end
end
----------------- [������ �������] ----------------------------
function sms(text)
    --local text = tostring(text):gsub('{mc}', '{FFA500}'):gsub('{mr}', '{FFFFFF}')
	local text = tostring(text):gsub('{mc}', '{FFFFFF}'):gsub('{mr}', '{FFFFFF}')
    sampAddChatMessage(string.format('[%s] {FFFFFF}%s', thisScript().name, text), 0xA9A9A9)
end

function imgui.CenterTextColoredRGB(text)
    imgui.SetCursorPosX(imgui.GetWindowSize().x / 2 - imgui.CalcTextSize(text).x / 2)
    imgui.TextColoredRGB(text)
end
----------------- [����������] ----------------------------
function counter()
    while true do
        wait(1000)
		if timeStatus then
            input.time[0] = input.time[0] + 1
            ini.infobar.time = input.time[0]
            JSONSave()
        end
    end
end     

function tstate()
    timeStatus = not timeStatus
end

function resetCounter()
	ini.infobar.time = 0
	timeStatus = false
    JSONSave()
    input.time[0] = ini.infobar.time
end

function get_clock(time)
    local timezone_offset = 86400 - os.date('%H', 0) * 3600
    if tonumber(time) >= 86400 then onDay = true else onDay = false end
    return os.date((onDay and math.floor(time / 86400)..'� ' or '')..'%H:%M:%S', time + timezone_offset)
end
----------------------------------------------------
function separator(n)
	local left,num,right = string.match(n,'^([^%d]*%d)(%d*)(.-)$')
	return left..(num:reverse():gsub('(%d%d%d)','%1.'):reverse())..right
end

function imgui.TextColoredRGB(text)
    local style = imgui.GetStyle()
    local colors = style.Colors
    local col = imgui.Col
    
    local designText = function(text__)
        local pos = imgui.GetCursorPos()
        if sampGetChatDisplayMode() == 2 then
            for i = 1, 1 --[[������� ����]] do
                imgui.SetCursorPos(imgui.ImVec2(pos.x + i, pos.y))
                imgui.TextColored(imgui.ImVec4(0, 0, 0, 1), text__) -- shadow
                imgui.SetCursorPos(imgui.ImVec2(pos.x - i, pos.y))
                imgui.TextColored(imgui.ImVec4(0, 0, 0, 1), text__) -- shadow
                imgui.SetCursorPos(imgui.ImVec2(pos.x, pos.y + i))
                imgui.TextColored(imgui.ImVec4(0, 0, 0, 1), text__) -- shadow
                imgui.SetCursorPos(imgui.ImVec2(pos.x, pos.y - i))
                imgui.TextColored(imgui.ImVec4(0, 0, 0, 1), text__) -- shadow
            end
        end
        imgui.SetCursorPos(pos)
    end

    local text = text:gsub('{(%x%x%x%x%x%x)}', '{%1FF}')

    local color = colors[col.Text]
    local start = 1
    local a, b = text:find('{........}', start)   
    
    while a do
        local t = text:sub(start, a - 1)
        if #t > 0 then
            designText(t)
            imgui.TextColored(color, t)
            imgui.SameLine(nil, 0)
        end

        local clr = text:sub(a + 1, b - 1)
        if clr:upper() == 'STANDART' then color = colors[col.Text]
        else
            clr = tonumber(clr, 16)
            if clr then
                local r = bit.band(bit.rshift(clr, 24), 0xFF)
                local g = bit.band(bit.rshift(clr, 16), 0xFF)
                local b = bit.band(bit.rshift(clr, 8), 0xFF)
                local a = bit.band(clr, 0xFF)
                color = imgui.ImVec4(r / 255, g / 255, b / 255, a / 255)
            end
        end

        start = b + 1
        a, b = text:find('{........}', start)
    end
    imgui.NewLine()
    if #text >= start then
        imgui.SameLine(nil, 0)
        designText(text:sub(start))
        imgui.TextColored(color, text:sub(start))
    end
end

function imgui.DarkTheme()
    imgui.SwitchContext()
    --==[ STYLE ]==--
    imgui.GetStyle().WindowPadding = imgui.ImVec2(5, 5)
    imgui.GetStyle().FramePadding = imgui.ImVec2(5, 5)
    imgui.GetStyle().ItemSpacing = imgui.ImVec2(5, 5)
    imgui.GetStyle().ItemInnerSpacing = imgui.ImVec2(2, 2)
    imgui.GetStyle().TouchExtraPadding = imgui.ImVec2(0, 0)
    imgui.GetStyle().IndentSpacing = 0
    imgui.GetStyle().ScrollbarSize = 0
    imgui.GetStyle().GrabMinSize = 10

    --==[ BORDER ]==--
    imgui.GetStyle().WindowBorderSize = 1
    imgui.GetStyle().ChildBorderSize = 1
    imgui.GetStyle().PopupBorderSize = 1
    imgui.GetStyle().FrameBorderSize = 1
    imgui.GetStyle().TabBorderSize = 1

    --==[ ROUNDING ]==--
    imgui.GetStyle().WindowRounding = 10
    imgui.GetStyle().ChildRounding = 5
    imgui.GetStyle().FrameRounding = 5
    imgui.GetStyle().PopupRounding = 5
    imgui.GetStyle().ScrollbarRounding = 5
    imgui.GetStyle().GrabRounding = 5
    imgui.GetStyle().TabRounding = 5

    --==[ ALIGN ]==--
    imgui.GetStyle().WindowTitleAlign = imgui.ImVec2(0.5, 0.5)
    imgui.GetStyle().ButtonTextAlign = imgui.ImVec2(0.5, 0.5)
    imgui.GetStyle().SelectableTextAlign = imgui.ImVec2(0.5, 0.5)
    
    --==[ COLORS ]==--
    imgui.GetStyle().Colors[imgui.Col.Text]                   = imgui.ImVec4(1.00, 1.00, 1.00, 1.00)
    imgui.GetStyle().Colors[imgui.Col.TextDisabled]           = imgui.ImVec4(0.50, 0.50, 0.50, 1.00)
    imgui.GetStyle().Colors[imgui.Col.WindowBg]               = imgui.ImVec4(0.07, 0.07, 0.07, 1.00)
    imgui.GetStyle().Colors[imgui.Col.ChildBg]                = imgui.ImVec4(0.07, 0.07, 0.07, 1.00)
    imgui.GetStyle().Colors[imgui.Col.PopupBg]                = imgui.ImVec4(0.07, 0.07, 0.07, 1.00)
    imgui.GetStyle().Colors[imgui.Col.Border]                 = imgui.ImVec4(0.25, 0.25, 0.26, 0.54)
    imgui.GetStyle().Colors[imgui.Col.BorderShadow]           = imgui.ImVec4(0.00, 0.00, 0.00, 0.00)
    imgui.GetStyle().Colors[imgui.Col.FrameBg]                = imgui.ImVec4(0.12, 0.12, 0.12, 1.00)
    imgui.GetStyle().Colors[imgui.Col.FrameBgHovered]         = imgui.ImVec4(0.25, 0.25, 0.26, 1.00)
    imgui.GetStyle().Colors[imgui.Col.FrameBgActive]          = imgui.ImVec4(0.25, 0.25, 0.26, 1.00)
    imgui.GetStyle().Colors[imgui.Col.TitleBg]                = imgui.ImVec4(0.12, 0.12, 0.12, 1.00)
    imgui.GetStyle().Colors[imgui.Col.TitleBgActive]          = imgui.ImVec4(0.12, 0.12, 0.12, 1.00)
    imgui.GetStyle().Colors[imgui.Col.TitleBgCollapsed]       = imgui.ImVec4(0.12, 0.12, 0.12, 1.00)
    imgui.GetStyle().Colors[imgui.Col.MenuBarBg]              = imgui.ImVec4(0.12, 0.12, 0.12, 1.00)
    imgui.GetStyle().Colors[imgui.Col.ScrollbarBg]            = imgui.ImVec4(0.12, 0.12, 0.12, 1.00)
    imgui.GetStyle().Colors[imgui.Col.ScrollbarGrab]          = imgui.ImVec4(0.00, 0.00, 0.00, 1.00)
    imgui.GetStyle().Colors[imgui.Col.ScrollbarGrabHovered]   = imgui.ImVec4(0.41, 0.41, 0.41, 1.00)
    imgui.GetStyle().Colors[imgui.Col.ScrollbarGrabActive]    = imgui.ImVec4(0.51, 0.51, 0.51, 1.00)
    imgui.GetStyle().Colors[imgui.Col.CheckMark]              = imgui.ImVec4(1.00, 1.00, 1.00, 1.00)
    imgui.GetStyle().Colors[imgui.Col.SliderGrab]             = imgui.ImVec4(0.21, 0.20, 0.20, 1.00)
    imgui.GetStyle().Colors[imgui.Col.SliderGrabActive]       = imgui.ImVec4(0.21, 0.20, 0.20, 1.00)
    imgui.GetStyle().Colors[imgui.Col.Button]                 = imgui.ImVec4(0.12, 0.12, 0.12, 1.00)
    imgui.GetStyle().Colors[imgui.Col.ButtonHovered]          = imgui.ImVec4(0.21, 0.20, 0.20, 1.00)
    imgui.GetStyle().Colors[imgui.Col.ButtonActive]           = imgui.ImVec4(0.41, 0.41, 0.41, 1.00)
    imgui.GetStyle().Colors[imgui.Col.Header]                 = imgui.ImVec4(0.12, 0.12, 0.12, 1.00)
    imgui.GetStyle().Colors[imgui.Col.HeaderHovered]          = imgui.ImVec4(0.20, 0.20, 0.20, 1.00)
    imgui.GetStyle().Colors[imgui.Col.HeaderActive]           = imgui.ImVec4(0.47, 0.47, 0.47, 1.00)
    imgui.GetStyle().Colors[imgui.Col.Separator]              = imgui.ImVec4(0.12, 0.12, 0.12, 1.00)
    imgui.GetStyle().Colors[imgui.Col.SeparatorHovered]       = imgui.ImVec4(0.12, 0.12, 0.12, 1.00)
    imgui.GetStyle().Colors[imgui.Col.SeparatorActive]        = imgui.ImVec4(0.12, 0.12, 0.12, 1.00)
    imgui.GetStyle().Colors[imgui.Col.ResizeGrip]             = imgui.ImVec4(1.00, 1.00, 1.00, 0.25)
    imgui.GetStyle().Colors[imgui.Col.ResizeGripHovered]      = imgui.ImVec4(1.00, 1.00, 1.00, 0.67)
    imgui.GetStyle().Colors[imgui.Col.ResizeGripActive]       = imgui.ImVec4(1.00, 1.00, 1.00, 0.95)
    imgui.GetStyle().Colors[imgui.Col.Tab]                    = imgui.ImVec4(0.12, 0.12, 0.12, 1.00)
    imgui.GetStyle().Colors[imgui.Col.TabHovered]             = imgui.ImVec4(0.28, 0.28, 0.28, 1.00)
    imgui.GetStyle().Colors[imgui.Col.TabActive]              = imgui.ImVec4(0.30, 0.30, 0.30, 1.00)
    imgui.GetStyle().Colors[imgui.Col.TabUnfocused]           = imgui.ImVec4(0.07, 0.10, 0.15, 0.97)
    imgui.GetStyle().Colors[imgui.Col.TabUnfocusedActive]     = imgui.ImVec4(0.14, 0.26, 0.42, 1.00)
    imgui.GetStyle().Colors[imgui.Col.PlotLines]              = imgui.ImVec4(0.61, 0.61, 0.61, 1.00)
    imgui.GetStyle().Colors[imgui.Col.PlotLinesHovered]       = imgui.ImVec4(1.00, 0.43, 0.35, 1.00)
    imgui.GetStyle().Colors[imgui.Col.PlotHistogram]          = imgui.ImVec4(0.90, 0.70, 0.00, 1.00)
    imgui.GetStyle().Colors[imgui.Col.PlotHistogramHovered]   = imgui.ImVec4(1.00, 0.60, 0.00, 1.00)
    imgui.GetStyle().Colors[imgui.Col.TextSelectedBg]         = imgui.ImVec4(1.00, 0.00, 0.00, 0.35)
    imgui.GetStyle().Colors[imgui.Col.DragDropTarget]         = imgui.ImVec4(1.00, 1.00, 0.00, 0.90)
    imgui.GetStyle().Colors[imgui.Col.NavHighlight]           = imgui.ImVec4(0.26, 0.59, 0.98, 1.00)
    imgui.GetStyle().Colors[imgui.Col.NavWindowingHighlight]  = imgui.ImVec4(1.00, 1.00, 1.00, 0.70)
    imgui.GetStyle().Colors[imgui.Col.NavWindowingDimBg]      = imgui.ImVec4(0.80, 0.80, 0.80, 0.20)
    imgui.GetStyle().Colors[imgui.Col.ModalWindowDimBg]       = imgui.ImVec4(0.00, 0.00, 0.00, 0.70)
end
----------------- [Hotkey] ----------------------------
function getDownKeys()
    local curkeys = ''
    local bool = false
    for k, v in pairs(vkeys) do
      if isKeyDown(v) and (v == VK_MENU or v == VK_CONTROL or v == VK_SHIFT or v == VK_LMENU or v == VK_RMENU or v == VK_RCONTROL or v == VK_LCONTROL or v == VK_LSHIFT) then
        if v ~= VK_MENU and v ~= VK_CONTROL and v ~= VK_SHIFT then
          curkeys = v
        end
      end
    end
    for k, v in pairs(vkeys) do
      if isKeyDown(v) and (v ~= VK_MENU and v ~= VK_CONTROL and v ~= VK_SHIFT and v ~= VK_LMENU and v ~= VK_RMENU and v ~= VK_RCONTROL and v ~= VK_LCONTROL and v ~= VK_LSHIFT) then
        if string.len(tostring(curkeys)) == 0 then
          curkeys = v
          return curkeys,true
        else
          curkeys = curkeys .. ' ' .. v
          return curkeys,true
        end
        bool = false
      end
    end
    return curkeys, bool
  end

  function imgui.GetKeysName(keys)
    if type(keys) ~= 'table' then
        return false
    else
        local tKeysName = {}
        for k = 1, #keys do
        tKeysName[k] = vkeys.id_to_name(tonumber(keys[k]))
        end
        return tKeysName
    end
  end
  function string.split(inputstr, sep)
    if sep == nil then
      sep = '%s'
    end
    local t={} ; i=1
    for str in string.gmatch(inputstr, '([^'..sep..']+)') do
      t[i] = str
      i = i + 1
    end
    return t
  end
  function isKeysDown(keylist, pressed)
    if keylist == nil then return end
    keylist = (string.find(keylist, '.+ %p .+') and {keylist:match('(.+) %p .+'), keylist:match('.+ %p (.+)')} or {keylist})
    local tKeys = keylist
    if pressed == nil then
      pressed = false
    end
    if tKeys[1] == nil then
      return false
    end
    local bool = false
    local key = #tKeys < 2 and tKeys[1] or tKeys[2]
    local modified = tKeys[1]
    if #tKeys < 2 then
      if wasKeyPressed(vkeys.name_to_id(key, true)) and not pressed then
        bool = true
      elseif isKeyDown(vkeys.name_to_id(key, true)) and pressed then
        bool = true
      end
    else
      if isKeyDown(vkeys.name_to_id(modified,true)) and not wasKeyReleased(vkeys.name_to_id(modified, true)) then
        if wasKeyPressed(vkeys.name_to_id(key, true)) and not pressed then
          bool = true
        elseif isKeyDown(vkeys.name_to_id(key, true)) and pressed then
          bool = true
        end
      end
    end
    if nextLockKey == keylist then
      if pressed and not wasKeyReleased(vkeys.name_to_id(key, true)) then
        bool = false
      else
        bool = false
        nextLockKey = ''
      end
    end
    return bool
  end
  function imgui.HotKey(name, path, pointer, defaultKey, width)
    local width = width or 90
    local cancel = isKeyDown(0x08)
    local tKeys, saveKeys = string.split(getDownKeys(), ' '),select(2,getDownKeys())
    local name = tostring(name)
    local keys, bool = path[pointer] or defaultKey, false

    local sKeys = keys
    for i=0,2 do
        if imgui.IsMouseClicked(i) then
            tKeys = {i==2 and 4 or i+1}
            saveKeys = true
        end
    end

    if tHotKeyData.edit ~= nil and tostring(tHotKeyData.edit) == name then
        if not cancel then
            if not saveKeys then
                if #tKeys == 0 then
                    sKeys = (math.ceil(imgui.GetTime()) % 2 == 0) and '______' or ' '
                else
                    sKeys = table.concat(imgui.GetKeysName(tKeys), ' + ')
                end
            else
                path[pointer] = table.concat(imgui.GetKeysName(tKeys), ' + ')
                tHotKeyData.edit = nil
                tHotKeyData.lasted = os.clock()
                JSONSave()
            end
        else
            path[pointer] = defaultKey
            tHotKeyData.edit = nil
            tHotKeyData.lasted = os.clock()
            JSONSave()
        end
    end
    imgui.PushStyleColor(imgui.Col.Button, imgui.GetStyle().Colors[imgui.Col.FrameBg])
    imgui.PushStyleColor(imgui.Col.ButtonHovered, imgui.GetStyle().Colors[imgui.Col.FrameBgHovered])
    imgui.PushStyleColor(imgui.Col.ButtonActive, imgui.GetStyle().Colors[imgui.Col.FrameBgActive])
    if imgui.Button((sKeys ~= '' and u8(sKeys) or u8'��������') .. '## '..name, imgui.ImVec2(width, 0)) then
        tHotKeyData.edit = name
    end
    imgui.PopStyleColor(3)
    return bool
end

function getMyNick()
    local result, id = sampGetPlayerIdByCharHandle(playerPed)
    if result then
        local nick = sampGetPlayerNickname(id)
        return nick
    end
end

function getMyId()
    local result, id = sampGetPlayerIdByCharHandle(playerPed)
    if result then
        return id
    end
end