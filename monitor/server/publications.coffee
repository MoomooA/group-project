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

Meteor.publish("logs", () ->
  if @userId
    Logs.find({userId : @userId}, {limit: 100, sort: [["timestamp", "desc"]]})
  else
    @ready()
)
