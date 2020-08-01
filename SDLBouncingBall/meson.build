project('SDLBouncingBall app', 'vala', 'c')

dependencies = [
    dependency('glib-2.0'),
    dependency('gobject-2.0'),
    dependency('sdl'),
    meson.get_compiler('vala').find_library('sdl-gfx'),
    meson.get_compiler('c').find_library('SDL_gfx'),
    meson.get_compiler('c').find_library('m'),
]

sources = files('src/main.vala', 'src/World.vala', 'src/Window.vala', 'src/Ball.vala')

executable('SDLBouncingBall', sources, dependencies: dependencies)


