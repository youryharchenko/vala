[CCode (cheader_filename = "mercuryprobelib_int.h")]
namespace MercuryProbeLib {
    [CCode (cname = "mercury_init")]
    public static void mercury_init([CCode (array_length_cname = "argc", array_length_pos = 0.5)] string[]? argv, int *stackbottom);

    [CCode (cname = "mercury_terminate")]
    public static void mercury_terminate();

    [CCode (cname = "write_hello")]
    public static void write_hello();

    [CCode (cname = "write_global_value")]
    public static void write_global_value();
}