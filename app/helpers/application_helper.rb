module ApplicationHelper
  def page_title(class_or_name, page_type)
    model_name(class_or_name) + I18n.t(page_type, :scope => [:views, :pages])
  end

  def link_to_show(*args, &block)
    link_to(I18n.t(:show, :scope => [:views, :links]), *args, &block)
  end

  def link_to_edit(*args, &block)
    link_to(I18n.t(:edit, :scope => [:views, :links]), *args, &block)
  end

  def link_to_destroy(*args, &block)
    link_to(I18n.t(:destroy, :scope => [:views, :links]), *args, &block)
  end

  def link_to_new(class_or_name, *args, &block)
    link_to(model_name(class_or_name) + I18n.t(:new, :scope => [:views, :links]), *args, &block)
  end

  def link_to_back_list(*args, &block)
    link_to(I18n.t(:back_list, :scope => [:views, :links]), *args, &block)
  end

  private
  def model_name(class_or_name)
    class_or_name.respond_to?(:human_name) ?
      class_or_name.human_name : class_or_name
  end

end
