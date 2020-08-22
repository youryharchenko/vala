using GLib;
using Gtk;

public class ValGo : Gtk.Application {

	private ApplicationWindow window;
	private HeaderBar headerBar;
	private Box vbox;
	private Box hbox;
	
	private Button b_new;
	private Button b_send;
	private Button b_quit;
	private MenuButton b_menu;

	private Statusbar sbar;

	private IOChannel output;
	private IOChannel error;

	//private IOChannel sockOut;
	//private IOChannel sockIn;

	private UnixSocketAddress sockAddr;
	private SocketClient client;
	private SocketConnection connection;
	//private OutputStream ostream;
	//private InputStream istream;
	
	public ValGo () {
		Object(application_id: "youry.harchenko.valgo",
				flags: ApplicationFlags.FLAGS_NONE);
		
		this.startup.connect(()=>{
			spawn(".", new string[]{"./service", "--sock=app.sock"});
		});
		
	}

	private void spawn(string? workdir, string[] argv ) {

		int pid, standard_input, standard_output, standard_error;
		try {
			Process.spawn_async_with_pipes(workdir, argv, null, 0 , null,
				out pid, out standard_input, out standard_output, out standard_error);
		} catch (SpawnError ex) {
			stdout.printf("SpawnError: %s\n", ex.message);
			return;
		}

		// stdout:
		output = new IOChannel.unix_new (standard_output);
		output.add_watch (IOCondition.IN | IOCondition.HUP, (channel, condition) => {
			return process_line (channel, condition, "stdout");
		});

		// stderr:
		error = new IOChannel.unix_new (standard_error);
		error.add_watch (IOCondition.IN | IOCondition.HUP, (channel, condition) => {
			return process_line (channel, condition, "stderr");
		});

		ChildWatch.add (pid, (pid, status) => {
			stdout.printf("ChildWatch: %d, %d\n", pid, status);
			Process.close_pid (pid);
		});
	
	}

	private void connect_to_service(string addr) {
		stdout.printf("connect_to_service: %s\n", addr);
		sockAddr = new UnixSocketAddress(addr);
		client = new SocketClient();
		send_to_service("Test connection");
	}

	private string send_to_service(string msg) {
		stdout.printf("send_to_service - message: %s\n", msg);

		 
		try {
			connection = client.connect(sockAddr);
		} catch (Error ex) {
			stdout.printf("connect error: %s\n", ex.message);
		}
		
		try {
			
			//ostream.write_bytes(new Bytes(msg.data));	
			if (connection.is_connected()) {
				connection.output_stream.write (msg.data);
			} else {
				stdout.printf("Connection not connected\n");
			}
			//stdout.printf("send_to_service: %s\n", "OK");
		} catch(IOError ex) {
			stdout.printf("send_to_service error - write: %s\n", ex.message);
			return "";
		}

		try {

			DataInputStream response = new DataInputStream (connection.input_stream);
			string resp = response.read_line (null).strip ();
			stdout.printf("send_to_service - response: %s\n", resp);

			connection.close();

			return resp;

		} catch(IOError ex) {
			stdout.printf("send_to_service error - read: %s\n", ex.message);
			return "";
		}

		
		
	}

	private bool process_line (IOChannel channel, IOCondition condition, string stream_name) {
		if (condition == IOCondition.HUP) {
			stdout.printf("%s: The fd has been closed.\n", stream_name);
			return false;
		}
	
		try {
			string line;
			channel.read_line (out line, null, null);
			if (line.strip() == "ready to connect") {
				connect_to_service("app.sock");
			}
			stdout.printf("%s: %s", stream_name, line);
		} catch (IOChannelError e) {
			stdout.printf("%s: IOChannelError: %s\n", stream_name, e.message);
			return false;
		} catch (ConvertError e) {
			stdout.printf("%s: ConvertError: %s\n", stream_name, e.message);
			return false;
		}
	
		return true;
	}

	private bool quit_confirm() {
		Dialog dlg = new Dialog.with_buttons("Quit?", window, DialogFlags.MODAL);
		dlg.add_button("Ok", 0);
		dlg.add_button("Cancel", 1);
		bool r = dlg.run() == 0 ? true : false;
		dlg.close();
		return r;
	}
	
	private void init_widgets() {
		//var imageNew = new Gtk.Image.from_icon_name("tab-new-symbolic", IconSize.SMALL_TOOLBAR); //({ icon_name: 'tab-new-symbolic', icon_size: Gtk.IconSize.SMALL_TOOLBAR });
    	var imageMenu = new Gtk.Image.from_icon_name("open-menu-symbolic", IconSize.SMALL_TOOLBAR); //({ icon_name: 'open-menu-symbolic', icon_size: Gtk.IconSize.SMALL_TOOLBAR });
    	//var imageSend = new Gtk.Image.from_icon_name("send-to-symbolic", IconSize.SMALL_TOOLBAR); //({ icon_name: 'send-to-symbolic', icon_size: Gtk.IconSize.SMALL_TOOLBAR });
		//var imageQuit = new Gtk.Image.from_icon_name("process-stop", IconSize.SMALL_TOOLBAR); //({ icon_name: 'process-stop', icon_size: Gtk.IconSize.SMALL_TOOLBAR });
		
		headerBar = new HeaderBar();
		headerBar.set_title("ValGo");
		headerBar.set_show_close_button(true);

		var headerStart = new Grid();
		headerStart.column_spacing = headerBar.spacing;

		b_new = new Button.from_icon_name("tab-new-symbolic", IconSize.SMALL_TOOLBAR);
		b_new.clicked.connect((button)=>{
			stdout.printf("ToolButton 'Newd' clicked\n");
		});
		        
		b_send = new Button.from_icon_name("send-to-symbolic", IconSize.SMALL_TOOLBAR);
		b_send.clicked.connect((button)=>{
			stdout.printf("ToolButton 'Send' clicked\n");
			send_to_service("ToolButton 'Send' clicked");
		});
		
		b_quit = new Button.from_icon_name("process-stop", IconSize.SMALL_TOOLBAR);
		b_quit.clicked.connect((button)=>{
			stdout.printf("ToolButton 'Quit' clicked\n");
			if (quit_confirm()) quit();
		});
		
		b_menu = new MenuButton();
		b_menu.set_image(imageMenu);
		var popMenu = new Popover(null);
    	b_menu.set_popover(popMenu);
		popMenu.set_size_request(-1, -1);
		
		var model = new GLib.Menu();

    	b_menu.set_menu_model(model);
		var section = new GLib.Menu();

		section.append("Send", "app.send");
		section.append("Send2", "app.send2");
			
		var actionSend = new GLib.SimpleAction("send", null);
		actionSend.activate.connect(() => {
			stdout.printf("Menu Item 'Send' clicked\n");
			send_to_service("Message sent from menu (№;%?%*(* МТЬБбюью))");
		});
		add_action(actionSend);
	
		var actionSend2 = new GLib.SimpleAction("send2", null);
		actionSend2.activate.connect(() => {
			stdout.printf("Menu Item 'Send2' clicked\n");
			send_to_service("Message sent 2 from menu (ЄєєЇЇавіі)");
		});
		add_action(actionSend2);
	
		model.append_section(null, section);

		headerStart.attach(b_new, 0, 0, 1, 1);
    	headerStart.attach(b_send, 1, 0, 1, 1);
		headerStart.attach(b_quit, 2, 0, 1, 1);
		
		headerBar.pack_start(headerStart);
		headerBar.pack_end(b_menu);

		vbox = new Box(Orientation.VERTICAL, 0);
		hbox = new Box(Orientation.HORIZONTAL, 0);
		
		sbar = new Statusbar();
		sbar.push(0, "Ready");

		vbox.pack_start(hbox, false, false, 0);

		vbox.pack_start(sbar, false, false, 0);
		window.add (vbox);
		window.set_titlebar(headerBar);

	}

	protected override void activate () {
		// Create the window of this application and show it
		window = new ApplicationWindow (this);
		window.set_default_size (800, 850);
		window.title = "Vala Go";
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
		var app = new ValGo ();
		return app.run (args);
	}
}
