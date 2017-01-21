using Konv;
using Gtk;

namespace Konv.Gui.Components {

  [GtkTemplate (ui = "/im/konv/desktop/interfaces/components/HeaderBar.ui")]
  public class HeaderBar : Gtk.Box {
  
    [GtkChild] private Gtk.Button button_profile;
    [GtkChild] private Gtk.Button button_status;
    [GtkChild] private Gtk.Image image_button_status;
    [GtkChild] private Gtk.Label label_profile_name;
    [GtkChild] private Gtk.Label label_profile_status;
  
    public HeaderBar () {
      
    }
  }
}
