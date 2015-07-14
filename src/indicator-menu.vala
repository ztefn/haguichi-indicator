/*
 * This file is part of Haguichi, a graphical frontend for Hamachi.
 * Copyright (C) 2007-2015 Stephen Brandt <stephen@stephenbrandt.com>
 *
 * Haguichi is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published
 * by the Free Software Foundation, either version 3 of the License,
 * or (at your option) any later version.
 */

using Gtk;

public class IndicatorMenu : Gtk.Menu
{
    private string mode;
    private int icon_num;
    
    private Gtk.CheckMenuItem show_item;
    private Gtk.MenuItem connecting_item;
    private Gtk.MenuItem connect_item;
    private Gtk.MenuItem disconnect_item;
    private Gtk.MenuItem join_item;
    private Gtk.MenuItem create_item;
    private Gtk.MenuItem info_item;
    private Gtk.MenuItem quit_item;
    
    public IndicatorMenu()
    {
        show_item = new CheckMenuItem.with_mnemonic (_("_Show Haguichi"));
        show_item.toggled.connect (() =>
        {
            try
            {
                if (show_item.active)
                {
                    HaguichiIndicator.session.show();
                }
                else
                {
                    HaguichiIndicator.session.hide();
                }
            }
            catch (IOError e)
            {
                stderr.printf (e.message);
            }
        });
        
        connecting_item = new Gtk.MenuItem.with_label ("Connecting");
        connecting_item.sensitive = false;
        
        connect_item = new Gtk.MenuItem.with_mnemonic (_("C_onnect"));
        connect_item.activate.connect (() =>
        {
            try
            {
                HaguichiIndicator.session.start_hamachi();
            }
            catch (IOError e)
            {
                stderr.printf (e.message);
            }
        });
        
        disconnect_item = new Gtk.MenuItem.with_mnemonic (_("_Disconnect"));
        disconnect_item.activate.connect (() =>
        {
            try
            {
                HaguichiIndicator.session.stop_hamachi();
            }
            catch (IOError e)
            {
                stderr.printf (e.message);
            }
        });
        
        join_item = new Gtk.MenuItem.with_mnemonic (_("_Join Network..."));
        join_item.activate.connect (() =>
        {
            try
            {
                HaguichiIndicator.session.join_network();
            }
            catch (IOError e)
            {
                stderr.printf (e.message);
            }
        });
        
        create_item = new Gtk.MenuItem.with_mnemonic (_("_Create Network..."));
        create_item.activate.connect (() =>
        {
            try
            {
                HaguichiIndicator.session.create_network();
            }
            catch (IOError e)
            {
                stderr.printf (e.message);
            }
        });
        
        info_item = new Gtk.MenuItem.with_mnemonic (_("_Information"));
        info_item.activate.connect (() =>
        {
            try
            {
                HaguichiIndicator.session.show();
                HaguichiIndicator.session.information();
            }
            catch (IOError e)
            {
                stderr.printf (e.message);
            }
        });
        
        quit_item = new Gtk.MenuItem.with_mnemonic (_("_Quit"));
        quit_item.activate.connect (() =>
        {
            try
            {
                HaguichiIndicator.session.quit_app();
            }
            catch (IOError e)
            {
                stderr.printf (e.message);
            }
        });
        
        
        add (show_item);
        add (new SeparatorMenuItem());
        add (connecting_item);
        add (connect_item);
        add (disconnect_item);
        add (new SeparatorMenuItem());
        add (join_item);
        add (create_item);
        add (new SeparatorMenuItem());
        add (info_item);
        add (new SeparatorMenuItem());
        add (quit_item);
        
        show_all();
        
        HaguichiIndicator.session.mode_changed.connect (set_mode);
        HaguichiIndicator.session.modality_changed.connect (set_modality);
        HaguichiIndicator.session.visibility_changed.connect (set_visibility);
        HaguichiIndicator.session.quitted.connect (() =>
        {
            HaguichiIndicator.session.mode_changed.disconnect (set_mode);
            HaguichiIndicator.session.modality_changed.disconnect (set_modality);
            HaguichiIndicator.session.visibility_changed.disconnect (set_visibility);
            HaguichiIndicator.app.quit();
        });
    }
    
    public void set_visibility (bool visible)
    {
        show_item.active = visible;
    }
    
    public void set_modality (bool modal)
    {
        if (modal)
        {
            show_item.sensitive       = false;
            connect_item.sensitive    = false;
            disconnect_item.sensitive = false;
            join_item.sensitive       = false;
            create_item.sensitive     = false;
            info_item.sensitive       = false;
        }
        else
        {
            show_item.sensitive       = true;
            info_item.sensitive       = true;
            
            set_mode (mode);
        }
    }
    
    private bool switch_icon ()
    {
        if (mode == "Connecting")
        {
            if (icon_num == 0)
            {
                HaguichiIndicator.indicator.icon_name = HaguichiIndicator.icon_connecting1;
                icon_num = 1;
            }
            else if (icon_num == 1)
            {
                HaguichiIndicator.indicator.icon_name = HaguichiIndicator.icon_connecting2;
                icon_num = 2;
            }
            else
            {
                HaguichiIndicator.indicator.icon_name = HaguichiIndicator.icon_connecting3;
                icon_num = 0;
            }
            
            return true;
        }
        else
        {
            return false;
        }
    }
    
    public void set_mode (string _mode)
    {
        mode = _mode;
        icon_num = 0;
        
        switch (mode)
        {
            case "Connecting":
                connect_item.hide();
                connecting_item.show();
                
                GLib.Timeout.add (400, switch_icon);
                break;
                
            case "Connected":
                connecting_item.hide();
                connect_item.hide();
                disconnect_item.show();
                disconnect_item.sensitive = true;
                join_item.sensitive       = true;
                create_item.sensitive     = true;
                info_item.sensitive       = true;
                
                HaguichiIndicator.indicator.icon_name = HaguichiIndicator.icon_connected;
                break;
                
            case "Disconnected":
                connecting_item.hide();
                connect_item.show();
                connect_item.sensitive    = true;
                disconnect_item.hide();
                join_item.sensitive       = false;
                create_item.sensitive     = false;
                info_item.sensitive       = true;
                
                HaguichiIndicator.indicator.icon_name = HaguichiIndicator.icon_disconnected;
                break;
            
            case "Not configured":
                connecting_item.hide();
                connect_item.sensitive    = false;
                disconnect_item.hide();
                join_item.sensitive       = false;
                create_item.sensitive     = false;
                info_item.sensitive       = false;
                
                HaguichiIndicator.indicator.icon_name = HaguichiIndicator.icon_disconnected;
                break;
            
            case "Not installed":
                connecting_item.hide();
                connect_item.sensitive    = false;
                disconnect_item.hide();
                join_item.sensitive       = false;
                create_item.sensitive     = false;
                info_item.sensitive       = false;
                
                HaguichiIndicator.indicator.icon_name = HaguichiIndicator.icon_disconnected;
                break;
        }
    }
}
