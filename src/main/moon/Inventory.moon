Material = javaImport("$.Material")
InventoryType = javaImport("$.event.inventory.InventoryType")
WEIGHTS = require("weights")

class Inventory
    new: (inv) =>
        @inv = inv

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

return Inventory