Template.login.events
  'submit #login-form' : (e, t) ->
    e.preventDefault()
    button = t.find('.progress-button')
    utils.hideErrorForm t.find('#error-serveur')
    utils.hideErrorForm t.find('#user-not-found')
    utils.hideErrorForm t.find('#password-incorrect')
    classie.addClass(button, 'loading')

    email = t.find('#login-email').value.trim()
    password = t.find('#login-password').value

    Meteor.loginWithPassword(email, password, (err)->
      classie.removeClass(button, 'loading')
      if (err)
        classie.addClass(button, 'error')
        setTimeout(
          () -> classie.removeClass(button, 'error' )
        , 1200 )
        console.log(err)
        if err.reason is "User not found" or err.reason is "Match failed"
          utils.showErrorForm t.find('#user-not-found')
        else if err.reason is "Incorrect password"
          utils.showErrorForm t.find('#password-incorrect')
        else
          utils.showErrorForm t.find('#error-serveur')
      else
        classie.addClass(button, 'success')
        setTimeout(
          () -> classie.removeClass(button, 'success' )
        , 1200 )

    )
    return false
