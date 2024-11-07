local Class = require "utils.classes"
local LineChecker = Class:Extend();

function LineChecker:construct()
    self.line = {}
    self.checked = {}
    self.lastResult = false;
end

function LineChecker:Add(cell)
    table.insert(self.line, cell);
    table.insert(self.checked, false);
end

function LineChecker:ClearChecked()
    for i = 1, #self.line do
        self.checked[i] = false;
    end
    self.lastResult = false;
end

function LineChecker:Test()
    self:ClearChecked();

    local letterLast = 0;
    local countRepeat = 1;
    local startMarker = false

    self.lastResult = false;

    for pos = 1, #self.line do
        if self.line[pos].letter == letterLast and letterLast > 0 then
            countRepeat = countRepeat + 1;
            if countRepeat > 2 then 
                self.checked[pos] = true;
                if not startMarker then 
                    self.checked[pos-1] = true;
                    self.checked[pos-2] = true;
                    startMarker = true
                    self.lastResult = true;
                end
            end
        else 
            countRepeat = 1;
            letterLast = self.line[pos].letter;
            startMarker = false
        end
    end

    return self.lastResult;
end

function LineChecker:CutChecked()
    local score = 0;
    if self.lastResult then 
        for i = 1, #self.line do
            if self.checked[i] then
                self.line[i]:StartAimationCollapse()
                score = score + 1
            end
        end
    end
    return score;
end

function LineChecker:debug()
    local result_line = "len: "..#self.line..'| '
    for i = 1, #self.line do
        result_line = result_line .. " " .. self.line[i].letter
        if self.checked[i] then
            result_line = result_line .. "*"
        else
            result_line = result_line .. " "
        end
    end
    return result_line
end

return LineChecker