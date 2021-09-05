Inventory = require("Inventory")
ChestManager = require("ChestManager")
Scoreboard = require("Scoreboard")

class LootWhale
  new: (p) =>
    -- Table of booleans
    -- If a user opens a chest and their corresponding value is true, ownership is transferred
    @ownNextChest = {}
    @chestManager = ChestManager(p.getStorageObject("LootWhale.json"))
    @scoreboard = Scoreboard()

    p.addCommand({name: "ownchest"}, self\ownChest)
    p.registerEvent("InventoryOpenEvent", self\invOpened)
    p.registerEvent("InventoryCloseEvent", self\invClosed)

    -- Done
    logger.info("LootWhaling!")

  invClosed: (e) =>
    -- Get and display sum of values for users
    valTable = @chestManager\getValueTable()
    @scoreboard\show(valTable)

    -- Get and display owner of chest
    inv = Inventory(e\getInventory())
    owner = @chestManager\getOwner(inv)
    owner = "nobody!" if owner == nil
    
    e\getPlayer()\sendMessage("Closed chest owned by #{owner}")

  invOpened: (e) =>
    inv = Inventory(e\getInventory())
    player = e\getPlayer()

    -- If a user has opened a chest and their ownNextChest is true
    if (inv\isChest(inv) and @ownNextChest[player\getName()] == true)
      -- Change ownership
      @chestManager\setOwnership(inv, player)
      @ownNextChest[player\getName()] = false

  ownChest: (e) =>
    player = e.getSender()
    @ownNextChest[player\getName()] = true
    player\sendMessage("You will own the next chest you open!")

return LootWhale