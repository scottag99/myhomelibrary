class Admin::BaseController < SecuredController
  layout 'admin'
  ALLOWED_ROLES = ['admin']
end
