/*

FLAT BLUE - Aspect and rotation aware layout for Attract-Mode Front-End

graphic design by: www.ClanLogoDesign.com
layout scripting by: Chris Van Graas
shader code by: Timothy Lottes, LUKE NUKEM, krischan, Chris Van Graas

Public Functions:
    round(float)
        Round a float value UP to nearest int (Negative numbers get rounded UP as well)
        returns int

    log(obj)
        Output a string message to the console if DEBUG constant is enabled.

    randomize(int)
        Generate a random number, int param sets ceiling.
        returns int

    percent_to_pixel(float, int)
        Convert a percentage value (as a float) to an integer.
        (Used for resolution independant layout positioning)
        returns int

    get_gcd(scalar2)
        Get the greatest common divisor (gcd) of a pair of integers.
        returns int

    get_aspect_ratio_float(scalar2)
        Get the aspect ratio of a pair of integers as a float.
        returns float

    get_aspect_ratio_width(scalar2)
        Get the aspect ratio width of a pair of integers.
        returns int

    get_aspect_ratio_height(scalar2)
        Get the aspect ratio height of a pair of integers.
        returns int

    get_aspect_ratio_dimensions(scalar2)
        Get the aspect ratio width and height of a pair of integers.
        returns scalar()

    set_surface_size_by_image_aspect_ratio_width(fe.surface, fe.image, int)
        Set the dimensions of a surface based on the aspect ratio width of an image.

    set_surface_size_by_image_aspect_ratio_height(fe.surface, fe.image, int)
        Set the dimensions of a surface based on the aspect ratio height of an image.

    set_surface_image_fill(fe.surface, fe.image, scalar2)
        Set an image inside a surface to fill the available space while maintaining the correct aspect ratio.

    set_surface_image_fit(fe.surface, fe.image, scalar2)
        Set an image inside a surface to fit the available space while maintaining the correct aspect ratio.

    truncate_message(fe.text, int)

    get_strength(string)
        Converts a set of 5 strings (strongest, strong, medium, weak, weakest) to a percentage of 255 on a linear scale.
        (Useful for UserConfig settings like "Scanline Strength")
        returns int

*/

function round(value)
{
    return floor(value + 0.5);
}

function log(msg)
{
    if (msg == null) msg = "null";
    msg = format("[%s v%s]: %s\n", LAYOUT_NAME, VERSION.tostring(), msg.tostring());
    if (DEBUG) print(msg);
}

function randomize(max_value)
{
    return rand() * max_value / RAND_MAX;
}

function percent_to_pixel(percent, context)
{
    // local value = percent * context;
    // if (value % 2 >= 0.5) value += 1;
    // return value.tointeger();
    return round(percent * context);
}

function get_gcd(dimensions) { return (dimensions.height == 0) ? dimensions.width : get_gcd(scalar2(dimensions.height, dimensions.width % dimensions.height)); }

function get_aspect_ratio_float(dimensions) { return dimensions.width / dimensions.height.tofloat(); }

function get_aspect_ratio_width(dimensions)
{
    local gcd = get_gcd(dimensions);
    if (gcd != 0) return dimensions.width / gcd;
    return 0;
}

function get_aspect_ratio_height(dimensions)
{
    local gcd = get_gcd(dimensions);
    if (gcd != 0) return dimensions.height / gcd;
    return 0;
}

function get_aspect_ratio_dimensions(dimensions)
{
    return scalar2(get_aspect_ratio_width(dimensions), get_aspect_ratio_height(dimensions));
}

function set_surface_size_by_image_aspect_ratio_width(surface, image, max_width)
{
    local image_aspect_ratio = scalar2();
    local texture_size = scalar2(image.texture_width, image.texture_height);
    image_aspect_ratio.w = get_aspect_ratio_width(texture_size);
    image_aspect_ratio.h = get_aspect_ratio_height(texture_size);

    // dodgey hack for scraped images with bad aspect ratio
    if (image_aspect_ratio.w == 222 && image_aspect_ratio.h == 167)
    {
        image_aspect_ratio.w = 4;
        image_aspect_ratio.h = 3;
    }

    local unit = (image_aspect_ratio.w == 0) ? 0 : max_width / image_aspect_ratio.w;

    surface.width = max_width;
    surface.height = unit * image_aspect_ratio.h;
}

function set_surface_size_by_image_aspect_ratio_height(surface, image, max_height)
{
    local image_aspect_ratio = scalar2();
    local texture_size = scalar2(image.texture_width, image.texture_height);
    image_aspect_ratio.w = get_aspect_ratio_width(texture_size);
    image_aspect_ratio.h = get_aspect_ratio_height(texture_size);

    // dodgey hack for scraped images with bad aspect ratio
    if (image_aspect_ratio.w == 167 && image_aspect_ratio.h == 222)
    {
        image_aspect_ratio.w = 3;
        image_aspect_ratio.h = 4;
    }

    local unit = (image_aspect_ratio.h == 0) ? 0 : max_height / image_aspect_ratio.h;

    surface.width = unit * image_aspect_ratio.w;
    surface.height = max_height;
}

function set_surface_image_fill(surface, image, max_dimensions)
{
    local texture_size = scalar2(image.texture_width, image.texture_height);
    local ar_f = vec2(get_aspect_ratio_float(texture_size), get_aspect_ratio_float(max_dimensions));

    if (ar_f.x >= ar_f.y) { set_surface_size_by_image_aspect_ratio_height(surface, image, max_dimensions.height); }
    else { set_surface_size_by_image_aspect_ratio_width(surface, image, max_dimensions.width); }
}

function set_surface_image_fit(surface, image, max_dimensions)
{
    local texture_size = scalar2(image.texture_width, image.texture_height);
    local ar_f = vec2(get_aspect_ratio_float(texture_size), get_aspect_ratio_float(max_dimensions));

    if (ar_f.x >= ar_f.y) { set_surface_size_by_image_aspect_ratio_width(surface, image, max_dimensions.width); }
    else { set_surface_size_by_image_aspect_ratio_height(surface, image, max_dimensions.height); }
}

function truncate_message(text_obj, max_length)
{
    if (text_obj.msg_width > max_length)
    {
        while (text_obj.msg_width > max_length)
        {
            text_obj.msg = text_obj.msg.slice(0, text_obj.msg.len() - 1);
            text_obj.msg = strip(text_obj.msg);
        }

        text_obj.msg = text_obj.msg.slice(0, text_obj.msg.len() - 1);
        text_obj.msg = strip(text_obj.msg);
        text_obj.msg += "...";
    }
}

function get_strength(strength)
{
    local unit;
    switch (strength)
    {
        case "Strongest":
            unit = 100;
            break;
        case "Strong":
            unit = 80;
            break;
        case "Medium":
            unit = 60;
            break;
        case "Weak":
            unit = 40;
            break;
        case "Weakest":
            unit = 20;
            break;
        case "Disabled":
            unit = 0;
            break;
    }
    return 255 * (unit / 100.0);
}
