-- Keep only your personal keybinding overrides here. Add new bindings or
-- unbind defaults before replacing them.

-- See current bindings and descriptions:
--   omarchy menu keybindings --print

-- To disable every Omarchy default binding, set this in
-- ~/.config/hypr/hyprland.lua before require("default.hypr.omarchy"), then add
-- only the bindings you want below:
--   omarchy_default_bindings = false

-- To disable all preinstalled app/webapp bindings, set:
--   omarchy_preinstalled_bindings = false

-- Add a new binding.
-- o.bind("SUPER + SHIFT + R", "SSH", "alacritty -e ssh your-server")

-- Change an existing binding by unbinding it first, then binding the key again.
-- This example changes SUPER+SPACE from the launcher to the Omarchy root menu.
-- hl.unbind("SUPER + SPACE")
-- o.bind("SUPER + SPACE", "Omarchy menu", "omarchy-menu toggle root")

-- Disable a default binding without replacing it.
-- hl.unbind("SUPER + SHIFT + B")

-- Logitech MX Keys examples:
-- o.bind("SUPER + SHIFT + S", nil, "omarchy-capture-screenshot")
-- o.bind("SUPER + H", nil, "voxtype record toggle")
-- o.bind("SUPER + PERIOD", nil, "omarchy-shell shell toggle omarchy.emojis")

-- i3-style bindings (ported from ~/.dotfiles/i3)

-- Close window: Super+W -> Super+Shift+Q
hl.unbind("SUPER + W")
o.rebind("SUPER + SHIFT + Q", "Close window", hl.dsp.window.close())

-- Launcher: Super+Space -> Super+D
hl.unbind("SUPER + SPACE")
o.bind("SUPER + D", "Omarchy menu", "omarchy-menu toggle")

-- File manager: Super+Shift+F -> Super+E
hl.unbind("SUPER + SHIFT + F")
o.bind("SUPER + E", "File manager", { omarchy = "nautilus" })

-- Browser (in addition to Super+Shift+B / Super+Shift+Return)
o.bind("SUPER + B", "Browser", { omarchy = "browser" })

-- Screenshot (was: Google Maps)
hl.unbind("SUPER + SHIFT + S")
o.bind("SUPER + SHIFT + S", "Screenshot", "omarchy-capture-screenshot")

-- Vim-style focus (was: J toggle split, K keybindings, L workspace layout)
hl.unbind("SUPER + J")
hl.unbind("SUPER + K")
hl.unbind("SUPER + L")
o.bind("SUPER + H", "Focus on left window", hl.dsp.focus({ direction = "l" }))
o.bind("SUPER + J", "Focus on below window", hl.dsp.focus({ direction = "d" }))
o.bind("SUPER + K", "Focus on above window", hl.dsp.focus({ direction = "u" }))
o.bind("SUPER + L", "Focus on right window", hl.dsp.focus({ direction = "r" }))

-- Vim-style window swap
o.bind("SUPER + SHIFT + H", "Swap window to the left", hl.dsp.window.swap({ direction = "l" }))
o.bind("SUPER + SHIFT + J", "Swap window down", hl.dsp.window.swap({ direction = "d" }))
o.bind("SUPER + SHIFT + K", "Swap window up", hl.dsp.window.swap({ direction = "u" }))
o.bind("SUPER + SHIFT + L", "Swap window to the right", hl.dsp.window.swap({ direction = "r" }))

-- Toggle split: Super+J -> Super+Z
o.bind("SUPER + Z", "Toggle window split", hl.dsp.layout("togglesplit"))

-- Floating toggle and top bar swap places
hl.unbind("SUPER + T")
hl.unbind("SUPER + SHIFT + SPACE")
o.bind("SUPER + SHIFT + SPACE", "Toggle window floating/tiling", hl.dsp.window.float({ action = "toggle" }))
o.bind_toggle("SUPER + T", "Toggle top bar", "bar")

-- Power menu (was: Email)
hl.unbind("SUPER + SHIFT + E")
o.bind("SUPER + SHIFT + E", "System menu", "omarchy-menu toggle system")

-- Lock (was: dismiss all notifications); Super+Ctrl+L still works
hl.unbind("SUPER + SHIFT + comma")
o.bind("SUPER + SHIFT + comma", "Lock system", "omarchy-system-lock")

-- Resize mode: hjkl/arrows resize, Enter/Esc exits
o.bind("SUPER + R", "Resize mode", hl.dsp.submap("resize"))
hl.define_submap("resize", function()
  hl.bind("h", hl.dsp.window.resize({ x = -50, y = 0, relative = true }), { repeating = true })
  hl.bind("j", hl.dsp.window.resize({ x = 0, y = 50, relative = true }), { repeating = true })
  hl.bind("k", hl.dsp.window.resize({ x = 0, y = -50, relative = true }), { repeating = true })
  hl.bind("l", hl.dsp.window.resize({ x = 50, y = 0, relative = true }), { repeating = true })
  hl.bind("left", hl.dsp.window.resize({ x = -50, y = 0, relative = true }), { repeating = true })
  hl.bind("down", hl.dsp.window.resize({ x = 0, y = 50, relative = true }), { repeating = true })
  hl.bind("up", hl.dsp.window.resize({ x = 0, y = -50, relative = true }), { repeating = true })
  hl.bind("right", hl.dsp.window.resize({ x = 50, y = 0, relative = true }), { repeating = true })
  hl.bind("Return", hl.dsp.submap("reset"))
  hl.bind("escape", hl.dsp.submap("reset"))
end)
