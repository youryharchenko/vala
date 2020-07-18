using Gtk;
using GomokuBaseLib;

public class GomokuSimple : Gtk.Application {

	private ApplicationWindow window;
	private Box vbox;
	private ComboBoxText cb_color;
	private ToolButton tb_new;
	private Statusbar sbar;
	private Desk desk;
	private Net net;
	private bool is_play;
	private bool is_think;
	private int hum_color;

	public GomokuSimple () {
		Object(application_id: "youry.harchenko.gomoku.simple",
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

	private void over_info(string message) {
		Dialog dlg = new MessageDialog(window, DialogFlags.MODAL, MessageType.INFO, ButtonsType.OK, message);
		dlg.response.connect((src, id)=>{src.close();});
		dlg.show();
	}

	private void init_widgets() {
		vbox = new Box(Orientation.VERTICAL, 0);

		Toolbar tbar = new Toolbar();
		ToolButton tb_quit = new ToolButton(null, "Quit");
		tb_quit.clicked.connect((button)=>{
			bool s_is_play = is_play;
			stdout.printf("ToolButton 'Quit' clicked\n");
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
			new_game();
		});
		tbar.add(tb_new);

		desk = new Desk();
		
		sbar = new Statusbar();
		sbar.push(0, "Ready");

		vbox.pack_start(tbar, false, false, 0);
		vbox.pack_start(desk);
		vbox.pack_start(sbar, false, false, 0);
		window.add (vbox);
	}

	private void new_game() {
		cb_color.set_sensitive(false);
		tb_new.set_sensitive(false);
		desk.clean();
		is_play = true;
		Step st = new Step(7, 7);
		desk.add_step(st);
		is_think = true;
		net = new Net(DIM, new Step[]{st});
		Result result;
		if (hum_color == 0) {
			result = net.calculate();
			stdout.printf("new_game: calculate result: %s\n", result.step.to_string());
			desk.add_step(result.step);
		}
		is_think = false;
	}

	private void next_step(Step step) {
		is_think = true;
		net.add_step(step);
		Result result = net.calculate();
		stdout.printf("new_game: calculate result: %s\n", result.to_string());
		if (result.step != null) desk.add_step(result.step);
		is_think = false;
		if (result.state != State.CONTINUE) game_over(result.message);
	}

	private void game_over(string mess) {
		is_play = false;
		set_cursor("default");
		over_info(mess);
		cb_color.set_sensitive(true);
		tb_new.set_sensitive(true);
	}

	private void set_cursor(string name) {
		Gdk.Window win = window.get_window();
		win.set_cursor(new Gdk.Cursor.from_name(win.get_display(), name));
	}

	protected override void activate () {
		// Create the window of this application and show it
		window = new ApplicationWindow (this);
		window.set_default_size (800, 850);
		window.title = "Gomoku Simple";
		window.delete_event.connect(() => {
			stdout.printf("App window delete_event\n");
			return !quit_confirm();			
		});

		init_widgets();

		window.add_events (Gdk.EventMask.ENTER_NOTIFY_MASK |
			Gdk.EventMask.BUTTON_RELEASE_MASK |
			Gdk.EventMask.POINTER_MOTION_MASK
		);

		window.button_release_event.connect((evt)=> {
			if (!is_play || is_think) return true;
			stdout.printf("main mouse click x:%f, y:%f\n", evt.x, evt.y);
			int x, y;
			window.translate_coordinates(desk, (int)evt.x, (int)evt.y, out x, out y);
			//stdout.printf("desk mouse click x:%d, y:%d\n", x, y);
			Step step = desk.get_step_from_cord(x, y);
			if (step.x != -1 && step.y != -1 && desk.is_empty(step.x, step.y)) {
				desk.add_step(step);
				next_step(step);
			}
			return true;
		});
		
		window.motion_notify_event.connect((evt)=> {
			if (!is_play || is_think) return true;
			int x, y;
			window.translate_coordinates(desk, (int)evt.x, (int)evt.y, out x, out y);
			//stdout.printf("desk mouse move x:%d, y:%d\n", x, y);
			
			Step step = desk.get_step_from_cord(x, y);
			if (step.x != -1 && step.y != -1 && desk.is_empty(step.x, step.y)) 
				set_cursor("crosshair");
			else 
				set_cursor("default");
			return true;
		});
		
		window.show_all ();
	}

	public static int main (string[] args) {
		GomokuSimple app = new GomokuSimple ();
		return app.run (args);
	}
}
