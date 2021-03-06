--DOC_HIDE_ALL --DOC_GEN_IMAGE
local a_tag    = require("awful.tag")
local a_layout = require("awful.layout")
local tile     = require("dynamite.suit.tile")

screen._setup_grid(128, 96, {4})

local function add_clients(s)
    local x, y = s.geometry.x, s.geometry.y
    for _=1, 5 do
        client.gen_fake{x = x+45, y = y+35, width=40, height=30, screen=s}:_hide()
    end
end

-- Add some tags and clients
local tags = {}
for i=1, 4 do
    tags[screen[i]] = a_tag.add("Test1", {screen=screen[i], selected = true})
    add_clients(screen[i])
end

local function show_layout(f, s, name)
    local t = tags[s]

    -- Test if the layout exist
    assert(f)

    t.layout = f

    local l = a_tag.getproperty(t, "layout")

    -- Test if the right type of layout was created
    assert(l.name == name)

    -- Test is setlayout did create a stateful layout
    assert(l.is_dynamic)

    -- Test if the tag is the right one
    assert(l._tag == t)

    for _ = 1, 5 do
        require("gears.timer").run_delayed_calls_now()
    end

    -- Test if the stateful layout track the right number of clients
    assert(#l.wrappers == #t:clients(), "GOT "..#l.wrappers.." expected "..#t:clients()) --DOC_HIDE

    local params = a_layout.parameters(t, s)

    -- Test if the tag state is correct
    assert(l.active)

    -- Test if the widget has been created
    assert(l.widget)

    -- Test if the number of clients wrapper is right and if they are there
    -- only once
    local all_widget = l.widget:get_all_children()
    local cls, inv = {},{}
    for _, w in ipairs(all_widget) do
        if w._client then
            assert(not inv[w._client])
            inv[w._client] = w
            table.insert(cls, w._client)
        end
    end
    assert(#cls == #t:clients())

    l.arrange(params)

    -- Test if 4 clients are equally tiled and one is master
    local sizes = {}
    for _, c in ipairs(t:clients()) do
        local geo = c:geometry()
        geo.height, geo.width = geo.height+2*c.border_width, geo.width+2*c.border_width
        sizes[geo.height*geo.width] = (sizes[geo.height*geo.width] or 0)+1
    end
    local count, total = 0,0
    for k,v in pairs(sizes) do
        count = count + 1
        assert(v == 1 or v == 4)
        total = total + k*v
    end
    assert(count == 2)

    -- Finally, test if the clients total size match the workarea
    assert(s.workarea.width * s.workarea.height == total)
end

show_layout(tile       , screen[1], "tile"      )
show_layout(tile.left  , screen[2], "tileleft"  )
show_layout(tile.top   , screen[3], "tiletop"   )
show_layout(tile.bottom, screen[4], "tilebottom")

return {hide_lines=true}
