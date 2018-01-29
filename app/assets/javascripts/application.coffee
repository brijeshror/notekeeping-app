#= require jquery
#= require jquery-ui
#= require materialize-sprockets
#= require select2-full
#= require_tree ./widgets

ready = ->
  $('select').material_select();
  $('textarea').trigger('autoresize');
  Materialize.updateTextFields();

$(document).on('ready turbolinks:load', ready)
