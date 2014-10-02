element =
  ###
    方向是向上的时候的 top
    箭头高 6
    再加上 target 和 parent 的上边高度差，target 的下内边距，下边宽，上内边距，上边宽，本身高度
  ###
  topWithUp: (target, parent) ->
    arrowHeight = 6
    height = $(target).height()
    parentTop = $(parent).offset().top
    offsetTop = $(target).offset().top
    paddingTop = parseInt $(target).css("padding-top")[0..-2]
    paddingBottom = parseInt $(target).css("padding-bottom")[0..-2]
    borderTop = parseInt $(target).css("border-top-width")[0..-2]
    borderBottom = parseInt $(target).css("border-bottom-width")[0..-2]
    arrowHeight + height + paddingTop + paddingBottom + offsetTop - parentTop + borderTop + borderBottom

  ###
    方向是向上的时候的 left
    target 和 parent 的左边距差
  ###
  leftWithUp: (target, parent) ->
    parentLeft = $(parent).offset().left
    offsetLeft = $(target).offset().left
    offsetLeft - parentLeft

  ###
    方向是向左的时候的 top
    本身高度的 1/2 加上 target 和 parent 的上边高度差，target 的上内边距，上边宽 减去 tip 一半的高度和边宽
  ###
  topWithLeft: (target, parent) ->
    height = $(target).height()
    parentTop = $(parent).offset().top
    offsetTop = $(target).offset().top
    paddingTop = parseInt $(target).css("padding-top")[0..-2]
    borderTop = parseInt $(target).css("border-top-width")[0..-2]
    height/2 + offsetTop - parentTop + paddingTop + borderTop - 14

  ###
    方向是向左的时候的 left
    箭头宽 6
    再加上 target 和 parent 的左边宽度差，target 的右内边距，右边宽，左内边距，左边宽，本身宽度
    再加上 10 的留白
  ###
  leftWithLeft: (target, parent) ->
    arrowWidth = 6
    width = $(target).width()
    parentLeft = $(parent).offset().left
    offsetLeft = $(target).offset().left
    paddingLeft = parseInt $(target).css("padding-left")[0..-2]
    paddingRight = parseInt $(target).css("padding-right")[0..-2]
    borderLeft = parseInt $(target).css("border-left-width")[0..-2]
    borderRight = parseInt $(target).css("border-right-width")[0..-2]
    10 + arrowWidth + width + offsetLeft - parentLeft + paddingLeft + paddingRight + borderLeft + borderRight

module.exports = element
