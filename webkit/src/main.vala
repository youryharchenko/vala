using Gtk;
using WebKit;

public class ValaBrowser : Window {

private const string TITLE = "The Settlers Online";
private const string DEFAULT_URL = "https://www.thesettlersonline.ru";
private const string DEFAULT_PROTOCOL = "https";

private string home_dir;

private Regex protocol_regex;

private Entry url_bar;

private WebView web_view;
private WebContext web_ctx;
private WebKit.Settings web_sets;
private Cancellable cancellable;

private Label status_bar;
private ToolButton back_button;
private ToolButton forward_button;
private ToolButton reload_button;

public ValaBrowser () {
	this.home_dir = GLib.Environment.get_home_dir ();
	stdout.printf("home_dir: %s\n", this.home_dir);

	this.title = ValaBrowser.TITLE;
	set_default_size (800, 600);

	try {
		this.protocol_regex = new Regex (".*://.*");
	} catch (RegexError e) {
		critical ("%s", e.message);
	}

	create_widgets ();
	connect_signals ();
	this.url_bar.grab_focus ();
}

private string load_event_to_string(LoadEvent evt) {
	switch(evt) {
	case LoadEvent.COMMITTED:
		return "COMMITTED";
	case LoadEvent.FINISHED:
		return "FINISHED";
	case LoadEvent.REDIRECTED:
		return "REDIRECTED";
	case LoadEvent.STARTED:
		return "STARTED";
	}
	return "UNDEFINED";
}

private string cache_model_to_string(CacheModel model) {
	switch(model) {
	case CacheModel.DOCUMENT_BROWSER:
		return "DOCUMENT_BROWSER";
	case CacheModel.DOCUMENT_VIEWER:
		return "DOCUMENT_VIEWER";
	case CacheModel.WEB_BROWSER:
		return "WEB_BROWSER";
	}
	return "UNDEFINED";
}

private string process_model_to_string(ProcessModel model) {
	switch(model) {
	case ProcessModel.MULTIPLE_SECONDARY_PROCESSES:
		return "MULTIPLE_SECONDARY_PROCESSES";
	case ProcessModel.SHARED_SECONDARY_PROCESS:
		return "SHARED_SECONDARY_PROCESS";
	}
	return "UNDEFINED";
}

private void print_settings() {
	stdout.printf("print_settings start\n");
	stdout.printf("get_default_charset: %s\n", this.web_sets.get_default_charset());
	stdout.printf("get_enable_accelerated_2d_canvas: %s\n", this.web_sets.get_enable_accelerated_2d_canvas ()? "true" : "false");
	stdout.printf("get_enable_developer_extras: %s\n", this.web_sets.get_enable_developer_extras ()? "true" : "false");
	stdout.printf("get_enable_fullscreen: %s\n", this.web_sets.get_enable_fullscreen ()? "true" : "false");
	stdout.printf("get_enable_html5_database: %s\n", this.web_sets.get_enable_html5_database ()? "true" : "false");
	stdout.printf("get_enable_html5_local_storage: %s\n", this.web_sets.get_enable_html5_local_storage ()? "true" : "false");
	stdout.printf("get_enable_java: %s\n", this.web_sets.get_enable_java ()? "true" : "false");
	stdout.printf("get_enable_javascript: %s\n", this.web_sets.get_enable_javascript ()? "true" : "false");
	stdout.printf("get_enable_javascript_markup: %s\n", this.web_sets.get_enable_javascript_markup ()? "true" : "false");
	stdout.printf("get_enable_media: %s\n", this.web_sets.get_enable_media ()? "true" : "false");
	stdout.printf("get_enable_offline_web_application_cache: %s\n", this.web_sets.get_enable_offline_web_application_cache ()? "true" : "false");
	stdout.printf("get_enable_page_cache: %s\n", this.web_sets.get_enable_page_cache ()? "true" : "false");
	stdout.printf("get_enable_plugins: %s\n", this.web_sets.get_enable_plugins ()? "true" : "false");
	stdout.printf("get_enable_webaudio: %s\n", this.web_sets.get_enable_webaudio ()? "true" : "false");
	stdout.printf("get_enable_webgl: %s\n", this.web_sets.get_enable_webgl ()? "true" : "false");
	stdout.printf("get_enable_write_console_messages_to_stdout: %s\n", this.web_sets.get_enable_write_console_messages_to_stdout ()? "true" : "false");
	stdout.printf("get_user_agent: %s\n", this.web_sets.get_user_agent());
	stdout.printf("print_settings end\n");
}

private void print_context() {
	stdout.printf("print_context start\n");
	stdout.printf("get_favicon_database_directory: %s\n", this.web_ctx.get_favicon_database_directory () == null? "null" : this.web_ctx.get_favicon_database_directory ());
	stdout.printf("get_sandbox_enabled: %s\n", this.web_ctx.get_sandbox_enabled ()? "true" : "false");
	stdout.printf("is_automation_allowed: %s\n", this.web_ctx.is_automation_allowed ()? "true" : "false");
	stdout.printf("is_ephemeral: %s\n", this.web_ctx.is_ephemeral ()? "true" : "false");

	var cache_model = this.web_ctx.get_cache_model();
	stdout.printf("get_cache_model: %s\n", cache_model_to_string (cache_model));

	var process_model = this.web_ctx.get_process_model();
	stdout.printf("get_process_model: %s\n", process_model_to_string (process_model));

	var website_data_manager = this.web_ctx.website_data_manager;
	stdout.printf("website_data_manager get_base_cache_directory: %s\n", website_data_manager.get_base_cache_directory());
	stdout.printf("website_data_manager get_base_data_directory: %s\n", website_data_manager.get_base_data_directory());
	stdout.printf("website_data_manager get_local_storage_directory: %s\n", website_data_manager.get_local_storage_directory());
	stdout.printf("website_data_manager get_disk_cache_directory: %s\n", website_data_manager.get_disk_cache_directory());
	stdout.printf("website_data_manager get_hsts_cache_directory: %s\n", website_data_manager.get_hsts_cache_directory());
	stdout.printf("website_data_manager get_indexeddb_directory: %s\n", website_data_manager.get_indexeddb_directory());
	stdout.printf("website_data_manager get_offline_application_cache_directory: %s\n", website_data_manager.get_offline_application_cache_directory());

	this.web_ctx.get_plugins.begin (this.cancellable,(obj, res) => {
			stdout.printf("get_plugins completed\n");
			try {
			        var plugins = this.web_ctx.get_plugins.end(res);
			        stdout.printf("plugins.length: %u\n", plugins.length());
			        foreach(var p in plugins) {
			                stdout.printf("plugin: %s\n", p.get_path());
				}
			} catch (Error e) {
			        string msg = e.message;
			        stderr.printf(@"Error: $msg\n");
			}
		});
	stdout.printf("print_context end\n");
}

private void create_widgets () {
	var toolbar = new Toolbar ();
	Gtk.Image img = new Gtk.Image.from_icon_name ("go-previous", Gtk.IconSize.SMALL_TOOLBAR);
	this.back_button = new Gtk.ToolButton (img, null);
	img = new Gtk.Image.from_icon_name ("go-next", Gtk.IconSize.SMALL_TOOLBAR);
	this.forward_button = new Gtk.ToolButton (img, null);
	img = new Gtk.Image.from_icon_name ("view-refresh", Gtk.IconSize.SMALL_TOOLBAR);
	this.reload_button = new Gtk.ToolButton (img, null);
	toolbar.add (this.back_button);
	toolbar.add (this.forward_button);
	toolbar.add (this.reload_button);

	this.url_bar = new Entry ();

	this.web_ctx = WebContext.get_default ();
	this.cancellable = new Cancellable ();
	cancellable.notify.connect (() => {
			stdout.printf("get_plugins canceled\n");
		});

	var cookie_manager = this.web_ctx.get_cookie_manager();
	cookie_manager.changed.connect((source)=>{
			stdout.printf("cookie_manager changed\n");
		});

	var cookie_dir = GLib.Path.build_filename(this.home_dir, ".local", "share", "webkitgtk");
	stdout.printf("persistent_dir: %s\n", cookie_dir);
	try {
		File file = File.new_for_path (cookie_dir);
		file.make_directory_with_parents ();
	} catch (Error e) {
		print ("Error: %s\n", e.message);
	}

	//var website_data_manager = this.web_ctx.website_data_manager;
	//website_data_manager.base_data_directory = persistent_dir;

	var cookie_persistent_storage = GLib.Path.build_filename(cookie_dir, "cookie_persistent_storage");
	stdout.printf("cookie_persistent_storage: %s\n", cookie_persistent_storage);
	GLib.File.new_for_path(cookie_persistent_storage);
	cookie_manager.set_persistent_storage(cookie_persistent_storage, CookiePersistentStorage.SQLITE);
	cookie_manager.set_accept_policy(CookieAcceptPolicy.ALWAYS);

	//this.web_ctx.set_additional_plugins_directory("/usr/lib/adobe-flashplugin/");
	//this.web_ctx.set_additional_plugins_directory("/usr/lib/adobe-flashplugin/");

	print_context();

	this.web_sets = new WebKit.Settings();
	this.web_sets.set_enable_write_console_messages_to_stdout (true);
	print_settings();

	this.web_view = new WebView.with_context (this.web_ctx);
	this.web_view.set_settings(this.web_sets);

	var scrolled_window = new ScrolledWindow (null, null);
	scrolled_window.set_policy (PolicyType.AUTOMATIC, PolicyType.AUTOMATIC);
	scrolled_window.add (this.web_view);

	this.status_bar = new Label ("Welcome");
	this.status_bar.xalign = 0;

	var box = new Box (Gtk.Orientation.VERTICAL, 0);
	box.pack_start (toolbar, false, true, 0);
	box.pack_start (this.url_bar, false, true, 0);
	box.pack_start (scrolled_window, true, true, 0);
	box.pack_start (this.status_bar, false, true, 0);
	add (box);
}

private void connect_signals () {
	this.destroy.connect (Gtk.main_quit);

	this.url_bar.activate.connect (on_activate);

	this.web_ctx.automation_started.connect((source, session) => {
			stdout.printf("web_ctx automation_started - start\n");
		});
	this.web_ctx.download_started.connect((source, download) => {
			stdout.printf("web_ctx download_started - start\n");
		});
	this.web_ctx.initialize_notification_permissions.connect((source) => {
			stdout.printf("web_ctx initialize_notification_permissions - start\n");
		});
	this.web_ctx.initialize_web_extensions.connect((source) => {
			stdout.printf("web_ctx initialize_web_extensions - start\n");
		});
	this.web_ctx.user_message_received.connect((source, message) => {
			stdout.printf("web_ctx user_message_received - start\n");
			stdout.printf("web_ctx user_message_received - message: %s\n", message.get_name());
			return false;
		});


	this.web_view.load_changed.connect ((source, evt) => {
			stdout.printf("web_view load_changed - start\n");
			stdout.printf("web_view load_changed - get_uri: %s\n", source.get_uri ());
			stdout.printf("web_view load_changed - event: %s\n", load_event_to_string (evt));
			this.url_bar.text = source.get_uri ();
			this.title = "%s - %s".printf (this.url_bar.text, ValaBrowser.TITLE);
			update_buttons ();
			stdout.printf("web_view load_changed - end\n");
		});

	this.web_view.permission_request.connect((source, request) => {
			stdout.printf("web_view permission_request - start\n");
			return false;
		});

	this.back_button.clicked.connect (this.web_view.go_back);
	this.forward_button.clicked.connect (this.web_view.go_forward);
	this.reload_button.clicked.connect (this.web_view.reload);
}

private void update_buttons () {
	this.back_button.sensitive = this.web_view.can_go_back ();
	this.forward_button.sensitive = this.web_view.can_go_forward ();
}

private void on_activate () {
	var url = this.url_bar.text;
	if (!this.protocol_regex.match (url)) {
		url = "%s://%s".printf (ValaBrowser.DEFAULT_PROTOCOL, url);
	}
	this.web_view.load_uri (url);
}

public void start () {
	show_all ();
	this.web_view.load_uri (DEFAULT_URL);
}

public static int main (string[] args) {
	Gtk.init (ref args);

	var browser = new ValaBrowser ();
	browser.start ();

	Gtk.main ();

	return 0;
}
}