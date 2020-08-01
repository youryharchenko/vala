project('Animated Actors app', 'vala', 'c')

dependencies = [
    dependency('glib-2.0'),
    dependency('gobject-2.0'),
    dependency('clutter-1.0'),
    #meson.get_compiler('vala').find_library('sdl-gfx'),
    #meson.get_compiler('c').find_library('SDL_gfx'),
    #meson.get_compiler('c').find_library('m'),
]

sources = files('src/main.vala')

executable('AnimatedActors', sources, dependencies: dependencies)


