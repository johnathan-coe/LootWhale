Inventory = require("Inventory")
Location = require("util.Location")
Mat = javaImport("$.Material")
NameTag = require("util.NameTag")

class ChestManager
    new: (storage) =>
        @storage = storage

        -- Table mapping serialised locations to names
        @owners = {}
        @pullFromFile()
        
    -- Set ownership of an inventory
    setOwnership: (inv, player) =>
        @owners[inv\serializeLoc()] = player\getName()
        @persist()

    -- Get the owner of an inventory
    getOwner: (inv) =>
        return @owners[inv\serializeLoc()]

    -- Get values
    getValueTable: () =>
        values = {}

        -- For every registered chest
        for locJSON, name in pairs(@owners)
            location = Location.fromJSON(locJSON)
            block = location\getBlock()
            
            -- Ensure the block is still a chest
            if (block\getType() != Mat\getMaterial("CHEST"))
                @owners[locJSON] = nil
                continue
            
            NameTag.setFor(block, "#{name}'s Chest")

            -- Get inventory from block
            inv = Inventory.fromBlock(block)

            -- Increment sum
            values[name] = 0 if values[name] == nil
            values[name] += inv\getWeight()

        @persist()
        return values

    -- Pull saved data from disk
    pullFromFile: () =>
        @owners = @storage\getMapValueAsTable("chests")

    -- Push current ownership data to disk
    persist: () =>
        @storage.setValueFromMap("chests", @owners)

return ChestManager