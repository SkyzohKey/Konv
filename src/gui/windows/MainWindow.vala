using Konv;
// using Konv.Core; // Uncomment later once core is ready.

[GtkTemplate (ui="/im/konv/desktop/interfaces/windows/MainWindow.ui")]
public class Konv.Gui.Windows.MainWindow : Gtk.ApplicationWindow {
  [GtkChild] private Gtk.Box box_left_side;
  [GtkChild] private Gtk.Box box_right_side;

  public MainWindow (Gtk.Application app) {
    GLib.Object (application: app);

    this.init_widgets ();
    this.connect_signals ();
    this.run_logic ();
  }

  private void init_widgets () {
    /**
    * TODO: Initialize the window widgets here.
    * @note Widgets properties MUST be defined in the UI file, if possible.
    **/

    this.set_title (Konv.App.NAME + " - v." + Konv.App.VERSION);
    //this.set_default_size (this.width_request, this.height_request);
    this.set_default_size (800, 400);
  }

  private void connect_signals () {
    /**
    * TODO: Connect the window signals here.
    **/
  }

  private void run_logic () {
    /**
    * TODO: Run the window logic here.
    **/

    this.show_all ();
  }
}
