def mock_pagination(obj, options = {})
  options = {
    :current_page => 1,
    :num_pages => 1,
    :limit_value => 10,
  }.update(options || {})
  options.each do |key, value|
    obj.should_receive(key).at_least(:once).and_return(value)
  end
  obj
end
