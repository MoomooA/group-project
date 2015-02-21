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
      switch color || 'emerald'
          when 'emerald'
              color = '#37BC9B'
          when 'sapphire'
              color = '#0f52ba'
          when 'ruby'
              color = '#D10056'
        
        $('body').css("color", color)
#        TODO CHANGE NEW OPTIMIZATION BOX COLOR
#        $('.addOptimization').css("background-color", color)
