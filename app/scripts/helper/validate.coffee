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
    if !$item then "DONT VALIDATE UNEXIST ELEMENT"

    patterns.$item = $item
    pattern = $item.attr "pattern" if $item.attr "pattern"
    pattern and pattern.replace('\\', '\\\\')
    type = $item.data("type") || 'text'
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
      @showTip(options, i)

  tipOne: (options, scope, i) ->
    i = @errorFields[0] if @errorFields.length isnt 0
    targetTop = i.$el.offset().top
    windowScroll = $(window).scrollTop()
    $(window).scrollTop(targetTop - 20) if targetTop < windowScroll
    @showTip(options, i)

  showTip: (options, i) ->
    if i.error is 'unvalid'
      message = i.$el.data("unvalidMessage") || "请正确填写"
    else
      message = i.$el.data("emptyMessage") || "请填写此项"
    parent = i.parent
    icon = options.icon
    direct = i.$el.data("direct") || options.direct
    top = if direct is "left" then element.topWithLeft(i.$el, i.parent) else element.topWithUp(i.$el, i.parent)
    left = if direct is "left" then element.leftWithLeft(i.$el, i.parent) else element.leftWithUp(i.$el, i.parent)
    interval = i.$el.data("interval") || options.interval
    type = i.$el.data("tipType") || 'error'
    new Tip({parent, direct, type, icon, message, top, left, interval}).show()

  validateForm: ($form, $fields, options) ->
    @errorFields = []
    @clearError($form)
    $.each $fields, (i, el) =>
      @validateOne($(el), options)
    if options.scope is "all" then @tipAll(options) else @tipOne(options, "one")
    if @errorFields.length then @errorFields else false

  clearError: ($form) ->
    $form.find(".tip").remove()

module.exports = validate
