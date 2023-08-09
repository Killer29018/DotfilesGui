local gears = require("gears")
local wibox = require("wibox")
local awful = require("awful")

local dpi = require("beautiful.xresources").apply_dpi

local gfs = require("gears.filesystem")
local themes_path = gfs.get_themes_dir()

local beautiful = require("beautiful")

local my_table = awful.util.table or gears.table

local naughty = require("naughty")

local theme = {}
theme.dir = require("gears.filesystem").get_configuration_dir()
theme.font = "CaskaydiaCove Nerd Font Mono 8"

theme.fg_normal = "#b8bbd0"
theme.fg_focus  = "#9398ba"
theme.fg_urgent = "#CC9393"

theme.bg_normal = "#0d0f16"
theme.bg_focus  = "#0f060a"
theme.bg_urgent = "#1A1A1A"

theme.useless_gap = dpi(4)

theme.border_width  = dpi(0)
theme.border_normal = "#3F3F3F"
theme.border_focus  = "#7F7F7F"
theme.border_marked = "#CC9393"

theme.menu_height = dpi(16)
theme.menu_width  = dpi(140)

theme.titlebar_fg_focus = theme.fg_focus
theme.titlebar_fg_normal = theme.fg_focus
theme.titlebar_bg_focus = theme.bg_focus
theme.titlebar_bg_normal = theme.bg_focus

-- {{{ DEFAULTS
theme.titlebar_close_button_normal = themes_path.."default/titlebar/close_normal.png"
theme.titlebar_close_button_focus  = themes_path.."default/titlebar/close_focus.png"

theme.titlebar_minimize_button_normal = themes_path.."default/titlebar/minimize_normal.png"
theme.titlebar_minimize_button_focus  = themes_path.."default/titlebar/minimize_focus.png"

theme.titlebar_ontop_button_normal_active   = themes_path.."default/titlebar/ontop_normal_active.png"
theme.titlebar_ontop_button_normal_inactive = themes_path.."default/titlebar/ontop_normal_inactive.png"

theme.titlebar_ontop_button_focus_active   = themes_path.."default/titlebar/ontop_focus_active.png"
theme.titlebar_ontop_button_focus_inactive = themes_path.."default/titlebar/ontop_focus_inactive.png"

theme.titlebar_sticky_button_normal_active   = themes_path.."default/titlebar/sticky_normal_active.png"
theme.titlebar_sticky_button_normal_inactive = themes_path.."default/titlebar/sticky_normal_inactive.png"

theme.titlebar_sticky_button_focus_active   = themes_path.."default/titlebar/sticky_focus_active.png"
theme.titlebar_sticky_button_focus_inactive = themes_path.."default/titlebar/sticky_focus_inactive.png"

theme.titlebar_floating_button_normal_active   = themes_path.."default/titlebar/floating_normal_active.png"
theme.titlebar_floating_button_normal_inactive = themes_path.."default/titlebar/floating_normal_inactive.png"

theme.titlebar_floating_button_focus_active   = themes_path.."default/titlebar/floating_focus_active.png"
theme.titlebar_floating_button_focus_inactive = themes_path.."default/titlebar/floating_focus_inactive.png"

theme.titlebar_maximized_button_normal_active   = themes_path.."default/titlebar/maximized_normal_active.png"
theme.titlebar_maximized_button_normal_inactive = themes_path.."default/titlebar/maximized_normal_inactive.png"

theme.titlebar_maximized_button_focus_active   = themes_path.."default/titlebar/maximized_focus_active.png"
theme.titlebar_maximized_button_focus_inactive = themes_path.."default/titlebar/maximized_focus_inactive.png"
-- }}}

theme.foreground = "#a6accd"
theme.background = "#0d0f16"
theme.colour0 = "#75d6fd"
theme.colour1 = "#b76cfd"
theme.colour2 = "#ff2281"
theme.colour3 = "#011ffd"
theme.colour4 = "#3b27ba"
theme.colour5 = "#e847ae"
theme.colour6 = "#13ca91"
theme.colour7 = "#ff9472"

theme.taglist_fg_focus = "#0f0f0f"
theme.taglist_bg_focus = "#CCCCCC"

theme.taglist_fg_occupied = "#FFFFFF"
theme.taglist_bg_occupied = "#888888"

theme.taglist_fg_empty = "#00000000"
theme.taglist_bg_empty = "#00000000"

-- taglist_[bg|fg]_[focus|urgent|occupied|empty|volatile]
-- tasklist_[bg|fg]_[focus|urgent]
-- titlebar_[bg|fg]_[normal|focus]
-- tooltip_[font|opacity|fg_color|bg_color|border_width|border_color]
-- mouse_finder_[color|timeout|animate_timeout|radius|factor]
-- prompt_[fg|bg|fg_cursor|bg_cursor|font]
-- hotkeys_[bg|fg|border_width|border_color|shape|opacity|modifiers_fg|label_bg|label_fg|group_margin|font|description_font]

-- menu_[bg|fg]_[normal|focus]
-- menu_[border_color|border_width]

theme.layout_floating  = themes_path.."default/layouts/floatingw.png"
theme.layout_max       = themes_path.."default/layouts/maxw.png"
theme.layout_tile      = themes_path.."default/layouts/tilew.png"
theme.layout_dwindle   = themes_path.."default/layouts/dwindlew.png"

theme.icon_theme = nil
theme.spacing = dpi(6)

theme.titlebar_location = "left"

local spr = wibox.widget.textbox(' ')

beautiful.init(theme)

function theme.on_titlebar(c)
    -- buttons for the titlebar
    local buttons = gears.table.join(
        awful.button(
            { }, 1,
            function()
                c:emit_signal("request::activate", "titlebar", {raise = true})
                awful.mouse.client.move(c)
            end),

        awful.button(
            { }, 3,
            function()
                c:emit_signal("request::activate", "titlebar", {raise = true})
                awful.mouse.client.resize(c)
            end)
    )

    awful.titlebar(c, { position =  beautiful.titlebar_location, size = 22 }) : setup {
        { -- Top
            awful.titlebar.widget.closebutton(c),
            awful.titlebar.widget.maximizedbutton(c),
            awful.titlebar.widget.minimizebutton(c),
            layout = wibox.layout.fixed.vertical(),
        },
        { -- Middle
            layout  = wibox.layout.fixed.vertical(),
            buttons = buttons
        },
        { -- Bottom
            {
                awful.titlebar.widget.iconwidget(c),
                layout = wibox.layout.fixed.vertical(),
            },
            widget = wibox.container.margin,
            bottom = 5
        },
        buttons = buttons,
        layout = wibox.layout.align.vertical()
    }
end

function theme.at_screen_connect(s)
    local rounded_rect_5 = function(cr, width, height)
        gears.shape.rounded_rect(cr, width, height, 5)
    end

    local rounded_rect_10 = function(cr, width, height)
        gears.shape.rounded_rect(cr, width, height, 10)
    end

    local keyboard_layout = awful.widget.keyboardlayout()

    local taglist_buttons = gears.table.join(
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
    )

    local tasklist_buttons = gears.table.join(
        awful.button({ }, 1,
            function (c)
                if c == client.focus then
                    c.minimized = true
                else
                    c:emit_signal(
                        "request::activate", "tasklist",
                        {raise = true})
                end
            end),

        awful.button({ }, 3, function()
            awful.menu.client_list({ theme = { width = 250 } })
        end),

        awful.button({ }, 4, function ()
            awful.client.focus.byidx(1)
        end),

        awful.button({ }, 5, function ()
            awful.client.focus.byidx(-1)
        end)
    )

    awful.tag({ "1", "2", "3", "4", "5", "6", "7", "8", "9" }, s, awful.layout.layouts[1])

    local layoutbox = awful.widget.layoutbox(s)

    layoutbox:buttons { gears.table.join(
        awful.button({ }, 1, function () awful.layout.inc( 1) end),
        awful.button({ }, 3, function () awful.layout.inc(-1) end),
        awful.button({ }, 4, function () awful.layout.inc( 1) end),
        awful.button({ }, 5, function () awful.layout.inc(-1) end))
    }

    local generate_taglist_tasklist = function(t)
        return awful.widget.tasklist {
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
            buttons = tasklist_buttons,
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
                end,
            }
        }
    end

    s.taglist = awful.widget.taglist {
        screen  = s,
        -- filter = awful.widget.taglist.filter.all,
        filter  = function(t) return t.selected or #t:clients() > 0 end,
        buttons = taglist_buttons,
        layout = {
            spacing = beautiful.spacing,
            spacing_widget = {
                visible = false,
            },
            layout = wibox.layout.fixed.horizontal
        },
        style = {
            shape = rounded_rect_5
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
                self:get_children_by_id("tasklist_placeholder")[1]:add(generate_taglist_tasklist(tag))
            end
        }
    }

    s.wibox = awful.wibar {
        position = "top",
        screen = s,
        height = dpi(34),
        ontop = true,
        bg = "#00000000"
    }

    s.wibox:setup {
        {
            {
                {
                    {
                        {
                            {
                                layoutbox,
                                top = dpi(3),
                                bottom = dpi(3),
                                left = dpi(5),
                                right = dpi(5),
                                layout = wibox.container.margin
                            },
                            bg = beautiful.colour0,
                            shape = rounded_rect_5,
                            layout = wibox.container.background
                        },
                        {
                            s.taglist,
                            layout = wibox.layout.stack,
                        },

                        spacing = beautiful.spacing,
                        spacing_widget = {
                            visible = false
                        },
                        layout = wibox.layout.fixed.horizontal,
                    },
                    margins = dpi(3),
                    layout = wibox.container.margin
                },
                bg = beautiful.background,
                shape = rounded_rect_5,
                layout = wibox.container.background
            },
            { -- Center Widgets
                layout = wibox.layout.fixed.horizontal
            },
            { -- Right Widgets
                keyboard_layout,
                layout = wibox.layout.fixed.horizontal
            },
            layout = wibox.layout.align.horizontal
        },
        layout = wibox.container.margin,
        top   = dpi(4),
        left  = dpi(5),
        right = dpi(5)
    }
end

-- local clock_widget = awful.widget.watch(
--     "date +'%a, %d %b %H:%M'", 30,
--     function(widget, stdout)
--         widget:set_markup(" " .. markup.font(theme.font, stdout))
--     end
-- )
--
-- local calendar_widget = require("awesome-wm-widgets.calendar-widget.calendar") {
--     placement = "top_right",
--     theme = "naughty",
--     start_sunday = true,
--     start_sundary = true,
-- }
--
-- clock_widget:connect_signal("button::press",
--     function(_,_,_, button)
--         if button == 1 then
--             calendar_widget.toggle()
--         end
--     end
-- )
--
-- local cpu_widget = require("awesome-wm-widgets.cpu-widget.cpu-widget") {
--     color = theme.fg_normal,
-- }
--
-- local net_speed_widget = require("awesome-wm-widgets.net-speed-widget.net-speed") {
--
-- }
--
-- local ram_widget = require("awesome-wm-widgets.ram-widget.ram-widget") {
--     color_used = theme.fg_normal,
--     color_free = theme.bg_focus
-- }
--
-- local fs_widget = require("awesome-wm-widgets.fs-widget.fs-widget") {
--     mounts = { '/' }
-- }
--
-- use_battery = (os.execute("ls /sys/class/power_supply/BAT0/") == true)
-- local battery_widget = require("awesome-wm-widgets.batteryarc-widget.batteryarc") {
--     show_current_level = true,
--     warning_msg_title = "Low Battery",
--     warning_msg_text  = "Please charge",
--     enable_battery_warning = use_battery
-- }
--
-- local weatherapi = require("weatherapi")
-- local use_weather = weatherapi.use;
-- local weather_widget
-- if use_weather then
--     local weather_widget = require("awesome-wm-widgets.weather-widget.weather") {
--         api_key = require("weatherapi").api_id,
--         coordinates = require("weatherapi").lat_long,
--         show_hourly_forecast = true,
--         icon_pack_name = "VitalyGorbachev"
--     }
-- end
--
-- local volume_widget = require("awesome-wm-widgets.volume-widget.volume") {
--     widget_type = "icon_and_text",
--     mixer_cmd = "pavucontrol",
--     device = "default"
-- }
--
-- use_brightness = (os.execute("xbacklight") == true)
-- local brightness_widget = require("awesome-wm-widgets.brightness-widget.brightness") {
--     type = "icon_and_text",
--     program = "light"
--     -- percent = true
-- }
--
-- function theme.at_screen_connect(s)
--     -- {{{ WIDGETS
--     local mykeyboardlayout = awful.widget.keyboardlayout()
--
--     s.mypromptbox = awful.widget.prompt()
--
--
--     local taglist_buttons = gears.table.join(
--         awful.button({ }, 1, function(t) t:view_only() end),
--
--         awful.button({ modkey }, 1,
--             function(t)
--                 if client.focus then
--                     client.focus:move_to_tag(t)
--                 end
--             end
--         ),
--
--         awful.button({ }, 3, awful.tag.viewtoggle),
--
--         awful.button({ modkey }, 3,
--             function(t)
--                 if client.focus then
--                     client.focus:toggle_tag(t)
--                 end
--             end
--         ),
--
--         awful.button({ }, 4, function(t) awful.tag.viewnext(t.screen) end),
--         awful.button({ }, 5, function(t) awful.tag.viewprev(t.screen) end)
--     )
--
--     local tasklist_buttons = gears.table.join(
--         awful.button({ }, 1,
--             function (c)
--                 if c == client.focus then
--                     c.minimized = true
--                 else
--                     c:emit_signal(
--                         "request::activate", "tasklist",
--                         {raise = true})
--                 end
--             end),
--
--         awful.button({ }, 3, function()
--             awful.menu.client_list({ theme = { width = 250 } })
--         end),
--
--         awful.button({ }, 4, function ()
--             awful.client.focus.byidx(1)
--         end),
--
--         awful.button({ }, 5, function ()
--             awful.client.focus.byidx(-1)
--         end)
--     )
--
--     awful.tag({ "1", "2", "3", "4", "5", "6", "7", "8", "9" }, s, awful.layout.layouts[1])
--
--     s.mylayoutbox = awful.widget.layoutbox(s)
--
--     s.mylayoutbox:buttons { gears.table.join(
--         awful.button({ }, 1, function () awful.layout.inc( 1) end),
--         awful.button({ }, 3, function () awful.layout.inc(-1) end),
--         awful.button({ }, 4, function () awful.layout.inc( 1) end),
--         awful.button({ }, 5, function () awful.layout.inc(-1) end))
--     }
--
--     s.mytaglist = awful.widget.taglist {
--         screen  = s,
--         filter  = awful.widget.taglist.filter.all,
--         buttons = taglist_buttons,
--         layout = {
--             spacing = 4,
--             spacing_widget = {
--                 visible = false,
--             },
--             layout = wibox.layout.fixed.horizontal
--         },
--         widget_template = {
--             {
--                 {
--                     {
--                         id = 'text_role',
--                         widget = wibox.widget.textbox,
--                     },
--                     left  = 3,
--                     right = 3,
--                     widget = wibox.container.margin,
--                 },
--                 shape = gears.shape.rectangle,
--                 widget = wibox.container.background
--             },
--             id = 'background_role',
--             widget = wibox.container.background
--         }
--     }
--
--     -- Create a tasklist widget
--     s.mytasklist = awful.widget.tasklist {
--         screen  = s,
--         filter  = awful.widget.tasklist.filter.currenttags,
--         buttons = tasklist_buttons,
--         layout = {
--             spacing = 5,
--             spacing_widget = {
--                 {
--                     forced_width = dpi(5),
--
--                     shape = gears.shape.circle,
--                     widget = wibox.widget.separator {
--                         visible = false
--                     }
--                 },
--                 valign = 'center',
--                 halign = 'center',
--                 widget = wibox.container.place
--             },
--             layout = wibox.layout.fixed.horizontal
--         },
--         widget_template = {
--             {
--                 {
--                     {
--                         {
--                             {
--                                 id = 'icon_role',
--                                 widget = wibox.widget.imagebox,
--                             },
--                             margins = 2,
--                             widget = wibox.container.margin,
--                         },
--                         {
--                             id = 'text_role',
--                             widget = wibox.widget.textbox,
--                         },
--                         forced_width = nil,
--                         layout = wibox.layout.fixed.horizontal,
--                     },
--                     left = 10,
--                     right = 10,
--                     widget = wibox.container.margin,
--                 },
--                 bg = theme.bg_normal,
--                 shape = gears.shape.rounded_bar,
--                 shape_border_color = theme.bg_focus,
--                 shape_border_width = 2,
--                 widget = wibox.container.background
--             },
--
--             id = 'background_role',
--             widget = wibox.container.background
--         }
--     }
--     -- }}}
--
--     -- Create the wibox
--     use_background = {
--         bg = false 
--     }
--     local function add_widget(widget)
--         if use_background.bg then
--             return bg_widget(widget)
--         else
--             return fg_widget(widget)
--         end
--     end
--
--     local function add_arrow_left()
--         if use_background.bg then
--             use_background.bg = not use_background.bg
--             return arr_l_bg_fg
--         else
--             use_background.bg = not use_background.bg
--             return arr_l_fg_bg
--         end
--     end
--
--     local function add_arrow_right()
--         if use_background.bg then
--             use_background.bg = not use_background.bg
--             return arr_r_bg_fg
--         else
--             use_background.bg = not use_background.bg
--             return arr_r_fg_bg
--         end
--     end
--
--     s.mywibox = awful.wibar {
--         position = "top",
--         screen = s,
--         height = dpi(20),
--         ontop = true
--     }
--
--     use_background.bg = true
--     local left_widgets = wibox.layout.fixed.horizontal()
--     left_widgets:add(
--         add_widget(wibox.widget.textbox(" ")),
--         add_widget(s.mytaglist, data),
--         add_widget(spr),
--
--         add_arrow_right(),
--
--         add_widget(spr),
--         s.mypromptbox
--     )
--
--     local center_widgets = s.mytasklist
--
--     local right_widgets = wibox.layout.fixed.horizontal()
--     right_widgets:add(
--         add_arrow_left(),
--
--         add_widget(mykeyboardlayout),
--         add_widget(wibox.widget.systray()),
--
--         add_arrow_left(),
--
--         add_widget(volume_widget), 
--         add_widget(spr)
--     )
--
--     if use_brightness then
--         right_widgets:add(
--             add_widget(spr),
--             add_widget(brightness_widget)
--         )
--     end
--
--     right_widgets:add(
--         add_arrow_left(),
--
--         add_widget(fs_widget), 
--         add_widget(spr), 
--
--         add_arrow_left(),
--
--         add_widget(net_speed_widget),
--
--         add_arrow_left(),
--
--         add_widget(spr),
--         add_widget(cpu_widget),
--         add_widget(spr),
--         add_widget(ram_widget),
--         add_widget(spr), 
--
--         add_arrow_left()
--     )
--
--     if use_weather then
--         right_widgets:add(
--             add_widget(weather_widget),
--             add_widget(spr),
--
--             add_arrow_left()
--         )
--     end
--
--     if use_battery then
--         right_widgets:add(
--             add_widget(battery_widget),
--             add_widget(spr),
--
--             add_arrow_left()
--         )
--     end
--
--     right_widgets:add(
--         add_widget(clock_widget), 
--         add_widget(spr), 
--         add_widget(spr) 
--     )
--
--     s.mywibox:setup {
--         layout = wibox.layout.align.horizontal,
--         left_widgets,
--         center_widgets,
--         right_widgets
--     }
-- end
--
-- beautiful.init(theme)
--

return theme
