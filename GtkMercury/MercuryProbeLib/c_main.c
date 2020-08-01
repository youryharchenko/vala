#include <stdio.h>

/*
** This header file is part of the stand-alone interface.
** It contains declarations for mercury_init() and mercury_terminate(),
** which are used to respectively start and shutdown the Mercury runtime.
*/
#include "mercuryprobelib_int.h"

/*
** mercury_lib.mh is generated by the compiler when we build libmercury_lib.
** It contains declarations for procedures exported by pragma foreign_export
** as well as other exported entities, like mutables.
**
*/
#include "mercuryprobelib.mh"

int
main(int argc, char **argv)
{
    void *stack_bottom;
   
    /* Before calling any Mercury procedures we must first initialise
    ** the Mercury runtime, standard library and any other Mercury libraries
    ** that we will be using.  The function mercury_init() is used to do
    ** this.  In order it does the following:
    **
    ** (1) initialises the runtime
    ** (2) initialises the standard library
    ** (3) calls any predicates specified in `:- initialise' declarations
    **     and assigns any mutables their initial value   
    **
    ** We strongly recommend that calling this function is the first thing
    ** that your program does.
    **
    ** The third argument to mercury_init() is the address of the base of the
    ** stack.  In grades that support conservative GC is used tell the
    ** collector where to begin tracing.
    */
    mercury_init(argc, argv, &stack_bottom);

    /*
    ** Here is a call to an exported Mercury procedure that does some I/O.
    */
    write_hello();

    /*
    ** Lookup the current value of the Mercury mutable 'global' and print it
    ** out.  In C code we can refer to `global' by it's "foreign" name, the
    ** name given by mutable's foreign_name attribute.
    **
    ** WARNING: in grades that support multithreading access to Mercury
    ** mutables from C is *not* (currently) thread safe.
    */
    printf("The current value of global is %" MR_INTEGER_LENGTH_MODIFIER "d.\n",
        GLOBAL);

    /*
    ** Change the value of the Mercury mutable `global'.
    */
    GLOBAL = 42;

    /*
    ** Call a Mercury procedure that prints out the current value of
    ** the mutable `global'.
    */
    write_global_value();

    /*
    ** Once we have finished calling Mercury procedures then we shut
    ** down the Mercury runtime by calling the function
    ** mercury_terminate().  The value returned by this function 
    ** is Mercury's exit status (as set by io.set_exit_status/3.)
    **
    ** This function will also invoke any finalisers specified in
    ** `:- finalise' declarations in the set of Mercury libraries that
    ** we are using.
    */
    return mercury_terminate();
}