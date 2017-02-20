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

  [GtkTemplate (ui = "/im/konv/client/interfaces/components/HeaderBar.ui")]
  public class HeaderBar : Gtk.Box {

    [GtkChild] private Gtk.Button button_profile;
    [GtkChild] private Gtk.Label label_profile_name;
    [GtkChild] private Gtk.Label label_profile_status;
    [GtkChild] private Gtk.Image image_avatar;
    [GtkChild] private Gtk.Image image_status;

    public signal void clicked ();

    /**
    * @constructor HeaderBar - The HeaderBar component constructor.
    **/
    public HeaderBar () {
      this.init_widgets ();
      this.connect_signals ();
    }

    /**
    * @private init_widgets - Initialize the widgets, only that. KISS.
    **/
    private void init_widgets () {
      /**
      * TODO: Initialize the widgets here.
      * @notes Widgets properties MUST be defined in the UI file, if possible.
      **/

      this.button_profile.get_style_context ().add_class ("no-radius");
      this.button_profile.get_style_context ().add_class ("no-border-bottom");
      this.button_profile.get_style_context ().add_class ("no-borders-horizontal");

      this.image_avatar.set_from_resource (@"$(Konv.Constants.RES_PATH)/pixmaps/avatar.jpg");
      this.image_status.set_from_resource (@"$(Konv.Constants.RES_PATH)/pixmaps/status/online.png");
    }

    private void connect_signals () {
      this.button_profile.clicked.connect (() => { this.clicked (); });
    }
  }
}
