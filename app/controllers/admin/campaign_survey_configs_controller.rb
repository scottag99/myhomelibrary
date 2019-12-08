class Admin::CampaignSurveyConfigsController < Admin::BaseController
  before_action :find_campaign
  before_action :load_surveys_and_teachers, only: [:edit, :new, :create, :update]
  def index
    @campaign_survey_configs = @campaign.campaign_survey_configs
    respond_to do |format|
      format.html
      format.json { render json: @campaign_survey_configs }
    end
  end

  def show
    @campaign_survey_config = @campaign.campaign_survey_configs.find(params[:id])
    respond_to do |format|
      format.html
      format.json { render json: @campaign_survey_config }
    end
  end

  def edit
    @campaign_survey_config = @campaign.campaign_survey_configs.find(params[:id])

    respond_to do |format|
      format.html
      format.js
      format.json { render json: @book }
    end
  end

  def update
    @campaign_survey_config = @campaign.campaign_survey_configs.find(params[:id])
    @campaign_survey_config.update!(campaign_survey_config_params)
    respond_to do |format|
      format.html { render "show" }
      format.js   { render "show" }
      format.json { render json: @campaign_survey_config }
    end
  end

  def new
    @campaign_survey_config = @campaign.campaign_survey_configs.new

    respond_to do |format|
      format.html
      format.js
      format.json { render json: @campaign_survey_config }
    end
  end

  def create
    @campaign_survey_config = @campaign.campaign_survey_configs.new(campaign_survey_config_params)
    if @campaign_survey_config.save
      respond_to do |format|
        format.html { render "show" }
        format.js
        format.json { render json: @campaign_survey_config }
      end
    else
      respond_to do |format|
        format.html { render "new" }
        format.js { render "new" }
        format.json { render json: @campaign_survey_config }
      end
    end
  end

  def destroy
    @campaign_survey_config_id = params[:id]
    @campaign.campaign_survey_configs.destroy(params[:id])
    respond_to do |format|
      format.html { render "index" }
      format.js
      format.json { render json: @campaign.campaign_survey_configs.all}
    end
  end
private
  def current_organization
    Organization.find(params[:organization_id])
  end

  def find_campaign
    @campaign = current_organization.campaigns.find(params[:campaign_id])
  end

  def load_surveys_and_teachers
    @surveys = Survey.order(:name).all
    @teachers = @campaign.wishlists.select(:teacher).distinct.order(:teacher)
  end

  def campaign_survey_config_params
    params.require(:campaign_survey_config).permit(:survey_id, :teacher, :is_disabled, :is_control_group)
  end
end
