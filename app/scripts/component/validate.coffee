require "helper/pattern"
validate = require "helper/validate"

module.exports =
  $.fn.validateTip = (options)->
    ###
      usage: $form.validateTip(options)
      options =
        identifie: {String} || [required]   # 需要校验的表单项
        direct: 'up' or 'left'              # tip 的方向， 默认是 left, 可以在 identifie 上指定 data-direct
        interval:  {integer}                # tip 显示的时间，毫秒级，默认是 0 ，可以在 idenifie 上指定 data-interval
        before: {Function}                  # 表单检验之前执行
        after: {Function}                   # 表单校验之后执行，只有返回 True 表单才可能被提交
    ###
    validate.options = options = options || {}
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
          after(@, $items)
