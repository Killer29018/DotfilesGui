local gears = require("gears")
local wibox = require("wibox")
local awful = require("awful")

local dpi = require("beautiful.xresources").apply_dpi

local gfs = require("gears.filesystem")
local themes_path = gfs.get_themes_dir()
local custom_theme = "~/.config/awesome/icons/"

local beautiful = require("beautiful")

local my_table = awful.util.table or gears.table

local naughty = require("naughty")

local theme = {}
theme.dir = require("gears.filesystem").get_configuration_dir()
theme.font = "CaskaydiaCove Nerd Font Mono 8"
theme.font_default = "CaskaydiaCove Nerd Font Mono "

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

theme.titlebar_fg_focus  = theme.fg_focus
theme.titlebar_fg_normal = theme.fg_focus
theme.titlebar_bg_focus  = theme.bg_focus
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
theme.background = "#151619"

theme.fg_normal = "#FFFFFF"
theme.bg_normal = "#888888"
theme.fg_focus  = "#0F0F0F"
theme.bg_focus  = "#CCCCCC"

theme.fg_focus_light = "#0F0F0F"
theme.bg_focus_light = "#AFAFAF"
theme.fg_normal_light = "#FFFFFF"
theme.bg_normal_light = "#6B6B6B"

theme.taglist_fg_occupied = theme.fg_normal
theme.taglist_bg_occupied = theme.bg_normal
theme.taglist_fg_focus    = theme.fg_focus
theme.taglist_bg_focus    = theme.bg_focus

theme.tasklist_fg_normal = theme.fg_normal
theme.tasklist_bg_normal = theme.bg_normal
theme.tasklist_fg_focus  = theme.fg_focus
theme.tasklist_bg_focus  = theme.bg_focus

-- taglist_[bg|fg]_[focus|urgent|occupied|empty|volatile]
-- tasklist_[bg|fg]_[focus|urgent]
-- titlebar_[bg|fg]_[normal|focus]
-- tooltip_[font|opacity|fg_color|bg_color|border_width|border_color]
-- mouse_finder_[color|timeout|animate_timeout|radius|factor]
-- prompt_[fg|bg|fg_cursor|bg_cursor|font]
-- hotkeys_[bg|fg|border_width|border_color|shape|opacity|modifiers_fg|label_bg|label_fg|group_margin|font|description_font]

-- menu_[bg|fg]_[normal|focus]
-- menu_[border_color|border_width]

theme.layout_fairh      = themes_path.."default/layouts/fairhw.png"
theme.layout_fairv      = themes_path.."default/layouts/fairvw.png"
theme.layout_floating   = themes_path.."default/layouts/floatingw.png"
theme.layout_magnifier  = themes_path.."default/layouts/magnifierw.png"
theme.layout_max        = themes_path.."default/layouts/maxw.png"
theme.layout_fullscreen = themes_path.."default/layouts/fullscreenw.png"
theme.layout_tilebottom = themes_path.."default/layouts/tilebottomw.png"
theme.layout_tileleft   = themes_path.."default/layouts/tileleftw.png"
theme.layout_tile       = themes_path.."default/layouts/tilew.png"
theme.layout_tiletop    = themes_path.."default/layouts/tiletopw.png"
theme.layout_spiral     = themes_path.."default/layouts/spiral.png"
theme.layout_dwindle    = themes_path.."default/layouts/dwindlew.png"
theme.layout_cornernw   = themes_path.."default/layouts/cornernww.png"
theme.layout_cornerne   = themes_path.."default/layouts/cornernew.png"
theme.layout_cornersw   = themes_path.."default/layouts/cornersww.png"
theme.layout_cornerse   = themes_path.."default/layouts/cornersew.png"

theme.menu_hamburger_normal = custom_theme.."menu/hamburger_menu_normal.png"
theme.menu_hamburger_focus  = custom_theme.."menu/hamburger_menu_focus.png"

theme.icon_theme = nil
theme.spacing = dpi(6)
theme.margin = dpi(3)

theme.titlebar_location = "left"

beautiful.init(theme)


function theme.on_titlebar(c)
    require("theme.titlebar").taskbar(c)
end

function theme.at_screen_connect(s)
    s.wibox = require("theme.taskbar.init").wibox(s)
end

return theme
