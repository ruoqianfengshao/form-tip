require "helper/pattern"
validate = require "helper/validate"

module.exports =
  $.fn.validateTip = (options)->
    ###
      usage: $form.validateTip(options)
      options =
        identifie: {String} || [required]   # 需要校验的表单项，选择器
        direct: 'left' or 'up'              # tip 的方向， 默认是 left, 可以在 identifie 上指定 data-direct
        # TODO appear: '{Event} || submit'         # 触发 tip 出现的动作，默认是 submit（表单提交），如果不为 submit， 其他动作校验一律即时生效
        disapper: '{Event} || time'         # 触发 tip 消失的动作，默认是 time（时间触发），可以是其他 event, 如 focusin
        interval:  {Integer} || 0           # tip 显示的时间，毫秒级，默认是 0 (不自动消失)，可以在 idenifie 上指定 data-interval
        scope: 'all' or 'one'               # tip 的 提示方式，所有一起提示还是提示第一个, 默认是提示所有
        icon: true or false                 # tip 的显示是否带icon， 默认 false (不带)
        before: {Function}                  # 表单检验之前执行
        after: {Function}                   # 表单校验之后执行，只有返回 true 表单才可能被提交
    ###
    options = options || {}
    identifie = options.identifie || '[required]'
    options.direct = options.direct || 'left'
    options.disappear = options.disappear || 'time'
    options.scope = options.scope || 'all'
    options.icon = options.icon || false
    options.interval = options.interval || 0
    before = options.before || -> true
    after = options.after || -> true
    errorCallBack = options.errorCallBack || (fields) ->

    @each ->
      $form = $(@)
      $items = validate.fields(identifie, $form)
      validate.novalidate($form)
      $form.on "submit", (evt)->
        evt.preventDefault()
        before(this, $items)
        validate.validateForm($form, $items, options)
        if validate.errorFields.length
          evt.preventDefault()
          evt.stopImmediatePropagation()
        else
          after(this, $items)
