class SecuredController < ApplicationController
  ALLOWED_ROLES = []
  #before_action :logged_in_using_omniauth?
  #before_action :has_role?

  private

  def logged_in_using_omniauth?
    unless session[:userinfo].present?
      redirect_to '/login'
    end
  end

  def has_role?
    if session[:userinfo]['extra'] && session[:userinfo]['extra']['raw_info']
      role = session[:userinfo]['extra']['raw_info']['role']
    end
    if role.nil? || !self.class::ALLOWED_ROLES.include?(role)
      flash[:error] = "You must have one of the following roles #{self.class::ALLOWED_ROLES} in order to access this section. Your role: #{role}"
      redirect_to "/"
    end
  end
end
