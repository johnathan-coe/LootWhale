ChestManager = require("ChestManager")
Inventory = require("wrapper.Inventory")
Scoreboard = require("wrapper.Scoreboard")
Storage = require("wrapper.Storage")
WEIGHTS = require("weights")
String = require("util.String")

class LootWhale
  new: (p) =>
    -- If a user opens a chest and their corresponding value is true, ownership is transferred
    @ownNextChest = {}
    
    storage = Storage(p.getStorageObject("LootWhale.json"))
    @chestManager = ChestManager(storage)

    p.addCommand({name: "ownchest"}, self\ownChest)
    p.addCommand({name: "lootweights"}, self\lootWeights)
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
      @updateScoreboard()

      player\sendMessage("Claimed chest!")
      e\setCancelled(true) -- Don't show inventory

  ownChest: (e) =>
    player = e.getSender()
    @ownNextChest[player] = true

    player\sendMessage("You will own the next chest you right-click!")

  lootWeights: (e) =>
    player = e.getSender()

    -- Sort keys by item weight
    keys = {}
    for key in pairs(WEIGHTS) do table.insert(keys, key)
    table.sort(keys, (a, b) -> WEIGHTS[a] < WEIGHTS[b])

    -- Print, converting material names to title case
    player\sendMessage("Current item weights:")
    for _, k in ipairs(keys)
      player\sendMessage("#{WEIGHTS[k]} : #{String.titleCase(k)}")

return LootWhale