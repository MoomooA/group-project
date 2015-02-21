Package.describe({
    name: 'group-project:wing-drawer',
    version: '0.0.1',
    // Brief, one-line summary of the package.
    summary: '',
    // URL to the Git repository containing the source code for this package.
    git: '',
    // By default, Meteor will default to using README.md for documentation.
    // To avoid submitting documentation, set this field to null.
    documentation: 'README.md'
});

Package.onUse(function (api) {
    api.versionsFrom('1.0.3.1');
    api.use(['templating'], 'client');
    api.addFiles('group-project:wing-drawer.html', 'client');
    api.addFiles('group-project:wing-drawer.js', 'client');

});

Package.onTest(function (api) {
    api.use('tinytest');
    api.use('group-project:wing-drawer');
    api.addFiles('group-project:wing-drawer-tests.js');
});