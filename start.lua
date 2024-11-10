-- загружаем вспомогательные библиотеки
require "utils.constants"
require "utils.func"
require "utils.strings"

local MapModel = require "models.MapModel" -- Основная модель данных игры, хранит карту уровня и делегирует все необходимые взаимодействия
local Vector2 =  require "models.Vector2"  -- класс для хранения координат

local AnimationSystem     = require "systems.AnimationSystem"    -- Система-хранилище анимации, для удобного создания анимаций и их отрисовки
local ItemSystem          = require "systems.ItemSystem"         -- Система-хранилище всех элементов игры, с которыми можно взаимодействовать
local LevelRectangleModel = require "models.LevelRectangleModel" -- Модель прямоугольного уровня с полным заполнением
local ConsoleView         = require "views.ConsoleView"          -- Предстваление для отрисовки уровня в консоль

-- Загрузка моделей элементов игры, с которыми можно взаимодействовать
local ItemAModel = require "models.Items.ItemAModel"
local ItemBModel = require "models.Items.ItemBModel"
local ItemCModel = require "models.Items.ItemCModel"
local ItemDModel = require "models.Items.ItemDModel"
local ItemEModel = require "models.Items.ItemEModel"
local ItemFModel = require "models.Items.ItemFModel"

-- создание анимации сбора элементов с игровова поля
local animationCut = AnimationSystem:Add({
    [-4] = "#",
    [-3] = "*",
    [-2] = "+",
    [-1] = "-"
}, {-4,-3,-2,-1})

-- добавление в систему всех игровых предметов, с которыми можно взаимодействовать
ItemSystem:Add(ItemAModel:new(animationCut))
ItemSystem:Add(ItemBModel:new(animationCut))
ItemSystem:Add(ItemCModel:new(animationCut))
ItemSystem:Add(ItemDModel:new(animationCut))
ItemSystem:Add(ItemEModel:new(animationCut))
ItemSystem:Add(ItemFModel:new(animationCut))


-- создание объекта, который занимается отрисовкой данных в консоле
local view = ConsoleView:new(WIDTH, HEIGHT)

-- создание прямоугольново, полностью заполненного, уровня, с паением элементов сверху вниз, и генерацией новых предметов в верхней линии
local levelSquare = LevelRectangleModel:new(WIDTH, HEIGHT)

-- создание модели игры, в которую передается представление в которое он фиксирует данные при DUMP, 
-- и модель уровня, к которой он обращается для создания новых предметов, их размещение на уровне и для проверок линий
local map = MapModel:new(view, levelSquare)

-- базовые значения переменных, завязанных на условиях выхода
local params = {" "}
local isMoved = false

-- проводим начальную иинициализацию уровня и рандомайзера
math.randomseed(os.time())
map:init()

repeat
    repeat 
        -- выполняем базовую логику уровня и все необходимые проверки
        map:tick()

        -- если после хода игрока запустилаь анимация или последовательность действий, которая должна закончить до нового хода игрока
        if isMoved and not map:isNotLoop() then 
            isMoved = false
            params = {" "}
        end

        -- проверяем введенные параметры игрока, для смены места предметов
        if params[1] == "m" and #params > 3 then
            local x = tonumber(params[2])
            local y = tonumber(params[3])
            local arrow = params[4]
            if isRange(x, map.width - 1) and isRange(y, map.height - 1) and in_array(arrow, ARROW_ACCESS)  then
                map:move(Vector2:new(x + 1, y + 1), arrow)
                isMoved = not isMoved
            else
                -- если что-то было введено неправильно, то сообщаем об этом, что бы игрок не думал, что сделал корректный ход, а ничего не произошло
                print("not correct command")
                sleep(1)
            end
        end

        -- если небыло активировано предварительное перемещение, командой игрока
        if not isMoved then
            -- если нет больше вариантов хода, то перемешиваем поле, пока не будет хотя бы 1 возможный ход
            while map.steps == 0 do
                map:mix()
            end
        end

        -- отрисовываем данные на экран
        map:dump()
        view:Draw()

        -- если игрок ввел ход, делаем на 1 секунду предпросмотр перемещения, что бы он увидел куда и что переместил, 
        -- иначе ожидаем 1/8 секунды, что бы наблюдать анимации
        if isMoved then
            sleep(1)
        else
            sleep(0.125)
        end
        
        -- выходим если поле стабилизировалось
    until map:isNotLoop() and not isMoved
    
    -- ждем новой команды от игрока
    params = io.read():split()
until params[1] == 'c' or params[1] == 'q'


