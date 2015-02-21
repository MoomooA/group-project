Template.changeTheme.helpers
  selected : (color) ->
    if color == Meteor.user().profile.theme then 'selected' else  ''

Template.changeNbIterations.helpers
  nbIterations : () ->
    Meteor.user().profile.nbIterations

Template.settings.events
  'click .clear-optimizations': (event, template) ->
    event.preventDefault()
    new Confirmation(
      message: "Are you sure you want to delete all optimizations?",
      title: "Confirmation",
      cancelText: "I better not",
      okText: "Go for it"
      success: no
    , (ok) ->
      if ok
        Meteor.call('deleteAllOptimizations')
    )
    return false

  'change .change-theme': (event, template) ->
    color = event.currentTarget.value
    Meteor.users.update({_id:Meteor.userId()}, {$set:{"profile.theme":color}})

  'click .logout': (event, template) ->
    Meteor.logout()

  'change .default-nb-iterations': (event, template) ->
    nb = event.currentTarget.value
    Meteor.users.update({_id:Meteor.userId()}, {$set:{"profile.nbIterations":nb}})
