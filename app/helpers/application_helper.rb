module ApplicationHelper
  def page_title(class_or_name, page_type)
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
    str = model_class_name(class_or_name) + I18n.t(:list, :scope => [:views, :pages])
    link_to(str, *args, &block)
  end

  def link_to_model(model, *args, &block)
    s = model_name(model)
    case model
    when Tengine::Core::Event then link_to(s, tengine_core_event_path(model))
    when Tengine::Core::Driver then link_to(s, tengine_core_driver_path(model))
    when Tengine::Core::Handler then link_to(s, tengine_core_driver_handler_path(model.driver, model))
    when Tengine::Core::Session then link_to(s, tengine_core_session_path(model))
    when Tengine::Core::HandlerPath then link_to(s, tengine_core_handler_path(model))
    end
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
