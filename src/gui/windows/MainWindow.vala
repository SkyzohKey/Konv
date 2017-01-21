using Konv;
using Konv.Gui.Components;
// using Konv.Core; // Uncomment later once core is ready.

[GtkTemplate (ui="/im/konv/desktop/interfaces/windows/MainWindow.ui")]
public class Konv.Gui.Windows.MainWindow : Gtk.ApplicationWindow {
  [GtkChild] private Gtk.MenuBar menubar_main;
  [GtkChild] private Gtk.Box box_left_side;
  [GtkChild] private Gtk.Box box_right_side;
  
  private Konv.Gui.Components.HeaderBar header { get; set; }
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
    this.set_default_size (800, 400);
    
    this.header = new Konv.Gui.Components.HeaderBar ();
    this.navbar = new Konv.Gui.Components.TabNavbar ();
    
    Gtk.Label recent_conversations = new Gtk.Label.with_mnemonic ("Recent conversations shows here.");
    Gtk.Label contacts_list = new Gtk.Label.with_mnemonic ("Contact list displays here.");    
    Gtk.Label file_transfers = new Gtk.Label.with_mnemonic ("All file transfers goes here.");
    Gtk.Label missed_calls = new Gtk.Label.with_mnemonic ("Missed calls will be listed here.");
    
    this.navbar.add_tab ("Recent conversations", recent_conversations, "document-open-recent-symbolic");
    this.navbar.add_tab ("Contacts", contacts_list, "system-users-symbolic");
    this.navbar.add_tab ("File transfers", file_transfers, "mail-send-receive-symbolic");
    this.navbar.add_tab ("Missed calls", missed_calls, "call-missed-symbolic");

    this.box_left_side.pack_start (this.header, false, true, 0);
    this.box_left_side.pack_start (this.navbar, true, true, 0);
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
