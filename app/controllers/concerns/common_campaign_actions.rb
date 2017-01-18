module CommonCampaignActions
  extend ActiveSupport::Concern

  def index
    @campaigns = @organization.campaigns
    respond_to do |format|
      format.html
      format.json { render json: @campaigns }
    end
  end

  def show
    @campaign = @organization.campaigns.find(params[:id])

    respond_to do |format|
      format.html
      format.json { render json: @campaign }
    end
  end

  def edit
    @campaign = @organization.campaigns.find(params[:id])

    respond_to do |format|
      format.html
      format.json { render json: @campaign }
    end
  end

  def readers
    term = "%#{params[:term]}%".downcase
    @readers = Wishlist.joins([{:campaign => :organization}]).where("(lower(reader_name) like ? or lower(teacher) like ?) and organizations.id = ?", term, term, @organization).distinct.order(:teacher, :reader_name).all
    respond_to do |format|
      format.js { render 'common/campaigns/readers' }
    end
  end
end
