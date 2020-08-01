using Gee;

namespace AimaCore {

public interface Action : Object {
    public abstract string to_string ();
}

public interface Model  : Object {
	public abstract string to_string ();
}

public interface Percept  : Object{
    public abstract string to_string ();
}

public interface State  : Object{
	public abstract string to_string ();
}

public interface Condition  : Object{

	public abstract bool evaluate(EnvironmentObject eo);

	public abstract string to_string();

}

public class Rule : Object {
	public Condition condition {get; construct;}
	public Action action {get; construct;}

	public Rule(Condition con, Action act) {
		Object(condition: con, action: act);
	}

	public bool evaluate(EnvironmentObject eo) {
		return (condition.evaluate(eo));
	}

	public string to_string() {
		return @"if $condition then $action.";
	}
}

}
