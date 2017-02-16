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
  private Gtk.Box plugins_box;

  public SettingsWindow (Gtk.Window? parent) {
    Object (type: Gtk.WindowType.TOPLEVEL);

    this.set_title (_("Preferences - %s").printf (Konv.Constants.APP_NAME));
    this.set_position (Gtk.WindowPosition.CENTER_ON_PARENT);
    this.set_transient_for (parent);

    //this.set_resizable (false);
    this.set_size_request (650, 400);
    this.set_border_width (0);
    this.set_modal (true);

    Gtk.Box canvas = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 2);
    this.add (canvas);

    this.stack = new Gtk.Stack ();
    this.stack.set_size_request (400, 1);
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
    this.stack.add_titled (this.plugins_box, "plugins", _("Addons"));

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
    this.make_plugins_box ();
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

    // Behavior section.
    listbox.new_section (_("Behavior"));

    Gtk.Switch switch_boot_start = new Gtk.Switch ();
    listbox.new_row (switch_boot_start,
      _("Start %s on computer boot").printf (Konv.Constants.APP_NAME),
      _("Control whether or not %s should start with the computer.").printf (Konv.Constants.APP_NAME)
    );

    Gtk.Switch switch_show_system_tray = new Gtk.Switch ();
    switch_show_system_tray.active = true;
    listbox.new_row (switch_show_system_tray,
      _("System tray icon"),
      _("Display an icon in the system tray for easier control of the app.")
    );

    Gtk.Switch switch_tray_closing = new Gtk.Switch ();
    listbox.new_row (switch_tray_closing,
      _("Close to system tray"),
      _("Hide the window instead of closing it when requested,\nwindow can be shown again by right clicking the system tray icon.")
    );
  }

  private void make_interface_box () {
    this.interface_box = new Gtk.Box(Gtk.Orientation.VERTICAL, 0);

    Components.SettingsListBox listbox = new Components.SettingsListBox ();
    this.interface_box.pack_start (listbox, true, true, 0);

    // Font section.
    listbox.new_section ("Font");

    Gtk.FontButton button_font = new Gtk.FontButton ();
    listbox.new_row (button_font,
      _("Interface font"),
      _("Choose which font should be used in the %s interface.").printf (Konv.Constants.APP_NAME)
    );

    Gtk.ComboBoxText comboboxtext_text_format = new Gtk.ComboBoxText ();
    comboboxtext_text_format.append_text ("Plaintext");
    comboboxtext_text_format.append_text ("Markdown");
    comboboxtext_text_format.append_text ("Plain Markdown");
    comboboxtext_text_format.active = 1;
    listbox.new_row (comboboxtext_text_format,
      _("Text formating"),
      _("Select your prefered text parsing method.")
    );

    // Theme section.
    listbox.new_section ("Theme");

    Gtk.Switch switch_dark_variant = new Gtk.Switch ();
    switch_dark_variant.active = true;
    listbox.new_row (switch_dark_variant,
      _("Dark theme"),
      _("Use the dark variant of the theme for the %s interface.").printf (Konv.Constants.APP_NAME)
    );

    Gtk.ComboBoxText comboboxtext_custom_theme = new Gtk.ComboBoxText ();
    comboboxtext_custom_theme.append_text ("GTK+3 theme");
    comboboxtext_custom_theme.active = 0;
    listbox.new_row (comboboxtext_custom_theme,
      _("Custom theme"),
      _("Choose a custom theme between those installed.")
    );
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

  private void make_plugins_box () {
    this.plugins_box = new Gtk.Box(Gtk.Orientation.VERTICAL, 0);
  }
}
