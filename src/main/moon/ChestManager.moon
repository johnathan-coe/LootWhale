Inventory = require("Inventory")
Location = require("util.Location")
Mat = javaImport("$.Material")
Gson = newInstance("com.google.gson.Gson", {})
Map = javaImport "java.util.Map"

class ChestManager
    new: (storage) =>
        @storage = storage

        -- Table mapping serialised locations to names
        @owners = {}
        @pullFromFile()

    pullFromFile: () =>
        -- Pull owners table from storage as Gson.JSONPrimitive
        chests = @storage\getValue("chests")

        -- If not yet persisted
        return if chests == nil

        -- Deserialize to map
        map = Gson\fromJson(chests\getAsString(), Map)
        @owners = util.getTableFromMap(map)
        
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
            
            -- Get inventory from block
            inv = Inventory.fromBlock(block)

            -- Increment sum
            values[name] = 0 if values[name] == nil
            values[name] += inv\getWeight()

        @persist()
        return values

    -- Push current ownership data to disk
    persist: () =>
        -- Add to a JsonObj
        jObj = newInstance("com.google.gson.JsonObject")
        for loc, name in pairs(@owners)
            jObj\addProperty(loc, name)

        @storage\setValue("chests", jObj\toString())
        @storage\save()

return ChestManager