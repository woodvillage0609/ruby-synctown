class ApplicationController < ActionController::Base
 
 before_action :configure_permitted_parameters, if: :devise_controller?
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  include ApplicationHelper

  def authenticate_user!
    session[:user_return_to] = env['PATH_INFO']
    redirect_to user_omniauth_authorize_path(:facebook) unless user_signed_in?
  end


private
def configure_permitted_parameters
	devise_parameter_sanitizer.for(:sign_up) << :name
end

end
