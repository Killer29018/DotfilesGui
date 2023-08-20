local wibox = require("wibox")
local awful = require("awful")

local beautiful = require("beautiful")
local dpi = require("beautiful.xresources").apply_dpi
local gears = require("gears")

require("theme.taskbar.utility")

local keyboard_layout = function(s)
    local widget = wibox.widget {
        {
            {
                widget = awful.widget.keyboardlayout
            },
            top = beautiful.margin,
            bottom = beautiful.margin,
            widget = wibox.container.margin
        },
        fg = beautiful.fg_normal,
        bg = beautiful.bg_normal,
        shape = rounded_rect_5,
        widget = wibox.container.background
    }
    return widget
end

local date = function(s)
    local widget = wibox.widget {
        {
            {
                format = "<big>%x</big>",
                widget = wibox.widget.textclock
            },
            margins = beautiful.margin,
            widget = wibox.container.margin
        },
        fg = beautiful.fg_normal,
        bg = beautiful.bg_normal,
        shape = rounded_rect_5,
        widget = wibox.container.background
    }
    widget:connect_signal(
        "mouse::enter",
        function(self)
            self.fg = beautiful.fg_focus_light
            self.bg = beautiful.bg_focus_light
        end
        )
    widget:connect_signal(
        "mouse::leave",
        function(self)
            self.fg = beautiful.fg_normal
            self.bg = beautiful.bg_normal
        end
        )

    local widget_t = awful.tooltip {
        objects = {
            widget
        },
        timer_function = function()
            return os.date("%A %d %B %Y%nDay: %j/365%nWeek: %U")
        end,

        bg = beautiful.bg_normal,
        fg = beautiful.fg_normal,
        mode = "outside",
        preferred_position = "bottom",
        preferred_alignment = "middle",
    }

    return widget
end

local time = function(s)
    widget = wibox.widget {
        {
            {
                format = "<big>%H:%M:%S</big>",
                refresh = 1,
                widget = wibox.widget.textclock,
            },
            margins = beautiful.margin,
            widget = wibox.container.margin
        },
        fg = beautiful.fg_normal,
        bg = beautiful.bg_normal,
        shape = rounded_rect_5,
        widget = wibox.container.background
    }
    return widget
end

local menu = function(s)
    widget = wibox.widget {
        {
            {
                image = beautiful.menu_hamburger_normal,
                buttons = {
                    awful.button({}, 1, nil,
                        function()
                            require("theme.menu").toggle_menu(s)
                        end
                    )
                },
                widget = wibox.widget.imagebox
            },
            margins = beautiful.margin,
            widget = wibox.container.margin
        },
        fg = beautiful.fg_normal,
        bg = beautiful.bg_normal,
        shape = rounded_rect_5,
        widget = wibox.container.background
    }
    widget:connect_signal(
        "mouse::enter",
        function(self)
            self.widget.widget.image = beautiful.menu_hamburger_focus
            self.bg = beautiful.bg_focus_light
        end
    )
    widget:connect_signal(
        "mouse::leave",
        function(self)
            self.widget.widget.image = beautiful.menu_hamburger_normal
            self.bg = beautiful.bg_normal
        end
    )

    return widget
end

return {
    right_widget = function(s)
        local widget = wibox.widget {
            {
                keyboard_layout(s),
                date(s),
                time(s),
                menu(s),
                spacing = beautiful.spacing,
                spacing_widget = {
                    visible = false
                },
                layout = wibox.layout.fixed.horizontal
            },
            margins = beautiful.margin,
            widget = wibox.container.margin
        }
        return widget
    end
}
