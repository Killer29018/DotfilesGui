local awful = require("awful")
local wibox = require("wibox")
local gears = require("gears")

rounded_rect_5 = function(cr, width, height)
    gears.shape.rounded_rect(cr, width, height, 5)
end

rounded_rect_10 = function(cr, width, height)
    gears.shape.rounded_rect(cr, width, height, 10)
end
