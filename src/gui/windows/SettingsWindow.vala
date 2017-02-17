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
    this.set_size_request (650, 400);
    this.set_border_width (0);

    //this.set_resizable (false);
    //this.set_modal (true);

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
    this.stack.add_titled (this.chatview_box, "conversations", _("Conversations"));
    this.stack.add_titled (this.notifications_box, "notifications", _("Notifications"));
    this.stack.add_titled (this.network_box, "network", _("Network"));
    this.stack.add_titled (this.files_box, "files", _("Files & downloads"));
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
    Components.SettingsListBox listbox = new Components.SettingsListBox ();
    this.general_box = new Gtk.Box(Gtk.Orientation.VERTICAL, 0);
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
    Components.SettingsListBox listbox = new Components.SettingsListBox ();
    this.interface_box = new Gtk.Box(Gtk.Orientation.VERTICAL, 0);
    this.interface_box.pack_start (listbox, true, true, 0);

    // Font section.
    listbox.new_section (_("Font"));

    Gtk.FontButton button_font = new Gtk.FontButton ();
    listbox.new_row (button_font,
      _("Interface font"),
      _("Choose which font should be used in the %s interface.").printf (Konv.Constants.APP_NAME)
    );

    Gtk.ComboBoxText comboboxtext_text_format = new Gtk.ComboBoxText ();
    comboboxtext_text_format.append_text (_("Plaintext"));
    comboboxtext_text_format.append_text (_("Markdown"));
    comboboxtext_text_format.append_text (_("Plain Markdown"));
    comboboxtext_text_format.active = 1;
    listbox.new_row (comboboxtext_text_format,
      _("Text formating"),
      _("Select your prefered text parsing method.")
    );

    // Theme section.
    listbox.new_section (_("Theme"));

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

    listbox.new_section (_("Misc"));

    Gtk.Switch switch_compact_list = new Gtk.Switch ();
    switch_compact_list.active = true;
    listbox.new_row (switch_compact_list,
      _("Compact list"),
      _("Lists are rendered as taller than possible to display more items.")
    );
  }

  private void make_chatview_box () {
    Components.SettingsListBox listbox = new Components.SettingsListBox ();
    this.chatview_box = new Gtk.Box(Gtk.Orientation.VERTICAL, 0);
    this.chatview_box.pack_start (listbox, true, true, 0);

    // Font section.
    listbox.new_section (_("Font"));

    Gtk.FontButton button_font = new Gtk.FontButton ();
    listbox.new_row (button_font,
      _("Conversations font"),
      _("Choose which font should be used in the conversations.")
    );

    // Messages section.
    listbox.new_section (_("Messages"));

    Gtk.Box box_emojis = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 5);

    Gtk.ComboBoxText combo_emojis = new Gtk.ComboBoxText ();
    combo_emojis.append_text ("Emojione");
    combo_emojis.append_text ("Twitter");
    combo_emojis.append_text ("iOS");
    combo_emojis.append_text ("Noto");
    combo_emojis.append_text ("kde4");
    combo_emojis.active = 0;

    Gtk.Switch switch_emojis = new Gtk.Switch ();
    switch_emojis.active = true;

    box_emojis.pack_start (switch_emojis, false, false, 0);
    box_emojis.pack_start (combo_emojis, false, false, 0);

    listbox.new_row (box_emojis,
      _("Enable emojis"),
      _("Convert unicode to emojis in messages.")
    );

    Gtk.Switch switch_bubbles = new Gtk.Switch ();
    switch_bubbles.active = true;
    listbox.new_row (switch_bubbles,
      _("Enable bubbles"),
      _("Display messages in bubbles instead of plaintext.")
    );

    Gtk.Switch switch_avatars = new Gtk.Switch ();
    switch_avatars.active = true;
    listbox.new_row (switch_avatars,
      _("Avatar instead of username"),
      _("Display avatar in place of username, and username in a tooltip.")
    );

    // Time section
    listbox.new_section (_("Timestamps"));

    /**
    * TODO: Find a better way to display the different formats to end-user.
    **/

    Gtk.ComboBoxText combo_time_format = new Gtk.ComboBoxText ();
    combo_time_format.append_text ("17:36"); // HH:mm
    combo_time_format.append_text ("17:36:21"); // hh:mm
    combo_time_format.append_text ("17:36:21 CET"); // HH:mm:ss t
    combo_time_format.append_text ("05:36 PM"); // hh:mm AP
    combo_time_format.append_text ("05:36:21 PM"); // hh:mm:ss AP
    combo_time_format.active = 1;
    listbox.new_row (combo_time_format,
      _("Timestamp format"),
      _("Select your prefered timestamp format.")
    );

    Gtk.ComboBoxText combo_date_format = new Gtk.ComboBoxText ();
    combo_date_format.append_text ("2017-02-16"); // yyyy-MM-dd
    combo_date_format.append_text ("Jeudi 16 Février 2016"); // dddd d MMMM yyyy
    combo_date_format.append_text ("16/02/2017"); // dd/MM/yyyy
    combo_date_format.append_text ("01-02-2017"); // dd-MM-yyyy
    combo_date_format.append_text ("1-02-2017"); // d-MM-yyyy
    combo_date_format.append_text ("Jeudi 01-02-2017"); // dddd dd-MM-yyyy
    combo_date_format.append_text ("Jeudi 16-02"); // dddd d-MM
    combo_date_format.active = 1;
    listbox.new_row (combo_date_format,
      _("Date format"),
      _("Select your prefered date format.")
    );

  }

  private void make_notifications_box () {
    Components.SettingsListBox listbox = new Components.SettingsListBox ();
    this.notifications_box = new Gtk.Box(Gtk.Orientation.VERTICAL, 0);
    this.notifications_box.pack_start (listbox, true, true, 0);

    Gtk.Switch switch_notify_blink = new Gtk.Switch ();
    switch_notify_blink.active = true;
    listbox.new_row (switch_notify_blink,
      _("Blink on notification"),
      _("Make the %s icon to blink in the taskbar on notification(s).").printf (Konv.Constants.APP_NAME)
    );

    // Contacts section.
    listbox.new_section (_("Contacts"));

    Gtk.Switch switch_notify_contacts = new Gtk.Switch ();
    switch_notify_contacts.active = true;
    listbox.new_row (switch_notify_contacts,
      _("Presence"),
      _("Show notification when contacts connects or disconnect.")
    );

    Gtk.Switch switch_notify_contacts_messages = new Gtk.Switch ();
    switch_notify_contacts_messages.active = true;
    listbox.new_row (switch_notify_contacts_messages,
      _("Message"),
      _("Show notification when you receive a message from a contact.")
    );

    Gtk.Switch switch_notify_contacts_name = new Gtk.Switch ();
    switch_notify_contacts_name.active = false;
    listbox.new_row (switch_notify_contacts_name,
      _("Name"),
      _("Show notification when contacts name changes.")
    );

    Gtk.Switch switch_notify_contacts_mood = new Gtk.Switch ();
    switch_notify_contacts_mood.active = false;
    listbox.new_row (switch_notify_contacts_mood,
      _("Status message"),
      _("Show notification when contacts status message changes.")
    );

    // Calls section.
    listbox.new_section (_("Calls"));

    Gtk.Switch switch_notify_audio_call = new Gtk.Switch ();
    switch_notify_audio_call.active = true;
    listbox.new_row (switch_notify_audio_call,
      _("Audio call"),
      _("Show a notification when you receive an audio call.")
    );

    Gtk.Switch switch_notify_video_call = new Gtk.Switch ();
    switch_notify_video_call.active = true;
    listbox.new_row (switch_notify_video_call,
      _("Video call"),
      _("Show notification when you receive a video call")
    );

    // Group chats section.
    listbox.new_section (_("Group chats"));

    Gtk.Switch switch_notify_group_messages = new Gtk.Switch ();
    switch_notify_group_messages.active = false;
    listbox.new_row (switch_notify_group_messages,
      _("Messages"),
      _("Show notification for each messages in a group chat.")
    );

    Gtk.Switch switch_notify_group_mentions = new Gtk.Switch ();
    switch_notify_group_mentions.active = true;
    listbox.new_row (switch_notify_group_mentions,
      _("Mentions"),
      _("Show notification when you are mentioned in a group chat.")
    );

    // File transfers section.
    listbox.new_section (_("File transfers"));

    Gtk.Switch switch_notify_file_complete = new Gtk.Switch ();
    switch_notify_file_complete.active = true;
    listbox.new_row (switch_notify_file_complete,
      _("Transfer complete"),
      _("Show notification when file transfer is complete.")
    );

    Gtk.Switch switch_notify_file_fail = new Gtk.Switch ();
    switch_notify_file_fail.active = true;
    listbox.new_row (switch_notify_file_fail,
      _("Transfer failed"),
      _("Show notification when file transfer fails.")
    );
  }

  private Gtk.Switch switch_enable_proxy;
  private Gtk.Box box_proxy;
  private void make_network_box () {
    Components.SettingsListBox listbox = new Components.SettingsListBox ();
    this.network_box = new Gtk.Box(Gtk.Orientation.VERTICAL, 0);
    this.network_box.pack_start (listbox, true, true, 0);

    // Proxy section.
    listbox.new_section (_("Proxy"));

    this.switch_enable_proxy = new Gtk.Switch ();
    this.switch_enable_proxy.active = false;
    listbox.new_row (this.switch_enable_proxy,
      _("Enable proxy"),
      _("Make external requests through a proxy.")
    );

    this.box_proxy = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 5);
    Gtk.ComboBoxText combo_proxy_type = new Gtk.ComboBoxText ();
    combo_proxy_type.append_text ("SOCKS5");
    combo_proxy_type.append_text ("HTTP");
    combo_proxy_type.active = 0;
    Gtk.Label proxy_scheme = new Gtk.Label ("://");
    Gtk.Entry entry_proxy_ip = new Gtk.Entry ();
    entry_proxy_ip.placeholder_text = "127.0.0.1";
    Gtk.Label separator = new Gtk.Label (":");
    Gtk.SpinButton spin_proxy_port = new Gtk.SpinButton.with_range (0, 65535, 1);
    spin_proxy_port.value = (float)9050;

    this.box_proxy.pack_start (combo_proxy_type, false, false, 0);
    this.box_proxy.pack_start (proxy_scheme, false, false, 0);
    this.box_proxy.pack_start (entry_proxy_ip, false, false, 0);
    this.box_proxy.pack_start (separator, false, false, 0);
    this.box_proxy.pack_start (spin_proxy_port, false, false, 0);
    this.box_proxy.sensitive = false;

    this.switch_enable_proxy.activate.connect (() => {
      this.box_proxy.sensitive = this.switch_enable_proxy.active;
    });

    listbox.new_row (this.box_proxy, "");

    // Connection section.
    listbox.new_section (_("Connection type (advanced users only)"));

    Gtk.Switch switch_auto_reconnect = new Gtk.Switch ();
    switch_auto_reconnect.active = true;
    listbox.new_row (switch_auto_reconnect,
      _("Auto-reconnect"),
      _("Attempt to reconnect to the network if connection get lost.")
    );

    Gtk.Switch switch_enable_udp = new Gtk.Switch ();
    switch_enable_udp.active = true;
    listbox.new_row (switch_enable_udp,
      _("Enable UDP"),
      _("Make external requests in UDP mode.")
    );

    Gtk.Switch switch_enable_tcp = new Gtk.Switch ();
    switch_enable_tcp.active = false;
    listbox.new_row (switch_enable_tcp,
      _("Enable TCP"),
      _("Make external requests in TCP mode.")
    );
  }

  private void make_files_box () {
    Components.SettingsListBox listbox = new Components.SettingsListBox ();
    this.files_box = new Gtk.Box(Gtk.Orientation.VERTICAL, 0);
    this.files_box.pack_start (listbox, true, true, 0);

    // Connection section.
    listbox.new_section (_("File transfers"));

    Gtk.Box box_save_path = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 5);
    Gtk.Entry entry_save_path = new Gtk.Entry ();
    entry_save_path.text = Environment.get_user_special_dir (UserDirectory.DOWNLOAD);
    entry_save_path.editable = false;
    Gtk.Button button_save_path = new Gtk.Button.with_mnemonic ("...");
    button_save_path.tooltip_text = _("Choose a folder");
    box_save_path.pack_start (entry_save_path, true, false, 0);
    box_save_path.pack_start (button_save_path, false, false, 0);

    listbox.new_row (box_save_path,
      _("Files save path"),
      _("Where does %s should store downloaded files?").printf (Konv.Constants.APP_NAME)
    );

    Gtk.Box box_auto_save = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 5);
    Gtk.Switch switch_auto_save = new Gtk.Switch ();
    switch_auto_save.active = true;
    Gtk.SpinButton spin_auto_save = new Gtk.SpinButton.with_range (0, 200, 10);
    spin_auto_save.value = 2.5;
    Gtk.Label label_auto_save = new Gtk.Label ("Mb");

    box_auto_save.pack_start (switch_auto_save, false, false, 0);
    box_auto_save.pack_start (spin_auto_save, false, false, 0);
    box_auto_save.pack_start (label_auto_save, false, false, 0);

    listbox.new_row (box_auto_save,
      _("Auto-accept files"),
      _("Automatically save files that are lower than the specified size.")
    );

    // Avatars section.
    listbox.new_section (_("Cache"));

    Gtk.Button button_clear_avatars_cache = new Gtk.Button.with_mnemonic ("Clear avatars");
    listbox.new_row (button_clear_avatars_cache,
      _("Avatars"),
      _("Remove every contact's avatar from the %s cache.").printf (Konv.Constants.APP_NAME)
    );

    Gtk.Button button_clear_transfers_cache = new Gtk.Button.with_mnemonic ("Clear file transfers");
    listbox.new_row (button_clear_transfers_cache,
      _("File transfers"),
      _("Remove every file transfers from the %s cache.").printf (Konv.Constants.APP_NAME)
    );

    Gtk.Button button_clear_logs_cache = new Gtk.Button.with_mnemonic ("Clear logs");
    listbox.new_row (button_clear_logs_cache,
      _("Chat logs"),
      _("Remove every chat logs from the %s cache.").printf (Konv.Constants.APP_NAME)
    );
  }

  private void make_av_box () {
    Components.SettingsListBox listbox = new Components.SettingsListBox ();
    this.av_box = new Gtk.Box(Gtk.Orientation.VERTICAL, 0);
    this.av_box.pack_start (listbox, true, true, 0);

    // Audio section.
    listbox.new_section (_("Audio"));

    /**
    * TODO: Populate the list beside with connected/supported speakers.
    **/
    Gtk.Box box_speakers_device = new Gtk.Box (Gtk.Orientation.VERTICAL, 5);
    Gtk.ComboBoxText combo_speakers_device = new Gtk.ComboBoxText ();
    combo_speakers_device.append_text ("JBL Bluetooth speaker");
    combo_speakers_device.append_text ("---");
    combo_speakers_device.active = 0;

    Gtk.Scale scale_speakers_volume = new Gtk.Scale.with_range (Gtk.Orientation.HORIZONTAL, 0, 100, 10);
    scale_speakers_volume.format_value.connect ((percent) => {
      return @"$(percent)%";
    });

    box_speakers_device.pack_start (combo_speakers_device, false, false, 0);
    box_speakers_device.pack_start (scale_speakers_volume, false, false, 0);

    listbox.new_row (box_speakers_device,
      _("Speakers"),
      _("Select the speakers you want to use.")
    );

    // -- volume

    /**
    * TODO: Populate the list beside with connected/supported micro device.
    **/
    Gtk.Box box_microphone_device = new Gtk.Box (Gtk.Orientation.VERTICAL, 5);
    Gtk.ComboBoxText combo_microphone_device = new Gtk.ComboBoxText ();
    combo_microphone_device.append_text ("Integrated microphone");
    combo_microphone_device.append_text ("---");
    combo_microphone_device.active = 0;

    Gtk.Scale scale_microphone_volume = new Gtk.Scale.with_range (Gtk.Orientation.HORIZONTAL, 0, 100, 10);
    scale_microphone_volume.format_value.connect ((percent) => {
      return @"$(percent)%";
    });

    box_microphone_device.pack_start (combo_microphone_device, false, false, 0);
    box_microphone_device.pack_start (scale_microphone_volume, false, false, 0);

    listbox.new_row (box_microphone_device,
      _("Microphone"),
      _("Select the microphone you want to use.")
    );

    // -- volume

    // Video section.
    listbox.new_section (_("Video"));

    /**
    * TODO: Populate the list beside with connected/supported video devices.
    **/
    Gtk.ComboBoxText combo_video_device = new Gtk.ComboBoxText ();
    combo_video_device.append_text ("Integrated webcam");
    combo_video_device.append_text ("---");
    combo_video_device.active = 0;
    listbox.new_row (combo_video_device,
      _("Webcam/camera"),
      _("Select the webcam/camera you want to use.")
    );

    /**
    * TODO: Populate the list beside with supported webcam resolutions.
    **/
    Gtk.ComboBoxText combo_video_resolution = new Gtk.ComboBoxText ();
    combo_video_resolution.append_text ("Default resolution");
    combo_video_resolution.append_text ("---");
    combo_video_resolution.active = 0;
    listbox.new_row (combo_video_resolution,
      _("Resolution"),
      _("Choose the resolution video will be sent/received.")
    );
  }

  private void make_plugins_box () {
    Components.SettingsListBox listbox = new Components.SettingsListBox ();
    this.plugins_box = new Gtk.Box(Gtk.Orientation.VERTICAL, 0);
    this.plugins_box.pack_start (listbox, true, true, 0);
  }
}
