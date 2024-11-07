--os.execute("cls")

function sleep (a) 
    local sec = tonumber(os.clock() + a); 
    while (os.clock() < sec) do 
    end 
end

function in_array (val, tab)
    for index, value in ipairs(tab) do
        if value == val then
            return true
        end
    end

    return false
end

function isDiap(num, max)
    return num and num >= 0 and num <= max;
end

require "utils.strings"
local Class    = require "utils.classes"
local MapModel = require "models.MapModel"
local Vector2 =  require "models.Vector2"

local LevelRectangleModel = require "models.LevelRectangleModel"
local ConsoleView = require "views.ConsoleView"

local WIDTH = 10
local HEIGHT = 10

local view = ConsoleView:new(WIDTH, HEIGHT);
local levelSquare = LevelRectangleModel:new(WIDTH, HEIGHT)
local map = MapModel:new(view, levelSquare);
local params = {" "}
local ARROW_ACCESS = {"l","r","u","d"};

local isMoved = false

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
            if isDiap(x, WIDTH - 1) and isDiap(y, HEIGHT - 1) and in_array(arrow, ARROW_ACCESS)  then
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


