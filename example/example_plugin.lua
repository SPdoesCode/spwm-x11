
--------------------------------------------------------------------------------------------
-- !!! PLEASE note this was made in early development so the api might not be the same!!! --
--------------------------------------------------------------------------------------------

local bar = SPWM.bar.make(rectangle, SPWM.get_var("bar_color"), 100, SPWM.bar.place.top, SPWM.bar.size.left_to_right)

-- basic bar kinda looks like |     [window name]      |
function init()
    SPWM.plugin_type(SPWM.plugin_types.bar)

    SPWM.log.debug("Initing bar")
    bar.init()

    while SPWM.event() != SPWM.events.exit do
        bar.print("["..SPWM.window.current.name .. "]", bar.center)
    end
end

function exit()
    SPWM.log.debug("Exiting...")
    bar.exit(0)
end