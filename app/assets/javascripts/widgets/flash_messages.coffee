FlashMessages =
  _create: ->
    element = @element

    element.find('.close').on "click", (e) =>
      element.hide()

ready = ->
  $.widget("ui.flashMessages", FlashMessages)
  $('.flash_messages').flashMessages()

$(document).on('ready turbolinks:load', ready)
