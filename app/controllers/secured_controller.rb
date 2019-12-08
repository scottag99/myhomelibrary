class SecuredController < ApplicationController
  ALLOWED_ROLES = []
  before_action :login_for_test
  before_action :logged_in_using_omniauth?
  before_action :has_role?

  private

  def login_for_test
    if Rails.env.test?
      session[:userinfo] = {'uid' => 'test_user', 'info' => {'image' => 'AVI URL', 'name' => 'TEST ADMIN USER', 'email' => 'test@example.com'}, 'extra' => {'raw_info' => {'email_verified' => true, 'role' => 'admin'}}}
    end
  end

  def logged_in_using_omniauth?
    unless session[:userinfo].present?
      session[:original_url] = request.original_url
      redirect_to login_path
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
      redirect_to logout_path
    end
  end

  def get_role
    if session[:userinfo]['extra'] && session[:userinfo]['extra']['raw_info']
      role = session[:userinfo]['extra']['raw_info']['role']
    end

    # if this isn't an admin user, check to see if they are assigned as a partner for an organization
    if role.blank?
      partners = Organization.joins(:partners).where('partners.email = ? and partners.active = ?', session[:userinfo]['info']['email'], true).all
      if partners.count() > 0
        role = partners.exists{|p| p.is_coordinator} ? 'coordinator' : 'partner'
      end
    end
    role
  end
end
