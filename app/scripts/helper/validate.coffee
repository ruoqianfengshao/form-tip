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
    $item.val() || (if $item.is('[contenteditable]') then $item.text() else '')

  # 添加 `novalidate` 到 form 中，防止浏览器默认的校验（样式不一致并且太丑）
  novalidate: ($form) ->
    $form.attr('novalidate') || $form.attr('novalidate', 'true')

  validateOne: ($item, parent)->
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


  tipAll: (direct)->
    $.each @errorFields, (n, i) ->
      if i.error is 'unvalid'
        message = i.$el.data("unvalidMessage") || "请正确填写"
      else
        message = i.$el.data("emptyMessage") || "请填写此项"
      parent = i.parent
      direct = if i.$el.data("direct") then i.$el.data("direct") else if direct then direct else "left"
      top = if direct is "left" then element.topWithLeft(i.$el, i.parent) else element.topWithUp(i.$el, i.parent)
      left = if direct is "left" then element.leftWithLeft(i.$el, i.parent) else element.leftWithUp(i.$el, i.parent)
      new Tip({parent, direct, type: "error", message, top, left, interval: 0}).tip()

  validateForm: ($form, $fields, method, parent) ->
    @errorFields = []
    @clearError($form)
    $.each $fields, (i, el)=>
      @validateOne($(el), parent)
    @tipAll()
    if @errorFields.length then @errorFields else false

  clearError: ($form) ->
    $form.find(".tip").remove()


module.exports = validate