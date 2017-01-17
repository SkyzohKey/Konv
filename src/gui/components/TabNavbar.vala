using Konv;
using Gtk;

//[GtkTemplate (ui="/im/konv/desktop/interfaces/components/TabNavbar.ui")]
public class Konv.Gui.Components.TabNavbar : Gtk.Box {
  /**
  * @public {Gtk.Stack[]?} pages - The current pages the TabNavbar component hold.
  * @notes `null` by default, please avoid setting it to null.
  **/
  public Gtk.Stack[]? pages { get; internal set; default = null; }

  /**
  * @public {int} current_page - The currently selected page in read/write mode.
  * @notes 1. Setting this to an invalide `page_index` will throw an error.
  *        2. A signal is connected when value change and it will focus the requested page.
  **/
  public int current_page { get; set; default = 0; }

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
  }

  /**
  * @private connect_signals - Connect the signals, only that. KISS.
  **/
  private void connect_signals () {
    /**
    * TODO: Connect the signals here.
    **/

    this.notify["current-page"].connect ((obj, props) => {
      /**
      * TODO: Do handle when current page has to be changed, focus the right one.
      **/
    });

    this.notify["direction"].connect ((obj, props) => {
      /**
      * TODO: Do handle direction changes, then repack the component.
      **/

      // At the end of the operation call `this.init_widgets` to redraw.
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
  * @public {int} add_page - Add a page to the component.
  * @param {string} title - The page title, displayed in the NavBar.
  * @param {Gtk.Widget?} content - The page content, can be any supported `Gtk.Widget`.
  * @return Return the newly created page index.
  **/
  public int add_page (string title, Gtk.Widget? content) {
    // return new page index.
    return 0;
  }

  /**
  * @public {bool} remove_page - Remove a page from the component.
  * @param {int} index - The page index within the `this.pages`.
  * @return Return true or false, depending if the page has been removed.
  **/
  public bool remove_page (int index) {
    // return true or false, is page has been removed.
    return false;
  }

  /**
  * @public {Gtk.Widget?} get_page - Get a page from the component.
  * @param {int} index - The page index within the `this.pages` to get.
  * @return Return the `page_content` related to given `index`. Can be null if `index` isn't present on `this.pages`.
  **/
  public Gtk.Widget? get_page (int index) {
    // return the given page from index, or null it no page found.
    return new Gtk.Label ("");
  }
}
