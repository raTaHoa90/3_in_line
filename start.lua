--os.execute("cls")

require "utils/strings"
local Class     = require "utils/classes"
local Vector2   = require "models/Vector2"
local CellModel = require "models/CellModel"

local ConsoleView = require "views/ConsoleView"

local view = ConsoleView:new(10, 10);

view:dump();
local s = io.read();

print("test "..#s:split(), view:InstanceOf(ConsoleView), view:InstanceOf(Vector2));
