local wibox = require("wibox")
local awful = require("awful")

local beautiful = require("beautiful")
local dpi = require("beautiful.xresources").apply_dpi
local gears = require("gears")

local naughty = require("naughty")

require("theme.taskbar.utility")

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

local calendar_theme = function(base_widget, flag, date)
    -- flag : "header", "monthheader", "weekday", "focus", "month", "normal"

    local widget = wibox.widget {
        {
            {
                halign = "center",
                widget = base_widget
            },
            margins = {
                left = dpi(3),
                right = dpi(3)
            },
            widget = wibox.container.margin
        },
        shape = rounded_rect_5,
        widget = wibox.container.background
    }

    if flag == "header" then
        widget.fg = beautiful.fg_normal
        widget.bg = beautiful.bg_normal
    elseif flag == "monthheader" then
        widget.fg = beautiful.fg_normal_light
        widget.bg = beautiful.bg_normal_light
    elseif flag == "weekday" then
        widget.fg = beautiful.fg_normal_light
        widget.bg = beautiful.bg_normal_light
    elseif flag == "focus" then
        widget.fg = beautiful.fg_focus
        widget.bg = beautiful.bg_focus
    elseif flag == "normal" then
        widget.fg = beautiful.fg_focus_light
        widget.bg = beautiful.bg_focus_light
    end

    return widget
end

local calendar_month = function(s)
    local calendar_widget = wibox.widget.calendar.month(os.date("*t"))
    calendar_widget.date_offset = 0
    calendar_widget.long_weekdays = true
    calendar_widget.fn_embed = calendar_theme

    local widget = awful.popup {
        widget = wibox.widget {
            {
                calendar_widget,
                margins = beautiful.margin,
                widget = wibox.container.margin
            },
            shape = rounded_rect_5,
            widget = wibox.container.background
        },
        shape = rounded_rect_5,
        ontop = true,
        visible = false
    }

    widget:connect_signal("button::press",
        function(self, _, _, button, _)
            local calculate_offset = function(t, date_offset)
                t.month = t.month + date_offset
                if t.month > 12 then
                    t.year = t.year + math.floor(t.month / 12)
                    t.month = t.month % 12
                end
                return t
            end

            local date = os.date("*t")

            if button == 4 then -- Scroll Up
                calendar_widget.date_offset = calendar_widget.date_offset + 1
            elseif button == 5 then -- Scroll Down
                calendar_widget.date_offset = calendar_widget.date_offset - 1
            end


            date = calculate_offset(date, calendar_widget.date_offset)
            if calendar_widget.date_offset ~= 0 then
                date.day = nil
            end
            calendar_widget.date = date
        end
    )
    widget:connect_signal("mouse::enter",
        function(self)
            self.focused = true
        end
    )
    widget:connect_signal("mouse::leave",
        function(self)
            if self.focused then
                self.focused = false
                self.visible = false
            end
        end
    )

    return widget
end

local calendar_year = function(s)
    local calendar_widget = wibox.widget.calendar.year(os.date("*t"))
    calendar_widget.date_offset = 0
    calendar_widget.long_weekdays = true
    calendar_widget.fn_embed = calendar_theme
    calendar_widget.flex_height = true

    local widget = awful.popup {
        widget = wibox.widget {
            {
                calendar_widget,
                margins = beautiful.margin,
                widget = wibox.container.margin
            },
            shape = rounded_rect_5,
            widget = wibox.container.background
        },
        shape = rounded_rect_5,
        ontop = true,
        visible = false
    }

    widget:connect_signal("button::press",
        function(self, _, _, button, _)
            local calculate_offset = function(t, date_offset)
                t.year = t.year + date_offset
                return t
            end

            local date = os.date("*t")

            if button == 4 then -- Scroll Up
                calendar_widget.date_offset = calendar_widget.date_offset + 1
            elseif button == 5 then -- Scroll Down
                calendar_widget.date_offset = calendar_widget.date_offset - 1
            end

            date = calculate_offset(date, calendar_widget.date_offset)
            if calendar_widget.date_offset ~= 0 then
                date.day = nil
            end
            calendar_widget.date = date
        end
    )
    widget:connect_signal("mouse::enter",
        function(self)
            self.focused = true
        end
    )
    widget:connect_signal("mouse::leave",
        function(self)
            if self.focused then
                self.focused = false
                self.visible = false
            end
        end
    )

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

    local calendar_position = function(calendar)
        local geo = calendar:geometry()
        local mouse_position = mouse.coords()

        geo.x = mouse_position.x - (geo.width / 2)
        geo.y = mouse_position.y + dpi(8)
        geo.width = geo.width
        geo.height = geo.height

        calendar:geometry(geo)

        geo = awful.placement.no_offscreen(calendar, {
            pretend = true,
            honor_padding = true,
            honor_workarea = true,
            margins = { left = dpi(10), right = dpi(10) }
        })

        calendar:geometry(geo)
    end

    local calendar_month = calendar_month(s)
    local calendar_year = calendar_year(s)

    widget:connect_signal("button::press",
        function(self, _, _, button, _)
            if button == 1 or button == 3 then
                calendar_position(calendar_month)

                calendar_year.visible = false
                calendar_month.visible = not calendar_month.visible
            elseif button == 2 then
                calendar_position(calendar_year)

                calendar_month.visible = false
                calendar_year.visible = not calendar_year.visible
            end
        end
    )

    widget:connect_signal("mouse::enter",
        function(self)
            self.widget.fg = beautiful.fg_focus
            self.widget.bg = beautiful.bg_focus
        end
    )

    widget:connect_signal("mouse::leave",
        function(self)
            self.widget.fg = beautiful.fg_normal
            self.widget.bg = beautiful.bg_normal
        end
    )

    return widget
end

local setup_menu = function(s)
    local wibox_widget = wibox {
        shape = rounded_rect_5,
        visible = false,
        ontop = true,
        x = 100,
        y = 100,
        width = dpi(350),
        height = dpi(400),
        screen = s
    }

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
        layout = wibox.container.background
    }

    -- wibox_widget:connect_signal("mouse::enter",
    --     function(self)
    --         self.focused = true
    --     end
    -- )

    -- wibox_widget:connect_signal("mouse::leave",
    --     function(self)
    --         if self.focused then
    --             self.focused = false
    --             self.visible = false
    --         end
    --     end
    -- )

    return wibox_widget
end


local close_menu = function(s)
    s.menu.visible = false
end

local open_menu = function(s)
    local workarea = s.workarea
    s.menu.x = workarea.x + workarea.width - s.menu.width - beautiful.useless_gap
    s.menu.y = workarea.y + beautiful.margin + beautiful.useless_gap

    s.menu.visible = true
end


return {
    create_menu = function(s)
        s.menu = setup_menu(s)
    end,

    toggle_menu = function(s)
        if s.menu.visible then
            close_menu(s)
        else
            open_menu(s)
        end
    end
}
