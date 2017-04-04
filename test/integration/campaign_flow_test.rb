require 'test_helper'

class CampaignFlowTest < ActionDispatch::IntegrationTest
  test "can see the list of campaigns" do
    get admin_organization_url(organizations(:one))
    assert_select "h3", "Campaigns"
  end

  test "can create a campaign" do
    get new_admin_organization_campaign_url(organizations(:one))
    assert_response :success

    post admin_organization_campaigns_url(organizations(:one)),
      params: { campaign: { name: "Test Campaign", deadline: 1.month.from_now, can_edit_wishlists: true, address: "123 Book Dr.", book_limit: 6, campaign_catalog_ids: [1] } }
    assert_response :redirect
    follow_redirect!
    assert_response :success
    assert_select "h3", "Campaign Detail"
  end

  test "can edit a campaign" do
    get admin_organization_campaign_url(organizations(:one), campaigns(:one))
    assert_response :success

    put admin_organization_campaign_url(organizations(:one), campaigns(:one)),
      params: { campaign: { name: "Test Campaign Edit", deadline: 1.month.from_now, can_edit_wishlists: true, address: "123 Book Dr.", book_limit: 6, campaign_catalog_ids: [1] } }
    assert_response :redirect
    follow_redirect!
    assert_response :success
    assert_select "h3", "Organization Detail"
  end

  test "can delete a campaign" do
    delete admin_organization_campaign_url(organizations(:one), campaigns(:two))
    assert_response :redirect
    follow_redirect!
    assert_response :success
    assert_select "h3", "Organization Detail"
  end

  test "can add wishlists when can edit wishlists is true" do
    get admin_organization_campaign_url(organizations(:one), campaigns(:one))
    assert_select "a", {count: 1, text: 'New Wishlist'}
    assert_select "a", {count: 1, text: 'Bulk Edit'}
    assert_select "a", {count: 1, text: 'Bulk Upload'}
    #These require selenium probably since there is some js rendering going on
    #assert_select "[colid=reader_name]", {count: 1, text: 'Reader One'}
    #assert_select "a", {count: 1, text: 'Edit'}
  end

  test "cannot add wishlists when can edit wishlists is nil" do
    get admin_organization_campaign_url(organizations(:one), campaigns(:two))
    assert_select "a", {count: 0, text: 'New Wishlist'}
    assert_select "a", {count: 0, text: 'Bulk Edit'}
    assert_select "a", {count: 0, text: 'Bulk Upload'}
    #These require selenium probably since there is some js rendering going on
    #assert_select "[colid=reader_name]", {count: 1, text: 'Reader Two'}
    #assert_select "a", {count: 0, text: 'Edit'}
  end

  test "cannot add wishlists when can edit wishlists is false" do
    get admin_organization_campaign_url(organizations(:one), campaigns(:three))
    assert_select "a", {count: 0, text: 'New Wishlist'}
    assert_select "a", {count: 0, text: 'Bulk Edit'}
    assert_select "a", {count: 0, text: 'Bulk Upload'}
    #These require selenium probably since there is some js rendering going on
    #assert_select "[colid=reader_name]", {count: 1, text: 'Reader Three'}
    #assert_select "a", {count: 0, text: 'Edit'}
  end

end
