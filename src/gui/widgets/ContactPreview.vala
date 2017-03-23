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

  [GtkTemplate (ui="/im/konv/client/interfaces/widgets/ContactPreview.ui")]
  public class ContactPreview : Gtk.Button {
    [GtkChild] private Gtk.Label name;
    [GtkChild] private Gtk.Box box_avatar;

    private Avatar avatar;

    public ContactPreview (string name, string avatar, string status) {
      this.name.set_text (name);
      this.name.get_style_context ().add_class ("text-little");

      this.avatar = new Avatar.from_resource (avatar, 48, 48);
      this.box_avatar.pack_start (this.avatar);

      this.avatar.set_status (status);
    }
  }
}
