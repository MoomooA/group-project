Meteor.subscribe("optimizations")
Meteor.subscribe("logs")

Tracker.autorun () ->
  Meteor.subscribe("iterations", Session.get("optimization"))
