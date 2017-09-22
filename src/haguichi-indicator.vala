/*
 * This file is part of Haguichi, a graphical frontend for Hamachi.
 * Copyright (C) 2007-2017 Stephen Brandt <stephen@stephenbrandt.com>
 *
 * Haguichi is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published
 * by the Free Software Foundation, either version 3 of the License,
 * or (at your option) any later version.
 */

using AppIndicator;
using Gtk;

class HaguichiIndicator : Gtk.Application
{
    public static Gtk.Application app;
    public static Indicator indicator;
    public static AppSession session;
    
    public static string current_desktop;
    
    public static string icon_connected    = "haguichi-connected";
    public static string icon_connecting1  = "haguichi-connecting-1";
    public static string icon_connecting2  = "haguichi-connecting-2";
    public static string icon_connecting3  = "haguichi-connecting-3";
    public static string icon_disconnected = "haguichi-disconnected";
    
    private static uint watch;
    
    public HaguichiIndicator ()
    {
        Object (application_id: "apps.Haguichi.Indicator", flags: ApplicationFlags.FLAGS_NONE);
    }
    
    public override void activate ()
    {
        // Nothing to do
    }
    
    public override void startup ()
    {
        base.startup();
        
        current_desktop = Environment.get_variable ("XDG_CURRENT_DESKTOP");
        
        // Only on specific desktops we use symbolic icons
        if ((current_desktop.contains ("GNOME")) ||
            (current_desktop == "Pantheon"))
        {
            string postfix = "-symbolic";
            
            icon_connected    += postfix;
            icon_connecting1  += postfix;
            icon_connecting2  += postfix;
            icon_connecting3  += postfix;
            icon_disconnected += postfix;
        }
        
        try
        {
            watch = Bus.watch_name (BusType.SESSION, "apps.Haguichi", BusNameWatcherFlags.AUTO_START, on_name_appeared, on_name_vanished);
            session = Bus.get_proxy_sync (BusType.SESSION, "apps.Haguichi", "/apps/Haguichi");
            
            IndicatorMenu menu = new IndicatorMenu();
            
            indicator = new Indicator ("haguichi", icon_disconnected, IndicatorCategory.APPLICATION_STATUS);
            indicator.set_title ("Haguichi");
            indicator.set_menu (menu);
            indicator.scroll_event.connect ((ind, steps, direction) =>
            {
                // Never hide the main window when a modal dialog is being shown
                if (menu.modal == true)
                {
                    return;
                }
                
                try
                {
                    // Show the main window when scrolling up and hide it when scrolling down
                    if (direction == Gdk.ScrollDirection.UP)
                    {
                        session.show();
                    }
                    else if (direction == Gdk.ScrollDirection.DOWN)
                    {
                        session.hide();
                    }
                }
                catch (IOError e)
                {
                    stderr.printf (e.message);
                }
            });
        }
        catch (IOError e)
        {
            stderr.printf (e.message);
        }
        
        // Keep this application running without window
        hold();
    }
    
    static int main (string[] args)
    {
        app = new HaguichiIndicator();
        return app.run();
    }

    private void on_name_appeared (DBusConnection conn, string name)
    {
        indicator.set_status (IndicatorStatus.ACTIVE);
    }

    private void on_name_vanished (DBusConnection conn, string name)
    {
        indicator.set_status (IndicatorStatus.PASSIVE);
    }
}
