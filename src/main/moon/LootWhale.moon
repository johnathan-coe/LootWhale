Inventory = require("Inventory")

class LootWhale
  new: (p) =>
    p.registerEvent("InventoryCloseEvent", self\invClosed)

    -- Done
    logger.info("LootWhaling!")

  invClosed: (e) =>
    inv = Inventory(e\getInventory())

    if (inv\isChest(inv))
      e\getPlayer()\sendMessage(inv\getWeight(inv))

return LootWhale