project('GomokuBase app', 'vala', 'c')

home = run_command('bash', '-c', 'echo $HOME').stdout().strip()

# vapi_dir = meson.current_source_dir() / '../GomokuBaseLib/builddir/'
vapi_dir = home / '.vala/vapi'
inc_dir = home / '.vala/inc'
lib_dir = home / '.vala/lib'

add_project_arguments(['--vapidir', vapi_dir, '--includedir', inc_dir], language: 'vala')

dependencies = [
    dependency('glib-2.0'),
    dependency('gobject-2.0'),
    dependency('gtk+-3.0'),
    #dependency('gomokubaselib-1.0'),
    meson.get_compiler('c').find_library('gomokubaselib-1.0', dirs:[lib_dir]),
    meson.get_compiler('vala').find_library('gomokubaselib-1.0', dirs:[vapi_dir, lib_dir]),
]

sources = files('src/main.vala', 'src/Desk.vala')

#add_project_arguments('-I../GomokuBaseLib/builddir', language : 'c')

executable('GomokuBase', sources, dependencies: dependencies)


