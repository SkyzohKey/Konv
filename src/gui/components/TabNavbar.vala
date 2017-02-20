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
using Konv;

namespace Konv.Gui.Components {
  public errordomain TabError {
    TITLE_ALREADY_USED,
    TITLE_BLANK,
    WIDGET_NULL,
    NULL_TAB,
    UNKNOWN
  }

  public class TabNavbar : Gtk.Box {
    /**
    * @private {Gtk.StackSwitcher} tab_header - The navbar container.
    **/
    private Gtk.StackSwitcher tabs_header { get; internal set; default = new Gtk.StackSwitcher (); }

    /**
    * @public {Gtk.Stack} tabs - The current tabs the TabNavbar component hold.
    * @notes `null` by default, please avoid setting it to null.
    **/
    public Gtk.Stack tabs { get; internal set; default = new Gtk.Stack (); }

    /**
    * @public {Gtk.SearchEntry} searchentry - The search entry, search in contacts, transfers, groups, etc...
    **/
    public Gtk.SearchEntry searchentry { get; internal set; }

    /**
    * @public {Gtk.Box} search_container - The search container, used to pack and unpack the search tab.
    **/
    public Gtk.Box search_container { get; internal set; }

    /**
    * @public {string} current_page - The currently selected page title in read/write mode.
    * @notes 1. Setting this to an invalide `page_title` will throw an error.
    *        2. A signal is connected when value change and it will focus the requested page.
    **/
    public string current_tab { get; set; default = ""; }
    private string _last_tab { get; private set; default = ""; }

    /**
    * @public {Gtk.PackDirection} direction - The compoment packing direction.
    * @notes 1. Defaults to Top-to-bottom.
    *        2. A signal is connected when value change and it repack the component.
    **/
    public Gtk.PackDirection direction { get; set; default = Gtk.PackDirection.TTB; }

    /**
    * @signal tab_changed - Triggered once a the current tab changed.
    * @param {string} id - The tab id.
    * @param {Konv.Gui.Components.TabContainer} tab - The tab container object.
    **/
    public signal void tab_changed (string id, TabContainer tab);

    /**
    * @signal tab_added - Triggered once a tab is added.
    * @param {string} id - The tab id.
    * @param {Konv.Gui.Components.TabContainer} tab - The tab container object.
    **/
    public signal void tab_added (string id, TabContainer tab);

    /**
    * @signal tab_removed - Triggered once a tab is removed.
    * @param {string} id - The tab id.
    * @param {Konv.Gui.Components.TabContainer} tab - The tab container object.
    **/
    public signal void tab_removed (string id, TabContainer tab);

    /**
    * @constructor TabNavbar - The TabNavbar component constructor.
    **/
    public TabNavbar () {
      this.init_widgets ();
      this.connect_signals ();
      this.run_logic ();
    }

    /**
    * @private init_widgets - Initialize the widgets, only that. KISS.
    **/
    private void init_widgets () {
      /**
      * TODO: Initialize the widgets here.
      * @notes Widgets properties MUST be defined in the UI file, if possible.
      **/

      this.tabs_header.set_stack (this.tabs);
      this.tabs_header.homogeneous = true;

      this.searchentry = new Gtk.SearchEntry ();
      this.searchentry.placeholder_text = _ ("Search or add a contact...");

      this.tabs_header.get_style_context ().add_class ("no-radius");
      this.tabs_header.get_style_context ().add_class ("no-borders-h-sides");

      this.searchentry.get_style_context ().add_class ("no-radius");
      this.searchentry.get_style_context ().add_class ("no-borders-horizontal");
      this.searchentry.get_style_context ().add_class ("no-border-top");

      this.search_container = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 0);
      Gtk.Label search = new Gtk.Label.with_mnemonic (_ ("Search results loading here..."));
      search.wrap = true;
      search.wrap_mode = Pango.WrapMode.WORD;
      search.justify = Gtk.Justification.CENTER;
      Gtk.Spinner spinner = new Gtk.Spinner ();
      spinner.active = true;

      Gtk.Box vbox = new Gtk.Box (Gtk.Orientation.VERTICAL, 0);
      vbox.pack_start (spinner, false, false, 10);
      vbox.pack_start (search, false, false, 0);
      vbox.halign = Gtk.Align.CENTER;
      vbox.valign = Gtk.Align.CENTER;

      this.search_container.pack_start (vbox, true, true, 0);

      this.tabs.hhomogeneous = true;
      this.tabs.transition_type = Gtk.StackTransitionType.SLIDE_LEFT_RIGHT;

      this.set_orientation (Gtk.Orientation.VERTICAL);
      this.pack_start (this.tabs_header, false, true, 0);
      this.pack_start (this.searchentry, false, true, 0);
      this.pack_start (this.tabs, true, true, 0);

      TabContainer search_tab = new TabContainer ("search", Gtk.Orientation.HORIZONTAL);
      search_tab.title = _ ("Search results");
      search_tab.icon_name = "system-search-symbolic";
      search_tab.pack_start (this.search_container, true, true, 0);

      try {
        this.add_tab (search_tab, false);
      } catch (TabError e) {
        debug (@"Cannot add tab. Error: $(e.message)");
      }
    }

    /**
    * @private connect_signals - Connect the signals, only that. KISS.
    **/
    private void connect_signals () {
      this.notify["direction"].connect ((obj, props) => {
        /**
        * TODO: Do handle direction changes, then repack the component.
        **/

        // At the end of the operation call `this.init_widgets` to redraw.
      });

      this.searchentry.search_changed.connect (() => {
        string search_text = this.searchentry.get_text ().down ();

        if (search_text.strip () != "") {
          //this.search_container.visible = true;
          this._last_tab = this.current_tab;
          try {
            this.set_visible_tab ("search");
          } catch (TabError e) {
            debug (@"Cannot set visible tab. Error: $(e.message)");
          }
        } else {
          //this.search_container.visible = false;
          try {
            this.set_visible_tab (this._last_tab);
          } catch (TabError e) {
            debug (@"Cannot set visible tab. Error: $(e.message)");
          }
        }
      });

      this.tabs.notify["visible-child-name"].connect ((obj, props) => {
        GLib.Idle.add (() => {
          TabContainer container = ((TabContainer) this.tabs.get_visible_child ());
          if (container == null || container.id == "search") {
            return false;
          }

          this._last_tab = this.current_tab;
          this.current_tab  = container.id;

          this.tab_changed (container.id, container);

          debug (@"Current tab set to `$(current_tab)`.");
          return false;
        });
      });
    }

    /**
    * @private run_logic - Run the component logic, only that. KISS!
    **/
    private void run_logic () {
      /**
      * TODO: Run the logic here.
      **/

      this.show_all ();
    }

    /**
    * @public {Gtk.Widget} add_tab - Add a tab to the component.
    * @param {Konv.Gui.Components.TabContainer} container - The tab container.
    * @param {bool} is_shown - Should the tab be shown ? Defaults to true.
    * @return Return the newly created tab.
    **/
    public Gtk.Widget add_tab (TabContainer container, bool is_shown = true) throws TabError {
      if (this.get_tab (container.id) != null) {
        throw new TabError.TITLE_ALREADY_USED ("The title specified is already used by another tab. Try to delete that tab before, or use another title.");
      }

      this.tabs.add_titled (container, container.id, container.title);
      this.tabs.child_set_property (container, "icon-name", container.icon_name);

      if (is_shown == false) {
        List<weak Gtk.Widget> childs = this.tabs_header.get_children ();
        foreach (Gtk.Widget m in childs) {
          if (m.tooltip_text == container.title) {
            this.tabs_header.remove (m);
          }
        }
      }

      this.tab_added (container.id, container);
      return this.get_tab (container.id);
    }


    /**
    * @public {TabContainer?} get_tab - Get a tab from the component.
    * @param {string} id - The tab inside the `this.tabs` to get.
    * @return Return the `content` related to given `id`. Can be null if `id` isn't present on `this.tabs`.
    **/
    public TabContainer? get_tab (string id) {
      Gtk.Widget? tab = this.tabs.get_child_by_name (id);
      return ((TabContainer) tab);
    }

    /**
    * @public {bool} remove_tab - Remove a tab from the component.
    * @param {string} id - The tab id.
    * @return Return true or false, depending if the tab has been removed.
    **/
    public bool remove_tab (string id) throws TabError {
      TabContainer? container = this.get_tab (id);
      if (container == null) {
        throw new TabError.NULL_TAB ("No tab with given `id` exists.");
      }

      this.tab_removed (container.id, container);

      container.destroy ();
      return true;
    }

    /**
    *
    **/
    public void set_visible_tab (string id) throws TabError {
      if (this.get_tab (id) == null) {
        throw new TabError.NULL_TAB ("No tab with given `id` exists.");
      }

      GLib.Idle.add (() => {
        TabContainer tab = this.get_tab (id);
        this.tabs.set_visible_child (tab);

        if (id != "search") {
          this.current_tab = tab.id;
          debug (@"Set visible tab to `$(current_tab)`.");
        }

        return false;
      });
    }
  }
}
