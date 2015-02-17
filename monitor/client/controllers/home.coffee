Template.home.helpers
  isAdmin: () ->
    Meteor.user().profile.admin
  isNotAdmin: () ->
    !Meteor.user().profile.admin

Template.main.helpers
  menu_settings: () ->
    Session.get('page') is 'settings'
  menu_optimizations: () ->
    Session.get('page') is 'optimizations'
  menu_optimization: () ->
    Session.get('page') is 'optimization'
  menu_help: () ->
    Session.get('page') is 'help'

Template.menu.events
  'click #menu-settings': (event, template) ->
    Session.set('page', 'settings')
  'click #menu-optimizations': (event, template) ->
    Session.set('page', 'optimizations')
  'click #menu-help': (event, template) ->
    Session.set('page', 'help')
