{
    whitelist_globals: {
      ["."]: {
        "logger", "plugin", "newInstance", "util" -- Lukkit
        "javaImport" -- main.lua
      },
      ["test/*"]: {
        "describe", "it", "before_each", "setup"
      }
    }
  }