project('AimaCore', 'vala', 'c')

dependencies = [
    dependency('glib-2.0'),
    dependency('gobject-2.0'),
    dependency('gee-0.8'),
]

sources = files('src/Environment.vala', 'src/Agent.vala', 'src/Util.vala')

#executable('GomokuSimple', sources, dependencies: dependencies)

shared_library('aimacore-1.0', sources, dependencies: dependencies,
                  vala_gir: 'AimaCore-1.0.gir',
                  install: true,
                  install_dir: [true, true, true, true])


