class Admin::ContentsController < Admin::BaseController
  def index
    @contents = Content.all
    respond_to do |format|
      format.html
      format.json { render json: @contents }
    end
  end

  def show
    @content = Content.find(params[:id])
    respond_to do |format|
      format.html
      format.json { render json: @content }
    end
  end

  def new
    @content = Content.new
    respond_to do |format|
      format.html { render 'common/form', locals: {form_title: 'New Content', model: 'contents'} }
      format.json { render json: @content }
    end
  end

  def edit
    @content = Content.find(params[:id])
    respond_to do |format|
      format.html { render 'common/form', locals: {form_title: 'Edit Content', model: 'contents'} }
      format.json { render json: @content }
    end
  end

  def update
    c = Content.find(params[:id])
    c.update!(content_params)
    flash[:notice] = "Content updated."
    @contents = Content.all
    respond_to do |format|
      format.html { render "index" }
      format.json { render json: @content }
    end
  end

  def create
    Content.create!(content_params)
    flash[:notice] = "Content created."
    @contents = Content.all
    respond_to do |format|
      format.html { render "index" }
      format.json { render json: @contents }
    end
  end

  def destroy
    Content.destroy(params[:id])
    flash[:notice] = "Content deleted."
    @contents = Content.all
    respond_to do |format|
      format.html { render "index" }
      format.json { render json: @contents}
    end
  end

private
  def content_params
    params.require(:content).permit(:name, :action_name, :content)
  end
end
