Meteor.publish("iterations", (optimizationId) ->
  Iterations.find({optimizationId: optimizationId})
)

Meteor.publish("optimizations", () ->
  Optimizations.find({userId : this.userId})
)
