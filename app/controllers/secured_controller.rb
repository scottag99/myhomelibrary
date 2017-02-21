class SecuredController < ApplicationController
  ALLOWED_ROLES = []
  before_action :logged_in_using_omniauth?
  before_action :has_role?

  private

  def logged_in_using_omniauth?
    unless session[:userinfo].present?
      session[:original_url] = request.original_url
      redirect_to '/login'
    end

    if session[:userinfo].present? && session[:userinfo]['extra'] && session[:userinfo]['extra']['raw_info'] && !session[:userinfo]['extra']['raw_info']['email_verified']
      flash[:error] = "You must verify your email before continuing. Check your email for a verification link and then re-login to My Home Library after verification."
      redirect_to '/'
    end
  end

  def has_role?
    role = get_role

    if role.blank? || !self.class::ALLOWED_ROLES.include?(role)
      flash[:error] = "You must have one of the following roles #{self.class::ALLOWED_ROLES} in order to access this section. Your role: #{role}"
      redirect_to "/"
    end
  end

  def get_role
    if session[:userinfo]['extra'] && session[:userinfo]['extra']['raw_info']
      role = session[:userinfo]['extra']['raw_info']['role']
    end

    # if this isn't an admin user, check to see if they are assigned as a partner for an organization
    if role.blank?
      if Organization.joins(:partners).where('partners.email = ? and partners.active = ?', session[:userinfo]['info']['email'], true).count() > 0
        role = 'partner'
      end
    end
    role
  end
end
