module Tengine::Resource::PhysicalServersHelper

  def button_to_by_get(name, options = {}, html_options = {}, parameter = {})
    html_options.merge!({:method => :get})

    result = button_to(name, options, html_options)
    return result if parameter.empty?

    parameter_tag = ''
    parameter.each_pair do |key, value|
      parameter_tag += tag('input',
        :type => 'hidden', :name => key.to_s, :value => value.to_s)
    end
    result.sub(/(><div>)/, '\1' + parameter_tag)
  end


end
