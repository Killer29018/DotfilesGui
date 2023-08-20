local wibox = require("wibox")
local awful = require("awful")

local beautiful = require("beautiful")
local dpi = require("beautiful.xresources").apply_dpi
local gears = require("gears")

local naughty = require("naughty")

require("theme.taskbar.utility")

local tasklist_focus_markup = function(name)
    local modified_name = ""
    local length = 20
    if #name > length then
        modified_name = name:sub(0, length - 3) .. "..."
    else
        modified_name = name
    end

    return ("<span color=\"" .. beautiful.tasklist_fg_focus .. "\">" .. modified_name .. "</span>")
end

local tasklist = function(s)
    local widget = awful.widget.tasklist {
        screen = s,
        filter = awful.widget.tasklist.filter.currenttags,
        buttons = {
            awful.button({ }, 1,
                function (c)
                    if c == client.focus then
                        c.minimized = true
                    else
                        c:emit_signal(
                            "request::activate", "tasklist",
                            {raise = true})
                    end
                end
            ),

            awful.button({ }, 3, function () awful.menu.client_list({ theme = { width = 250 } }) end),
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
        style = {
            shape = rounded_rect_5,
        },
        widget_template = {
            {
                {
                    {
                        {
                            id = "client_icon",
                            widget = awful.widget.clienticon
                        },
                        {
                            id = "client_name",
                            widget = wibox.widget.textbox
                        },
                        spacing = beautiful.spacing,
                        spacing_widget = {
                            visible = false
                        },
                        id = "client",
                        layout = wibox.layout.fixed.horizontal,
                    },
                    left = dpi(3),
                    right = dpi(5),
                    widget = wibox.container.margin,
                },
                shape = rounded_rect_5,
                widget = wibox.container.background,
            },
            id = "background_role",
            widget = wibox.container.background,

            create_callback = function(self, c, _, _)
                self:get_children_by_id("client_icon")[1].client = c

                awful.tooltip {
                    objects = { self },
                    timer_function = function()
                        return c.name
                    end,
                    mode = "outside",
                    preferred_position = "bottom",
                    preferred_alignment = "middle",
                }

                self:get_children_by_id("client_name")[1].markup = tasklist_focus_markup(c.name)
                if client.focus == c then
                    self:get_children_by_id("client_name")[1].visible = true
                else
                    self:get_children_by_id("client_name")[1].visible = false
                end

                local background = self:get_children_by_id("background_role")[1]
                self:connect_signal("mouse::enter",
                    function()
                        if client.focus ~= c then
                            background.bg = beautiful.bg_focus_light
                            background.fg = beautiful.fg_focus_light
                        end
                    end
                )
                self:connect_signal("mouse::leave",
                    function()
                        if client.focus == c then
                            background.bg = beautiful.bg_focus
                            background.fg = beautiful.fg_focus
                        else
                            background.bg = beautiful.bg_normal
                            background.fg = beautiful.fg_normal
                        end
                    end
                )
            end,

            update_callback = function(self, c, _, clients)
                if client.focus == c then
                    self:get_children_by_id("client_name")[1].visible = true
                else
                    self:get_children_by_id("client_name")[1].visible = false
                end
            end
        }
    }

    return widget
end

return {
    center_widget = function(s)
        local widget = wibox.widget {
            {
                tasklist(s),
                layout = wibox.layout.fixed.horizontal
            },
            margins = beautiful.margin,
            widget = wibox.container.margin,
        }

        local display_widget = function(c)
            if #s.selected_tag:clients() < 1 then
                widget.visible = false
            else
                widget.visible = true
            end
        end

        client.connect_signal("manage", display_widget)
        client.connect_signal("unmanage", display_widget)
        client.connect_signal("tag::switched", display_widget)
        awesome.connect_signal("refresh", display_widget)

        return widget
    end
}
