local wibox = require("wibox")
local awful = require("awful")

local beautiful = require("beautiful")
local dpi = require("beautiful.xresources").apply_dpi
local gears = require("gears")

local naughty = require("naughty")

require("theme.taskbar.utility")

local layoutbox = function(s)
    local widget = wibox.widget {
        {
            {
                screen = s,
                buttons = {
                    awful.button({}, 1, function() awful.layout.inc( 1) end),
                    awful.button({}, 3, function() awful.layout.inc(-1) end),
                    awful.button({}, 4, function() awful.layout.inc( 1) end),
                    awful.button({}, 5, function() awful.layout.inc(-1) end)
                },
                widget = awful.widget.layoutbox
            },
            top = dpi(3),
            bottom = dpi(3),
            left = dpi(5),
            right = dpi(5),
            widget = wibox.container.margin
        },
        bg = beautiful.bg_normal,
        shape = rounded_rect_5,
        widget = wibox.container.background
    }

    local layoutlist = awful.widget.layoutlist {
        screen = s,
        source = function(s, _)
            return {
                awful.layout.suit.tile,
                awful.layout.suit.floating,
                awful.layout.suit.max.fullscreen
            }
        end,
        base_layout = wibox.widget {
            spacing = 5,
            forced_num_cols = 5,
            layout = wibox.layout.grid.vertical
        },
        widget_template = {
            {
                {
                        id = "icon_role",
                        widget = wibox.widget.imagebox,
                },
                margins = dpi(3),
                widget = wibox.container.margin
            },
            id = "background_role",
            forced_width = dpi(24),
            forced_height = dpi(24),
            shape = rounded_rect_10,
            widget = wibox.container.background
        }
    }

    local popup = awful.popup {
        widget = wibox.widget {
            layoutlist,
            id = "base_widget",
            margins = 4,
            widget = wibox.container.margin
        },
        preferred_anchors = "front",
        border_color = beautiful.border_color,
        border_width = beautiful.border_width,
        shape = rounded_rect_5,
        ontop = true,
        visible = false,
        hide_on_right_click = true,
        offset = {
            y = dpi(5)
        }
    }
    popup:bind_to_widget(widget, 2)

    layoutlist:connect_signal("mouse::enter",
        function(self)
            self.focused = true
        end
    )
    layoutlist:connect_signal("mouse::leave",
        function(self)
            if self.focused then
                self.focused = false
                popup.visible = false
            end
        end
    )


    widget:connect_signal("mouse::enter", function(self) self.bg = beautiful.bg_focus_light  end)
    widget:connect_signal("mouse::leave", function(self) self.bg = beautiful.bg_normal end)

    return widget
end

local tasklist = function(s, t)
    local widget = awful.widget.tasklist {
        screen = s,
        filter = function(c, scr)
            local ctags = c:tags()
            for _, v in ipairs(ctags) do
                if v == t then
                    return true
                end
            end
            return false
        end,
        buttons = {
            awful.button({ }, 1,
                function (c)
                    if c == client.focus then
                        c.minimized = true
                    else
                        c:emit_signal(
                            "request::activate", "tasklist",
                            {raise = true}
                        )
                    end
                end
            ),

            awful.button({ }, 4, function () awful.client.focus.byidx( 1) end),
            awful.button({ }, 5, function () awful.client.focus.byidx(-1) end)
        },
        layout = {
            spacing = beautiful.spacing,
            spacing_widget = {
                visible = false
            },
            layout = wibox.layout.fixed.horizontal,
        },
        widget_template = {
            {
                id = "clienticon",
                widget = awful.widget.clienticon
            },
            layout = wibox.layout.fixed.horizontal,
            create_callback = function(self, client, _, _)
                self:get_children_by_id("clienticon")[1].client = client
                awful.tooltip {
                    objects = { self },
                    timer_function = function()
                        return client.name
                    end,
                    mode = "outside",
                    preferred_position = "bottom",
                    preferred_alignment = "middle",
                }
            end,
        }
    }
    return widget
end

local taglist = function(s)
    awful.tag({ "1", "2", "3", "4", "5", "6", "7", "8", "9" }, s, awful.layout.layouts[1])
    local taglist = awful.widget.taglist {
        screen  = s,
        filter  = function(t) return t.selected or #t:clients() > 0 end,
        buttons = {
            awful.button({ }, 1, function(t) t:view_only() end),
            awful.button({ modkey }, 1,
                function(t)
                    if client.focus then
                        client.focus:move_to_tag(t)
                    end
                end
            ),

            awful.button({ }, 3, awful.tag.viewtoggle),
            awful.button({ modkey }, 3,
                function(t)
                    if client.focus then
                        client.focus:toggle_tag(t)
                    end
                end
            ),

            awful.button({ }, 4, function(t) awful.tag.viewnext(t.screen) end),
            awful.button({ }, 5, function(t) awful.tag.viewprev(t.screen) end)
        },
        layout = {
            spacing = beautiful.spacing,
            spacing_widget = {
                visible = false,
            },
            layout = wibox.layout.fixed.horizontal
        },
        style = {
            shape = rounded_rect_5,
        },
        widget_template = {
            {
                {
                    {
                        id = 'text_role',
                        widget = wibox.widget.textbox,
                    },
                    {
                        id = 'tasklist_placeholder',
                        widget = wibox.layout.fixed.horizontal,
                    },
                    spacing = beautiful.spacing,
                    spacing_widget = {
                        visible = false
                    },
                    layout = wibox.layout.fixed.horizontal
                },
                left  = dpi(5),
                right = dpi(5),
                widget = wibox.container.margin,
            },
            id = 'background_role',
            widget = wibox.container.background,

            create_callback = function(self, tag, index, _)
                self:get_children_by_id("tasklist_placeholder")[1]:add(tasklist(s, tag))

                local background = self:get_children_by_id("background_role")[1]
                self:connect_signal("mouse::enter",
                    function()
                        if s.selected_tag ~= tag then
                            background.bg = beautiful.bg_focus_light
                            background.fg = beautiful.fg_focus_light
                        end
                    end
                )
                self:connect_signal("mouse::leave",
                    function()
                        if s.selected_tag == tag then
                            background.bg = beautiful.bg_focus
                            background.fg = beautiful.fg_focus
                        else
                            background.bg = beautiful.bg_normal
                            background.fg = beautiful.fg_normal
                        end
                    end
                )
            end
        }
    }
    return taglist
end

return {
    left_widget = function(s)
        local widget = wibox.widget {
            {
                layoutbox(s),
                taglist(s),

                spacing = beautiful.spacing,
                spacing_widget = {
                    visible = false
                },
                layout = wibox.layout.fixed.horizontal,
            },
            margins = beautiful.margin,
            layout = wibox.container.margin
        }
        return widget
    end
}
