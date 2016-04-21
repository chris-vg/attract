/*

FLAT BLUE - Aspect and rotation aware layout for Attract-Mode Front-End

graphic design by: www.ClanLogoDesign.com
layout scripting by: Chris Van Graas
shader code by: Timothy Lottes, LUKE NUKEM, krischan, Chris Van Graas

*/

class UserConfig </ help="FLAT BLUE - Aspect and rotation aware layout for Attract-Mode Front-End." />
{
    </ label="Layout rotation", help="Set the rotation of the layout to suit your monitor.", options="None, Right, Flip, Left", order=1 />
    layout_rotation = "None";

    </ label="Menu artwork", help="Set menu panel artwork type.", options="Snap, Title", order=2 />
    menu_art_type = "Snap";

    </ label="Menu videos", help="Toggle video playback for menu artwork.", options="Enabled, Disabled", order=3 />
    menu_video = "Disabled";

    </ label="Wheel logo", help="Toggle display of game wheel logos.", options="Enabled, Disabled", order=4 />
    show_wheel = "Enabled";

    </ label="Game info 1", help="Set game information to display in info panel.", options="Year, ROM Name", order=5 />
    game_info_1 = "Year";

    </ label="Game info 2", help="Set game information to display in info panel.", options="Manufacturer, Played Count", order=6 />
    game_info_2 = "Manufacturer";

    </ label="Scanline overlay", help="Set scanline overlay effect strength. Only used if CRT Shader is disabled.", options="Strongest, Strong, Medium, Weak, Weakest, Disabled", order=7 />
    scanline_strength = "Weakest";

    </ label="Panel shadows", help="Set menu and information panel shadow effect strength.", options="Strongest, Strong, Medium, Weak, Weakest, Disabled", order=8 />
    shadow_strength = "Medium";

    </ label="CRT Shader", help="Toggle CRT Shader for snaps. Disabled for resolutions under 1024x768.", options="Enabled, Disabled", order=9 />
    crt_shader = "Disabled";

    </ label="Shader resolution", help="Set the shader resolution. Use Full for low res videos (under 640x480), otherwise use Half", options="Full, Half", order=10 />
    shader_res = "Half";

    </ label="Options menu button", help="Set the button/key to use for opening the layout Options menu.", is_input=true, order=11 />
    options_button = "Num1";

    </ label="History.dat", help="Toggle History.dat viewer in Options menu.", options="Enabled, Disabled", order=12 />
    options_history = "Disabled";

    </ label="MAMEInfo.dat", help="Toggle MameInfo.dat in Options menu.", options="Enabled, Disabled", order=13 />
    options_mameinfo = "Disabled";

    </ label="History.dat file path", help="The full path to the history.dat file.", order=14 />
    historydat_path="$HOME/history.dat";

    </ label="MAMEInfo.dat file path", help="The full path to the MAMEInfo.dat file", order=15 />
    mameinfodat_path="$HOME/mameinfo.dat";

    </ label="Index Clones", help="Set whether entries for clones should be included in the index. Enabling this will make the index significantly larger.", order=16, options="Yes,No" />
    index_clones="No";

    </ label="Generate Indexes", help="Generate indexes for History.dat and/or MAMEInfo.dat. (this can take some time)", is_function=true, order=17 />
    generate="generate_indexes";

}

const LAYOUT_NAME = "FLAT BLUE";
const VERSION = 0.9997;
const DEBUG = false;

fe.load_module("pan-and-scan");
fe.load_module("submenu");
fe.do_nut("scripts/helperfunctions.nut");
fe.do_nut("scripts/vectors.nut");
fe.do_nut("scripts/layoutsettings.nut");
fe.do_nut("scripts/background.nut");
fe.do_nut("scripts/sidebar.nut");
fe.do_nut("scripts/infopanel.nut");
fe.do_nut("scripts/mamedats.nut");
fe.do_nut("scripts/overlaymenu.nut");

local layout = LayoutSettings();

local test_resolution = scalar2();

// test_resolution = scalar2(1920,1080);
// test_resolution = scalar2(1366,768);
// test_resolution = scalar2(1360,768);
// test_resolution = scalar2(1024,576);

// test_resolution = scalar2(1920,1200);
// test_resolution = scalar2(1280,768);
// test_resolution = scalar2(800,480);

// test_resolution = scalar2(1600,1280);
// test_resolution = scalar2(1280,1024);

// test_resolution = scalar2(1600,1200);
// test_resolution = scalar2(1024,768);
// test_resolution = scalar2(800,600);
// test_resolution = scalar2(640,480);
// test_resolution = scalar2(320,240);

// layout.set_layout_dimensions(test_resolution);

layout.initialize();

Background(layout.settings);
sidebar <- SideBar(layout.settings);
InfoPanel(layout.settings);

local overlaymenu = OverlayMenu(layout.settings);

function generate_indexes(config)
{
    overlaymenu.generate_indexes();
}
