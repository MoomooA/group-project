@Logs = new Meteor.Collection("logs")

@Logs.allow
  insert: (userId, doc) ->
    # the user must be logged in
    userId? and doc.userId is userId
  update: (userId, doc, fields, modifier) ->
    no
  remove: (userId, doc) ->
    no

###
{
  "_id": ObjectId,
  "userId": ObjectId,
  "type": String,
  "message": String,
  "timestamp": Date
}
###
