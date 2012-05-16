class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :set_locale

  private

  def set_locale
    if params[:locale]
      session[:session_locale] = params[:locale]
    end
    I18n.locale = session[:session_locale] || I18n.default_locale
  end

  def successfully_created(model)
    I18n.t(:successfully_created, :scope => [:views, :notice],:model => model.class.human_name)
  end

  def successfully_updated(model)
    I18n.t(:successfully_updated, :scope => [:views, :notice],:model => model.class.human_name)
  end

  def successfully_destroyed(model)
    I18n.t(:successfully_destroyed, :scope => [:views, :notice],:model => model.class.human_name)
  end

  def sort_order(sort_param)
    order = sort_param.map do |k, v|
              k = "_id" if k.to_s == "id"
              v = (v.to_s == "desc") ? :desc : :asc
              [k, v]
            end
    return order
  end
end
