-- Taken from http://lua-users.org/wiki/SimpleLuaClasses
function Class(base, init)
    local c = {}
    if not init and type(base) == 'function' then
        init = base
        base = nil
    elseif type(base) == 'table' then
        for i,v in pairs(base) do
            c[i] = v
        end
        c._base = base
    end
    c.__index = c

    local mt = {}
    mt.__call = function(class_tbl, ...)
    local obj = {}
    setmetatable(obj,c)
    if init then
        init(obj,...)
    else
        if base and base.init then
        base.init(obj, ...)
        end
    end
    return obj
    end
    c.init = init
    c.is_a = function(self, klass)
        local m = getmetatable(self)
        while m do
            if m == klass then return true end
            m = m._base
        end
        return false
    end
    setmetatable(c, mt)
    return c
end


ShapeImage = Class(
    function (o, meter_name, num_rows, width, height)
        o.meter_name = meter_name

        -- Create line shapes for each row
        local row_height = height / num_rows
        for y = 0, num_rows - 1 do
            local suffix = (y == 0) and '' or ('%d'):format(y + 1)
            local meter_y = y * row_height + row_height / 2
            local options = ('StrokeWidth %s | Stroke LinearGradient Grad%s'):format(
                row_height, suffix
            )

            -- Create a line for this row
            SKIN:Bang('!SetOption', meter_name, 'Shape' .. suffix,
                ('Line 0,%d,%d,%d | %s'):format(
                    meter_y,
                    width,
                    meter_y,
                    options
                )
            )

            -- Set a black gradient so rainmeter doesn't complain about the
            -- gradient not existing
            SKIN:Bang('!SetOption', meter_name, 'Grad' .. suffix,
                '180 | 0,0,0,0;0'
            )
        end
    end
)


function ShapeImage:drawRow(y, tRow)
    local suffix = (y == 0) and '' or ('%d'):format(y + 1)
    local gradient = {'180'}
    local length = #tRow + 1

    for i = 0, #tRow do
        table.insert(gradient, ('%s;%f'):format(tRow[i], i / length))
        table.insert(gradient, ('%s;%f'):format(tRow[i], (i + 1) / length))
    end

    SKIN:Bang('!SetOption', self.meter_name, 'Grad' .. suffix,
        table.concat(gradient, '|')
    )
end

-- Remove the Class function so we don't pollute the global scope more than we
-- have to
Class = nil
