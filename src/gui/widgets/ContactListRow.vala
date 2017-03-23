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

namespace Konv.Gui.Widgets {

  [GtkTemplate (ui="/im/konv/client/interfaces/widgets/ContactListRow.ui")]
  public class ContactListRow : Gtk.EventBox {

    [GtkChild] private Gtk.Box box_avatar;
    [GtkChild] private Gtk.Label name;
    [GtkChild] private Gtk.Label status_message;
    [GtkChild] private Gtk.Revealer revealer_unread;
    [GtkChild] private Gtk.Label unread_count;
    [GtkChild] private Gtk.Label secondary_text;

    public Avatar avatar;
    public int count;
    public string second_text;

    public ContactListRow (string name, string status_message, string avatar, string status) {
      this.name.set_text (name);
      this.status_message.set_text (status_message);

      this.avatar = new Avatar.from_resource (avatar, 36, 36);
      this.avatar.set_status (status);
      this.box_avatar.pack_start (this.avatar);

      this.remove_second_text ();
      this.remove_unread_count ();

      this.connect_signals ();
    }

    private void connect_signals () {
      this.notify["count"].connect ((o, p) => {
        this.set_unread_count (this.count);
      });

      this.notify["second-text"].connect ((o, p) => {
        this.set_second_text (this.second_text);
      });
    }

    public void set_second_text (string text) {
      this.second_text = text;
      this.secondary_text.set_text (this.second_text);
      this.secondary_text.show ();
    }

    public void remove_second_text () {
      this.secondary_text.visible = false;
    }

    public void set_unread_count (int count) {
      this.count = count;
      this.unread_count.set_text ("%d".printf (this.count));

      if (this.revealer_unread.visible == false) {
        Idle.add (() => { // Avoid issues with animations/transitions.
          this.revealer_unread.show ();
          this.revealer_unread.reveal_child = true;
          return false;
        });
      }
    }

    public void remove_unread_count () {
      Idle.add (() => { // Avoid issues with animations/transitions.
        this.revealer_unread.reveal_child = false;
        this.revealer_unread.hide ();
        return false;
      });
    }
  }
}
