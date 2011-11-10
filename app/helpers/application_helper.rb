module ApplicationHelper
  def page_title(class_or_name, page_type = :list)
    model_class_name(class_or_name) + I18n.t(page_type, :scope => [:views, :pages])
  end

  def link_to_show(*args, &block)
    link_to(I18n.t(:show, :scope => [:views, :links]), *args_for_nested_path(*args), &block)
  end

  def link_to_edit(*args, &block)
    link_to(I18n.t(:edit, :scope => [:views, :links]), *args_for_nested_path(*args), &block)
  end

  def link_to_destroy(*args, &block)
    link_to(I18n.t(:destroy, :scope => [:views, :links]), *args_for_nested_path(*args), &block)
  end

  def link_to_new(class_or_name, *args, &block)
    link_to(model_class_name(class_or_name) + I18n.t(:new, :scope => [:views, :links]), *args, &block)
  end

  def link_to_back_list(*args, &block)
    link_to(I18n.t(:back_list, :scope => [:views, :links]), *args, &block)
  end

  def link_to_list(class_or_name, *args, &block)
    link_to(page_title(class_or_name), *args, &block)
  end

  def link_to_model(model, *args, &block)
    return nil if model.nil?
    link_to(model_name(model), url_to_model(model))
  end

  def url_to_model(model, &block)
    case model
    when nil then nil
    when Tengine::Core::Handler then tengine_core_driver_handler_path(model.driver, model)
    else
      method_name = model.class.name.underscore.gsub('/', '_') + '_path'
      send(method_name, model)
    end
  end

  def navi_link_to(class_or_text, href = nil)
    text =
      case class_or_text
      when Class then page_title(class_or_text)
      else class_or_text.to_s
      end
    unless href
      method_name =
        case class_or_text
        when Class then class_or_text.name.underscore.gsub('/', '_').pluralize + '_path'
        else class_or_text.to_s
        end
      href = send(method_name)
    end
    content_tag(:li, link_to(text, href), :class => request.path.include?(href) ? 'Current' : nil)
  end


  private
  def model_class_name(class_or_name)
    class_or_name.respond_to?(:human_name) ? class_or_name.human_name :
      I18n.t("mongoid.models.tengine/event", :default => class_or_name.to_s)
  end

  def model_name(model)
    case model
    when Tengine::Core::Event then "%s@%s[%s]" % [model.event_type_name, model.source_name, model.iso8601]
    when Tengine::Core::Driver then model.name
    when Tengine::Core::Handler then "%s<%s>" % [model.driver.name, model.event_type_names.join(",")]
    when Tengine::Core::Session then "%s:session" % model.driver.name
    when Tengine::Core::HandlerPath then "%s->%s" % [model.event_type_name, model.driver.name]
    end
  end

  def args_for_nested_path(*args)
    case args.first
    when Array then
      if args.first.map(&:class) == [Tengine::Core::Driver, Tengine::Core::Handler]
        return *[tengine_core_driver_handler_path(*args.shift), *args]
      end
    end
    return *args
  end

end
