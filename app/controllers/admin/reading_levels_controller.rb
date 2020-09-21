class Admin::ReadingLevelsController < Admin::BaseController
  def index
    @reading_levels = ReadingLevel.all
    respond_to do |format|
      format.html
      format.json { render json: @reading_levels }
    end
  end

  def show
    @reading_level = ReadingLevel.find(params[:id])
    respond_to do |format|
      format.html
      format.json { render json: @reading_level }
    end
  end

  def new
    @reading_level = ReadingLevel.new
    respond_to do |format|
      format.html { render 'common/form', locals: {form_title: 'New ReadingLevel', model: 'reading_levels'} }
      format.json { render json: @reading_level }
    end
  end

  def edit
    @reading_level = ReadingLevel.find(params[:id])
    respond_to do |format|
      format.html { render 'common/form', locals: {form_title: 'Edit ReadingLevel', model: 'reading_levels'}  }
      format.json { render json: @reading_level }
    end
  end

  def update
    @reading_level = ReadingLevel.find(params[:id])
    @reading_level.update!(reading_level_params)
    flash[:notice] = "ReadingLevel updated."
    @reading_levels = ReadingLevel.all
    respond_to do |format|
      format.html { render "index" }
      format.json { render json: @reading_level }
    end
  end

  def create
    @reading_level = ReadingLevel.create!(reading_level_params)
    flash[:success] = "Thank you! Your reading_level has been added."
    respond_to do |format|
      format.html { render "show" }
      format.json { render json: @reading_level }
    end
  end

  def destroy
    @reading_level = ReadingLevel.find(params[:id])
    @reading_level.destroy()
    if @reading_level.errors.any?
      @reading_level.errors.full_messages.each do |message|
        flash[:warning] = message
      end
    end
    @reading_levels = ReadingLevel.all
    respond_to do |format|
      format.html { render "index" }
      format.json { render json: @reading_levels}
    end
  end

  def is_disabled
    @reading_level = ReadingLevel.find(params[:id])
    @reading_level.is_disabled = !@reading_level.is_disabled
    @reading_level.save
  end

private
  def reading_level_params
    params.require(:reading_level).permit(:name, :is_disabled)
  end
end
