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
end
