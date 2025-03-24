local colors = {
    rosewater = { 0.862, 0.541, 0.471 },
    flamingo = { 0.867, 0.471, 0.471 },
    pink = { 0.918, 0.463, 0.796 },
    mauve = { 0.533, 0.224, 0.937 },
    red = { 0.82, 0.059, 0.224 },
    maroon = { 0.902, 0.275, 0.325 },
    peach = { 0.996, 0.392, 0.043 },
    yellow = { 0.875, 0.557, 0.114 },
    green = { 0.251, 0.627, 0.169 },
    teal = { 0.09, 0.576, 0.6 },
    sky = { 0.016, 0.647, 0.898 },
    sapphire = { 0.127, 0.624, 0.71 },
    blue = { 0.118, 0.4, 0.961 },
    lavender = { 0.447, 0.529, 0.992 },
    text = { 0.298, 0.31, 0.412 },
    subtext1 = { 0.361, 0.373, 0.467 },
    subtext0 = { 0.424, 0.435, 0.522 },
    overlay2 = { 0.486, 0.498, 0.576 },
    overlay1 = { 0.549, 0.561, 0.631 },
    overlay0 = { 0.612, 0.627, 0.69 },
    surface2 = { 0.675, 0.69, 0.745 },
    surface1 = { 0.737, 0.753, 0.8 },
    surface0 = { 0.8, 0.816, 0.855 },
    base = { 0.937, 0.945, 0.961 },
    mantle = { 0.902, 0.914, 0.937 },
    crust = { 0.863, 0.878, 0.91 },
    greens = {

        highlight2 = { 0.549, 0.855, 0.212 },
        highlight = { 0.607, 0.733, 0.059 },
        base = { 0.545, 0.675, 0.059 },
        shadow = { 0.188, 0.384, 0.188 },
        border = { 0.059, 0.220, 0.059 }
    },
    hexToRgb = function(hex)
        local r = tonumber(hex:sub(2, 3), 16) / 255
        local g = tonumber(hex:sub(4, 5), 16) / 255
        local b = tonumber(hex:sub(6, 7), 16) / 255
        return { r, g, b }
    end
}


return colors
