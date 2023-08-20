local wibox = require("wibox")
local awful = require("awful")

local beautiful = require("beautiful")
local dpi = require("beautiful.xresources").apply_dpi
local gears = require("gears")

local naughty = require("naughty")

require("theme.taskbar.utility")

local wibox_widget = wibox {
    shape = rounded_rect_5,
    visible = false,
    ontop = true,
    x = 100,
    y = 100,
    width = dpi(350),
    height = dpi(400),
}

local clock = function(s)
    widget = wibox.widget {
        {
            {
                {
                    format = "<big>%H:%M:%S</big>",
                    refresh = 0.5,
                    font = beautiful.font_default..20,
                    widget = wibox.widget.textclock
                },
                margins = beautiful.margin,
                widget = wibox.container.margin
            },
            fg = beautiful.fg_normal,
            bg = beautiful.bg_normal,
            shape = rounded_rect_5,
            widget = wibox.container.background
        },
        halign = "center",
        widget = wibox.container.place
    }

    return widget
end

local date = function(s)
    date_widget = wibox.widget {
        text = "",
        widget = wibox.widget.textbox,
        font = beautiful.font_default..15,

        set_date = function(val)
            text = val
        end
    }

    widget = wibox.widget {
        {
            {
                date_widget,
                margins = beautiful.margin,
                widget = wibox.container.margin
            },
            fg = beautiful.fg_normal,
            bg = beautiful.bg_normal,
            shape = rounded_rect_5,
            widget = wibox.container.background
        },
        halign = "center",
        widget = wibox.container.place
    }

    local cmd = "date '+%A %-d %B'"

    awful.spawn.easy_async_with_shell(cmd,
        function(stdout, stderr, _, _)
            local full_date = string.sub(stdout, 1, string.len(stdout) - 1)

            local start_index = string.find(full_date, " ", nil, nil) + 1
            local end_index = string.find(full_date, " ", start_index, nil) - 1
            local date = string.sub(full_date, start_index, end_index)

            convert_date = function(date)
                date = tonumber(date)
                string_date = ""..date
                local ones = date % 10

                if date <= 11 and date >= 13 and (ones == "1" or ones == "2" or ones == "3") then
                    if ones == 1 then return string_date.."st"
                    elseif ones == 2 then return string_date.."nd"
                    elseif ones == 3 then return string_date.."rd"
                    end
                else
                    return string_date.."th"
                end
            end

            local modified_date = string.gsub(full_date, date, convert_date(date))
            date_widget.markup = "<big>"..modified_date.."</big>"
        end
    )

    local calendar = awful.popup {
        widget = wibox.widget {
            {
                {
                    widget = wibox.widget.calendar.month(os.date("*t"))
                },
                margins = beautiful.margin,
                widget = wibox.container.margin
            },
            shape = rounded_rect_5,
            widget = wibox.container.background
        },
        shape = rounded_rect_5,
        ontop = true,
        visible = false,
        hide_on_right_click = true,
    }

    calendar:connect_signal("property::visible",
        function(self)
            local geo = self:geometry()
            local mouse_position = mouse.coords()

            geo.x = mouse_position.x - (geo.width / 2)
            geo.y = mouse_position.y + dpi(8)
            geo.width = geo.width
            geo.height = geo.height

            self:geometry(geo)

            awful.placement.no_offscreen(self)
        end
    )

    widget:connect_signal("button::press",
        function(self)
            if self.focused then
                if calendar.visible then
                    calendar.visible = false
                else
                    calendar.visible = true
                end
            end
        end
    )

    widget:connect_signal("mouse::enter",
        function(self)
            self.widget.fg = beautiful.fg_focus
            self.widget.bg = beautiful.bg_focus
            self.focused = true
        end
    )

    widget:connect_signal("mouse::leave",
        function(self)
            self.widget.fg = beautiful.fg_normal
            self.widget.bg = beautiful.bg_normal
            self.focused = false
        end
    )

    return widget
end

local setup_menu = function(s)
    wibox_widget.screen = s
    wibox_widget:setup {
        {
            {
                {
                    {
                        clock(s),
                        date(s),
                        spacing = beautiful.spacing,
                        spacing_widget = {
                            visible = false
                        },
                        layout = wibox.layout.fixed.vertical
                    },
                    margins = beautiful.margin,
                    layout = wibox.container.margin
                },
                fg = beautiful.foreground,
                bg = beautiful.background,
                shape = rounded_rect_5,
                layout = wibox.container.background
            },
            margins = beautiful.margin,
            layout = wibox.container.margin
        },
        fg = beautiful.fg_normal,
        bg = beautiful.bg_normal,
        -- shape = rounded_bar_5,
        layout = wibox.container.background
    }
end

local show_menu = function(s)
    local workarea = s.workarea
    wibox_widget.x = workarea.x + workarea.width - wibox_widget.width - beautiful.useless_gap
    wibox_widget.y = workarea.y + beautiful.margin + beautiful.useless_gap

    wibox_widget.visible = true
    setup_menu(s)
end

local close_menu = function(s)
    wibox_widget.visible = false
    -- date_timer:stop()
    -- setup_menu(s)
end


return {

    toggle_menu = function(s)
        if wibox_widget.visible then
            close_menu(s)
        else
            show_menu(s)
        end
    end

}
