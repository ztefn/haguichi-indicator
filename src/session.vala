/*
 * This file is part of Haguichi, a graphical frontend for Hamachi.
 * Copyright (C) 2007-2015 Stephen Brandt <stephen@stephenbrandt.com>
 *
 * Haguichi is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published
 * by the Free Software Foundation, either version 3 of the License,
 * or (at your option) any later version.
 */

[DBus (name = "apps.Haguichi")]
public interface AppSession : Object
{
    public abstract void show()           throws IOError;
    public abstract void hide()           throws IOError;
    public abstract void start_hamachi()  throws IOError;
    public abstract void stop_hamachi()   throws IOError;
    public abstract void change_nick()    throws IOError;
    public abstract void join_network()   throws IOError;
    public abstract void create_network() throws IOError;
    public abstract void information()    throws IOError;
    public abstract void preferences()    throws IOError;
    public abstract void about()          throws IOError;
    public abstract void quit_app()       throws IOError;
    
    public signal void mode_changed (string mode);
    public signal void modality_changed (bool modal);
    public signal void visibility_changed (bool visible);
    public signal void quitted ();
}
