Gson = newInstance("com.google.gson.Gson", nil)
Map = javaImport "java.util.Map"
JsonObject = () -> newInstance("com.google.gson.JsonObject")

-- Wrapper for Lukkit storage object
class Storage
    new: (storageObject) =>
        @storageObject = storageObject

    getValueAsTable: (key) =>
        -- Pull owners table from storage as Gson.JSONPrimitive
        primitive = @storageObject\getValue(key)

        -- If not yet persisted
        return {} if primitive == nil

        -- Deserialize to map
        map = Gson\fromJson(primitive\getAsString(), Map)
        return util.getTableFromMap(map)

    setValueFromTable: (key, t) =>
        jObj = JsonObject()
        
        for k, v in pairs(t)
            jObj\addProperty(k, v)

        @storageObject\setValue(key, jObj\toString())
        @storageObject\save()

return Storage