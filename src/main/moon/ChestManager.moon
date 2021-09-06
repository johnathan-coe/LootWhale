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
        @processChestChanges()
        @owners[inv\serializeLoc()] = player\getName()
        @persist()

    -- Get the owner of an inventory
    getOwner: (inv) =>
        @processChestChanges()
        return @owners[inv\serializeLoc()]

    -- Get values
    getValueTable: () =>
        @processChestChanges()
        values = {}

        -- For every registered chest
        for locJSON, name in pairs(@owners)
            location = Location.fromJSON(locJSON)
            block = location\getBlock()
            
            NameTag.setFor(block, "#{name}'s Chest")

            -- Get inventory from block
            inv = Inventory.fromBlock(block)

            -- Increment sum
            values[name] = 0 if values[name] == nil
            values[name] += inv\getWeight()

        @persist()
        return values

    -- Processes chest merges and deletions
    processChestChanges: =>
        newOwners = {}

        for locJSON, name in pairs(@owners)
            location = Location.fromJSON(locJSON)
            block = location\getBlock()
            continue if (block\getType() != Mat\getMaterial("CHEST"))
            inventory = Inventory.fromBlock(block)

            -- Ensure location JSON is up to date
            -- TODO: Retain ownership if they delete the right part of a DoubleChest
            locJSON = inventory\serializeLoc()
            newOwners[locJSON] = name

        @owners = newOwners
        @persist()

    -- Pull saved data from disk
    pullFromFile: () =>
        @owners = @storage\getValueAsTable("chests")

    -- Push current ownership data to disk
    persist: () =>
        @storage\setValueFromTable("chests", @owners)

return ChestManager