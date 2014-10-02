require "helper/pattern"
validate = require "helper/validate"

module.exports =
  $.fn.validateTip = (options)->
    ###
      usage: $form.validateTip(options)
      options =
        identifie: {String} || [required]   # 需要校验的表单项，选择器
        direct: 'left' or 'up'              # tip 的方向， 默认是 left, 可以在 identifie 上指定 data-direct
        interval:  {Integer} || 0           # tip 显示的时间，毫秒级，默认是 0 (不自动消失)，可以在 idenifie 上指定 data-interval
        scope: 'all' or 'one'               # tip 的 提示方式，所有一起提示还是提示第一个, 默认是提示所有
        before: {Function}                  # 表单检验之前执行
        after: {Function}                   # 表单校验之后执行，只有返回 True 表单才可能被提交
    ###
    options = options || {}
    identifie = options.identifie || '[required]'
    options.direct = options.direct || 'left'
    options.interval = options.interval || 0
    options.scope = options.scope || 'all'
    before = options.before || -> true
    after = options.after || -> true
    errorCallBack = options.errorCallBack || (fields) ->
    validate.options = options

    @each ->
      $form = $(@)
      $items = validate.fields(identifie, $form)
      validate.novalidate($form)
      $form.on "submit", (evt)->
        evt.preventDefault()
        before(this, $items)
        validate.validateForm($form, $items)
        if validate.errorFields.length
          evt.preventDefault()
          evt.stopImmediatePropagation()
        else
          after(this, $items)
