Loc = javaImport "$.Location"
Gson = newInstance("com.google.gson.Gson", nil)
Map = javaImport "java.util.Map"

-- Handles deserialisation of Location objects
Location =
    fromJSON: (json) ->
        map = Gson\fromJson(json, Map)
        return Loc\deserialize(map)

    toJSON: (l) ->
        return Gson\toJson(l\serialize())

return Location