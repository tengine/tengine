module Tengine::Resource::CredentialsHelper
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

end
