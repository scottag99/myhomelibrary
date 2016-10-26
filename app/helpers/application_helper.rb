module ApplicationHelper
  def admin?
    controller.class.parent == Admin
  end

  def partner?
    controller.class.parent == Partner
  end
end
