/*

FLAT BLUE - Aspect and rotation aware layout for Attract-Mode Front-End

graphic design by: www.ClanLogoDesign.com
layout scripting by: Chris Van Graas
shader code by: Timothy Lottes, LUKE NUKEM, krischan, Chris Van Graas

OverlayMenu class

    constructor(array, array, string, string)
        Creates a custom overlay menu using Attract-Mode's built in system.
        Must provide the following arguments:
            A string array of menu item labels,
            A string array of actions to perform for each item (currently only accepts signals),
            A string containing the keycode for the button to open the menu,
            A string containing the label for the overlay menu.

*/

class OverlayMenu
{
    _items = [];
    _actions = [];
    _button = "";
    _label = "";

    constructor(items, actions, button, label)
    {
        _items = items;
        _actions = actions;
        _button = button;
        _label = label;

        fe.add_ticks_callback(this, "OnTick");
    }

    function OnTick( ttime )
    {
        if (fe.get_input_state(_button))
        {
            local selected = fe.overlay.list_dialog(_items, _label);
            if ((selected < 0) || (selected >= _actions.len()) || (_actions[selected].len() < 1))
                return;

            fe.signal(_actions[selected]);
        }
    }
}