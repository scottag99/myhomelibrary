class Partner::BaseController < SecuredController
  layout 'admin'
  ALLOWED_ROLES = ['admin', 'partner']
end
