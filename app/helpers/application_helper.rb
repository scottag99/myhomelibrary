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
    html = '<p>'
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
      return session[:userinfo]['extra']['raw_info']['role'] == 'admin'
    end
    return false
  end
end
