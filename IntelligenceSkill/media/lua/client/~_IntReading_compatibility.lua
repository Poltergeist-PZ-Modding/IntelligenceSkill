require "ISUI/ISInventoryPane"
require "ISUI/ISToolTipInv"
local utils = require "IntReading_utils"

local function patch(class,fnName,wrapFn)
    class[fnName] = wrapFn(class[fnName])
end
--
--local function wrap(class,fnName,wrapFn)
--    local original = class[fnName]
--    class[fnName] = wrapFn(original)
--end

patch(ISInventoryPane,"doContextualDblClick",function(original)
    return function(self,item,...)
        if item:IsLiterature() then return ISInventoryPaneContextMenu.readItem(item, self.player) end
        return original(self,item,...)
    end
end)

patch(ISToolTipInv,"setItem",function(original) return function(self,item,...)
    if item:IsLiterature() and not item:canBeWrite() and item:getNumberOfPages() <= -1 then utils.BetLitCalcPages(item) end
    return original(self,item,...)
end  end)
