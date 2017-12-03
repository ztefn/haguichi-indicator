project(
    'haguichi-indicator',
    ['vala', 'c'],
    version: '0.3.5',
    default_options: ['prefix=/usr'],
    meson_version: '>= 0.40'
)

add_project_arguments(
    '-DGETTEXT_PACKAGE="haguichi"',
    language: 'c'
)

sources = [
    'src/haguichi-indicator.vala',
    'src/indicator-menu.vala',
    'src/session.vala'
]

deps = [
    dependency('appindicator3-0.1'),
    dependency('gio-2.0'),
    dependency('glib-2.0', version: '>= 2.42'),
    dependency('gobject-2.0'),
    dependency('gtk+-3.0', version: '>= 3.14')
]

executable(
    meson.project_name(),
    sources,
    dependencies: deps,
    install: true
)
