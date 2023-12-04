require "TimedActions/IntReading_ISReadABook"

require "ISUI/ISInventoryPaneContextMenu"
ISInventoryPaneContextMenu.readItem = function(item, player)
    local playerObj = getSpecificPlayer(player)
    if item:getContainer() == nil then return end
    ISInventoryPaneContextMenu.transferIfNeeded(playerObj, item)
    ISTimedActionQueue.add(ISReadABookInt:new(playerObj, item, 150))
end
