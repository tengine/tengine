# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
load_form = (id) ->
  $("#form_container").html($("#"+id).html())

select_changed = () ->
  $("#credential_auth_type_cd option:selected").each ()->load_form(this.value)
    
window.onload = () -> 
  load_form($("#credential_auth_type_cd option:selected").attr("value"))
  $("#credential_auth_type_cd").change select_changed
