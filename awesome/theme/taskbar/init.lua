local wibox = require("wibox")
local awful = require("awful")

local beautiful = require("beautiful")
local dpi = require("beautiful.xresources").apply_dpi
local gears = require("gears")

require("theme.taskbar.utility")

return {
    wibox = function(s)
        taskbar = awful.wibar {
            position = "top",
            screen = s,
            height = dpi(38),
            ontop = true,
            restrict_workarea = true,
            shape = rounded_rect_5,
            margins = { left = dpi(5), right = dpi(5), top = dpi(5) },
            bg = beautiful.background
        }

        local left_widget   = require("theme.taskbar.left").left_widget(s)
        local center_widget = require("theme.taskbar.center").center_widget(s)
        local right_widget  = require("theme.taskbar.right").right_widget(s)

        taskbar:setup {
            {
                left_widget,
                center_widget,
                right_widget,
                expand = "none",
                layout = wibox.layout.align.horizontal
            },
            layout = wibox.container.margin,
            top   = dpi(4),
            left  = dpi(5),
            right = dpi(5),
            bottom = dpi(4)
        }
        return taskbar
    end
}
