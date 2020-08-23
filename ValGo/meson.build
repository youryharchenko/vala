project('ValGo app', 'vala', 'c')

dependencies = [
    dependency('glib-2.0'),
    dependency('gobject-2.0'),
    dependency('gio-2.0'),
    dependency('gio-unix-2.0'),
    dependency('gtk+-3.0'),
    dependency('json-glib-1.0'),
    #meson.get_compiler('vala').find_library('sdl-gfx'),
    #meson.get_compiler('c').find_library('SDL_gfx'),
    #meson.get_compiler('c').find_library('m'),
]

sources = files('src/main.vala', 'src/json.vala')

executable('ValGo', sources, dependencies: dependencies)
