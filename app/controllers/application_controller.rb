class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :set_locale

  def set_locale
    if params[:locale]
      session[:session_locale] = params[:locale]
    end
    I18n.locale = session[:session_locale] || I18n.default_locale
  end

end
