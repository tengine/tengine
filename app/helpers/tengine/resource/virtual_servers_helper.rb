module Tengine::Resource::VirtualServersHelper
  def image_name_link_and_desc(virtual_server)
    html = ""
    if image = virtual_server_image(virtual_server)
      url = edit_tengine_resource_virtual_server_image_url(image)
      html << link_to(image.name, url)
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

  private

  def virtual_server_image(virtual_server)
    image = nil
    if provided_image_id = virtual_server.provided_image_id
      image = virtual_server.provider.virtual_server_images.
        where(:provided_id => provided_image_id).first
    end
    return image
  end

  def virtual_server_type(virtual_server)
    type = nil
    if provided_type_id = virtual_server.provided_type_id
      type = virtual_server.provider.virtual_server_types.
        where(:provided_id => provided_type_id).first
    end
    return type
  end
end
