Inventory = require("Inventory")
ChestManager = require("ChestManager")
Scoreboard = require("Scoreboard")

class LootWhale
  new: (p) =>
    -- If a user opens a chest and their corresponding value is true, ownership is transferred
    @ownNextChest = {}
    
    @chestManager = ChestManager(p.getStorageObject("LootWhale.json"))
    @scoreboard = Scoreboard()

    p.addCommand({name: "ownchest"}, self\ownChest)
    p.registerEvent("InventoryOpenEvent", self\invOpened)
    p.registerEvent("InventoryCloseEvent", self\invClosed)

    @updateScoreboard()

    -- Done
    logger.info("LootWhaling!")

  updateScoreboard: () =>
    -- Get and display sum of values for users
    valTable = @chestManager\getValueTable()
    @scoreboard\show(valTable)

  invClosed: (e) =>
    -- Get and display owner of chest
    inv = Inventory(e\getInventory())
    owner = @chestManager\getOwner(inv) .. "'s"
    owner = "an unclaimed" if owner == nil
    
    e\getPlayer()\sendMessage("Closed #{owner} chest!")
    @updateScoreboard()

  invOpened: (e) =>
    inv = Inventory(e\getInventory())
    player = e\getPlayer()

    -- Claim chest
    if (inv\isChest(inv) and @ownNextChest[player\getName()] == true)
      @chestManager\setOwnership(inv, player)
      player\sendMessage("Claimed chest!")

      @ownNextChest[player\getName()] = false

  ownChest: (e) =>
    player = e.getSender()
    @ownNextChest[player\getName()] = true
    player\sendMessage("You will own the next chest you open!")

return LootWhale