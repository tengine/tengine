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

  ENABLE_ORDER = ["asc", "desc"].freeze
  ASC_CLASS = "asc"
  DESC_CLASS = "desc"
  NO_ORDER_CLASS = ""

  def sort_class(sym)
    return NO_ORDER_CLASS if (sort = request.query_parameters[:sort]).blank?
    return NO_ORDER_CLASS if (current_order = sort[sym].to_s).blank?
    return NO_ORDER_CLASS unless ENABLE_ORDER.include?(current_order)
    return current_order
  end

  def sort_param(sym)
    sym = sym.to_s
    default = {"sort" => {sym => "asc"}}
    sort = request.query_parameters[:sort]
    return default if sort.blank? || (current_order = sort[sym].to_s).blank?
    return default unless ENABLE_ORDER.include?(current_order)
    order = (current_order == "asc") ? "desc" : "asc"
    return {"sort" => {sym => order}}
  end

  def category_tree(root_categories, tree_id, link_params, link_options={})
    return "" if root_categories.blank?

    params = link_params
    all_link = link_to(I18n.t(:all, :scope => [:views, :category_tree]),
                  params, link_options)
    root_categories = [root_categories].flatten

    tree = %|<ul id="#{tree_id}"><li>#{ERB::Util.html_escape(all_link)}<ul>|
    root_categories.each do |root_category|
      stack = []
      category = root_category
      sibling_index = 0
      while !(stack.empty? && category.nil?)
        while !(category.nil?)
          stack << [category, sibling_index]

          last_category = stack.last.first
          link = link_to(last_category.caption,
            params.merge(:category => last_category.id), link_options)
          tree << "<li>#{ERB::Util.html_escape(link)}"

          children = category.children
          tree << "<ul>" if children.count != 0
          category = children.first
        end
        _stack = stack.last
        sibling_index = _stack[1] = _stack[1]+1
        unless category = _stack[0].children[sibling_index]
          parent_category = stack.pop.first
          tree << "</ul>" if parent_category.children.count != 0
          tree << "</li>"
        end
        sibling_index = 0
      end
    end
    tree << "</ul></li></ul>"

    return tree
  end

  private
  def model_class_name(class_or_name)
    class_or_name.respond_to?(:human_name) ? class_or_name.human_name :
      I18n.t("mongoid.models", :default => class_or_name.to_s)
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
