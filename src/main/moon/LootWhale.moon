Inventory = require("Inventory")
ChestManager = require("ChestManager")
Scoreboard = require("Scoreboard")

class LootWhale
  new: (p) =>
    -- If a user opens a chest and their corresponding value is true, ownership is transferred
    @ownNextChest = {}
    
    @chestManager = ChestManager(p.getStorageObject("LootWhale.json"))

    p.addCommand({name: "ownchest"}, self\ownChest)
    p.registerEvent("InventoryOpenEvent", self\invOpened)
    p.registerEvent("InventoryCloseEvent", self\invClosed)

    -- Wait until world load for scoreboard init
    p.onEnable(() ->
      @scoreboard = Scoreboard()
      @updateScoreboard()
    )
    
    -- Done
    logger.info("LootWhaling!")

  updateScoreboard: () =>
    @scoreboard\show(@chestManager\getValueTable())

  invClosed: (e) =>
    -- Get and display owner of chest
    inv = Inventory(e\getInventory())
    return if not inv\isChest()

    -- Tell the user if this chest doesn't have an owner
    if @chestManager\getOwner(inv) == nil
      e\getPlayer()\sendMessage("Stray chest :(")
    
    @updateScoreboard()

  invOpened: (e) =>
    inv = Inventory(e\getInventory())
    return if not inv\isChest()

    player = e\getPlayer()

    -- Claim chest
    if (@ownNextChest[player\getName()] == true)
      @chestManager\setOwnership(inv, player)
      @ownNextChest[player\getName()] = false

      player\sendMessage("Claimed chest!")

  ownChest: (e) =>
    player = e.getSender()
    @ownNextChest[player\getName()] = true

    player\sendMessage("You will own the next chest you open!")

return LootWhale