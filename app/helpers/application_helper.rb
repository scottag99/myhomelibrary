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

  def user_is_coordinator?
    if session[:userinfo] && session[:userinfo]['extra'] && session[:userinfo]['extra']['raw_info']
      if session[:userinfo]['extra']['raw_info']['email_verified']
        return Organization.joins(:partners).where('partners.email = ? and partners.active = ? and partners.is_coordinator = ?', session[:userinfo]['info']['email'], true, true).count() > 0
      end
    end
    return false
  end

  def is_coordinator?(organization)
    organization.partners.any?{|p| p.active && p.email == session[:userinfo]['info']['email'] && p.is_coordinator }
  end

  def live_campaigns?
    Campaign.where("deadline > ? and ready_for_donations = ?", 1.day.from_now.at_midnight, true).count > 0
  end

  def get_scrivito_menu_items
    Obj.all.select{|obj|obj.permalink}.select{|obj| obj.show_in_menu == 'true' }.sort_by(&:get_menu_order)
  end
end
