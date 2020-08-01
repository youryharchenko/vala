#ifndef MERCURYPROBELIB_INT_H
#define MERCURYPROBELIB_INT_H

#ifdef __cplusplus
extern "C" {
#endif

extern void
mercury_init(int argc, char **argv, void *stackbottom);

extern int
mercury_terminate(void);

#ifdef __cplusplus
}
#endif

#endif /* MERCURYPROBELIB_INT_H */
