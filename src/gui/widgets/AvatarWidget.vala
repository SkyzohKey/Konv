/*
 *  Copyright (C) 2015-2017 Granite Developers (https://launchpad.net/granite)
 *
 *  This program or library is free software; you can redistribute it
 *  and/or modify it under the terms of the GNU Lesser General Public
 *  License as published by the Free Software Foundation; either
 *  version 3 of the License, or (at your option) any later version.
 *
 *  This library is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
 *  Lesser General Public License for more details.
 *
 *  You should have received a copy of the GNU Lesser General
 *  Public License along with this library; if not, write to the
 *  Free Software Foundation, Inc., 51 Franklin Street, Fifth Floor,
 *  Boston, MA 02110-1301 USA.
 *
 *  Authored by: Felipe Escoto <felescoto95@hotmail.com>, Rico Tzschichholz <ricotz@ubuntu.com>
 */

/**
 * The Avatar widget allowes to theme and crop images with css BORDER_RADIUS
 * property in the .avatar class.
 */
public class Konv.Gui.Widgets.Avatar : Gtk.EventBox {
    private const string DEFAULT_ICON = "avatar-default";
    private const string DEFAULT_STYLE = "ic-avatar";
    private const int EXTRA_MARGIN = 4;
    private const int BORDER_RADIUS = 100;
    private bool draw_theme_background = true;

    public Gdk.Pixbuf? pixbuf { get; set; }
    public bool border { get; set; default = true; }

    private Gdk.RGBA status_color { get; set; default = Gdk.RGBA (){
      red = 0.0,
      green = 0.9,
      blue = 0.4,
      alpha = 0.7 };
    }

    /**
     * Makes new Avatar widget
     */
    public Avatar () {
      this.set_status ("idle");
    }

    /**
    * Creates a new Avatar from the speficied pixbuf
    *
    * @param pixbuf image to be used
    */
    public Avatar.from_pixbuf (Gdk.Pixbuf pixbuf) {
        Object (pixbuf: pixbuf);
    }

    /**
    * Creates a new Avatar from the speficied resource
    *
    * @param path resource image to be used
    */
    public Avatar.from_resource (string path, int width, int height) {
        Object (pixbuf: new Gdk.Pixbuf.from_resource_at_scale (path, width, height, false));
    }

    /**
     * Creates a new Avatar from the speficied filepath and icon size
     *
     * @param filepath image to be used
     * @param size to scale the image
     */
    public Avatar.from_file (string filepath, int icon_size) {
        try {
            var size = icon_size * this.get_style_context ().get_scale ();
            pixbuf = new Gdk.Pixbuf.from_file_at_size (filepath, size - 1, size - 1);
        } catch (Error e) {
            show_default (icon_size);
        }
    }

    /**
     * Creates a new Avatar with the default icon from theme without applying the css style
     *
     * @param icon_size size of the icon to be loaded
     */
    public Avatar.with_default_icon (int icon_size) {
        show_default (icon_size);
    }

    construct {
        valign = Gtk.Align.CENTER;
        halign = Gtk.Align.CENTER;
        visible_window = false;
        var style_context = this.get_style_context ();
        style_context.add_class (DEFAULT_STYLE);

        notify["pixbuf"].connect (refresh_size_request);
    }

    ~Avatar () {
        notify["pixbuf"].disconnect (refresh_size_request);
    }

    public void set_status (string status) {
      if (status == "online") {
        this.status_color = { 0.29, 0.68, 0.31, 1 };
        this.set_tooltip_text (_("Online"));
      } else if (status == "idle") {
        this.status_color = { 1.00, 0.92, 0.23, 1 };
        this.set_tooltip_text (_("Away"));
      } else if (status == "busy") {
        this.status_color = { 0.95, 0.26, 0.21, 1 };
        this.set_tooltip_text (_("Busy"));
      } else {
        this.status_color = { 0.61, 0.61, 0.61, 1 };
        this.set_tooltip_text (_("Offline"));
      }

      queue_draw ();
    }

    private void refresh_size_request () {
        if (pixbuf != null) {
            var scale_factor = this.get_style_context ().get_scale ();
            set_size_request ((pixbuf.width - EXTRA_MARGIN / 2) / scale_factor + EXTRA_MARGIN * 2, (pixbuf.height - EXTRA_MARGIN / 2) / scale_factor + EXTRA_MARGIN * 2);
            draw_theme_background = true;
        } else {
            set_size_request (0, 0);
        }

        queue_draw ();
    }

    /**
     * Load the default avatar icon from theme into the widget without applying the css style
     *
     * @param icon_size size of the icon to be loaded
     */
    public void show_default (int icon_size) {
        Gtk.IconTheme icon_theme = Gtk.IconTheme.get_default ();
        try {
            pixbuf = icon_theme.load_icon_for_scale (DEFAULT_ICON, icon_size, this.get_style_context ().get_scale (), 0);
        } catch (Error e) {
            stderr.printf ("Error setting default avatar icon: %s ", e.message);
        }

        draw_theme_background = false;
    }

    public override bool draw (Cairo.Context cr) {
        if (pixbuf == null) {
            return base.draw (cr);
        }

        unowned Gtk.StyleContext style_context = this.get_style_context ();
        var width = get_allocated_width () - EXTRA_MARGIN * 2;
        var height = get_allocated_height () - EXTRA_MARGIN * 2;
        var scale_factor = style_context.get_scale ();

        if (draw_theme_background) {
            var border_radius = BORDER_RADIUS;
            var crop_radius = int.min (width / 2, border_radius * width / 100);

            Utils.cairo_rounded_rectangle (cr, EXTRA_MARGIN / 2 + 2, EXTRA_MARGIN / 2 + 2, width + EXTRA_MARGIN - 2, height + EXTRA_MARGIN - 2, crop_radius);
            cr.set_source_rgba (
              this.status_color.red,
              this.status_color.green,
              this.status_color.blue,
              this.status_color.alpha
            );
            cr.fill_preserve ();
            cr.save ();
            #if SYSTEM_OSX
            cr.scale (1.0 / scale_factor * 2.0, 1.0 / scale_factor * 2.0);
            #else
            cr.scale (1.0 / scale_factor, 1.0 / scale_factor);
            #endif
            cr.new_path ();
            Utils.cairo_rounded_rectangle (cr, EXTRA_MARGIN + 2, EXTRA_MARGIN + 2, width - 2, height - 2, crop_radius);
            Gdk.cairo_set_source_pixbuf (cr, pixbuf, EXTRA_MARGIN * scale_factor, EXTRA_MARGIN * scale_factor);
            cr.fill_preserve ();
            cr.restore ();
            style_context.render_background (cr, EXTRA_MARGIN + 1, EXTRA_MARGIN + 1, width - 1, height - 1);
            style_context.render_frame (cr, 0, 0, width, height);

        } else {
            cr.save ();
            #if SYSTEM_OSX
            cr.scale (1.0 / scale_factor * 2.0, 1.0 / scale_factor * 2.0);
            #else
            cr.scale (1.0 / scale_factor, 1.0 / scale_factor);
            #endif

            style_context.render_icon (cr, pixbuf, EXTRA_MARGIN, EXTRA_MARGIN);
            cr.restore ();
        }

        return Gdk.EVENT_STOP;
    }
}
