using Konv;
using Gtk;

namespace Konv.Gui.Components {
  public class TabContainer : Gtk.Box {
    public string id { get; private set; default = ""; }
    public string title { get; set; default = ""; }
    public string icon_name { get; set; default = ""; }

    public TabContainer (string id, Gtk.Orientation orientation) {
      this.id = id;
      this.orientation = orientation;
      this.spacing = 0;
    }
  }
}
