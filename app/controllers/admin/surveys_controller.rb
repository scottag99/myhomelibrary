class Admin::SurveysController < Admin::BaseController
  def index
    @surveys = Survey.all
    respond_to do |format|
      format.html
      format.json { render json: @surveys }
    end
  end

  def show
    @survey = Survey.find(params[:id])
    respond_to do |format|
      format.html
      format.json { render json: @survey }
    end
  end

  def new
    @survey = Survey.new
    respond_to do |format|
      format.html { render 'common/form', locals: {form_title: 'New Survey', model: 'surveys'} }
      format.json { render json: @survey }
    end
  end

  def edit
    @survey = Survey.find(params[:id])
    respond_to do |format|
      format.html { render 'common/form', locals: {form_title: 'Edit Survey', model: 'surveys'}  }
      format.json { render json: @survey }
    end
  end

  def update
    @survey = Survey.find(params[:id])
    @survey.update!(survey_params)
    flash[:notice] = "Survey updated."
    @surveys = Survey.all
    respond_to do |format|
      format.html { render "index" }
      format.json { render json: @survey }
    end
  end

  def create
    @survey = Survey.create!(survey_params)
    flash[:success] = "Thank you! Your survey has been added."
    respond_to do |format|
      format.html { render "show" }
      format.json { render json: @survey }
    end
  end

  def destroy
    @survey = Survey.find(params[:id])
    @survey.destroy()
    if @survey.errors.any?
      @survey.errors.full_messages.each do |message|
        flash[:warning] = message
      end
    end
    @surveys = Survey.all
    respond_to do |format|
      format.html { render "index" }
      format.json { render json: @surveys}
    end
  end

  def is_disabled
    @survey = Survey.find(params[:id])
    @survey.is_disabled = !@survey.is_disabled
    @survey.save
  end

  def reorder
    @survey = Survey.find(params[:id])
    params[:sorted].each_with_index do |id, idx|
      @survey.survey_questions.find(id.gsub(/\D+/, '').to_i).update(sequence: idx)
    end
    respond_to do |format|
      format.html { render "show" }
      format.js
      format.json { render json: @survey}
    end
  end

private
  def survey_params
    params.require(:survey).permit(:name, :description, :is_disabled)
  end
end
