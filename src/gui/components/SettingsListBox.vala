/**
* Copyright (c) 2017 SkyzohKey <skyzohkey@konv.im>
*
* MIT License
*
* Permission is hereby granted, free of charge, to any person obtaining
* a copy of this software and associated documentation files (the
* "Software"), to deal in the Software without restriction, including
* without limitation the rights to use, copy, modify, merge, publish,
* distribute, sublicense, and/or sell copies of the Software, and to
* permit persons to whom the Software is furnished to do so, subject to
* the following conditions:
*
* The above copyright notice and this permission notice shall be
* included in all copies or substantial portions of the Software.
*
* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
* EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
* MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
* NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
* LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
* OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
* WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
**/

using Konv;
using Gtk;

namespace Konv.Gui.Components {

  public class SettingsListBox: Gtk.Box {

    public Gtk.Box scrolled_box;
    public Gtk.ListBox listbox;

    public SettingsListBox () {
      this.set_orientation (Gtk.Orientation.HORIZONTAL);

      Gtk.ScrolledWindow scroll = new Gtk.ScrolledWindow (null, null);
      scroll.set_size_request (400, 1);
      this.pack_start (scroll, true, true, 0);

      Gtk.Box hbox = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 0);
      scroll.add (hbox);

      this.scrolled_box = new Gtk.Box (Gtk.Orientation.VERTICAL, 0);
      this.scrolled_box.set_size_request (400, 1);
      hbox.pack_start (this.scrolled_box, true, true, 0);
    }

    public Gtk.Box new_section (string name) {
      Gtk.Box box = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 0);
      this.scrolled_box.pack_start (box, false, false, 5);

      Gtk.Label label = new Gtk.Label (null);
      label.set_line_wrap (true);
      label.set_markup (@"<b>$name</b>");
      label.set_margin_top (4);
      label.set_margin_start (6);
      box.pack_start (label, false, false, 2);

      this.listbox = new Gtk.ListBox ();
      this.listbox.set_selection_mode (Gtk.SelectionMode.NONE);
      this.scrolled_box.pack_start (this.listbox, false, false, 0);

      return box;
    }

    public Gtk.Box new_row (Gtk.Widget widget, string name, string? help = null) {
      Gtk.ListBoxRow row = new Gtk.ListBoxRow ();
      row.set_size_request (1, 50);
      this.listbox.add (row);

      Gtk.Box box = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 0);
      box.set_border_width (5);
      row.add (box);

      Gtk.Box vbox = new Gtk.Box (Gtk.Orientation.VERTICAL, 0);
      box.pack_start (vbox, false, true, 0);

      Gtk.Label label = new Gtk.Label (name);
      label.set_line_wrap (true);
      label.set_xalign (0);
      vbox.pack_start (label, false, false, 0);

      if (help != null) {
        label = new Gtk.Label (null);
        label.set_xalign (0);
        label.set_sensitive (false);
        label.set_markup (@"<small>$help</small>");
        vbox.pack_start (label, false, false, 0);
      }

      vbox = new Gtk.Box (Gtk.Orientation.VERTICAL, 0);
      vbox.set_center_widget (widget);
      box.pack_end (vbox, false, false, 0);

      return box;
    }
  }
}
