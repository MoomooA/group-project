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
      color = event.target.value
      Session.set('theme-color', color)