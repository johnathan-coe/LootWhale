Material = javaImport("$.Material")
InventoryType = javaImport("$.event.inventory.InventoryType")
WEIGHTS = require("weights")
Location = require("util.Location")

class Inventory
    new: (inv) =>
        @inv = inv

    fromBlock: (block) ->
        return Inventory(block\getState()\getInventory())

    getWeight: =>
        weight = 0

        for item, points in pairs(WEIGHTS)
            -- Get the material
            m = Material\getMaterial(item)

            -- Get all stacks of this material
            stacks = @inv\all(m)

            -- For each stack
            for _, stack in pairs(util.getTableFromMap(stacks))
                weight += points * stack\getAmount()

        return weight

    isChest: =>
        return @inv\getType() == InventoryType.CHEST

    serializeLoc: =>
        return Location.toJSON(@inv\getLocation())

return Inventory