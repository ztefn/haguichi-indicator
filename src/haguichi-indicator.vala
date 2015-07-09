/*
 * This file is part of Haguichi, a graphical frontend for Hamachi.
 * Copyright (C) 2007-2015 Stephen Brandt <stephen@stephenbrandt.com>
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
        
        Intl.textdomain ("haguichi");
        
        try
        {
            watch = Bus.watch_name (BusType.SESSION, "apps.Haguichi", BusNameWatcherFlags.AUTO_START, on_name_appeared, on_name_vanished);
            session = Bus.get_proxy_sync (BusType.SESSION, "apps.Haguichi", "/apps/Haguichi");
            
            indicator = new Indicator ("haguichi", "haguichi-disconnected-symbolic", IndicatorCategory.APPLICATION_STATUS);
            indicator.set_menu (new IndicatorMenu());
            indicator.scroll_event.connect ((ind, steps, direction) =>
            {
                try
                {
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
        
        hold(); // Keep this application running without window
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
