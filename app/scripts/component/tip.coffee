tipTemplate = Handlebars.templates["component/templates/tip"]

class Tip
  constructor: (@options)->
    @getInterval()
    @tip = $(tipTemplate @options)

  getInterval: ->
    @options.noInterval = if @options.interval then false else true
    @options.interval = if @options.interval then @options.interval else 3000

  show: ->
    $(@options.parent).addClass("parent-position")
    @tip.appendTo($(@options.parent))
    setTimeout @remove, @options.interval, @tip unless @options.noInterval
    setTimeout @parentPositionRevert, @options.interval, @options.parent unless @options.noInterval

  remove: (target) ->
    $(target).remove()

  parentPositionRevert: (target) ->
    $(target).removeClass("parent-position")

  # API for element tip
  $(document).on "blur", ->


module.exports =  Tip
