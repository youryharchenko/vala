project('GtkProbe app', 'vala', 'c')

vapi_dir = meson.current_source_dir() / '../MercuryProbeLib/'
mer_lib = '/usr/lib/mercury/lib/asm_fast.gc'
mer_inc = '/usr/lib/mercury/inc'
mer_gc = '/usr/lib/mercury/lib'

add_project_arguments(['--vapidir', vapi_dir, '--includedir', vapi_dir, '--includedir', mer_inc], language: 'vala')
# add_project_arguments(['mercuryprobelib_int.o'], language: 'c')

dependencies = [
    dependency('glib-2.0'),
    dependency('gobject-2.0'),
    dependency('gtk+-3.0'),
    #dependency('gomokubaselib-1.0'),
    meson.get_compiler('c').find_library('mercuryprobelib', dirs:[vapi_dir]),
    meson.get_compiler('c').find_library('mer_std', dirs:[mer_lib]),
    meson.get_compiler('c').find_library('mer_rt', dirs:[mer_lib]),
    meson.get_compiler('c').find_library('gc', dirs:[mer_gc]),
    meson.get_compiler('c').find_library('m'),
    meson.get_compiler('vala').find_library('mercuryprobelib', dirs:[vapi_dir]),
]

sources = files('src/main.vala', 'src/mercuryprobelib_int.c')

add_project_arguments('-I/usr/lib/mercury/inc', '-I/usr/lib/mercury/conf',  language : 'c')

executable('GtkProbe', sources, dependencies: dependencies)


