Template.popup_confirm.helpers
  title: () ->
    Session.get('title_popup')
  message: () ->
    Session.get('message_popup')
  cancelText: () ->
    Session.get('cancel_popup')
  okText: () ->
    Session.get('ok_popup')
