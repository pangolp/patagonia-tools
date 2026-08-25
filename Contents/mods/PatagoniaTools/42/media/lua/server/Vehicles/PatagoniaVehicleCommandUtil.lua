-- Build 42 disabled the sendObjectChange 'removeItemType' / 'addItem' paths on
-- characters (they only warn now). The server must move items with
-- sendRemoveItemFromContainer / sendAddItemToContainer. These helpers wrap the
-- correct B42 calls so the vehicle repair commands stay MP-safe.

PatagoniaVehicleCommandUtil = PatagoniaVehicleCommandUtil or {}

-- Remove up to `count` items of `fullType` from the player's inventory (recursive)
-- and sync the removal to the client. `fullType` may be a full type ("Base.EngineParts")
-- or a bare type ("EngineParts"); getSomeTypeRecurse accepts both.
function PatagoniaVehicleCommandUtil.removeItems(player, fullType, count)
    local inv = player:getInventory()
    local items = inv:getSomeTypeRecurse(fullType, count)
    for i = 0, items:size() - 1 do
        local item = items:get(i)
        local container = item and item:getContainer()
        if container then
            container:DoRemoveItem(item)
            sendRemoveItemFromContainer(container, item)
        end
    end
end

-- Add an already-created item to the player's inventory and sync it to the client.
function PatagoniaVehicleCommandUtil.addItem(player, item)
    if not item then return end
    player:getInventory():AddItem(item)
    sendAddItemToContainer(player:getInventory(), item)
end
