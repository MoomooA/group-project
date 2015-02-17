Package.describe({
  name: 'group-project:lift-solver',
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
  api.export('LiftSolver', 'server');
  api.addFiles('group-project:lift-solver.js', 'server');
});

Package.onTest(function(api) {
  api.use('tinytest');
  api.use('group-project:lift-solver');
  api.addFiles('group-project:lift-solver-tests.js');
});
