class ApplicationController < ActionController::Base
  before_action :store_user_location!, if: :storable_location?
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  # После входа возвращаем на последнюю посещённую страницу
  def after_sign_in_path_for(resource)
    stored_location_for(resource) || root_path
  end

  # После выхода возвращаем на ту же страницу
  def after_sign_out_path_for(resource_or_scope)
    request.referer || root_path
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name, :avatar])
    devise_parameter_sanitizer.permit(:account_update, keys: [:name, :avatar])
  end

  private

  # Запоминаем только GET-запросы на обычные страницы (не Devise, не AJAX)
  def storable_location?
    request.get? && is_navigational_format? && !devise_controller? && !request.xhr?
  end

  def store_user_location!
    store_location_for(:user, request.fullpath)
  end

  def require_admin!
    unless current_user&.admin?
      redirect_to root_path, alert: "Доступ только для администратора."
    end
  end
end