RemoteLinkHandler =
  _create: ->
    msg = @element.data("confirm") || ''

    @element.on @getAction(), (e) =>
      e.preventDefault();
      return if (msg.length > 0 && !confirm(msg))
      $.ajax @getUrl(),
        method: @getMethod()
        asynchronous: true
        evalScripts: true
        dataType: @getDataType()
        data: @getData()
      .success (data, status) ->
        successCall(e.target, data, status)

    successCall = (element, data, status) ->
      if data.window_redirect
        window.location.href = data.window_redirect;

      # NOTE : Inor materializecss, jQuery .val() does not automatically bind textarea as resized
      # Reference : http://materializecss.com/forms.html
      $('textarea').trigger('autoresize');
      Materialize.updateTextFields();
      $('[autofocus]').setFocus()

      $('a[data-remote]').remoteLinkHandler()
      $('form[data-remote]').remoteLinkHandler()
      $('input[data-remote]').remoteLinkHandler()

    getFinder = (key, value) ->
      finder = value['finder']
      finderValue = value['value']
      result = []

      if finder
        [$(key), finderValue]
      else
        [$("#"+key), value]

    getFinderAndKey= (key, value) ->
      finder = value['finder']
      finderAttr = value['attr']
      finderValue = value['value']
      result = []

      if finder
        [$(key), finderAttr, finderValue]
      else
        [$("#"+key), finderAttr, value]

  getData: ->
    return @element.serialize();

  getUrl: ->
    return @element.attr("href") || @element.attr("action") || @element.data("url")

  getMethod: ->
    formMethod = @element.find('input[name=_method]').val()
    return @element.data('method') || @element.attr('method') || formMethod || 'get'

  getDataType: ->
    return @element.data('data-type') || 'json'

  getAction: ->
    tagname = @element.prop("tagName").toLowerCase()
    action = tagname == 'a' && 'click'
    action = !action && tagname == 'form' && 'submit'
    return action || 'click'

ready = ->
  $.widget("ui.remoteLinkHandler", RemoteLinkHandler)
  $('a[data-remote]').remoteLinkHandler()
  $('form[data-remote]').remoteLinkHandler()
  $('input[data-remote]').remoteLinkHandler()

$(document).on('ready turbolinks:load', ready)
