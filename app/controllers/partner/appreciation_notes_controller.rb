class Partner::AppreciationNotesController < Partner::BaseController
  include CommonAppreciationNoteActions
  before_action :find_organization
end
