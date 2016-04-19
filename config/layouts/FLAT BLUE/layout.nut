/*

FLAT BLUE - Aspect and rotation aware layout for Attract-Mode Front-End

graphic design by: www.ClanLogoDesign.com
layout scripting by: Chris Van Graas
shader code by: Timothy Lottes, LUKE NUKEM, krischan, Chris Van Graas

*/

class UserConfig </ help="FLAT BLUE - Aspect and rotation aware layout for Attract-Mode Front-End." />
{
    </ label="Layout rotation", help="Set the rotation of the layout to suit your monitor.  Default is None.", options="None, Right, Flip, Left", order=1 />
    layout_rotation = "None";

    </ label="Menu artwork", help="Set menu panel artwork type.  Default is Snap.\nNOTE: Configure artwork types in emulator settings.", options="Snap, Title", order=2 />
    menu_art_type = "Snap";

    </ label="Menu videos", help="Toggle video playback for menu artwork.  Default is Disabled.", options="Enabled, Disabled", order=3 />
    menu_video = "Disabled";

    </ label="Game info 1", help="Set game information to display in info panel.  Default is Year.", options="Year, ROM Name", order=4 />
    game_info_1 = "Year";

    </ label="Game info 2", help="Set game information to display in info panel.  Default is Manufacturer.", options="Manufacturer, Played Count", order=5 />
    game_info_2 = "Manufacturer";

    </ label="Scanline overlay", help="Set scanline overlay effect strength. Default is Weakest.\nNOTE: Only used if CRT Shader is disabled.", options="Strongest, Strong, Medium, Weak, Weakest, Disabled", order=6 />
    scanline_strength = "Weakest";

    </ label="Panel shadows", help="Set menu and information panel shadow effect strength.  Default is Medium.", options="Strongest, Strong, Medium, Weak, Weakest, Disabled", order=7 />
    shadow_strength = "Medium";

    </ label="CRT Shader", help="Toggle CRT Shader for snaps.  Default is Disabled.\nNOTE: Requires GPU that supports pixel shaders.  Disabled for resolutions under 1024x768.", options="Enabled, Disabled", order=8 />
    crt_shader = "Disabled";

    </ label="Shader resolution", help="Set the shader resolution.  Full works best with low resolution videos (under 640x480).  Half works best with high resolution (640x480 and above).", options="Full, Half", order=9 />
    shader_res = "Half";

    </ label="Options menu button", help="Set the button/key to use for opening the layout Options menu.  Default is 1.", is_input=true, order=10 />
    options_button = "Num1";

    </ label="Show wheel logo", help="Toggle game wheel logos.  Default is Yes.", options="Yes, No", order=11 />
    show_wheel = "Yes";
}

fe.load_module("preserve-art");
fe.do_nut("scripts/helperfunctions.nut");
fe.do_nut("scripts/vectors.nut");
fe.do_nut("scripts/layoutsettings.nut");
fe.do_nut("scripts/background.nut");
fe.do_nut("scripts/sidebar.nut");
fe.do_nut("scripts/infopanel.nut");
fe.do_nut("scripts/overlaymenu.nut");

const LAYOUT_NAME = "FLAT BLUE";
const VERSION = 0.9995;
const DEBUG = false;

local layout = LayoutSettings();
local options = null;

function init_options_menu()
{
    local options_items = [];
    options_items.append("Toggle favourite");
    options_items.append("Filters menu");
    options_items.append("Displays menu");
    options_items.append("Toggle audio mute");
    options_items.append("Enable screensaver");
    options_items.append("Configuration");
    options_items.append("Exit Attract-Mode");

    local options_actions = [];
    options_actions.append("add_favourite");
    options_actions.append("filters_menu");
    options_actions.append("displays_menu");
    options_actions.append("toggle_mute");
    options_actions.append("screen_saver");
    options_actions.append("configure");
    options_actions.append("exit_no_menu");

    local options_label = "Options Menu";

    local options_button = layout.get_user_config("options_button");
    options = OverlayMenu(options_items, options_actions, options_button, options_label);
}

function main()
{
    layout.initialize();

    log(format("layout width:    %d", layout.get_layout_width()));
    log(format("layout height:   %d", layout.get_layout_height()));
    log(format("aspect ratio:    %d:%d (%f:1)", layout.get_layout_aspect_ratio_width(), layout.get_layout_aspect_ratio_height(), layout.get_layout_aspect_ratio_float()));
    log(format("layout rotation: %s", layout.get_layout_rotation_name()));
    log(format("lowres:          %s", layout.get_lowres_flag().tostring()));

    Background(layout.settings);
    SideBar(layout.settings);
    InfoPanel(layout.settings);

    init_options_menu();
}

local test_resolution = scalar2();

// test_resolution = scalar2(1920, 1080);
// test_resolution = scalar2(1366, 768);
// test_resolution = scalar2(1360, 768);
// test_resolution = scalar2(1024, 576);

// test_resolution = scalar2(1920, 1200);
// test_resolution = scalar2(1280, 768);
// test_resolution = scalar2(800, 480);

// test_resolution = scalar2(1600, 1280);
// test_resolution = scalar2(1280, 1024);

// test_resolution = scalar2(1600, 1200);
// test_resolution = scalar2(1024, 768);
// test_resolution = scalar2(800, 600);
// test_resolution = scalar2(640, 480);
// test_resolution = scalar2(320, 240);

// layout.set_layout_dimensions(test_resolution);

main()
