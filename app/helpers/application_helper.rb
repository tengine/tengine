# -*- coding: utf-8 -*-
module ApplicationHelper
  def page_title(class_or_name, page_type = :list)
    # app/views/layouts/application.html.erbの<title>...</title>に使用するためにインスタンス変数で覚えておきます
    @page_title = model_class_name(class_or_name) + I18n.t(page_type, :scope => [:views, :pages])
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

  def model_error_messages(obj)
    return unless obj.errors.any?
    content_tag(:div,
      content_tag(:p,
        I18n.t('activerecord.errors.template.header', :count => obj.errors.size, :model => obj.class.human_name)) +
      content_tag(:ul,
        obj.errors.full_messages.map{|msg| content_tag(:li, msg)}.join.html_safe),
      :class => "Msg MsgError")
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

  def reset_tag(value="Reset", options={})
    options = options.stringify_keys
    options.delete_if{|k, v| %w(type value).include?(k) }
    tag :input, {"type" => :reset, "name" => "reset", "value" => value}.update(options)
  end

  def format_map_yml_value(hash)
    html = ""
    return html if hash.blank?
    html << hash.collect{|k, v| ERB::Util.html_escape("#{k}: #{v}") }.join("<br />")
    return html.html_safe
  end

  def message(type, text, &block)
    klass = case type.to_s
            when "warning"  then "MsgWarning"
            when "complete" then "MsgComplete"
            when "delete"   then "MsgCompleteDelete"
            end

    html = %|<div class="Msg #{klass}">|
    html << "<p>#{text}</p>"
    html << capture(&block) if block_given?
    html << "</div>"
    return html.html_safe
  end

  private
  def model_class_name(class_or_name)
    return nil unless class_or_name
    return class_or_name.human_name if class_or_name.respond_to?(:human_name)
    class_name = class_or_name.is_a?(Class) ? class_or_name.name : class_or_name.to_s
    class_name_hash = I18n.t("mongoid.models") || {}
    class_name_hash[class_name.underscore.to_sym] || class_name
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
