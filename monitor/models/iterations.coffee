@Iterations = new Meteor.Collection("iterations")

@Iterations.allow
  insert: (userId, doc) ->
    # the user must be logged in
    userId? and Optimizations.findOne({$and: [_id:doc.optimizationId, userId: userId]})?
  update: (userId, doc, fields, modifier) ->
    no
  remove: (userId, doc) ->
    no

###
{
  "_id": ObjectId,
  "D": number,
  "L": number,
  "value": number,
  "parameters": [number]
  "optimizationId": ObjectId,
  "variation": ObjectId,
  "step": number,
  "timestamp": Date
}
###
