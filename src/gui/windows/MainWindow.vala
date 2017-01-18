using Konv;
using Konv.Gui.Components;
// using Konv.Core; // Uncomment later once core is ready.

[GtkTemplate (ui="/im/konv/desktop/interfaces/windows/MainWindow.ui")]
public class Konv.Gui.Windows.MainWindow : Gtk.ApplicationWindow {
  [GtkChild] private Gtk.Box box_left_side;
  [GtkChild] private Gtk.Box box_right_side;
  
  private Konv.Gui.Components.TabNavbar navbar { get; set; }

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
    
    this.navbar = new Konv.Gui.Components.TabNavbar ();
    
    Gtk.Label profile_content = new Gtk.Label.with_mnemonic ("This is a test tab.");
    Gtk.Label logo_content = new Gtk.Label.with_mnemonic ("So much swag you'd think you're SkyzohKey !");    
    Gtk.Label settings_content = new Gtk.Label.with_mnemonic ("This should allow to view settings.");
    
    this.navbar.add_tab ("Profile", profile_content, "view-list-symbolic");
    this.navbar.add_tab ("Konv logo", logo_content, "user-status-pending-symbolic");
    this.navbar.add_tab ("Settings", settings_content, "open-menu-symbolic");
    
    this.box_left_side.pack_start (navbar, true, true, 0);
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
