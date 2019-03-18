class Admin::AppreciationNotesController < Admin::BaseController
  include CommonAppreciationNoteActions

  private
    def current_organization
      Organization.find(params[:organization_id])
    end

  end
