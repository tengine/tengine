def mock_pagination(obj, options = {})
  options = {
    :current_page => 1,
    :num_pages => 1,
    :limit_value => 10,
  }.update(options || {})
  options.each do |key, value|
    obj.should_receive(key).and_return(value)
  end
  obj
end
