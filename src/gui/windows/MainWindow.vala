using GLib;
using Gtk;
using Konv;
using Konv.Gui.Components;
// using Konv.Core; // Uncomment later once core is ready.

[GtkTemplate (ui="/im/konv/client/interfaces/windows/MainWindow.ui")]
public class Konv.Gui.Windows.MainWindow : Gtk.ApplicationWindow {
  // Application menu.
  [GtkChild] private Gtk.MenuBar menubar_main;
    // File menu.
    [GtkChild] private Gtk.MenuItem menuitem_file;
    [GtkChild] private Gtk.Menu menu_file;
      [GtkChild] private Gtk.ImageMenuItem menuitem_load_profile;
      [GtkChild] private Gtk.ImageMenuItem menuitem_new_profile;
      [GtkChild] private Gtk.ImageMenuItem menuitem_quit;
    // Edit menu.
    [GtkChild] private Gtk.MenuItem menuitem_edit;
    [GtkChild] private Gtk.Menu menu_edit;
      [GtkChild] private Gtk.ImageMenuItem menuitem_copy_toxid;
      [GtkChild] private Gtk.ImageMenuItem menuitem_save_qrcode;
      [GtkChild] private Gtk.ImageMenuItem menuitem_change_nospam;
      [GtkChild] private Gtk.ImageMenuItem menuitem_preferences;
    // View menu.
    [GtkChild] private Gtk.MenuItem menuitem_view;
    [GtkChild] private Gtk.Menu menu_view;
      [GtkChild] private Gtk.CheckMenuItem checkmenuitem_enable_compact_list;
      [GtkChild] private Gtk.CheckMenuItem checkmenuitem_enable_bubbles;
      [GtkChild] private Gtk.ImageMenuItem menuitem_text_format;
      [GtkChild] private Gtk.Menu menu_text_format;
        [GtkChild] private Gtk.RadioMenuItem radiomenuitem_plain_text;
        [GtkChild] private Gtk.RadioMenuItem radiomenuitem_markdown;
        [GtkChild] private Gtk.RadioMenuItem radiomenuitem_plain_markdown;
    // About menu.
    [GtkChild] private Gtk.MenuItem menuitem_help;
    [GtkChild] private Gtk.Menu menu_help;
      [GtkChild] private Gtk.ImageMenuItem menuitem_help_website;
      [GtkChild] private Gtk.ImageMenuItem menuitem_help_source;
      [GtkChild] private Gtk.ImageMenuItem menuitem_help_bugs;
      [GtkChild] private Gtk.ImageMenuItem menuitem_help_about;

  // Main boxes.
  [GtkChild] private Gtk.Box box_left_side;
  [GtkChild] private Gtk.Box box_right_side;

  private Components.HeaderBar header { get; set; }
  private Components.TabNavbar navbar { get; set; }

  public MainWindow (Gtk.Application app) {
    Object (application: app);

    this.set_title (Konv.Constants.APP_NAME + " - v." + Konv.Constants.VERSION + "-" + Konv.Constants.VERSION_INFO);
    this.set_default_size (800, 450);
    this.set_icon_name ("tox");

    this.load_styles ();
    this.init_widgets ();
    this.connect_signals ();
    this.run_logic ();
  }

  private void load_styles () {
    CssProvider provider = new CssProvider ();
    provider.parsing_error.connect ((section, e) => {
      warning ("%s:[%u:%u]:[%u:%u]: CSS parsing error: %s".printf (
        section.get_file ().get_basename (), section.get_start_line (),
        section.get_end_line (), section.get_start_position (),
        section.get_end_position (), e.message
      ));
    });

    provider.load_from_resource (@"$(Konv.Constants.RES_PATH)/resources/styles/helpers.css");

    Gtk.StyleContext.add_provider_for_screen (
      Gdk.Screen.get_default (), provider,
      Gtk.STYLE_PROVIDER_PRIORITY_APPLICATION
    );
  }

  private void init_widgets () {
    /**
    * TODO: Initialize the window widgets here.
    * @note Widgets properties MUST be defined in the UI file, if possible.
    **/

    this.navbar = new Components.TabNavbar ();
    this.header = new Components.HeaderBar ();
    this.header.get_style_context ().add_class ("no-radius");

    Gtk.Label label_recent = new Gtk.Label.with_mnemonic (_("Recent conversations shows here."));
    TabContainer recent = new TabContainer ("recent", Gtk.Orientation.VERTICAL);
    recent.title = _("Recent conversations");
    recent.icon_name = "document-open-recent-symbolic";
    recent.pack_start (label_recent, true, true, 0);

    Gtk.Label label_contacts = new Gtk.Label.with_mnemonic (_("Contact list displays here."));
    TabContainer contacts = new TabContainer ("contacts", Gtk.Orientation.VERTICAL);
    contacts.title = _("Contacts");
    contacts.icon_name = "system-users-symbolic";
    contacts.pack_start (label_contacts, true, true, 0);

    Gtk.Label label_transfers = new Gtk.Label.with_mnemonic (_("All file transfers goes here."));
    TabContainer transfers = new TabContainer ("transfers", Gtk.Orientation.VERTICAL);
    transfers.title = _("File transfers");
    transfers.icon_name = "mail-send-receive-symbolic";
    transfers.pack_start (label_transfers, true, true, 0);

    Gtk.Label label_missed_calls = new Gtk.Label.with_mnemonic (_("Missed calls will be listed here."));
    TabContainer missed_calls = new TabContainer ("calls", Gtk.Orientation.VERTICAL);
    missed_calls.title = _("Missed calls");
    missed_calls.icon_name = "call-missed-symbolic";
    missed_calls.pack_start (label_missed_calls, true, true, 0);

    try {
      this.navbar.add_tab (recent);
      this.navbar.add_tab (contacts);
      this.navbar.add_tab (transfers);
      this.navbar.add_tab (missed_calls);
      this.navbar.set_visible_tab ("recent");
    } catch (TabError e) {
      error (@"Cannot add tab. Error: $(e.message)");
    }

    this.box_left_side.pack_start (this.navbar, true, true, 0);
    this.box_left_side.pack_start (this.header, false, true, 0);
  }

  private void connect_signals () {
    // File menu !
    this.menuitem_quit.activate.connect (() => {
      this.close ();
    });

    // Help menu !
    this.menuitem_help_website.activate.connect (() => {
      try {
        AppInfo.launch_default_for_uri (Konv.Constants.WEBSITE_URL, null);
      } catch (Error e) {
        error (@"Cannot find default handler for website. Error: $(e.message)");
      }
    });

    this.menuitem_help_source.activate.connect (() => {
      try {
        AppInfo.launch_default_for_uri (Konv.Constants.SOURCE_URL, null);
      } catch (Error e) {
        error (@"Cannot find default handler for source code. Error: $(e.message)");
      }
    });

    this.menuitem_help_bugs.activate.connect (() => {
      try {
        AppInfo.launch_default_for_uri (Konv.Constants.ISSUES_URL, null);
      } catch (Error e) {
        error (@"Cannot find default handler for issues tracker. Error: $(e.message)");
      }
    });

    /* TEMP DEV ZONE.
    this.navbar.tab_changed.connect ((id, tab) => {
      if (id == "calls") {
        debug ("Calls called.");
        this.navbar.remove_tab (id);
      }
    });*/
  }

  private void run_logic () {
    /**
    * TODO: Run the window logic here.
    **/

    this.show_all ();
  }
}
