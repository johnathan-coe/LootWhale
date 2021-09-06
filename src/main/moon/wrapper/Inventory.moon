WEIGHTS = require("weights")
Location = require("util.Location")
Material = javaImport("$.Material")
InventoryType = javaImport("$.event.inventory.InventoryType")

class Inventory
    new: (inv) =>
        @inv = inv

    -- Deserialise from chest location JSON
    deserialize: (JSON) ->
        location = Location.fromJSON(JSON)
        block = location\getBlock()
        
        if (block\getType() != Material\getMaterial("CHEST"))
            return Inventory(nil)
            
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
        return false if @inv == nil
        return @inv\getType() == InventoryType.CHEST

    setTitle: (name) =>
        state = @inv\getLocation()\getBlock()\getState()
        state\setCustomName(name)
        state\update()

    serializeLoc: =>
        return Location.toJSON(@inv\getLocation())

return Inventory