class Admin::SurveyQuestionsController < Admin::BaseController
  before_action :find_survey
  before_action :load_question_types, only: [:edit, :new, :create, :update]
  def index
    @survey_questions = @survey.survey_questions
    respond_to do |format|
      format.html
      format.json { render json: @survey_questions }
    end
  end

  def show
    @survey_question = @survey.survey_questions.find(params[:id])
    respond_to do |format|
      format.html
      format.json { render json: @survey_question }
    end
  end

  def edit
    @survey_question = @survey.survey_questions.find(params[:id])

    respond_to do |format|
      format.html
      format.js
      format.json { render json: @book }
    end
  end

  def update
    @survey_question = @survey.survey_questions.find(params[:id])
    @survey_question.update!(survey_question_params)
    respond_to do |format|
      format.html { render "show" }
      format.js   { render "show" }
      format.json { render json: @survey_question }
    end
  end

  def new
    @survey_question = @survey.survey_questions.new

    respond_to do |format|
      format.html
      format.js
      format.json { render json: @survey_question }
    end
  end

  def create
    @survey_question = @survey.survey_questions.new({sequence: @survey.survey_questions.count+1}.merge(survey_question_params))
    if @survey_question.save
      respond_to do |format|
        format.html { render "show" }
        format.js
        format.json { render json: @survey_question }
      end
    else
      respond_to do |format|
        format.html { render "new" }
        format.js { render "new" }
        format.json { render json: @survey_question }
      end
    end
  end

  def destroy
    @survey_question_id = params[:id]
    @survey.survey_questions.destroy(params[:id])
    respond_to do |format|
      format.html { render "index" }
      format.js
      format.json { render json: @survey.survey_questions.all}
    end
  end

private
  def find_survey
    @survey = Survey.find(params[:survey_id])
  end

  def load_question_types
    @question_types = QuestionType.order(:name).all
  end

  def survey_question_params
    params.require(:survey_question).permit(:question, :description, :question_type_id, :answer_options, :sequence)
  end
end
