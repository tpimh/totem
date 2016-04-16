/*
 * Copyright (C) Dmitry Golovin 2016 <dima@golovin.in>
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU Library General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 51 Franklin Street, Fifth Floor Boston, MA 02110-1301,  USA
 */

using Totem;
using Peas;
using Gtk;

class PlaylistSidebarPlugin: GLib.Object, Peas.Activatable {
    public GLib.Object object { owned get; construct; }

    public Window sidebar { get; set; }

    private Gtk.ListStore playlist_store;
    private TreeView playlist;

    public void activate() {
        Totem.Object t = (Totem.Object)this.object;
        t.file_opened.connect(cb_file_opened);

        playlist_store = new Gtk.ListStore(1, typeof(string));

        var scroll = new ScrolledWindow(null, null);
        playlist = new TreeView.with_model(playlist_store);

        CellRendererText cell = new Gtk.CellRendererText();
        playlist.insert_column_with_attributes(-1, "Title", cell, "text", 0);
        playlist.headers_visible = false;
        playlist.get_selection().mode = SelectionMode.BROWSE;

        scroll.add(playlist);

        sidebar = new Window();
        sidebar.title = "Playlist";
        sidebar.set_default_size(450, 600);
        sidebar.deletable = false;
        sidebar.add(scroll);
        sidebar.show_all();
    }

    public void deactivate() {
        Totem.Object t = (Totem.Object)this.object;
        t.file_opened.disconnect(cb_file_opened);
        sidebar.destroy();
    }

    public void update_state() {
        // nothing to do here
    }

    private void cb_file_opened(string mrl) {
        Totem.Object t = (Totem.Object)this.object;

        uint playlist_length = t.get_playlist_length();

        playlist_store.clear();
        TreeIter iter;
        for (int i = 0; i < playlist_length; i++) {
            playlist_store.append(out iter);
            playlist_store.set(iter, 0, strip_filename(t.get_title_at_playlist_pos(i)));
            if (i == t.get_playlist_pos()) {
                playlist.get_selection().select_path(new TreePath.from_indices(i, -1));
            }
        }
    }

    private string strip_filename(string filename) {
        int last_slash = filename.last_index_of_char('/') + 1;
        int last_dot = filename.last_index_of_char('.');
        if (last_dot == -1) last_dot = filename.length;
        return filename.slice(last_slash, last_dot);
    }
}

[ModuleInit]
public void peas_register_types(TypeModule module) {
    var objmodule = module as ObjectModule;
    objmodule.register_extension_type(typeof(Peas.Activatable), typeof(PlaylistSidebarPlugin));
}
