# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$(window).load ->
  $('input#StopAll').click ->
    stop_all = $(this).attr("checked");
    $('input.StopCheckBox').each ->
      if stop_all
        $(this).attr("checked", true);
      else
        $(this).attr("checked", false);

  $('select#virtual_server_host_server_id').change ->
    val = $(this).children(":selected").attr("value");
    provider_id = physical_server_map_provider[val];
    images = virtual_server_images_by_provider[provider_id];
    type = virtual_server_types_by_provider[provider_id];

    select_image = $('select#virtual_server_provided_image_id');
    select_image.children().remove()
    $(images).each (index, item) ->
      option = $("<option>").attr("value", item[1]).text(item[0]);
      select_image.append(option);

    select_type = $('select#virtual_server_provided_type_id');
    select_type.children().remove()
    $(type).each (index, item) ->
      option = $("<option>").attr("value", item[1]).text(item[0]);
      select_type.append(option);


    types = select_type.children(":selected");
    if types
      type = types.attr("value");
      provider_id = physical_server_map_provider[val];
      capacities = capacities_by_provider[provider_id];
      if capacities
        starting_numbers = capacities[val];
        if starting_numbers
          starting_number = starting_numbers[type];
          starting_number = 0 unless starting_number
          $('input#virtual_server_starting_number').attr("max", starting_number);
          $('span#starting_number_max').text(starting_number);


  $('select#virtual_server_provided_type_id').change ->
    type = $(this).children(":selected").attr("value");
    server = $('select#virtual_server_host_server_id').children(":selected").attr("value");
    provider_id = physical_server_map_provider[server];
    capacities = capacities_by_provider[provider_id];
    if capacities
      starting_numbers = capacities[server];
      if starting_numbers
        starting_number = starting_numbers[type];
        starting_number = 0 unless starting_number
        $('input#virtual_server_starting_number').attr("max", starting_number);
        $('span#starting_number_max').text(starting_number);

