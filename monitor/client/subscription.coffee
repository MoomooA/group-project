Meteor.subscribe("optimizations")

Tracker.autorun () ->
  Meteor.subscribe("iterations", Session.get("optimization"))
