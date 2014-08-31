tipTemplate = Handlebars.templates["common/tip_and_alert/templates/tip"]

class Tip
  constructor: (@options)->
    @el = @options.el
    @parent = @options.parent
    @type = @options.type
    @direct = @options.direct
    @title = @options.title
    @message = @options.message
    @width = @options.width
    @left = @options.left
    @top = @options.top
    @tipInterval = @options.interval or 3000
    @noInterval = @options.noInterval or false
    @otherClass = @options.otherClass
    @otherCss = @options.otherCss

  tip: =>
    $(".tip").remove() unless @noInterval
    $(@parent).addClass("parent-position")
    $(@parent).append(tipTemplate({type: @type, direct:@direct, message:@message, width: @width, left:@left, top: @top, otherClass: @otherClass, otherCss: @otherCss}))
    _.delay tipOrAlertRemove, @tipInterval, ".tip" unless @noInterval
    _.delay parentPositionRevert, @tipInterval, @parent unless @noInterval

  tipOrAlertRemove = (target)->
    $(target).remove()

  parentPositionRevert = (target)->
    $(target).removeClass("parent-position")

module.exports =  Tip
