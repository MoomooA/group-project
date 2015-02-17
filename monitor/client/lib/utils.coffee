@utils = {}

@utils.showErrorForm = (el) ->
  el.style.height = "20px"
  el.style.visibility = "visible"
  el.style.opacity = "1"
  el.style.padding = "5px"
@utils.hideErrorForm = (el) ->
  el.style.height = "0"
  el.style.visibility = "hidden"
  el.style.opacity = "0"
  el.style.padding = "0"

@utils.confirm = (message, title, cancelText, okText, callback) ->
  Session.set('message_popup', message)
  Session.set('title_popup', title)
  Session.set('cancel_popup', cancelText)
  Session.set('ok_popup', okText)

  popup = document.getElementById('popup')
  ok = document.getElementById('popup_ok')
  cancel = document.getElementById('popup_cancel')

  _hide = (skipAnimation) ->
    ok.removeEventListener('click', okListener)
    cancel.removeEventListener('click', cancelListener)
    if skipAnimation
      classie.addClass(popup, 'hide')
    else
      classie.addClass(popup, 'leave-down')
      setTimeout(
        () ->
          classie.addClass(popup, 'hide')
          classie.remove(popup, 'leave-down')
      , 500 )

  okListener = () ->
    _hide()
    if callback? then callback(true)
  cancelListener = () ->
    _hide()
    if callback? then callback(false)

  _hide(true)

  classie.addClass(popup, 'go-up')
  classie.remove(popup, 'hide')

  ok.addEventListener('click', okListener)
  cancel.addEventListener('click', cancelListener)
