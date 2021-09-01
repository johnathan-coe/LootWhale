require("muck.stubs.globals")
LootWhale = require "LootWhale"
Plugin = require("muck.stubs.Plugin")

describe "<LootWhale>", ->
    it "Run LootWhale", ->
      LootWhale(Plugin)
