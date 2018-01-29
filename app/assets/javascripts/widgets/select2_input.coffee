Select2Input =
  _create: ->
    @element.select2
      tags: @element.hasClass('tags')
      placeholder: @element.data('placeholder')

ready = ->
  $.widget("ui.select2Input", Select2Input)
  $(".select2-input").select2Input()

$(document).on('ready turbolinks:load', ready)
