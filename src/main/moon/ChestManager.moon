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

            @ensureLocationCongruency(locJSON, inv)

            -- Increment sum
            values[name] = 0 if values[name] == nil
            values[name] += inv\getWeight()

        @persist()
        return values

    ensureLocationCongruency: (locJSON, inventory) =>
        -- If a single chest has been merged, update its location to the
        -- location of the DoubleChest
        if (inventory\serializeLoc() != locJSON)
            print("Chest changed location!")
            @owners[inventory\serializeLoc()] = @owners[locJSON]
            @owners[locJSON] = nil

        @persist()

    -- Pull saved data from disk
    pullFromFile: () =>
        @owners = @storage\getValueAsTable("chests")

    -- Push current ownership data to disk
    persist: () =>
        @storage\setValueFromTable("chests", @owners)

return ChestManager