Inventory = require("Inventory")
ChestManager = require("ChestManager")
Scoreboard = require("Scoreboard")
Storage = require("util.Storage")

class LootWhale
  new: (p) =>
    -- If a user opens a chest and their corresponding value is true, ownership is transferred
    @ownNextChest = {}
    
    storage = Storage(p.getStorageObject("LootWhale.json"))
    @chestManager = ChestManager(storage)

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
      inv\setTitle("A Stray Chest")
    
    @updateScoreboard()

  invOpened: (e) =>
    inv = Inventory(e\getInventory())
    return if not inv\isChest()

    player = e\getPlayer()

    -- Claim chest
    if (@ownNextChest[player] == true)
      @ownNextChest[player] = false
      @chestManager\setOwnership(inv, player)

      player\sendMessage("Claimed chest!")
      e\setCancelled(true) -- Don't show inventory

  ownChest: (e) =>
    player = e.getSender()
    @ownNextChest[player] = true

    player\sendMessage("You will own the next chest you right-click!")

return LootWhale