--os.execute("cls")

require "utils/strings"
local Class     = require "utils/classes"
local MapModel = require "models/MapModel"

local ConsoleView = require "views/ConsoleView"

local view = ConsoleView:new(10, 10);
local map = MapModel:new(view);
map:init();
map:dump();
view:dump();
local s = io.read();


