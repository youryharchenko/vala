using Gee;

namespace AimaCore {

public interface Agent : EnvironmentObject {

	public abstract bool is_alive {get; set;}
	public abstract AgentProgram program {get; construct;}
    
    public abstract Action act(Percept percept);
    
}

public interface AgentProgram : Object {
    public abstract Action apply(Percept percept);
}

}
