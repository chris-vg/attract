/*

FLAT BLUE - Aspect and rotation aware layout for Attract-Mode Front-End

graphic design by: www.ClanLogoDesign.com
layout scripting by: Chris Van Graas
shader code by: Timothy Lottes, LUKE NUKEM, krischan, Chris Van Graas

MAMEDatViewer class

based on History.dat plugin

*/

class MAMEDatViewer extends SubMenu
{
    dat_path = null;
    idx_path = null;
    tag = null;

    surf = null;
    surf_art = null;
    m_text = null;
    m_curr_rom = null;
    next_ln_overflow = null;
    loaded_idx = null;

    settings = null;

    constructor(layout_settings)
    {
        base.constructor("");

        settings = layout_settings.mamedats;

        next_ln_overflow=""; // used by the get_next_ln() function
        loaded_idx = {};
        m_curr_rom = "";

        draw();
    }

    function draw()
    {
        local text_width = round(fe.layout.width / PHI);
        local flyer_width = fe.layout.width - text_width;

        surf = fe.add_surface(fe.layout.width, fe.layout.height);
        local surf_bg = surf.add_image("images/pixel.png", 0, 0, surf.width, surf.height);
        surf_bg.set_rgb(0, 0, 0);
        surf_bg.alpha = 220;

        surf_art = PanAndScanArt("flyer", 50, 50, flyer_width - 100, surf.height - 100);
        surf_art.set_fit_or_fill("fill");
        surf_art.set_anchor(::Anchor.Center);
        surf_art.set_zoom(4.5, 0.00008);
        surf_art.set_animate(::AnimateType.Bounce, 0.07, 0.07)
        surf_art.set_randomize_on_transition(true);
        surf_art.set_start_scale(1.15);

        m_text = surf.add_text( "", flyer_width, 0, text_width, fe.layout.height );
        m_text.first_line_hint = 0; // enables word wrapping
        m_text.charsize = fe.layout.height / 30;
        m_text.align = Align.Left;
        surf_art.visible = false;
        surf.visible=false;
    }

    function show(flag)
    {
        if (flag)
        {
            m_up = true;
            fe.add_signal_handler(this, "on_signal");
            on_show();
        }
        else
        {
            m_up = false;
            fe.remove_signal_handler(this, "on_signal");
            on_hide();
        }
    }

    function on_show()
    {
        local sys = split( fe.game_info( Info.System ), ";" );
        local rom = fe.game_info( Info.Name );

        //
        // we only go to the trouble of loading the entry if
        // it is not already currently loaded
        //
        if ( m_curr_rom != rom )
        {
            m_curr_rom = rom;
            local alt = fe.game_info( Info.AltRomname );
            local cloneof = fe.game_info( Info.CloneOf );

            local lookup = get_offset(sys, rom, alt, cloneof);

            if ( lookup >= 0 )
            {
                m_text.first_line_hint = 0;
                m_text.msg = get_entry(lookup);
            }
            else
            {
                if ( lookup == -2 )
                    m_text.msg = "Index file not found.  Try generating an index from the history.dat plug-in configuration menu.";
                else    
                    m_text.msg = "Unable to locate: "
                        + rom;
            }
        }

        surf.visible = true;
        surf_art.visible = true;
    }

    function on_hide()
    {
        surf_art.visible = false;
        surf.visible = false;
    }

    function on_scroll_up()
    {
        m_text.first_line_hint--;
    }

    function on_scroll_down()
    {
        m_text.first_line_hint++;
    }

    //
    // Return the text for the history.dat entry after the given offset
    //
    function get_entry(offset)
    {
        local datfile;
        datfile = file(fe.path_expand(dat_path), "rb");
        datfile.seek( offset );

        local entry = "\n\n"; // a bit of space to start
        local open_entry = false;

        while ( !datfile.eos() )
        {
            local blb = datfile.readblob( READ_BLOCK_SIZE );
            while ( !blb.eos() )
            {
                local line = get_next_ln( blb );

                if ( !open_entry )
                {
                    //
                    // forward to the $bio or $mame tag
                    //
                    if (( line.len() < 1 )
                            || (  line != tag ))
                        continue;

                    open_entry = true;
                }
                else
                {
                    if ( line == "$end" )
                    {
                        entry += "\n\n";
                        return entry;
                    }
                    else if (!(blb.eos() && (line == "" ))) entry += line + "\n";
                }
            }
        }
        return entry;
    }

    //
    // Load the index for the given system if it is not already loaded
    //
    function load_index(sys)
    {
        // check if system index already loaded
        //
        if (loaded_idx.rawin(sys)) return true;

        local idx;
        try
        {
            idx = file(idx_path + sys + ".idx", "r");
        }
        catch(e)
        {
            loaded_idx[sys] <- null;
            return false;
        }

        loaded_idx[sys] <- {};

        while (!idx.eos())
        {
            local blb = idx.readblob(READ_BLOCK_SIZE);
            while (!blb.eos())
            {
                local line = get_next_ln(blb);
                local bits = split(line, ";");
                if (bits.len() > 0) (loaded_idx[sys])[bits[0]] <- bits[1].tointeger();
            }
        }
        return true;
    }

    //
    // Return the index the history.dat entry for the specified system and rom
    //
    function get_offset(sys, rom, alt, cloneof)
    {
        foreach (s in sys)
        {
            if ((load_index(s)) && (loaded_idx[s] != null))
            {
                if (loaded_idx[s].rawin(rom)) return (loaded_idx[s])[rom];
                else if ((alt.len() > 0) && (loaded_idx[s].rawin(alt))) return (loaded_idx[s])[alt];
                else if ((cloneof.len() > 0) && (loaded_idx[s].rawin(cloneof))) return (loaded_idx[s])[cloneof];
            }
        }
        if ((sys.len() != 1) || (sys[0] != "info")) return get_offset(["info"], rom, alt, cloneof);
        return -1;
    }
}

class HistoryViewer extends MAMEDatViewer
{
    constructor(layout_settings)
    {
        base.constructor(layout_settings)
        dat_path = settings.historydat_path;
        idx_path = FeConfigDirectory + "history.idx/";
        tag = "$bio";
    }
}

class MAMEInfoViewer extends MAMEDatViewer
{
    constructor(layout_settings)
    {
        base.constructor(layout_settings)
        dat_path = settings.mameinfodat_path;
        idx_path = FeConfigDirectory + "mameinfo.idx/";
        tag = "$mame";
    }
}
