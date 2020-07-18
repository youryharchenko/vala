project('GomokuBase app', 'vala', 'c')

vapi_dir = meson.current_source_dir() / '../GomokuBaseLib/builddir/'

add_project_arguments(['--vapidir', vapi_dir, '--includedir', vapi_dir], language: 'vala')

dependencies = [
    dependency('glib-2.0'),
    dependency('gobject-2.0'),
    dependency('gtk+-3.0'),
    #dependency('gomokubaselib-1.0'),
    meson.get_compiler('c').find_library('gomokubaselib-1.0', dirs:[vapi_dir]),
    meson.get_compiler('vala').find_library('gomokubaselib-1.0', dirs:[vapi_dir]),
]

sources = files('src/main.vala', 'src/Desk.vala')

#add_project_arguments('-I../GomokuBaseLib/builddir', language : 'c')

executable('GomokuBase', sources, dependencies: dependencies)


