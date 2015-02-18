Package.describe({
  name: 'group-project:authentication',
  version: '0.0.1',
  // Brief, one-line summary of the package.
  summary: '',
  // URL to the Git repository containing the source code for this package.
  git: '',
  // By default, Meteor will default to using README.md for documentation.
  // To avoid submitting documentation, set this field to null.
  documentation: 'README.md'
});

Package.onUse(function(api) {
  api.versionsFrom('1.0');
  api.use('ssh2', 'server');
  api.export('Auth', 'server');
  api.addFiles('group-project:authentication.js', 'server');
});

Package.onTest(function(api) {
  api.use('tinytest');
  api.use('group-project:authentication');
  api.addFiles('group-project:authentication-tests.js');
});

Npm.depends({
  ssh2: "0.4.4"
});
