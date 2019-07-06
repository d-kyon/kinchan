class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
before_action :configure_permitted_parameters, if: :devise_controller?

protected

  def configure_permitted_parameters
    added_attrs = [ :username, :email, :password, :password_confirmation,:linkToken　]
    devise_parameter_sanitizer.permit :sign_up, keys: added_attrs
    devise_parameter_sanitizer.permit :account_update, keys: added_attrs
    devise_parameter_sanitizer.permit :sign_in, keys: added_attrs
  end
  
  def after_sign_in_path_for(resource)
    if params[:linkToken].present? then
      redirect_lineaccount_path(linkToken:params[:linkToken])
    else
      attendance_index_path(current_user.id)
    end
  end
end
