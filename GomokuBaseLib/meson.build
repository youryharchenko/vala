project('GomokuBaseLib', 'vala', 'c')

dependencies = [
    dependency('glib-2.0'),
    dependency('gobject-2.0'),
]

sources = files('src/main.vala', 'src/Step.vala', 'src/Game.vala')

#executable('GomokuSimple', sources, dependencies: dependencies)

shared_library('gomokubaselib-1.0', sources, dependencies: dependencies,
                  vala_gir: 'GomokuBaseLib-1.0.gir',
                  install: true,
                  install_dir: [true, true, true, true])


