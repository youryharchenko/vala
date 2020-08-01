using Gtk;
using MercuryProbeLib;

public class GtkProbe : Gtk.Application {

	private ApplicationWindow window;
	private Box vbox;
	private ComboBoxText cb_color;
	private ToolButton tb_new;
	private Statusbar sbar;
	
	private bool is_play;
	private bool is_think;
	private int hum_color;

	public GtkProbe () {
		Object(application_id: "youry.harchenko.gtk.probe",
				flags: ApplicationFlags.FLAGS_NONE);
		this.is_play = false;
		this.is_think = false;
	}

	private bool quit_confirm() {
		is_play = false;
		Dialog dlg = new Dialog.with_buttons("Quit?", window, DialogFlags.MODAL);
		dlg.add_button("Ok", 0);
		dlg.add_button("Cancel", 1);
		bool r = dlg.run() == 0 ? true : false;
		dlg.close();
		return r;
	}

	private void init_widgets() {
		vbox = new Box(Orientation.VERTICAL, 0);

		Toolbar tbar = new Toolbar();
		ToolButton tb_quit = new ToolButton(null, "Quit");
		tb_quit.clicked.connect((button)=>{
			bool s_is_play = is_play;
			stdout.printf("ToolButton 'Quit' clicked\n");
			write_hello();
			if (quit_confirm()) quit();
			else is_play = s_is_play;
		});
		tbar.add(tb_quit);
		
		ToolItem tb_color = new ToolItem();
		cb_color = new ComboBoxText();
		cb_color.changed.connect((cmb)=>{
			if(cmb.active_id == "b") hum_color = 0;
			else hum_color = 1;
		});
		cb_color.append("b", "Black");
		cb_color.append("w", "White");
		cb_color.active_id ="b";
		tb_color.add(cb_color);
		tbar.add(tb_color);

		tb_new = new ToolButton(null, "New");
		tb_new.clicked.connect((button)=>{
			stdout.printf("ToolButton 'New' clicked\n");
			write_hello();
		});
		tbar.add(tb_new);
		
		sbar = new Statusbar();
		sbar.push(0, "Ready");

		vbox.pack_start(tbar, false, false, 0);

		vbox.pack_start(sbar, false, false, 0);
		window.add (vbox);
	}

	protected override void activate () {
		// Create the window of this application and show it
		window = new ApplicationWindow (this);
		window.set_default_size (800, 850);
		window.title = "Gtk Probe";
		window.delete_event.connect(() => {
			stdout.printf("App window delete_event\n");
			return !quit_confirm();			
		});

		init_widgets();

		window.add_events (Gdk.EventMask.ENTER_NOTIFY_MASK |
			Gdk.EventMask.BUTTON_RELEASE_MASK |
			Gdk.EventMask.POINTER_MOTION_MASK
		);
		
		window.show_all ();
	}

	public static int main (string[] args) {
		int *stack_bottom = null;
		mercury_init(args, stack_bottom);
		GtkProbe app = new GtkProbe ();
		return app.run (args);
	}
}
