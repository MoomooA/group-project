Template.optimizations.helpers
  optimizations: () ->
    Optimizations.find({userId: Meteor.userId()}, {sort:[["updatedAt", "desc"]]})

Template.optimizations.events
  'click .del-optimization': (e, t) ->
    e.preventDefault()
    Meteor.call('deleteOptimization', e.currentTarget.id)
    return false
  'click .addOptimization': (event, template) ->
    Session.set('page', 'optimization')
  'click .optimization': (e, t) ->
    Session.set('optimization', e.currentTarget.id)
    Session.set('page', 'optimization')
