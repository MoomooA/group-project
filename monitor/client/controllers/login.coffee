Template.login.events
  'submit #login-form' : (e, t) ->
    e.preventDefault()
    button = new ProgressButton "button"
    utils.initFormErrors t

    username = t.find('#login-email').value.trim()
    password = t.find('#login-password').value

    Meteor.loginWithPassword(username, password, (err)->
      if err?
        if err.reason is "User not found" or err.reason is "Match failed"
          Meteor.call('checkAstral', username, password, (err, result) ->
            if err?
              button.removeClass("loading")
              button.error()
              console.log('err-on-astral', err)
              utils.showErrorForm t.find('#error-serveur')
            else
              Meteor.setTimeout( () ->
                Meteor.loginWithPassword(username, password, (err)->
                  if err?
                    button.error()
                    console.log(err)
                  else
                    button.success()
                )
              , 500)
          )
        else
          button.error()
          console.log(err)
          if err.reason is "Incorrect password"
            utils.showErrorForm t.find('#password-incorrect')
          else
            utils.showErrorForm t.find('#error-serveur')
      else
        button.success()

    )
    return false
