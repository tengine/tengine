module Tengine::Resource::VirtualServersHelper
  def name_link_and_desc(physical_server, options={})
    unless physical_server.description.blank?
      options[:description] = physical_server.description
    end
    return name_and_desc(physical_server.name, options)
  end

  def image_name_link_and_desc(virtual_server, link=true)
    html = ""
    if image = virtual_server_image(virtual_server)
      if link
        url = edit_tengine_resource_virtual_server_image_url(image)
        html << link_to(image.name, url)
      else
        html << image.name
      end
      unless image.description.blank?
        html << "(#{ERB::Util.html_escape(image.description)})"
      end
    end
    return html.html_safe
  end

  def type_caption(virtual_server)
    html = ""
    if type = virtual_server_type(virtual_server)
      html << ERB::Util.html_escape(type.caption)
    end
    return html
  end

  def format_addresses(virtual_server)
    html = ""
    if addresses = virtual_server.addresses
      _addresses = []
      addresses.each do |k ,v|
        if %w(private_ip_address ip_address).include?(k.to_s)
           _addresses << ERB::Util.html_escape(addresses[k])
        end
      end
      html << _addresses.join("<br />")
    end
    return html.html_safe
  end

  private

  def virtual_server_image(virtual_server)
    image = nil
    if provided_image_id = virtual_server.provided_image_id
      if provider = virtual_server.provider
        image = provider.virtual_server_images.
          where(:provided_id => provided_image_id).first
      end
    end
    return image
  end

  def virtual_server_type(virtual_server)
    type = nil
    if provided_type_id = virtual_server.provided_type_id
      if provider = virtual_server.provider
        type = provider.virtual_server_types.
          where(:provided_id => provided_type_id).first
      end
    end
    return type
  end

  def name_and_desc(name, options={})
    options = options.stringify_keys
    html = options["url"] ? link_to(name, options["url"]) : ERB::Util.html_escape(name)

    d = options["description"]
    unless d.blank?
      if delimiter = options["delimiter"]
        html += delimiter.html_safe
      end
      html += ERB::Util.html_escape("(#{d})")
    end
    return html
  end
end
