require "helper/pattern"
require "helper/validate"
require "component/validate"

module.exports = ->
  $("#form0").validateTip()
  $("#form0").on "submit", (evt)->
    evt.preventDefault()
    alert "form0"
  $("#form1").validateTip()
  $("#form1").on "submit", (evt)->
    evt.preventDefault()
    alert "form1"
  $("#form2").validateTip
    direct: "left"
    scope: 'one'
  $("#form2").on "submit", (evt)->
    evt.preventDefault()
    alert "form2"
  $("#form3").validateTip()
  $("#form3").on "submit", (evt)->
    evt.preventDefault()
    alert "form3"
  $("#form4").validateTip()
  $("#form4").on "submit", (evt)->
    evt.preventDefault()
    alert "form4"
  $("#form5").validateTip
    direct: 'up'
    scope: 'one'
  $("#form5").on "submit", (evt)->
    evt.preventDefault()
    alert "form5"
