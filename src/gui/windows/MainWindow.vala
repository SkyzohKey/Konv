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

using Gtk;
using Konv.Gui.Components;
using Konv.Gui.Windows;
using Konv.Gui.Widgets;
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
  [GtkChild] private Gtk.CheckMenuItem checkmenuitem_toggle_menubar;
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

  // Windows.
  private Windows.SettingsWindow preferences_window { get; set; }

  // Widgets.
  private Widgets.WelcomeView welcome_view { get; set; default = null; }

  // Components.
  private Components.HeaderBar header { get; set; }
  private Components.TabNavbar navbar { get; set; }

  public MainWindow (Gtk.Application app) {
    Object (application: app);

    this.set_default_size (800, 450);
    this.set_title ("%s - v. %s-%s".printf (
                      Konv.Constants.APP_NAME, Konv.Constants.VERSION, Konv.Constants.VERSION_INFO
                    ));

    string logo = @"$(Konv.Constants.RES_PATH)/pixmaps/tox-logo-256.png";

    try {
      Gdk.Pixbuf pixbuf = new Gdk.Pixbuf.from_resource_at_scale (logo, 48, 48, true);
      this.set_default_icon (pixbuf);
    } catch (Error e) {
      print (@"Cannot load default_icon pixbuf. Error: $(e.message)");
    }

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
    this.navbar = new Components.TabNavbar ();
    this.header = new Components.HeaderBar ();

    Gtk.Label label_recent = new Gtk.Label.with_mnemonic (_ ("Recent conversations shows here."));
    TabContainer recent = new TabContainer ("recent", Gtk.Orientation.VERTICAL);
    recent.title = _ ("Recent conversations");
    recent.icon_name = "document-open-recent-symbolic";
    recent.pack_start (label_recent, true, true, 0);

    Gtk.Label label_contacts = new Gtk.Label.with_mnemonic (_ ("Contact list displays here."));
    TabContainer contacts = new TabContainer ("contacts", Gtk.Orientation.VERTICAL);
    contacts.title = _ ("Contacts");
    contacts.icon_name = "system-users-symbolic";
    contacts.pack_start (label_contacts, true, true, 0);

    Gtk.Label label_transfers = new Gtk.Label.with_mnemonic (_ ("All file transfers goes here."));
    TabContainer transfers = new TabContainer ("transfers", Gtk.Orientation.VERTICAL);
    transfers.title = _ ("File transfers");
    transfers.icon_name = "mail-send-receive-symbolic";
    transfers.pack_start (label_transfers, true, true, 0);

    Gtk.Label label_missed_calls = new Gtk.Label.with_mnemonic (_ ("Missed calls will be listed here."));
    TabContainer missed_calls = new TabContainer ("calls", Gtk.Orientation.VERTICAL);
    missed_calls.title = _ ("Missed calls");
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

    //this.checkmenuitem_toggle_menubar.accel_path = "app.toggle-menubar";
    var label_toggle_menubar = ((Gtk.AccelLabel) this.checkmenuitem_toggle_menubar.get_child ());
    label_toggle_menubar.set_accel (Gdk.keyval_from_name("M"),
                                    Gdk.ModifierType.CONTROL_MASK | Gdk.ModifierType.SHIFT_MASK);

    //this.menuitem_help_about.accel_path = "app.show-about";
    var label_help_about = ((Gtk.AccelLabel) this.menuitem_help_about.get_child ());
    label_help_about.set_accel (Gdk.keyval_from_name("H"),
                                Gdk.ModifierType.CONTROL_MASK | Gdk.ModifierType.SHIFT_MASK);

    //this.menuitem_preferences.accel_path = "app.show-preferences";
    var label_preferences = ((Gtk.AccelLabel) this.menuitem_preferences.get_child ());
    label_preferences.set_accel (Gdk.keyval_from_name("P"),
                                Gdk.ModifierType.CONTROL_MASK | Gdk.ModifierType.SHIFT_MASK);

    this.show_welcome_view ();
  }

  private void connect_signals () {
    // File menu !
    this.menuitem_quit.activate.connect (() => {
      this.close ();
    });

    // View menu !
    this.checkmenuitem_toggle_menubar.activate.connect (() => {
      this.toggle_menubar ();
    });

    // Help menu !
    this.menuitem_help_website.activate.connect (() => {
      this.open_uri (Konv.Constants.WEBSITE_URL);
    });

    this.menuitem_help_source.activate.connect (() => {
      this.open_uri (Konv.Constants.SOURCE_URL);
    });

    this.menuitem_help_bugs.activate.connect (() => {
      this.open_uri (Konv.Constants.ISSUES_URL);
    });

    this.menuitem_help_about.activate.connect (() => {
      this.show_about ();
    });

    this.menuitem_preferences.activate.connect (() => {
      this.show_preferences ();
    });

    this.header.clicked.connect (() => {
      this.send_test_notification ();
    });
  }

  private void run_logic () {
    /**
    * TODO: Run the window logic here.
    **/
  }

  public void toggle_menubar () {
    if (this.menubar_main.visible) {
      this.menubar_main.hide ();
    } else {
      this.menubar_main.show ();
    }

    print ("Toggled menubar_main.\n");
  }

  public void show_welcome_view () {
    if (this.welcome_view == null) {
      this.welcome_view = new Widgets.WelcomeView ("SkyzohKey");
      this.welcome_view.destroy.connect (() => {
          this.welcome_view = null;
      });
    }

    this.box_right_side.pack_start (this.welcome_view, true, true, 0);
    this.welcome_view.show_all ();
  }

  public void show_preferences () {
    if (this.preferences_window == null) {
      this.preferences_window = new Windows.SettingsWindow (((Gtk.Window) this));
      this.preferences_window.destroy.connect (() => {
        this.preferences_window = null; // Release the reference when not needed anymore.
      });
    }

    this.preferences_window.show_all ();
  }

  public void show_about () {
    Gtk.show_about_dialog (
      this,
      program_name: Konv.Constants.APP_NAME,
      comments: Konv.Constants.RELEASE_NAME,
      version: "%s-%s".printf (Konv.Constants.VERSION, Konv.Constants.VERSION_INFO),
      license: "TODO: MIT License.",
      wrap_license: true,
      copyright: "Copyright © 2017 SkyzohKey <skyzohkey@konv.im>",
      authors: new string[] {
        "SkyzohKey <skyzohkey@konv.im>"
      },
      website: Konv.Constants.WEBSITE_URL,
      website_label: _ ("Konv.im official website")
    );
  }

  public void open_uri (string uri) {
    try {
      AppInfo.launch_default_for_uri (uri, null);
    } catch (Error e) {
      error (@"Cannot find default handler for uri. Error: $(e.message)");
    }
  }

  private void send_test_notification () {
    Gtk.Image image = new Gtk.Image.from_icon_name ("tox", Gtk.IconSize.DIALOG);

    Notification notif = new Notification ("Test notification.");
    notif.set_body ("This is a cool notification, it doesn't use any external lib!");
    notif.set_icon (image.gicon);
    notif.set_priority (NotificationPriority.URGENT);
    notif.add_button_with_target_value ("Konv", "app.about", null);
    notif.add_button_with_target_value ("is", "app.about", null);
    notif.add_button_with_target_value ("AWESOME", "app.about", null);

    this.application.send_notification ("notify.app", notif);
  }
}
