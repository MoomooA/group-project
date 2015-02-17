Meteor.startup ->
  if Meteor.users.find().count() is 0
    Accounts.createUser
      email : 'test@test.test'
      password: '1234'

