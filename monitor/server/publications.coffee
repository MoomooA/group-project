Meteor.publish("iterations", (optimizationId) ->
  if @userId and optimizationId?
    Iterations.find({optimizationId: optimizationId})
  else
    @ready()

)

Meteor.publish("optimizations", () ->
  if @userId
    Optimizations.find({userId : @userId})
  else
    @ready()
)
