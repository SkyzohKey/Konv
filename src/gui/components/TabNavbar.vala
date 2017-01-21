using Konv;
using Gtk;

namespace Konv.Gui.Components {
  public errordomain TabError {
    TITLE_ALREADY_USED,
    TITLE_BLANK,
    WIDGET_NULL,
    NULL_TAB,
    UNKNOWN
  }


  //[GtkTemplate (ui="/im/konv/desktop/interfaces/components/TabNavbar.ui")]
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
    
    public Gtk.Box search_container { get; internal set; }

    /**
    * @public {string} current_page - The currently selected page title in read/write mode.
    * @notes 1. Setting this to an invalide `page_title` will throw an error.
    *        2. A signal is connected when value change and it will focus the requested page.
    **/
    public string current_tab { get; set; default = ""; }

    /**
    * @public {Gtk.PackDirection} direction - The compoment packing direction.
    * @notes 1. Defaults to Top-to-bottom.
    *        2. A signal is connected when value change and it repack the component.
    **/
    public Gtk.PackDirection direction { get; set; default = Gtk.PackDirection.TTB; }  

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
      this.tabs_header.icon_size = 36;
      this.tabs_header.homogeneous = true;
      
      this.searchentry = new Gtk.SearchEntry ();
      this.searchentry.placeholder_text = "Search or add a contact...";
      
      this.search_container = new Gtk.Box (Gtk.Orientation.VERTICAL, 0);
      Gtk.Label search = new Gtk.Label.with_mnemonic ("Search results loading here...");
      Gtk.Spinner spinner = new Gtk.Spinner ();
      spinner.active = true;
      
      Gtk.Box vbox = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 0);
      vbox.pack_start (spinner, false, false, 10);
      vbox.pack_start (search, false, false, 0);
      vbox.halign = Gtk.Align.CENTER;

      this.search_container.pack_start (vbox, true, true, 0);
      
      this.add_tab ("Search results", this.search_container, "system-search-symbolic");
      
      this.tabs.hhomogeneous = true;
      this.tabs.transition_type = Gtk.StackTransitionType.SLIDE_LEFT_RIGHT;
      
      this.set_orientation (Gtk.Orientation.VERTICAL);
      this.pack_start (this.tabs_header, false, true, 0);
      this.pack_start (this.searchentry, false, true, 0);
      this.pack_start (this.tabs, true, true, 0);
      
      this.show_all ();
    }

    /**
    * @private connect_signals - Connect the signals, only that. KISS.
    **/
    private void connect_signals () {
      /**
      * TODO: Connect the signals here.
      **/

      this.notify["current-tab"].connect ((obj, props) => {
        /**
        * TODO: Do handle when current page has to be changed, focus the right one.
        **/
        
        if (this.get_tab (this.current_tab) == null) {
          throw new TabError.NULL_TAB ("No tab with given tab_title exists.");
        }
        
        this.tabs.visible_child_name = this.current_tab;
      });

      this.notify["direction"].connect ((obj, props) => {
        /**
        * TODO: Do handle direction changes, then repack the component.
        **/

        // At the end of the operation call `this.init_widgets` to redraw.
      });
      
      this.searchentry.search_changed.connect (() => {
        string search_text = this.searchentry.get_text ().down ();
        
        if (search_text.strip () != "") {
          this.search_container.visible = true;
          this.current_tab = "Search results";
        } else {
          this.search_container.visible = false;
          this.current_tab = "";
        }
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
    * @param {string} title - The tab title, displayed in the NavBar.
    * @param {Gtk.Widget?} content - The tab content, can be any supported `Gtk.Widget`.
    * @return Return the newly created tab.
    **/
    public Gtk.Widget add_tab (string tab_title, Gtk.Widget? tab_content, string icon_name) throws TabError {
      if (this.get_tab (tab_title) != null) {
        throw new TabError.TITLE_ALREADY_USED ("The title specified is already used by another tab. Try to delete that tab before, or use another title.");
      }
    
      // Let's wrap our content widget inside a Box.
      Gtk.Box container = new Gtk.Box (Gtk.Orientation.VERTICAL, 0);
      container.pack_start (tab_content, true, true, 0);
      
      this.tabs.add_titled (container, tab_title, tab_title);
      this.tabs.child_set_property (container, "icon-name", icon_name);

      // return new page index.
      return this.get_tab (tab_title);
    }

    /**
    * @public {bool} remove_tab - Remove a tab from the component.
    * @param {string} tab_title - The tab index within the `this.tabs`.
    * @return Return true or false, depending if the tab has been removed.
    **/
    public bool remove_tab (string tab_title) throws TabError {
      Gtk.Widget? tab = this.get_tab (tab_title);
      if (tab == null) {
        throw new TabError.NULL_TAB ("No tab with given tab_title exists.");
      }
      
      tab.destroy ();
      return true;
    }

    /**
    * @public {Gtk.Widget?} get_tab - Get a tab from the component.
    * @param {string} tab_title - The tab index within the `this.tabs` to get.
    * @return Return the `tab_content` related to given `tab_title`. Can be null if `tab_title` isn't present on `this.tabs`.
    **/
    public Gtk.Widget? get_tab (string tab_title) {
      Gtk.Widget? tab = this.tabs.get_child_by_name (tab_title);
      return tab;
    }
  }
}
