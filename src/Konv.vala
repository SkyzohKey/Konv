using Konv;
using Konv.Gui;
// using Konv.Core; // Uncomment later once core is ready.

/**
* @class Konv.App - Entrypoint of the application.
**/
namespace Konv {
	public class App : Gtk.Application {
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
	      application_id: "im.konv.client",
	      flags: ApplicationFlags.FLAGS_NONE
	    );

			Intl.setlocale(LocaleCategory.MESSAGES, "");
	    Intl.textdomain(Konv.Constants.GETTEXT_PACKAGE);
	    Intl.bind_textdomain_codeset(Konv.Constants.GETTEXT_PACKAGE, "utf-8");
	    Intl.bindtextdomain(Konv.Constants.GETTEXT_PACKAGE, Konv.Constants.GETTEXT_PATH);

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
			stdout.printf (_("%s v.%s started..."), Konv.Constants.APP_NAME, Konv.Constants.VERSION);

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
