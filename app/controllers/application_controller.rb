class ApplicationController < ActionController::Base
  include Pundit
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :configure_permitted_parameters, if: :devise_controller?

  layout :layout_by_resource

  def layout_by_resource
    if devise_controller? && resource_name == :user
      "devise"
    else
      "application"
    end
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) << :name
    devise_parameter_sanitizer.for(:account_update) << :name
  end


  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  private

  def check_user
    if !(request.xhr? or request.headers['X-PJAX'])
      redirect_to root_path if !(current_user and current_user.admin?)
    end
  end

  def user_not_authorized
    flash[:alert] = "Access denied."
    redirect_to (request.referrer || root_path)
  end

end
