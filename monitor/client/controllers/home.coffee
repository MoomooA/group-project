UI.body.rendered = () ->
  new OutdatedBrowser()

Template.wrapper.helpers
  color : () ->
    if Meteor.user()? and Meteor.user().profile? and Meteor.user().profile.theme? then Meteor.user().profile.theme else 'emerald'
    
Template.main.helpers
  menu_settings: () ->
    Session.get('page') is 'settings'
  menu_optimizations: () ->
    Session.get('page') is 'optimizations'
  menu_optimization: () ->
    Session.get('page') is 'optimization'
  menu_help: () ->
    Session.get('page') is 'help'
  menu_logs: () ->
    Session.get('page') is 'logs'

Template.menu.events
  'click #menu-settings': (event, template) ->
    Session.set('optimization', null)
    Session.set('page', 'settings')
  'click #menu-optimizations': (event, template) ->
    Session.set('optimization', null)
    Session.set('page', 'optimizations')
  'click #menu-help': (event, template) ->
    Session.set('optimization', null)
    Session.set('page', 'help')
  'click #menu-logs': (event, template) ->
    Session.set('optimization', null)
    Session.set('page', 'logs')
