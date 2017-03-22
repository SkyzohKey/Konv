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
  public class ContactListRow : Gtk.Box {

    [GtkChild] private Gtk.Box box_avatar;
    [GtkChild] private Gtk.Label name;
    [GtkChild] private Gtk.Label status_message;
    [GtkChild] private Gtk.Box box_unread;
    [GtkChild] private Gtk.Label unread_count;

    private Avatar avatar;

    public ContactListRow (string name, string status_message, string avatar) {
      this.name.set_text (name);
      this.status_message.set_text (status_message);

      this.avatar = new Avatar.from_resource (avatar, 36, 36);
      this.box_avatar.pack_start (this.avatar);

      //this.status.set_from_resource (@"$(Konv.Constants.RES_PATH)/pixmaps/status/$status.png");
    }
  }
}
