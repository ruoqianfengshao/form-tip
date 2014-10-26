tipTemplate = Handlebars.templates["component/templates/tip"]

class Tip
  constructor: (@options)->
    @getInterval()
    @tip = $(tipTemplate @options)

  getInterval: ->
    @options.noInterval = if @options.interval then false else true
    @options.interval = if @options.interval then @options.interval else 3000

  show: ->
    $(@options.parent).addClass "parent-position"
    @tip.appendTo $(@options.parent)
    setTimeout @remove, @options.interval unless @options.noInterval

  # API for element tip
  remove: =>
    $(@options.parent).removeClass "parent-position"
    @tip.remove()

module.exports =  Tip
