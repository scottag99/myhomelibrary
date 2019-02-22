module CommonAppreciationNoteActions
  extend ActiveSupport::Concern

  def index
    @appreciation_notes = current_wishlist.appreciation_notes
    respond_to do |format|
      format.html
      format.json { render json: @appreciation_notes }
    end
  end

  def show
    @appreciation_note = current_wishlist.appreciation_notes.find(params[:id])
    respond_to do |format|
      format.html
      format.json { render json: @appreciation_note }
    end
  end

  def create
    @appreciation_note = current_wishlist.appreciation_notes.create!(appreciation_note_params)
    flash[:success] = "Thank you! Your note has been added."
    respond_to do |format|
      format.html { render "show" }
      format.js
      format.json { render json: @appreciation_note }
    end
  end

end
