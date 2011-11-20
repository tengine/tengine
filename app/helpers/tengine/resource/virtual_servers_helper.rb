module Tengine::Resource::VirtualServersHelper
  def name_link_and_desc(physical_server, link=true)
    html = ""
    if link
      url = tengine_resource_physical_server_url(physical_server)
      html << link_to(physical_server.name, url)
    else
      html << physical_server.name
    end
    unless physical_server.description.blank?
      html << "<br />"
      html << "(#{ERB::Util.html_escape(physical_server.description)})"
    end
    return html.html_safe
  end

  def image_name_link_and_desc(virtual_server, link=true)
    html = ""
    if image = virtual_server_image(virtual_server)
      if link
        url = edit_tengine_resource_virtual_server_image_url(image)
        html << link_to(image.provided_id, url)
      else
        html << image.provided_id
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
end
