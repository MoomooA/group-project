Meteor.methods
  isUserAdmin: (userId) ->
    user = Meteor.users.findOne(userId)
    user.profile.admin

Accounts.config
  forbidClientAccountCreation: true
