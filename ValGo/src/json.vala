using GLib;
using Json;

public class Request : GLib.Object{
    public Request(string cmd) {
        GLib.Object(command: cmd);

    }

    public string command { get; set; }
    public string to_string() {
        return @"Request{command:'$command'}";
    }
}

public class Response  : GLib.Object {
    public Response(string cmd) {}

    public string? command { get; set; }
    public string? message { get; set; }
    public int status { get; set; }
    public string to_string() {
        return @"Response{command:'$command', message:'$message', status:'$status'}";
    }
}

class JsonUtils<T> {

    public JsonUtils() {}

    public string marshal(T obj) {
        var root = Json.gobject_serialize (obj as GLib.Object);
        var generator = new Json.Generator ();
        generator.set_root (root);
        var data = generator.to_data (null);
        return data;
    }
    
    public T unmarshal(string json) {
        var parser = new Json.Parser ();
        try {
            parser.load_from_data (json);
        } catch(Error ex) {
            return null;
        }
        Json.Node node = parser.get_root ();
        T obj = Json.gobject_deserialize (typeof (T), node) ;
        return obj;
    }
}



