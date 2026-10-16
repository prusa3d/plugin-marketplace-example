-- Hello Marketplace: a cube with a word embossed on top.
local M = {}

function M.hello_cube(opts)
    local text = opts.text or "Hello"
    local size = opts.size or 20.0
    local depth = opts.depth or 1.0
    local font = opts.font or api.get_default_font()

    local cube = api.make_cube(size, size, size)
    local label = api.emboss_text {
        font=font,
        text=text,
        depth=depth
    }
    local b = label:bounds()
    local width = b.max_x - b.min_x
    local height = b.max_y - b.min_y

    return {
        {mesh=cube, translate={x=0, y=0, z=0}},
        {mesh=label, translate={x=(size - width) / 2 - b.min_x, y=(size - height) / 2 - b.min_y, z=size}}
    }
end

return M
