class Admin::LanguagesController < Admin::BaseController
  def index
    @languages = Language.all
    respond_to do |format|
      format.html
      format.json { render json: @languages }
    end
  end

  def show
    @language = Language.find(params[:id])
    respond_to do |format|
      format.html
      format.json { render json: @language }
    end
  end

  def new
    @language = Language.new
    respond_to do |format|
      format.html { render 'common/form', locals: {form_title: 'New Language', model: 'languages'} }
      format.json { render json: @language }
    end
  end

  def edit
    @language = Language.find(params[:id])
    respond_to do |format|
      format.html { render 'common/form', locals: {form_title: 'Edit Language', model: 'languages'}  }
      format.json { render json: @language }
    end
  end

  def update
    @language = Language.find(params[:id])
    @language.update!(language_params)
    flash[:notice] = "Language updated."
    @languages = Language.all
    respond_to do |format|
      format.html { render "index" }
      format.json { render json: @language }
    end
  end

  def create
    @language = Language.create!(language_params)
    flash[:success] = "Thank you! Your language has been added."
    respond_to do |format|
      format.html { render "show" }
      format.json { render json: @language }
    end
  end

  def destroy
    @language = Language.find(params[:id])
    @language.destroy()
    if @language.errors.any?
      @language.errors.full_messages.each do |message|
        flash[:warning] = message
      end
    end
    @languages = Language.all
    respond_to do |format|
      format.html { render "index" }
      format.json { render json: @languages}
    end
  end

  def is_disabled
    @language = Language.find(params[:id])
    @language.is_disabled = !@language.is_disabled
    @language.save
  end

private
  def language_params
    params.require(:language).permit(:name, :is_disabled)
  end
end
