Template.home.helpers
  isAdmin: () ->
    Meteor.user().profile.admin
  isNotAdmin: () ->
    !Meteor.user().profile.admin

Template.menu.helpers
  hide: () ->
    Session.get('page') is 'chantier'
  isNotAdmin: () ->
    !Meteor.user().profile.admin

Template.main.helpers
  chantier: () ->
    Session.get('page') is 'chantier'
  bdd: () ->
    Session.get('page') is 'bdd'
  aide: () ->
    Session.get('page') is 'aide'
  membres: () ->
    Session.get('page') is 'membres'
  preferences: () ->
    Session.get('page') is 'preferences'


Template.menu.events
  'click #menu-chantiers': (event, template) ->
    Session.set('page', 'chantiers')
  'click #menu-bdd': (event, template) ->
    Session.set('page', 'bdd')
    Session.set('page_bdd', 'materiel')
  'click #menu-membres': (event, template) ->
    if Meteor.user().profile.admin
      Session.set('page', 'membres')
  'click #menu-aide': (event, template) ->
    Session.set('page', 'aide')
  'click #menu-preferences': (event, template) ->
    Session.set('page', 'preferences')
  'input #menu-search': (e,t) ->
    Session.set('page', 'chantiers')
    Session.set('chantierQuery',t.find('#menu-search').value)
