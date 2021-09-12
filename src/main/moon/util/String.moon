String =
    titleCase: (s) ->
        return s\gsub("_", " ")\gsub(
            "(%a)([%w_']*)", (first, rest) -> first\upper() .. rest\lower()
    )

return String