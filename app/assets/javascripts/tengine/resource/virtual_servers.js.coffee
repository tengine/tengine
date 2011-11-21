# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

recalc_starting_number = (ps_provided_id, type_provided_id) ->
  provider_id = physical_server_map_provider[ps_provided_id];
  capacities = capacities_by_provider[provider_id];
  if capacities
    starting_numbers = capacities[ps_provided_id];
    if starting_numbers
      starting_number = starting_numbers[type_provided_id];
      starting_number = 0 unless starting_number
      $('input#virtual_server_starting_number').attr("max", starting_number);
      $('span#starting_number_max').text(starting_number);
      $('input#starting_number_max').attr("value", starting_number);

$(window).load ->
  # index
  $('input#StopAll').click ->
    stop_all = $(this).attr("checked");
    submit = $('input#SubmitStopAll');
    if stop_all
      submit.attr("disabled", false);
    else
      submit.attr("disabled", true);

    $('input.StopCheckBox').each ->
      if stop_all
        $(this).attr("checked", true);
      else
        $(this).attr("checked", false);


  $('input.StopCheckBox').change ->
    submit = $('input#SubmitStopAll');
    if $(this).attr("checked")
      submit.attr("disabled", false);
    else
      checked = false;
      $('input.StopCheckBox').each ->
        if $(this).attr("checked")
          checked = true;
          return false;

      if submit.attr("disabled")
        if checked
          submit.attr("disabled", false);
      else
        unless checked
          submit.attr("disabled", true);


  # new
  $('select#virtual_server_host_server_id').change ->
    val = $(this).children(":selected").attr("value");
    provider_id = physical_server_map_provider[val];
    images = virtual_server_images_by_provider[provider_id];
    types = virtual_server_types_by_provider[provider_id];
    select_type = $('select#virtual_server_provided_type_id');
    replace_data = [
      [$('select#virtual_server_provided_image_id'), images],
      [select_type, types]
    ];

    # replace select options
    $(replace_data).each (i, data) ->
      e = data[0];
      e.children().remove();
      $(data[1]).each (j, item) ->
        option = $("<option>").attr("value", item[1]).text(item[0]);
        e.append(option);

    # recalc starting number
    selected = select_type.children(":selected");
    if selected
      type_provided_id = selected.attr("value");
      recalc_starting_number(val, type_provided_id);


  $('select#virtual_server_provided_type_id').change ->
    type = $(this).children(":selected").attr("value");
    server = $('select#virtual_server_host_server_id').children(":selected").attr("value");
    recalc_starting_number(server, type);
