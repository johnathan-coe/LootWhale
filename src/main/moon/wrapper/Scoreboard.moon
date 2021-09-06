Bukkit = javaImport("org.bukkit.Bukkit")
DisplaySlot = javaImport("$.scoreboard.DisplaySlot")

class Scoreboard
    new: () =>
        @sb = Bukkit\getScoreboardManager()\getMainScoreboard()
        @objective = nil
        @clearBoard()

    show: (t) =>
        @clearBoard()

        for name, score in pairs(t)
            @objective\getScore(name)\setScore(score)

    clearBoard: =>
        oldObjective = @sb\getObjective("LootWhale")

        -- If an old objective exists
        if (oldObjective != nil)
            oldObjective\unregister()
            
        @objective = @sb\registerNewObjective("LootWhale", "dummy", "Server Whales")
        @objective\setDisplaySlot(DisplaySlot.SIDEBAR)

return Scoreboard