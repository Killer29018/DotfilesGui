local awful = require("awful")
local wibox = require("wibox")
local gears = require("gears")
local beautiful = require("beautiful")

local use_taskbar = false

return {
    taskbar = function(c)
        local taskbar_buttons = gears.table.join(
            awful.button(
                { }, 1,
                function()
                    c:emit_signal("request::activate", "titlebar", {raise = true})
                    awful.mouse.client.move(c)
                end
            ),

            awful.button(
                { }, 3,
                function()
                    c:emit_signal("request::activate", "titlebar", {raise = true})
                    awful.mouse.client.resize(c)
                end
            )
        )

        if use_taskbar then
            local titlebar = awful.titlebar(
                c,
                {
                    position =  beautiful.titlebar_location,
                    size = 22
                }
            )
            titlebar:setup {
                { -- Top
                    awful.titlebar.widget.closebutton(c),
                    awful.titlebar.widget.maximizedbutton(c),
                    awful.titlebar.widget.minimizebutton(c),
                    layout = wibox.layout.fixed.vertical(),
                },
                { -- Middle
                    buttons = taskbar_buttons,
                    layout  = wibox.layout.fixed.vertical(),
                },
                { -- Bottom
                    {
                        awful.titlebar.widget.iconwidget(c),
                        layout = wibox.layout.fixed.vertical(),
                    },
                    buttons = taskbar_buttons,
                    bottom = 5,
                    widget = wibox.container.margin,
                },
                layout = wibox.layout.align.vertical()
            }
        end
    end
}
