-- Autostart Applications
local awful = require("awful")
awful.spawn.with_shell("picom --transparent-clipping")
-- awful.spawn.with_shell("nitrogen --restore") -- Single Background
awful.spawn.with_shell("nitrogen --random --set-scaled") -- Random Background
awful.spawn.with_shell("setxkbmap -layout gb")
