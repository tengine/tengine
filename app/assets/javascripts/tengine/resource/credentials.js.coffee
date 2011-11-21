# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
load_form = (type) ->
  if type == "01"
    # for password authentication
    $("#credential_auth2_name").html($("#hidden_password_key").html())
    $("#credential_auth2_value").html($("#hidden_password_value").html())
    $("#credential_auth3_name").html("")
    $("#credential_auth3_value").html("")
  else
    # for public key authentication
    $("#credential_auth2_name").html($("#hidden_key_key").html())
    $("#credential_auth2_value").html($("#hidden_key_value").html())
    $("#credential_auth3_name").html($("#hidden_passphrase_key").html())
    $("#credential_auth3_value").html($("#hidden_passphrase_value").html())

select_changed = () ->
  $("#credential_auth_type_cd option:selected").each ()->load_form(this.value)
    
window.onload = () -> 
  load_form($("#credential_auth_type_cd option:selected").attr("value"))
  $("#credential_auth_type_cd").change select_changed
