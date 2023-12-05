script_version('ver 0.0.1a')
----------------- [Библиотеки] ----------------------------
require('lib.moonloader')
local liberror = {}

local ffi = require('ffi')

local res,ad = pcall(require,'ADDONS')
assert(res,'У вас нет библиотеки: ADDONS')

local res,vkeys = pcall(require,'vkeys')
assert(res,'У вас нет библиотеки: vkeys')

local res,fa = pcall(require,'fAwesome6')
assert(res,'У вас нет библиотеки: fAwesome6')

local res,sampev = pcall(require,'samp.events')
assert(res,'У вас нет библиотеки: samp.events')

local res,imgui = pcall(require,'mimgui')
assert(res,'У вас нет библиотеки: mimgui')

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
		desc = "Автоматическая перезагрузка скриптов в папке moonloader во время их изменения",
		--source = "https://www.blast.hk/threads/59396/",
		source = nil,
		url = "https://raw.githubusercontent.com/Maksim-Avdeenko/atools/main/AutoReboot.lua",
		cmds = {}
	},
	{ 
		name = "AirBrake",
		file = "AirBrake.lua",
		libs = {},
		desc = "Позволяет перемещаться через текстуры, и вообще через всё что угодно.",
		source = nil,
		url = "https://raw.githubusercontent.com/Maksim-Avdeenko/atools/main/AirBrake.lua",
		cmds = { "Cheat-Code: QE " }
	},
	{ 
		name = "Click Warp",
		file = "clickwarp.lua",
		libs = {},
		desc = "Телепорт по колёсику мыши",
		source = nil,
		url = "https://raw.githubusercontent.com/Maksim-Avdeenko/atools/main/clickwarp.lua",
		cmds = {}
	},
	{ 
		name = "WallHack",
		file = "Skeletal WH.lua",
		libs = {},
		desc = "Позволяет увидеть рендер игрока",
		source = nil,
		url = "https://raw.githubusercontent.com/Maksim-Avdeenko/atools/main/Skeletal WH.lua",
		cmds = { "/skeletal" }
	},
	{ 
		name = "Traser Shot",
		file = "Traser Shot.lua",
		libs = {},
		desc = "Трейсер пуль от игрока",
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
----------------- [Аргументы] ----------------------------
local new, str = imgui.new, ffi.string
local icons = {
    ['global'] = new.bool(),
    ['infobar'] = new.bool(),
    ['libs'] = new.bool()
}

url = requests.get("https://pastebin.com/raw/AYsckvAt")
a = decodeJson(url.text)

local box = {
    ----------------- [Настройки] ----------------------------
    autocargo = new.bool(ini.config.autocargo),
    autocargoprod = new.bool(ini.config.autocargoprod),
    autocargoprodtime = new.bool(ini.config.autocargoprodtime),
    autotruck = new.bool(ini.config.autotruck),
    skipdialog = new.bool(ini.config.skipdialog),
    minus_rent = new.bool(ini.config.minus_rent),

    ----------------- [Инфобар] ----------------------------
    activationinfobar = new.bool(ini.infobar.activationinfobar),
    salary = new.bool(ini.infobar.salary),
    salaryfull = new.bool(ini.infobar.salaryfull),
    larec = new.bool(ini.infobar.larec),
    rays = new.bool(ini.infobar.rays),
    direct = new.bool(ini.infobar.direct),
    weight = new.bool(ini.infobar.weight),
    renttime = new.bool(ini.infobar.renttime),
    goal = new.bool(ini.infobar.goal),

    ----------------- [Вай Сити] ----------------------------
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

    ----------------- [Вай Сити] ----------------------------
    goalcountvc = new.int(ini.vc.goalcountvc),
    pricelarecvc = new.int(ini.vc.pricelarecvc),
    exchange = new.int(ini.vc.exchange)
}

local other = {
    move = false,
    smsspawn = true,
    menu = new.int(1),
    autotruckitem = new['const char*'][#autotrucklist](autotrucklist),

    direct = 'Неизвестно',
    weight = 'Не пройдено',
}

local navigator = {
    x = {
        {1484,' Лас Вентурас - Диллимор'},
        {1476,' Лас Вентурас - Ангел Пайн'},
        {2166,' Лос Сантос - Ангел Пайн'},
        {2227,' Лос Сантос - Лас Пайсадас'}
    },
    y = {
        {304,' Cан Фиерро - Лас Пайсадас'},
        {233,' Cан Фиерро - Диллимор'}
    }
}
----------------- [Функции хоткеев] ----------------------------
local hotkey_func = {
    {ini.hotkey.globaliconht,function() icons['global'][0] = not icons['global'][0] end},
    {ini.hotkey.infobariconht,function() icons['infobar'][0] = not icons['infobar'][0] end},
    {ini.hotkey.lockht,function() sampSendChat('/lock') end},
    {ini.hotkey.fillht,function() sampSendChat('/fillcar') end},
    {ini.hotkey.repcarht,function() sampSendChat('/repcar') end},
    {ini.hotkey.timerht,function() tstate() end}    
}
----------------- [Визуал] ----------------------------
local buttonmenu = 
{{'circle_info','Информация'}, 
{'gears','Настройки'}, 
{'AWARD','Серверная часть'}, 
{'keyboard','Горячие клавиши'}, 
{'memo_circle_info','Настройки инфобара'},
{'city','Дополнительный софт'},
{'file_lines','Чат-Лог'},
{'cloud','Обновления'},
{'gun', 'Выдача оружия'},
{'hand', 'Благодарности'}
--{'hand','Биндер'}
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
    {'timer','Секундомер', function() tstate() end, 'Запускает/останавливает секундомер'},
    {'bug','Телеграм', function() os.execute("start t.me/painwl") end, 'При возникновении проблем со скриптом'},
    {'rotate_right','Сбросить статистику', function() reset_stats() end, 'Или командой /resetsc'},
    {'rotate_right','Сбросить секундомер', function() resetCounter() end, 'И так понятно'}
}
local settingshotkey = {
    {'globaliconht','Основное меню скрипта','circle_info'},
    {'infobariconht','Инфобар','circle_info'},
    {'timerht','Секундомер','timer'},
    {'fillht','Быстрая заправка','fill_drip'},
    {'repcarht','Быстрая починка','wrench'},
    {'lockht','Закрытие транспорта','key'},
    {'faststopht','Быстрый тормоз','octagon_exclamation'}
}
local settingsinfobar = {
    {'road',u8'Подсчет количества рейсов',box.rays},
    {'road',u8'Отображать направление рейса',box.direct},
    {'truck_ramp_box',u8'Отображать прохождение взвешивания',box.weight},
    {'truck_clock',u8'Отображать время до конца аренды фуры',box.renttime},
    {'bullseye_arrow',u8'Отображать цель',box.goal}    
}
local settingsvc = {
    {'right_left','Курс $VC',input.exchange},
    {'circle_dollar','Стоимость ларца',input.pricelarecvc},
    {'bullseye_pointer','Цель в $VC',input.goalcountvc}
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
        ----------------- [Хоткей] ----------------------------
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
                sms('Позиция инфобара сохранена')
            end
        end
        if #liberror > 0 and sampIsLocalPlayerSpawned() and other.smsspawn then
            icons['libs'][0] = true 
            other.smsspawn = false      
        elseif #liberror == 0 and sampIsLocalPlayerSpawned() and other.smsspawn then
            print('[Dalboy] У вас загружены все библиотеки')
            if a['last'] > thisScript().version then
                sms('Доступна новая версия: {mc}'..a['last'])
                sms('Для того что бы обновить - перейдите во вкладку "Обновления"')
            else
                sms(string.format('tools howtomw успешно запустился. Активация: {mc}/%s {mr}или {mc}%s',ini.config.globalcom,ini.hotkey.globaliconht))
				--sms(string.format('tools howtomw успешно запустился. Активация: {mc}/%s {mr}или {mc}%s',ini.config.globalcom,ini.hotkey.globaliconht))
            end
            other.smsspawn = false
        end
    end
end
----------------- [Мимгуи] ----------------------------
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

                if box.salary[0] then imgui.Text(fa('circle_dollar')..u8' Зарплата: '..separator(ini.stats_sa.salary)..'$') end
                if box.salaryfull[0] then imgui.Text(fa('money_bill')..u8' Полная зарплата: '..separator(salaryfull)..'$') end
                if box.larec[0] then 
                    imgui.Text(fa('box')..u8' Ларцов: '..separator(ini.stats_sa.larec))
                    imgui.SameLine()
                    imgui.TextDisabled(string.format('(+%s$)',separator(salarylarec)))
                end
                if box.rays[0] then imgui.Text(fa('road')..u8' Рейсов: '..separator(ini.stats_sa.rays)) end
                if box.direct[0] then imgui.Text(fa('road')..u8' Навигатор: '..u8(other.direct)) end
                if box.weight[0] then imgui.Text(fa('truck_ramp_box')..u8' Взвешивание: '..u8(other.weight)) end
                if ini.infobar.rent >= os.time() and box.renttime[0] then
                    local time_on_rent = ini.infobar.rent - os.time()
                    imgui.Text(fa('clock')..u8' До конца аренды: '..u8(get_clock(time_on_rent)))
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
                    imgui.Text(fa('circle_dollar')..u8' Зарплата: '..separator(ini.stats_vc.salary)..'$VC') 
                    imgui.SameLine()
                    imgui.TextDisabled(string.format(u8'(+%s$SA)',separator(salarysa)))
                end
                if box.salaryfull[0] then 
                    imgui.Text(fa('money_bill')..u8' Полная зарплата: '..separator(salaryfull)..'$VC')
                    imgui.SameLine()
                    imgui.TextDisabled(string.format(u8'(+%s$SA)',separator(salaryfullsa)))
                end
                if box.larec[0] then 
                    imgui.Text(fa('box')..u8' Ларцов: '..separator(ini.stats_vc.larec))
                    imgui.SameLine()
                    imgui.TextDisabled(string.format('(+%s$VC | +%s$SA)',separator(salarylarec),separator(salarylarecsa)))
                end
                if box.rays[0] then imgui.Text(fa('road')..u8' Рейсов: '..separator(ini.stats_vc.rays)) end
                if ini.infobar.rent >= os.time() and box.renttime[0] then
                    local time_on_rent = ini.infobar.rent - os.time()
                    imgui.Text(fa('clock')..u8' До конца аренды: '..u8(get_clock(time_on_rent)))
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
            imgui.CenterTextColoredRGB(u8'У вас не загружены следующие библиотеки:')
            for index,id in pairs(liberror) do
                imgui.CenterTextColoredRGB(id.name)
            end
            if imgui.Button(u8'Тема скрипта c библиотеками',imgui.ImVec2(-1,30)) then os.execute("start blast.hk/threads/179965") end
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
    imgui.GetIO().Fonts:AddFontFromMemoryCompressedBase85TTF(fa.get_font_data_base85('light'), 15, config, iconRanges) -- solid - тип иконок, так же есть thin, regular, light и duotone
    fontsize = imgui.GetIO().Fonts:AddFontFromFileTTF(getFolderPath(0x14) .. '\\trebucbd.ttf', 20.0, nil, imgui.GetIO().Fonts:GetGlyphRangesCyrillic())
end)

----------------- [Функции тулса] ----------------------------

function clearchatmimgui()
    lua_thread.create(function()
	sampSendChat("/cc") 
	wait(1000) 
	sampSendChat("/a [TH] Игровой чат очищен")
	end)
end

----------------- [Функции меню мимгуи] ----------------------------

function givegunimgui()
    imgui.PushItemWidth(70)
	--imgui.Text(u8"test menu")
	if ad.AnimButton(u8"Кастет [ 1 ]", imgui.ImVec2(250, 25)) then sampSendChat("/givegun "..getMyId().." 1 100") end
	imgui.SameLine()
	if ad.AnimButton(u8"Клюшка для гольфа [ 2 ]", imgui.ImVec2(250, 25)) then sampSendChat("/givegun "..getMyId().." 2 100") end
	if ad.AnimButton(u8"Полицейская дубинка [ 3 ]", imgui.ImVec2(250, 25)) then sampSendChat("/givegun "..getMyId().." 3 100") end
	imgui.SameLine()
	if ad.AnimButton(u8"Нож [ 4 ]", imgui.ImVec2(250, 25)) then sampSendChat("/givegun "..getMyId().." 4 100") end
	if ad.AnimButton(u8"Бейсбольная бита [ 5 ]", imgui.ImVec2(250, 25)) then sampSendChat("/givegun "..getMyId().." 5 100") end
	imgui.SameLine()
	if ad.AnimButton(u8"Лопата [ 6 ]", imgui.ImVec2(250, 25)) then sampSendChat("/givegun "..getMyId().." 6 100") end
	if ad.AnimButton(u8"Кий [ 7 ]", imgui.ImVec2(250, 25)) then sampSendChat("/givegun "..getMyId().." 7 100") end
	imgui.SameLine()
	if ad.AnimButton(u8"Катана [ 8 ]", imgui.ImVec2(250, 25)) then sampSendChat("/givegun "..getMyId().." 8 100") end
	if ad.AnimButton(u8"Бензопила [ 9 ]", imgui.ImVec2(250, 25)) then sampSendChat("/givegun "..getMyId().." 9 100") end
	imgui.SameLine()
	if ad.AnimButton(u8"Двухсторонний дилдо [ 10 ]", imgui.ImVec2(250, 25)) then sampSendChat("/givegun "..getMyId().." 10 100") end
	if ad.AnimButton(u8"Дилдо [ 11 ]", imgui.ImVec2(250, 25)) then sampSendChat("/givegun "..getMyId().." 11 100") end
	imgui.SameLine()
	if ad.AnimButton(u8"Вибратор [ 12 ]", imgui.ImVec2(250, 25)) then sampSendChat("/givegun "..getMyId().." 12 100") end
	if ad.AnimButton(u8"Серебряный вибратор [ 13 ]", imgui.ImVec2(250, 25)) then sampSendChat("/givegun "..getMyId().." 13 100") end
	imgui.SameLine()
	if ad.AnimButton(u8"Букет цветов [ 14 ]", imgui.ImVec2(250, 25)) then sampSendChat("/givegun "..getMyId().." 14 100") end
	if ad.AnimButton(u8"Трость [ 15 ]", imgui.ImVec2(250, 25)) then sampSendChat("/givegun "..getMyId().." 15 100") end
	imgui.SameLine()
	if ad.AnimButton(u8"Граната [ 16 ]", imgui.ImVec2(250, 25)) then sampSendChat("/givegun "..getMyId().." 16 100") end
	if ad.AnimButton(u8"Слезоточивый газ [ 17 ]", imgui.ImVec2(250, 25)) then sampSendChat("/givegun "..getMyId().." 17 100") end
	imgui.SameLine()
	if ad.AnimButton(u8"Коктейль Молотова [ 18 ]", imgui.ImVec2(250, 25)) then sampSendChat("/givegun "..getMyId().." 18 100") end
	if ad.AnimButton(u8"Пистолет 9мм [ 22 ]", imgui.ImVec2(250, 25)) then sampSendChat("/givegun "..getMyId().." 22 100") end
	imgui.SameLine()
	if ad.AnimButton(u8"Пистолет 9мм с глушителем [ 23 ]", imgui.ImVec2(250, 25)) then sampSendChat("/givegun "..getMyId().." 23 100") end
	if ad.AnimButton(u8"Desert Eagle [ 24 ]", imgui.ImVec2(250, 25)) then sampSendChat("/givegun "..getMyId().." 24 100") end
	imgui.SameLine()
	if ad.AnimButton(u8"Обычный дробовик [ 25 ]", imgui.ImVec2(250, 25)) then sampSendChat("/givegun "..getMyId().." 25 100") end
	if ad.AnimButton(u8"Обрез [ 26 ]", imgui.ImVec2(250, 25)) then sampSendChat("/givegun "..getMyId().." 26 100") end
	imgui.SameLine()
	if ad.AnimButton(u8"Скорострельный дробовик [ 27 ]", imgui.ImVec2(250, 25)) then sampSendChat("/givegun "..getMyId().." 27 100") end
	if ad.AnimButton(u8"Узи [ 28 ]", imgui.ImVec2(250, 25)) then sampSendChat("/givegun "..getMyId().." 28 100") end
	imgui.SameLine()
	if ad.AnimButton(u8"MP5 [ 29 ]", imgui.ImVec2(250, 25)) then sampSendChat("/givegun "..getMyId().." 29 100") end
	if ad.AnimButton(u8"AK-47 [ 30 ]", imgui.ImVec2(250, 25)) then sampSendChat("/givegun "..getMyId().." 30 100") end
	imgui.SameLine()
	if ad.AnimButton(u8"Винтовка M4 [ 31 ]", imgui.ImVec2(250, 25)) then sampSendChat("/givegun "..getMyId().." 31 100") end
	if ad.AnimButton(u8"Tec-9 [ 32 ]", imgui.ImVec2(250, 25)) then sampSendChat("/givegun "..getMyId().." 32 100") end
	imgui.SameLine()
	if ad.AnimButton(u8"Охотничье ружье [ 33 ]", imgui.ImVec2(250, 25)) then sampSendChat("/givegun "..getMyId().." 33 100") end
	if ad.AnimButton(u8"Снайперская винтовка [ 34 ]", imgui.ImVec2(250, 25)) then sampSendChat("/givegun "..getMyId().." 34 100") end
	imgui.SameLine()
	if ad.AnimButton(u8"РПГ [ 35 ]", imgui.ImVec2(250, 25)) then sampSendChat("/givegun "..getMyId().." 35 100") end
	if ad.AnimButton(u8"Самонаводящиеся ракеты HS [ 36 ]", imgui.ImVec2(250, 25)) then sampSendChat("/givegun "..getMyId().." 36 100") end
	imgui.SameLine()
	if ad.AnimButton(u8"Огнемет [ 37 ]", imgui.ImVec2(250, 25)) then sampSendChat("/givegun "..getMyId().." 37 100") end
	if ad.AnimButton(u8"Миниган [ 38 ]", imgui.ImVec2(250, 25)) then sampSendChat("/givegun "..getMyId().." 38 100") end
	imgui.SameLine()
	if ad.AnimButton(u8"Сумка с тротилом [ 39 ]", imgui.ImVec2(250, 25)) then sampSendChat("/givegun "..getMyId().."39 100") end
	if ad.AnimButton(u8"Детонатор к сумке [ 40 ]", imgui.ImVec2(250, 25)) then sampSendChat("/givegun "..getMyId().." 40 100") end
	imgui.SameLine()
	if ad.AnimButton(u8"Баллончик с краской [ 41 ]", imgui.ImVec2(250, 25)) then sampSendChat("/givegun "..getMyId().." 41 100") end
	if ad.AnimButton(u8"Огнетушитель [ 42 ]", imgui.ImVec2(250, 25)) then sampSendChat("/givegun "..getMyId().." 42 100") end
	imgui.SameLine()
	if ad.AnimButton(u8"Фотоаппарат [ 43 ]", imgui.ImVec2(250, 25)) then sampSendChat("/givegun "..getMyId().." 43 100") end
	if ad.AnimButton(u8"Прибор ночного видения [ 44 ]", imgui.ImVec2(250, 25)) then sampSendChat("/givegun "..getMyId().." 44 100") end
	imgui.SameLine()
	if ad.AnimButton(u8"Тепловизор [ 45 ]", imgui.ImVec2(250, 25)) then sampSendChat("/givegun "..getMyId().." 45 100") end
	if ad.AnimButton(u8"Парашют [ 46 ]", imgui.ImVec2(250, 25)) then sampSendChat("/givegun "..getMyId().." 46 100") end
end

function bindermimgui()
    imgui.PushItemWidth(70)

	imgui.Text(u8"" .. fa.HEAD_SIDE_HEART .. " Xavier Axmenberg " .. fa.MESSAGE_LINES)
end

function blagodarnostimimgui()
    imgui.PushItemWidth(70)
	imgui.CenterTextColoredRGB(u8"Отдельная благодарность этим людям, за то что они финансово поддержали ")
	imgui.CenterTextColoredRGB(u8"разработку этого скрипта, тем самым дав надежду на его жизнь")
	imgui.Text(u8"(c) howtomw " .. fa.LAPTOP_CODE)
	imgui.Text(u8"Desseluter Axmenberg " .. fa.HANDS_HOLDING_HEART)
	imgui.Text(u8"Ketshi Supreme " .. fa.HAND_HOLDING_HEART)
	imgui.Text(u8"Xavier Axmenberg " .. fa.HEAD_SIDE_HEART)
	--imgui.Text(u8"" .. fa.HEAD_SIDE_HEART .. " Xavier Axmenberg " .. fa.MESSAGE_LINES)
end

function ypravserv()
    imgui.PushItemWidth(70)
	--imgui.Text(u8"test menu")
	if ad.AnimButton(u8"Очистить игровой чат", imgui.ImVec2(180, 24)) then clearchatmimgui() end
	if imgui.Button(u8"Выдать себе оружие", imgui.ImVec2(180, 24)) then givegunimgui() end
	--if imgui.Button(u8"Покинуть организацию", imgui.ImVec2(200, 25)) then sampSendChat("/uval "..getMyId().." aleave") end
end

function infoicon()
    --imgui.SetCursorPosX(40)
    --imgui.TextColoredRGB(u8'{B57676}Dalboy - {FFFFFF}скрипт для упрощения работы и подсчета заработка')
	imgui.TextColoredRGB(u8'Привет, {B57676}'..getMyNick()..' {FFFFFF}[{B57676} '..getMyId()..' {FFFFFF}]')
    --imgui.CenterTextColoredRGB(u8'на работе дальнобойщика.',0)
	imgui.Separator()
	--imgui.TextColoredRGB(u8'Сегодняшняя дата:')
	imgui.TextColoredRGB(u8'Текущее время: '..os.date('[ {B57676}%H:%M:%S {FFFFFF}]'))
    imgui.TextColoredRGB(u8'Текущая дата: [ {B57676}'..arr.day..'.'.. arr.month..'.'.. arr.year ..' {FFFFFF}]')
	imgui.Separator()
	--imgui.TextColoredRGB(u8'Admin Tools - Многофункциональное приложение работающее на базе библиотеки MoonLoader. \nНаписан на языке Lua. \nЦель скрипта - облегчение работы администрации сервера на игровом проекте SA:MP, YouTube RP. \nПриятного времяпровождения и удобного администрирования.')
	imgui.TextColoredRGB(u8'{B57676}Admin Tools {FFFFFF}- Многофункциональное приложение работающее на базе библиотеки MoonLoader.')
	imgui.TextColoredRGB(u8'Написан на языке {B57676}Lua{FFFFFF}.')
	imgui.TextColoredRGB(u8'{B57676}Цель скрипта {FFFFFF}- облегчение работы администрации сервера на игровом проекте {B57676}SA:MP{FFFFFF}, {B57676}YouTube RP{FFFFFF}.')
	imgui.TextColoredRGB(u8'Приятного {B57676}времяпровождения {FFFFFF}и удобного {B57676}администрирования{FFFFFF}.')
	imgui.Separator()
    --imgui.SetCursorPosY(70)
    imgui.TextColoredRGB(string.format(u8'{B57676}/%s {FFFFFF}или {B57676}%s {FFFFFF}- открыть/закрыть основное меню скрипта',ini.config.globalcom,ini.hotkey.globaliconht))
    --imgui.TextColoredRGB(string.format(u8'{B57676}/%s {FFFFFF}или {B57676}%s {FFFFFF}- включить инфобар(если активирован)',ini.config.infobarcom,ini.hotkey.infobariconht))
    --imgui.TextColoredRGB(string.format(u8'{B57676}/%s {FFFFFF}или {B57676}в меню скрипта {FFFFFF}- сбросить статистику',ini.config.reset))
    --imgui.SetCursorPosY(180)
	imgui.Separator()
    imgui.TextColoredRGB(u8'Текущая версия: {FFFFFF}[ {B57676}'..thisScript().version..' {FFFFFF}]')
	imgui.Separator()
    --imgui.SameLine(315)
    --imgui.TextColoredRGB('{B57676}blast.hk/threads/179965')
    imgui.SetCursorPosY(430)
    imgui.BeginChild('menubutton',imgui.ImVec2(-1,95),true, imgui.WindowFlags.NoScrollbar)
	--imgui.Text(u8(string.format("Текущая дата: %s", os.date())))
	imgui.TextColoredRGB(u8'Разработчик скрипта howtomw')
	imgui.Separator()
	if ad.AnimButton(u8'Telegram', imgui.ImVec2(180, 24)) then thisScript():unload() end
	imgui.SameLine()
	if ad.AnimButton(u8'ВКонтакте', imgui.ImVec2(180, 24)) then thisScript():unload() end
	imgui.SameLine()
	if ad.AnimButton(u8'Форум', imgui.ImVec2(180, 24)) then thisScript():unload() end
	imgui.Separator()
	--if ad.AnimButton(u8'Благодарности', imgui.ImVec2(180, 24)) then thisScript():unload() end
	imgui.TextColoredRGB(u8'Предложения по улучшению отправлять в личные сообщения разработчику')
    imgui.EndChild()
end


function settingsicon()
    imgui.PushItemWidth(70)
	imgui.Text(u8"Команда активации меню тулса")
    if imgui.InputTextWithHint('##global',u8'Главное окно',input.globaliconcom,30) then save() end
	imgui.Text(u8"Команда активации инфобара")
    --imgui.SameLine()
    if imgui.InputTextWithHint('##infobar',u8'Инфобар',input.infobariconcom,30) then save() end
    --imgui.SameLine()
	imgui.Text(u8"Команда сброса инфобара")
    if imgui.InputTextWithHint('##reset',u8'Инфобар',input.reset,30) then save() end
    imgui.PopItemWidth()
    if ad.AnimButton(u8'Перезагрузить скрипт', imgui.ImVec2(180, 24)) then thisScript():reload() end
	--{'rotate_right','Сбросить секундомер', function() resetCounter() end, 'И так понятно'}
	if ad.AnimButton(u8'Выгрузить скрипт', imgui.ImVec2(180, 24)) then thisScript():unload() end
    if ad.AnimButton(fa('circle_check')..u8' Сохранить настройки', imgui.ImVec2(180, 24)) then save() thisScript():reload() end
    --imgui.SetCursorPosY(245)
    --if ad.AnimButton(fa('circle_check')..u8' Применить настройки',imgui.ImVec2(-1,25)) then thisScript():reload() end
end

function hotkeyicon()
    for index,id in pairs(settingshotkey) do
        imgui.HotKey(u8(id[2]), ini.hotkey, id[1], "Свободно", string.find(ini.hotkey.globaliconht, '+') and 150 or 75)
        imgui.SameLine()
        imgui.Text(fa(id[3])..' '..u8(id[2]))
    end
    imgui.Text(u8'Если хотите выключить горячую клавишу - при смене клавиши \nнажмите Backspace')
    imgui.SetCursorPosY(imgui.GetCursorPosY()+5)
    if ad.AnimButton(fa('circle_check')..u8' Применить настройки',imgui.ImVec2(-1,25)) then thisScript():reload() end
end

function infobarsettingsicon()
    imgui.SetCursorPosX(410)
   -- if ad.AnimButton(fa('hand_pointer')) then
     --   if box.activationinfobar[0] then
     --       icons['global'][0] = false
     --       icons['infobar'][0] = true
     --       other.move = true
     --       sms('Что-бы сохранить положение нажмите ПРОБЕЛ')
     --   else
     --       sms('У вас отключен инфобар.')
     --   end
    --end
    --ad.Hint('##move',u8'Перемещение инфобара')
   -- imgui.SetCursorPosY(imgui.GetCursorPosY()-30)
    --if imgui.Checkbox(fa('toggle_on')..u8' Активация инфобара',box.activationinfobar) then save() end
    --if imgui.Checkbox(fa('money_bill')..u8' Подсчет заработка',box.salary) then save() end
    --imgui.SameLine()
    --if imgui.Checkbox(u8'с ларцами',box.salaryfull) then save() end
    --if imgui.Checkbox(fa('box')..u8' Подсчет ларцов',box.larec) then save() end
    --imgui.PushItemWidth(80)
    --if box.salaryfull[0] then
     --   imgui.SameLine()
     --   if imgui.InputInt(fa('circle_dollar')..u8' Стоимость ларца',input.pricelarec,0,10) then save() end
    --end
    --for index,id in pairs(settingsinfobar) do
     --   if imgui.Checkbox(fa(id[1])..' '..id[2],id[3]) then save() end
    --end
    --if box.goal[0] then
      --  imgui.SameLine()
     --   if imgui.InputInt(fa('bullseye_pointer')..u8' Цель',input.goal,0,15) then save() end
    --end
    imgui.PopItemWidth()
end

function dopolsoft() 
	imgui.PushItemWidth(70)
	imgui.CenterTextColoredRGB(u8'Раздел дополнительного софта\nот разработчика Admin Tools\'а')
	imgui.Separator()

	local width = imgui.GetWindowWidth()
		for i, info in ipairs(Repository) do
			if imgui.CollapsingHeader(u8(info.name)) then
	imgui.TextColoredRGB(u8"Имя файла: " .. info.file)
	imgui.Separator()
			if info.source ~= nil then
				imgui.TextColoredRGB(u8"Ссылка: ")
				imgui.Separator()
				imgui.SameLine(nil, 4)
			if imgui.Link(u8(info.source .. "##" .. i)) then
				os.execute(("explorer.exe \"%s\""):format(info.source))
			end
				end

		if #info.cmds > 1 then
			imgui.TextColoredRGB(u8"Команды скрипта: " .. table.concat(info.cmds, ", "))
			imgui.Separator()
		elseif #info.cmds == 1 then
			imgui.TextColoredRGB(u8"Команда скрипта: " .. info.cmds[1])
			imgui.Separator()
		else
			imgui.TextColoredRGB(u8"Активация: автоматическая")
			imgui.Separator()
		end
			imgui.TextColoredRGB(u8"Описание:")
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
		imgui.Button(u8("Установить ") .. fa.DOWNLOAD .. "##Repo" .. i, imgui.ImVec2(180, 24))
		imgui.Hint("notlibwarn" .. i, u8"Для начала установите важные компоненты ниже!")

		imgui.TextColoredRGB(u8"{FF0000}Необходимо установить:")
			for i, name in pairs(missing) do
				imgui.SameLine(nil, 4)
			if imgui.Link(u8(name)) then
				os.execute(("explorer.exe \"%s\""):format(Libs[name]))
			end
				end
			elseif not doesFileExist(path) then
			imgui.Separator()
				if imgui.Button(u8("Установить ") .. fa.DOWNLOAD .. "##Repo" .. i, imgui.ImVec2(180, 24)) then
					downloadUrlToFile(info.url, path, function (id, status, p1, p2)
						if status == STATUSEX_ENDDOWNLOAD then
							sampAddChatMessage(string.format("Скрипт «{M}%s{W}» успешно загружен!", info.name))
						script.load(path)
				end
					end)
						end
					else
					imgui.Separator()
						imgui.Button(u8("Установлено ") .. fa.FILE_CHECK .. "##Repo" .. i, imgui.ImVec2(180, 24))
						imgui.SameLine()
						if imgui.Button(u8("Удалить ") .. fa.DELETE_LEFT .. "##RepoDel" .. i, imgui.ImVec2(180, 24)) then
							for _, s in ipairs(script.list()) do
								if s.path == path then
							  		s:unload()
								end
							end
							os.remove(path)
							sampAddChatMessage(string.format("{FFFFFF}Скрипт «%s» успешно удалён!", info.name))
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
--imgui.CenterTextColoredRGB(u8'Раздел дополнительного софта\nот разработчика Admin Tools\'а')
--imgui.TextColoredRGB(u8"Последняя строка из чата: " .. oldStr)
--.TextColoredRGB(u8'', oldStr)
end

function updateicon()
    if a['last'] > thisScript().version then versionact = u8'{FA8072}неактуальная' else versionact = u8'{7FFF00}актуальная' end
    imgui.TextColoredRGB(u8'Текущая версия скрипта: {B57676}'..thisScript().version)
    imgui.TextColoredRGB(u8'У вас установлена '..versionact..u8' {FFFFFF}версия скрипта.')
    if a['last'] > thisScript().version then
        if ad.AnimButton(fa('cloud_exclamation')..u8' Перейти в тему скрипта, для скачивания обновления') then os.execute("start blast.hk/threads/179965") end
    end
    if a['last'] > thisScript().version then
        imgui.BeginChild('logupdate',imgui.ImVec2(-1,-1-28),true)
            imgui.CenterTextColoredRGB(u8'Изменения в {7FFF00}новой версии:',0)
            imgui.Text(a['updatelog'])
        imgui.EndChild()
    end
    if imgui.CollapsingHeader(u8'Лог обновлений') then
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
    ----------------- [Автовыбор грузовика] ----------------------------
    if id == 15505 and box.autotruck[0] then
        sampSendDialogResponse(15505,1,input.autotruckint[0],-1)
        return false
    end
    if id == 15506 and box.autotruck[0] then 
        sampSendDialogResponse(15506,1,-1,-1)
        return false 
    end
    ----------------- [Скип лишних диалогов] ----------------------------
    if id == 15558 and box.skipdialog[0] then sampSendDialogResponse(15558,1,-1,-1) return false end
    if id == 15508 and box.skipdialog[0] then sampSendDialogResponse(15508,1,-1,-1)  return false end
    ----------------- [Автовыбор груза] ----------------------------
    if id == 15507 and box.autocargo[0] then
        local gryz = text:match('%[ осталось цистерн: (%d+) %]')
        local gryz2 = text:match('%[ осталось прицепов: (%d+) %]')
        if gryz > '0' then 
            sampSendDialogResponse(15507,1,0,-1)
        elseif gryz == '0' and gryz2 > '0' then
            sampSendDialogResponse(15507,1,1,-1)
        end
        if gryz2 == '0' and gryz == '0' and box.autocargoprod[0] then
            sampSendDialogResponse(15507,1,2,-1)
        elseif gryz2 == '0' and gryz == '0' and os.date('%M') > '55' and box.autocargoprodtime[0] and box.autocargoprod[0] then
            sms('Время более 55 минут. Отмена выбора груза.')
        end
        return false
    end
end

function sampev.onServerMessage(color, text)
    if text:find('Ваша зарплата за рейс: $(%d+)') then
	    
        local salary = text:match('Ваша зарплата за рейс: $(%d+)')
        ini.stats_sa.salary = ini.stats_sa.salary + salary
        ini.stats_sa.rays = ini.stats_sa.rays + 1
        other.direct = 'Неизвестно'
        other.weight = 'не пройдено'
        table.insert(ini.log,{date = os.date('%d.%m.%Y | %X'),text = '[SA] Рейс завершен. Зарплата: '..separator(salary)..'$'})
        JSONSave()
        sms('Рейс завершен. Зарплата на рейс: {mc}'..separator(salary)..'$. {mr}Всего заработано: {mc}'..separator(ini.stats_sa.salary)..'$')
        return false
    elseif text:find('Ваша зарплата за рейс: VC$(%d+)') then
        local salary = text:match('Ваша зарплата за рейс: VC$(%d+)')
        ini.stats_vc.salary = ini.stats_vc.salary + salary
        ini.stats_vc.rays = ini.stats_vc.rays + 1
        other.weight = 'не пройдено'
        table.insert(ini.log,{date = os.date('%d.%m.%Y | %X'),text = '[VC] Рейс завершен. Зарплата: '..separator(salary)..'$VC'})
        JSONSave()
        sms('Рейс завершен. Зарплата на рейс: {mc}'..separator(salary)..'$VC. {mr}Всего заработано: {mc}'..separator(ini.stats_vc.salary)..'$VC')
        return false
    end

    if text:find('Благодаря улучшениям вашей семьи вы получаете дополнительную зарплату: $(%d+).') then
        local famsalary = text:match('Благодаря улучшениям вашей семьи вы получаете дополнительную зарплату: $(%d+)')
        ini.stats_sa.salary = ini.stats_sa.salary + famsalary
        JSONSave()
        sms('Прибавление к зарплате за семью: {mc}'..separator(famsalary)..'$')
        return false
    end

    if text:find("Вам был добавлен предмет 'Ларец дальнобойщика'") then
        if box.activationvc[0] then 
            ini.stats_vc.larec = ini.stats_vc.larec + 1
            sms('Вам выпал {mc}ларец дальнобойщика. {mr}Общее кол-во: {mc}'..separator(ini.stats_vc.larec))
            table.insert(ini.log,{date = os.date('%d.%m.%Y | %X'),text = '[VC] Выпал ларец дальнобойщика'}) 
            JSONSave()
        else 
            ini.stats_sa.larec = ini.stats_sa.larec + 1
            sms('Вам выпал {mc}ларец дальнобойщика. {mr}Общее кол-во: {mc}'..separator(ini.stats_sa.larec))
            table.insert(ini.log,{date = os.date('%d.%m.%Y | %X'),text = '[SA] Выпал ларец дальнобойщика'})
            JSONSave()
        end
        return false
    end

    if text:find("Взвешивание завершено..") then
        other.weight = 'пройдено'
        return false
    end
    if text:find('(.+)%[ID:%d+%] передал вам в аренду (.+) на (%d+)ч за (%d+)') then
        
        local nick,truck,time,money = text:match('(.+)%[ID:%d+%] передал вам в аренду (.+) на (%d+)ч за (%d+)')
        local current = os.time() + time*3600
        ini.infobar.rent = current
        if box.minus_rent[0] then
            ini.stats_sa.salary = ini.stats_sa.salary - money
        end
        table.insert(ini.log,{date = os.date('%d.%m.%Y | %X'),text = string.format('%s_%s сдал в аренду %s на %s часов за %s$',nick,nick1,truck,time,money)}) 
        JSONSave()
    end
    if text:find('Вы арендовали транспорт (.+) на (%d+)ч за (%d+)') then
	    
        local truck,time,money = text:match('Вы арендовали транспорт (.+) на (%d+)ч за (%d+)')
        local current = os.time() + time*3600
        if box.minus_rent[0] then
            ini.stats_sa.salary = ini.stats_sa.salary - money
        end
        ini.infobar.rent = current
        table.insert(ini.log,{date = os.date('%d.%m.%Y | %X'),text = string.format('Вы арендовали %s на %s часов с парк. места за %s$',truck,time,money)}) 
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
----------------- [Прочие функции] ----------------------------
function sms(text)
    --local text = tostring(text):gsub('{mc}', '{FFA500}'):gsub('{mr}', '{FFFFFF}')
	local text = tostring(text):gsub('{mc}', '{FFFFFF}'):gsub('{mr}', '{FFFFFF}')
    sampAddChatMessage(string.format('[%s] {FFFFFF}%s', thisScript().name, text), 0xA9A9A9)
end

function imgui.CenterTextColoredRGB(text)
    imgui.SetCursorPosX(imgui.GetWindowSize().x / 2 - imgui.CalcTextSize(text).x / 2)
    imgui.TextColoredRGB(text)
end
----------------- [Секундомер] ----------------------------
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
    return os.date((onDay and math.floor(time / 86400)..'д ' or '')..'%H:%M:%S', time + timezone_offset)
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
            for i = 1, 1 --[[Степень тени]] do
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
    if imgui.Button((sKeys ~= '' and u8(sKeys) or u8'Свободно') .. '## '..name, imgui.ImVec2(width, 0)) then
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