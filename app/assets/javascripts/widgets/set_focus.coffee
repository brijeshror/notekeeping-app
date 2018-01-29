SetFocus =
  _create: ->
    @element.focus()
    element_value = @element.val()
    @element.val('').val(element_value)

ready = ->
  $.widget("ui.setFocus", SetFocus)

$(document).on('ready turbolinks:load', ready)
