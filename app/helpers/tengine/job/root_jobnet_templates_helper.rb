# -*- coding: utf-8 -*-

module Tengine::Job::RootJobnetTemplatesHelper
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
end
