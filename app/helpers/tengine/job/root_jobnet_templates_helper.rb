# -*- coding: utf-8 -*-

module Tengine::Job::RootJobnetTemplatesHelper
  ENABLE_ORDER = ["asc", "desc"].freeze
  ASC_CLASS = "asc"
  DESC_CLASS = "desc"

  def sort_class(sym)
    return ASC_CLASS if (sort = request.query_parameters[:sort]).blank?
    order = if (current_order = sort[sym].to_s).blank?
              ASC_CLASS
            else
              ENABLE_ORDER.include?(current_order) ? current_order : ASC_CLASS
            end
    return order
  end

  def sort_param(sym)
    sort = request.query_parameters[:sort]
    return {"sort" => {sym.to_s=>"desc"}} if sort.blank?
    order = if (current_order = sort[sym.to_s]).blank?
              "desc"
            else
              (current_order == "asc") ? "desc" : "asc"
            end
    return {"sort" => {sym.to_s => order}}
  end
end
