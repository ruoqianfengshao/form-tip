require "helper/pattern"
validate = require "helper/validate"

module.exports =
  $.fn.validateTip = (options)->
    options = options || {}
    identifie = options.identifie || '[required]'
    before = options.before || -> true
    after = options.after || -> true
    errorCallBack = options.errorCallBack || (fields) ->

    @.each ->
      $form = $(@)
      $items = validate.fields(identifie, $form)
      validate.novalidate($form)
      $form.on "submit", (evt)->
        evt.preventDefault()
        before(@, $items)
        validate.validateForm($form, $items)
        if validate.errorFields.length
          evt.preventDefault()
          evt.stopImmediatePropagation()
        else
          console.log 1
