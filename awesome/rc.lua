-- If LuaRocks is installed, make sure that packages installed through it are
-- found (e.g. lgi). If LuaRocks is not installed, do nothing.
pcall(require, "luarocks.loader")

-- Standard awesome library
local gears = require("gears")
local awful = require("awful")
require("awful.autofocus")

-- Widget and layout library
local wibox = require("wibox")

-- Theme handling library
local beautiful = require("beautiful")

-- Notification library
local naughty = require("naughty")
local menubar = require("menubar")
local hotkeys_popup = require("awful.hotkeys_popup")

-- Load Tmux keybinds
require("awful.hotkeys_popup.keys.tmux")

modkey = "Mod4"

-- {{{ Error handling
    -- Check if awesome encountered an error during startup and fell back to
    -- another config (This code will only ever execute for the fallback config)
    if awesome.startup_errors then
        naughty.notify({ preset = naughty.config.presets.critical,
                title = "Oops, there were errors during startup!",
            text = awesome.startup_errors })
    end

    -- Handle runtime errors after startup
    do
        local in_error = false
        awesome.connect_signal("debug::error", function (err)
            -- Make sure we don't go into an endless error loop
            if in_error then return end
            in_error = true

            naughty.notify({ preset = naughty.config.presets.critical,
                    title = "Oops, an error happened!",
                text = tostring(err) })
            in_error = false
        end)
    end
-- }}}

-- {{{ Variable definitions
    terminal = "kitty"
    editor = "nvim"
    editor_cmd = terminal .. " -e " .. editor

    modkey = "Mod4"

    tag.connect_signal("request::default_layouts",
        function()
            awful.layout.append_default_layouts({
                awful.layout.suit.tile,
                awful.layout.suit.floating,
            })
        end)

    local theme = require("theme.init")

    if not beautiful.init(theme) then
        beautiful.init(gears.filesystem.get_configuration_dir() .. "theme.default.lua")
    end
-- }}}

-- {{{ Menu
    menubar.utils.terminal = terminal -- Set the terminal for applications that require it
-- }}}

awful.screen.connect_for_each_screen(
    function(s)
        beautiful.at_screen_connect(s)
        require("theme.menu").create_menu(s)
    end
)

-- {{{ Mouse bindings
    root.buttons(gears.table.join(
            awful.button({ }, 4, awful.tag.viewnext),
            awful.button({ }, 5, awful.tag.viewprev)
    ))
-- }}}

-- {{{ Key bindings
    local globalkeys = require("global_keybinds")
    local client_keybinds = require("client_keybinds")

    local client_keys = client_keybinds.keys
    local client_buttons = client_keybinds.buttons

    -- Set keys
    root.keys(globalkeys)
-- }}}

-- {{{ Rules
    -- Rules to apply to new clients (through the "manage" signal).
    awful.rules.rules = {
        -- All clients will match this rule.
        { rule = { },
            properties = {
                border_width = beautiful.border_width,
                border_color = beautiful.border_normal,
                focus = awful.client.focus.filter,
                raise = true,
                keys = client_keybinds.keys,
                buttons = client_keybinds.buttons,
                screen = awful.screen.preferred,
                placement = awful.placement.no_overlap+awful.placement.no_offscreen
            }
        },

        -- Floating clients.
        { rule_any = {
                instance = {
                    "DTA",  -- Firefox addon DownThemAll.
                    "copyq",  -- Includes session name in class.
                    "pinentry",
                },
                class = {
                    "Arandr",
                    "Blueman-manager",
                    "Gpick",
                    "Kruler",
                    "MessageWin",  -- kalarm.
                    "Sxiv",
                    "Tor Browser", -- Needs a fixed window size to avoid fingerprinting by screen size.
                    "Wpa_gui",
                    "veromix",
                "xtightvncviewer"},

                -- Note that the name property shown in xprop might be set slightly after creation of the client
                -- and the name shown there might not match defined rules here.
                name = {
                    "Event Tester",  -- xev.
                },
                role = {
                    "AlarmWindow",  -- Thunderbird's calendar.
                    "ConfigManager",  -- Thunderbird's about:config.
                    "pop-up",       -- e.g. Google Chrome's (detached) Developer Tools.
                }
        }, properties = { floating = true }},

        -- Add titlebars to normal clients and dialogs
        { rule_any = {type = { "normal", "dialog" }
            }, properties = { titlebars_enabled = false }
        },

        -- Set Firefox to always map on the tag named "2" on screen 1.
        -- { rule = { class = "Firefox" },
        --   properties = { screen = 1, tag = "2" } },
    }
-- }}}

-- {{{ FLOATING TITLEBAR TOGGLE
    local function setTitlebar(client, should_float)
        if should_float then
            if client.titlebar == nil then
                client:emit_signal("request:titlebars", "rules", {})
                -- client:emit_signal("request:titlebars")
            end
            awful.titlebar.show(client, beautiful.titlebar_location)
            screen = awful.screen.focused()
            screengeo = screen.geometry

            geo = client:geometry(nil)
            geo.width = screengeo.width * (3/4)
            geo.height = screengeo.height * (3/4)
            geo.x = (screengeo.width / 2) - (geo.width / 2)
            geo.y = (screengeo.height / 2) - (geo.height / 2)
            client:geometry(geo)
        else
            awful.titlebar.hide(client, beautiful.titlebar_location)
        end
    end

    client.connect_signal("property::floating",
        function(c)
            setTitlebar(c, c.floating)
        end)

    client.connect_signal("manage",
        function(c)
            setTitlebar(c, c.floating or c.first_tag.layout == awful.layout.suit.floating)
        end)

    tag.connect_signal("property::layout",
        function(t)
            for _, c in pairs(t:clients()) do
                if t.layout == awful.layout.suit.floating then
                    setTitlebar(c, true)
                else
                    setTitlebar(c, false)
                end
            end
        end)
-- }}}

-- {{{ Signals
    -- Signal function to execute when a new client appears.
    client.connect_signal("manage",
        function (c)
            if not awesome.startup then awful.client.setslave(c) end

            if awesome.startup
                and not c.size_hints.user_position
                and not c.size_hints.program_position then
                -- Prevent clients from being unreachable after screen count changes.
                awful.placement.no_offscreen(c)
            end
        end)

    client.connect_signal("request::titlebars", beautiful.on_titlebar)

    -- Enable sloppy focus, so that focus follows mouse.
    -- client.connect_signal("mouse::enter", function(c)
    --     c:emit_signal("request::activate", "mouse_enter", {raise = false})
    -- end)
    client.connect_signal("focus", function(c) c.border_color = beautiful.border_focus end)
    client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)

    screen.connect_signal(
        "tag::history:update",
        function()
            local s = awful.screen.focused()
            local c = awful.client.focus.history.get(s, 0)
            if c == nil then
                return
            end
            awful.client.focus.byidx(0, c)
        end
    )
-- }}}

-- Clean memory
collectgarbage("setpause", 160)
collectgarbage("setstepmul", 400)

gears.timer.start_new(10, function()
    collectgarbage("step", 20000)
    return true
end)

require("autostart")
