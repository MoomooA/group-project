@Optimizations = new Meteor.Collection("optimizations")

@Optimizations.allow
  insert: (userId, doc) ->
    userId? and doc.userId is userId
  update: (userId, doc, fields, modifier) ->
    userId? and doc.userId is userId
  remove: (userId, doc) ->
    no

###
{
  "_id": ObjectId,
  "userId": ObjectId,
  "createdAt": Date,
  "updateAt": Date,
  "finished": bool,
  "tolerance": number,
  "defaultStep": number
}
###
