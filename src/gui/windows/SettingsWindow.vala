using GLib;
using Gtk;
using Konv;
using Konv.Gui.Components;
// using Konv.Core; // Uncomment later once core is ready.

public class Konv.Gui.Windows.SettingsWindow : Gtk.Window {

  public Gtk.Stack stack;
  public Gtk.StackSidebar sidebar;

  private Gtk.Box general_box;
  private Gtk.Box interface_box;
  private Gtk.Box chatview_box;
  private Gtk.Box notifications_box;
  private Gtk.Box network_box;
  private Gtk.Box files_box;
  private Gtk.Box av_box;

  public SettingsWindow () {
    Object (type: Gtk.WindowType.TOPLEVEL);

    this.set_title (_("Preferences - %s").printf (Konv.Constants.APP_NAME));
    this.set_resizable (false);
    this.set_size_request (650, 400);
    this.set_border_width (0);
    this.set_modal (true);

    Gtk.Box canvas = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 2);
    this.add (canvas);

    this.stack = new Gtk.Stack ();
    //this.stack.set_transition_type (Gtk.StackTransitionType.OVER_UP_DOWN);
    canvas.pack_end (this.stack, true, true, 0);

    this.sidebar = new Gtk.StackSidebar ();
    this.sidebar.set_stack (this.stack);
    this.sidebar.set_size_request (150, 1);
    canvas.pack_start (this.sidebar, false, false, 0);

    this.make_boxes ();

    this.stack.add_titled (this.general_box, "general", _("General"));
    this.stack.add_titled (this.interface_box, "interface", _("Interface"));
    this.stack.add_titled (this.chatview_box, "chatview", _("Chat view"));
    this.stack.add_titled (this.notifications_box, "notifications", _("Notifications"));
    this.stack.add_titled (this.network_box, "network", _("Network"));
    this.stack.add_titled (this.files_box, "files", _("File transfers"));
    this.stack.add_titled (this.av_box, "av", _("Audio/video"));

    this.show_all ();
  }

  private void make_boxes () {
    this.make_general_box ();
    this.make_interface_box ();
    this.make_chatview_box ();
    this.make_notifications_box ();
    this.make_network_box ();
    this.make_files_box ();
    this.make_av_box ();
  }

  private void make_general_box () {
    this.general_box = new Gtk.Box(Gtk.Orientation.VERTICAL, 0);

    Components.SettingsListBox listbox = new Components.SettingsListBox ();
    this.general_box.pack_start (listbox, true, true, 0);

    // Language section.
    listbox.new_section (_("Language"));

    Gtk.ComboBoxText comboboxtext_language = new Gtk.ComboBoxText ();
    comboboxtext_language.append_text ("English");
    comboboxtext_language.append_text ("French");
    comboboxtext_language.active = 0;
    listbox.new_row (comboboxtext_language,
      _("Software language"),
      _("Choose the language that Konv interface will be displayed in.")
    );

    listbox.new_section (_("Behavior"));

    Gtk.Switch switch_boot_start = new Gtk.Switch ();
    listbox.new_row (switch_boot_start,
      _("Start %s on computer boot").printf (Konv.Constants.APP_NAME),
      _("Control whether or not %s should start with the computer.").printf (Konv.Constants.APP_NAME)
    );

    Gtk.Switch switch_show_system_tray = new Gtk.Switch ();
    listbox.new_row (switch_show_system_tray,
      _("Show system tray icon"),
      _("Display an icon in the system tray for easier control of the app.")
    );
  }

  private void make_interface_box () {
    this.interface_box = new Gtk.Box(Gtk.Orientation.VERTICAL, 0);
  }

  private void make_chatview_box () {
    this.chatview_box = new Gtk.Box(Gtk.Orientation.VERTICAL, 0);
  }

  private void make_notifications_box () {
    this.notifications_box = new Gtk.Box(Gtk.Orientation.VERTICAL, 0);
  }

  private void make_network_box () {
    this.network_box = new Gtk.Box(Gtk.Orientation.VERTICAL, 0);
  }

  private void make_files_box () {
    this.files_box = new Gtk.Box(Gtk.Orientation.VERTICAL, 0);
  }

  private void make_av_box () {
    this.av_box = new Gtk.Box(Gtk.Orientation.VERTICAL, 0);
  }
}
