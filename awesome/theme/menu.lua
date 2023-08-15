local wibox = require("wibox")
local awful = require("awful")

local beautiful = require("beautiful")
local dpi = require("beautiful.xresources").apply_dpi
local gears = require("gears")

local naughty = require("naughty")

require("theme.taskbar.utility")

return {
    show_menu = function(s)
        naughty.notify({ text = "Show Menu" })
    end
}
