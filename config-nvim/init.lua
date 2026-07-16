-- HOT TIPS
--
--   Ctrl-O / Ctrl-I -- jump backwards/forwards through the jump list. "jumps" include `:e`, `gd`, `gr`, `*`, `n`, etc.
--                      so jumps can be within the same buffer, or to a different buffer. Each pane
--                      has its own jump list.
--
-- CONCEPTS
--   `g` is a prefix namspace Vim uses to multiply its command space without modifier keys. There's no
--   unifying concept for everything under `g`, but _some_ of the commands follow some loose themes.
--   For example, "go":
--      gg      = go to top of file
--      gd / gD = go to definition/declaration
--      gi      = go to last insert position
--   The other theme is "variant of the base command with the same letter". For example:
--      gj / gk = move by display (wrapped) lines instead of real ones
--      gJ      = join lines without inserting a space
--      gn / gN = select the next/prev search match (operable)
--   But then there's also just extra stuff that matches neither theme, e.g. g? = Rot13 encode
--
--   Other prefix namespaces include:
--    - z — folds and vertical scroll positioning (zz, zf, zo, za, ...)
--    - [ / ] — jump backward/forward between pairs of things ([c/]c hunks, [d/]d diagnostics, [m/]m methods)
--    - Ctrl-w — window management
--    - " — register selection

require("config.lazy")
require("config.ftplugin")
