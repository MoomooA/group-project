Accounts.onLogin (info) ->
  Logs.insert
    userId: info.user._id
    type: "connection"
    message: "Connection from #{info.connection.clientAddress}"
    timestamp: new Date()
  info.connection.onClose () ->
    Logs.insert
      userId: info.user._id
      type: "disconnection"
      message: "Disconnection of #{info.connection.clientAddress}"
      timestamp: new Date()

Accounts.onCreateUser (options, user) ->
  Logs.insert
    userId: user._id
    type: "account"
    message: "Creation of the account"
    timestamp: new Date()
  return user
