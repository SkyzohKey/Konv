using Konv;
// using Konv.Core; // Uncomment later once core is ready.
using Konv.Gui;

/**
* @class Konv.App - Entrypoint of the application.
**/
namespace Konv {
	public class App : Gtk.Application {
		/**
		* The application name.
		**/
		public static string NAME = "Konv";

		/**
		* The application current version.
		* TODO: Use something like `config.vapi.in` in order to have the version
		*		linked to the build system (ie. allows git builds to have version).
		**/
		public static string VERSION = "0.1.0-alpha";

		/**
		* Resources base path (gresources).
		**/
		public static string RES_PATH = "/im/konv/desktop";

		/**
		* @private {string} args - The arguments used in this instance.
		**/
		private string[] args = {};

		/**
		*	@public {Konv.Gui.Windows.MainWindow} main_window - The main window used by the app.
		**/
		public Konv.Gui.Windows.MainWindow main_window { get; set; default = null; }

		/**
		* @constructor Konv.App
		* @param {string[]} args - The arguments array to parse.
		**/
		public App (string[] args) {
			GLib.Object (
	      application_id: "im.konv.desktop",
	      flags: ApplicationFlags.FLAGS_NONE
	    );

			this.args = args;
		}

		public override void activate () {
			this.main_window = new Konv.Gui.Windows.MainWindow (this);
		}

		/**
		* @public start - Init & start the application.
		* @return {int} - Returns 0 if no error, any number if errored.
		**/
		public int start () {
			stdout.printf ("%s v.%s started...", Konv.App.NAME, Konv.App.VERSION);

			/**
			* TODO: Parse this.args and dispatch.
			**/

			return 0;
		}
	}
}

public static int main (string[] argv) {
	return new Konv.App (argv).run (argv);
}
