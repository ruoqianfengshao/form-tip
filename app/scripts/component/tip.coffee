tipTemplate = Handlebars.templates["tip"]

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
    @otherClass = @options.otherClass
    @otherCss = @options.otherCss
    @getInterval()

  getInterval: ->
    @interval = if @options.interval then @options.interval else 3000
    @noInterval = if @options.interval then false else true

  tip: =>
    $(".tip").remove() unless @noInterval
    $(@parent).addClass("parent-position")
    $(@parent).append(tipTemplate({type: @type, direct: @direct, message: @message, width: @width, left:@left, top: @top, otherClass: @otherClass, otherCss: @otherCss}))

  tipOrAlertRemove = (target)->
    $(target).remove()

  parentPositionRevert = (target)->
    $(target).removeClass("parent-position")

  # API for element tip
  $(document).on "blur", ->


module.exports =  Tip
