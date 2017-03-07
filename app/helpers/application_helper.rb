module ApplicationHelper
  def admin?
    controller.class.parent == Admin
  end

  def partner?
    controller.class.parent == Partner
  end

  def get_namespace
    controller.class.parent.name.downcase
  end

  def breadcrumb(items)
    html = '<p id="breadcrumb">'
    items.each do |item|
      if item.is_a?(Hash)
        html += link_to( item[:label], item[:href])
      else
        html += item
      end
      html += " &raquo "
    end
    html.html_safe
  end

  def user_is_admin?
    if session[:userinfo] && session[:userinfo]['extra'] && session[:userinfo]['extra']['raw_info']
      return session[:userinfo]['extra']['raw_info']['role'] == 'admin' && session[:userinfo]['extra']['raw_info']['email_verified']
    end
    return false
  end

  def live_campaigns?
    Campaign.where("deadline > ? and ready_for_donations = ?", 1.day.from_now.at_midnight, true).count > 0
  end
end
