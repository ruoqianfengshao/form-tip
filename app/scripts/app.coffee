require "helper/pattern"
require "helper/validate"
require "component/validate"

module.exports = ->
  console.info "log from app!"
  $(".form").validateTip()
  $(".form").on "submit", (evt)->
    evt.preventDefault()
    console.log "success!"
