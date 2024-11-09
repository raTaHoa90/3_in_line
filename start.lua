--os.execute("cls")

require "utils.func"
require "utils.strings"
local Class    = require "utils.classes"
local MapModel = require "models.MapModel"
local Vector2 =  require "models.Vector2"
local CellModel = require "models.CellModel"

local AnimationSystem     = require "systems.AnimationSystem"
local ItemSystem          = require "systems.ItemSystem"
local LevelRectangleModel = require "models.LevelRectangleModel"
local ConsoleView         = require "views.ConsoleView"

local ItemAModel = require "models.Items.ItemAModel"
local ItemBModel = require "models.Items.ItemBModel"
local ItemCModel = require "models.Items.ItemCModel"
local ItemDModel = require "models.Items.ItemDModel"
local ItemEModel = require "models.Items.ItemEModel"
local ItemFModel = require "models.Items.ItemFModel"

local animationCut = AnimationSystem:Add({
    [-4] = "#",
    [-3] = "*",
    [-2] = "+",
    [-1] = "-"
}, {-4,-3,-2,-1})

ItemSystem:Add(ItemAModel:new(animationCut))
ItemSystem:Add(ItemBModel:new(animationCut))
ItemSystem:Add(ItemCModel:new(animationCut))
ItemSystem:Add(ItemDModel:new(animationCut))
ItemSystem:Add(ItemEModel:new(animationCut))
ItemSystem:Add(ItemFModel:new(animationCut))

WIDTH = 10
HEIGHT = 10

local view = ConsoleView:new(WIDTH, HEIGHT);
local levelSquare = LevelRectangleModel:new(WIDTH, HEIGHT)
local map = MapModel:new(view, levelSquare);
local params = {" "}
local ARROW_ACCESS = {"l","r","u","d"};

local isMoved = false

if false then -- DEBUG CELL ANIMATION CODE

    local test = CellModel:new(nil, Vector2:new(1,1))
    local TestRender = ConsoleView:Extend()
    function TestRender:write(x, y, progress)
        local item = ItemSystem:FindByValue(progress)
        local letter = " ";
        if item then
            letter = ItemSystem:Get(item):toDump(progress)
        end
        print('test: ', letter)
    end
    local testDraw = TestRender:new(1,1)
    test:init()
    test:StartAimationCollapse()
    test:dump(testDraw);
    repeat
        test:tick();

        test:dump(testDraw);
        sleep(1)

    until not test:hasAnimationRun()
end


math.randomseed(os.time())
map:init();
repeat

    repeat 
        map:tick();
        if map.isEmptyCell then
            levelSquare:FillEmptyCell()
        end

        if isMoved and not map:isNotLoop() then 
            isMoved = false;
            params = {" "}
        end

        if params[1] == "m" and #params > 3 then
            local x = tonumber(params[2]);
            local y = tonumber(params[3]);
            local arrow = params[4]
            if isRange(x, WIDTH - 1) and isRange(y, HEIGHT - 1) and in_array(arrow, ARROW_ACCESS)  then
                map:move(Vector2:new(x + 1, y + 1), arrow)
                isMoved = not isMoved
            else
                print("not correct command")
                sleep(1);
            end
        end

        map:dump();
        view:Draw();
        --levelSquare:debug()
        --print("status: moved=", map.isMoved, " animated=", map.isAnimate, " empty=", map.isEmptyCell);
        if isMoved then
            sleep(1);
        else
            sleep(0.125);
        end
        
    until map:isNotLoop() and not isMoved
    
    local command = io.read();
    params = command:split()
until params[1] == 'c' or params[1] == 'q'


