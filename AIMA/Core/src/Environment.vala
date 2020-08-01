using Gee;

namespace AimaCore {

public interface EnvironmentObject : Object {
    public abstract string to_string();
}

public interface Environment : Object {
    
    public abstract Gee.List<Agent> agents {get; construct;}
    public abstract Gee.List<EnvironmentObject> objects {get; construct;}
    
    public abstract void add_agent(Agent agent);
    public abstract void remove_agent(Agent agent);

    public abstract void add_object(EnvironmentObject eo);
    public abstract void remove_environment_object(EnvironmentObject eo);

    public abstract void step();

    public void step_n(int n) {
        for (int i = 0; i < n; i++)
            step();
    }

    public void step_until_done() {
        while (!is_done())
            step();
    }

    public abstract bool is_done();

    public abstract double get_performance_measure(Agent agent);

}

public interface EnvironmentState {
    public abstract string to_string();
}

}
