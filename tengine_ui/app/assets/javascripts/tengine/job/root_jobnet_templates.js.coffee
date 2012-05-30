# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
#
#= require jquery.cookie
#= require jquery.treeview

$(window).load ->
  $('ul#category').treeview({
    persist: "cookie",
    cookieId: "tengine_category_tree",
    collapsed: true
  });
