patterns = require "helper/pattern"
Tip = require "component/tip"
element = require "helper/element"
validate =

  errorFields: []

  # 获取待校验的项
  fields: (identifie, form) ->
    $(identifie, form)

  # 获取待校验项的值
  getVal: ($item) ->
    $item.data("value") || $item.val() || (if $item.is('[contenteditable]') then $item.text() else '')

  # 添加 `novalidate` 到 form 中，防止浏览器默认的校验（样式不一致并且太丑）
  novalidate: ($form) ->
    $form.attr('novalidate') || $form.attr('novalidate', 'true')

  validateOne: ($item, options)->
    return "DONT VALIDATE UNEXIST ELEMENT" if !$item

    patterns.$item = $item
    pattern = $item.attr "pattern" if $item.attr "pattern"
    pattern and pattern.replace('\\', '\\\\')
    type = $item.data("type") || $item.attr "type" || 'text'
    type = if patterns[type] then type else 'text'
    val = $.trim @getVal($item)
    parent = if parent then $item.closest(parent) else $item.parent()
    event = $item.data('event')

    if !(/^(?:radio|checkbox)$/.test(type)) and !patterns['text'](val)
      message = 'empty'

    message = if message then message else
      if pattern
        new RegExp(pattern).test(val) || 'unvalid'
      else
        patterns[type](val) || 'unvalid'

    if /^(?:unvalid|empty)$/.test message
      $item.trigger("after:" + event, $item)
      @errorFields.push {$el: $item, parent, type, error: message}

  validateFields: ($fields, parent)->
    # TO DO blur tip

  tipAll: (options)->
    $.each @errorFields, (n, i) =>
      @bindOneTip(options, i)

  tipOne: (options, scope, i) ->
    if @errorFields.length
      i = @errorFields[0]
      targetTop = i.$el.offset().top
      windowScroll = $(window).scrollTop()
      $(window).scrollTop(targetTop - 20) if targetTop < windowScroll
      @bindOneTip(options, i)

  bindOneTip: (options, i) ->
    if i.error is 'unvalid'
      message = i.$el.data("unvalidMessage") || "请正确填写"
    else
      message = i.$el.data("emptyMessage") || "请填写此项"
    parent = i.parent
    icon = options.icon
    direct = i.$el.data("direct") || options.direct
    top = if i.$el.data("top") then i.$el.data("top") else if direct is "left" then element.topWithLeft(i.$el, i.parent) else element.topWithUp(i.$el, i.parent)
    left = if i.$el.data("left") then i.$el.data("left") else  if direct is "left" then element.leftWithLeft(i.$el, i.parent) else element.leftWithUp(i.$el, i.parent)
    interval = i.$el.data("interval") || options.interval
    type = i.$el.data("tipType") || 'error'
    tip = new Tip({parent, direct, type, icon, message, top, left, interval})
    tip.show()
    i.$el.data("tip", tip)
    i.$el.on "#{options.disappear}", tip.remove if options.disappear isnt 'time'

  validateForm: ($form, $fields, options) ->
    @errorFields = []
    @clearError($fields)
    $.each $fields, (i, el) =>
      @validateOne($(el), options)
    if options.scope is "all" then @tipAll(options) else @tipOne(options, "one")
    if @errorFields.length then @errorFields else false

  clearError: ($fields) ->
    $.each $fields, (i, el) ->
      $(el).data("tip").remove() if $(el).data("tip")

module.exports = validate
