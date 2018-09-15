class SearchPageController < CmsController
  include CommonSearchActions
  before_action :find_organization
  before_action :find_wishlists
  before_action :find_content

private

  def find_organization
    unless params[:slug].nil?
      @organization = Organization.find_by_slug(params[:slug])
    end

    #if !params[:term].nil? && @organization.nil?
    #  @organization = Organization.find_by_name(params[:term])
    #end
  end

  def find_content
    @content = Content.where(action_name: action_name).all.map{|c| [c.name, c.content]}.to_h
  end
end
