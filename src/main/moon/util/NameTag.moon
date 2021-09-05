NameTag =
    -- Add a nametag to the Chest
    setFor: (block, name) ->
        state = block\getState()
        state\setCustomName(name)
        state\update()

return NameTag