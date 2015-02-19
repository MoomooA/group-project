Template.login.events
  'submit #login-form' : (e, t) ->
    e.preventDefault()
    button = utils.initButton t, "button"

    username = t.find('#login-email').value.trim()
    password = t.find('#login-password').value

    Meteor.loginWithPassword(username, password, (err)->
      if err?
        if err.reason is "User not found" or err.reason is "Match failed"
          Meteor.call('checkAstral', username, password, (err, result) ->
            if err?
              console.log('err-on-astral', err)
              utils.showErrorForm t.find('#error-serveur')
            else
              Meteor.setTimeout( () ->
                Meteor.loginWithPassword(username, password, (err)->
                  button.removeClass("loading")
                  if err?
                    button.addClass("error")
                    Meteor.setTimeout(
                      () -> button.removeClass("error")
                    , 1200 )
                    console.log(err)
                  else
                    button.addClass("success")
                    Meteor.setTimeout(
                      () -> button.removeClass("success")
                    , 1200 )
                )
              , 500)
          )
        else
          button.removeClass("loading")
          button.addClass("error")
          Meteor.setTimeout(
            () -> button.removeClass("error")
          , 1200 )
          console.log(err)
          if err.reason is "Incorrect password"
            utils.showErrorForm t.find('#password-incorrect')
          else
            utils.showErrorForm t.find('#error-serveur')
      else
        button.removeClass('loading')
        button.addClass("success")
        Meteor.setTimeout(
          () -> button.removeClass("success")
        , 1200 )

    )
    return false
