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

  [GtkTemplate (ui="/im/konv/client/interfaces/widgets/WelcomeView.ui")]
  public class WelcomeView : Gtk.Box {

    // Welcome screen.
    [GtkChild] private Gtk.Label label_welcome_user;
    [GtkChild] private Gtk.Label label_welcome_help;
    [GtkChild] private Gtk.Image image_left_arrow;

    // Online contacts.
    [GtkChild] private Gtk.Box box_online_contacts;

    private string user_name { get; private set; default = ""; }
    private string welcome_text { get; private set; default = ""; }

    public WelcomeView (string user_name) {
      this.user_name = user_name;
      this.welcome_text = this.label_welcome_user.label;

      this.init_widgets ();
      this.connect_signals ();
    }

    private void init_widgets () {
      this.set_welcome_sentence ();
      this.set_arrow_accent ();
      this.init_online_contacts ();
    }

    private void connect_signals () {
      Gtk.Settings.get_default ().notify["gtk-application-prefer-dark-theme"].connect ((o, p) => {
        this.set_arrow_accent ();
      });
    }

    public void set_arrow_accent () {
      if (Gtk.Settings.get_default ().gtk_application_prefer_dark_theme == true) {
        this.image_left_arrow.set_from_resource (@"$(Konv.Constants.RES_PATH)/pixmaps/left-arrow-white.svg");
      } else {
        this.image_left_arrow.set_from_resource (@"$(Konv.Constants.RES_PATH)/pixmaps/left-arrow-dark.svg");
      }
    }

    public void set_welcome_sentence () {
      string welcome = this.welcome_text;
      this.label_welcome_user.set_text (welcome.printf (this.user_name));
    }

    public void init_online_contacts () {
      // Clear the online contacts.
      List<Gtk.Widget> contacts = this.box_online_contacts.get_children ();
      foreach (Gtk.Widget item in contacts) {
        this.box_online_contacts.remove (item);
      }

      ContactPreview prev = new ContactPreview ("Dumby", @"$(Konv.Constants.RES_PATH)/pixmaps/tmp/gun.png", "online");
      this.box_online_contacts.pack_start (prev, true, true, 0);

      prev = new ContactPreview ("Lil Wayne", @"$(Konv.Constants.RES_PATH)/pixmaps/tmp/lil-wayne.jpg", "idle");
      this.box_online_contacts.pack_start (prev, true, true, 0);

      prev = new ContactPreview ("Rihanna", @"$(Konv.Constants.RES_PATH)/pixmaps/tmp/rihanna.jpg", "busy");
      this.box_online_contacts.pack_start (prev, true, true, 0);

      prev = new ContactPreview ("The Rock", @"$(Konv.Constants.RES_PATH)/pixmaps/tmp/the-rock.jpg", "busy");
      this.box_online_contacts.pack_start (prev, true, true, 0);
    }
  }
}
