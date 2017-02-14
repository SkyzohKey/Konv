using Konv;
using Gtk;

namespace Konv.Gui.Components {

  [GtkTemplate (ui = "/im/konv/client/interfaces/components/HeaderBar.ui")]
  public class HeaderBar : Gtk.Box {

    [GtkChild] public Gtk.Button button_profile;
    [GtkChild] private Gtk.Label label_profile_name;
    [GtkChild] private Gtk.Label label_profile_status;
    [GtkChild] private Gtk.Image image_avatar;
    [GtkChild] private Gtk.Image image_status;

    /**
    * @constructor HeaderBar - The HeaderBar component constructor.
    **/
    public HeaderBar () {
      this.init_widgets ();
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
  }
}
