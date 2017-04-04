require 'test_helper'

class WishlistFlowTest < ActionDispatch::IntegrationTest
  test "can see the list of wishlists as admin" do
    get admin_organization_campaign_url(organizations(:one), campaigns(:one))
    assert_select "h3", "Wishlists"
  end

  test "can see the list of wishlists as volunteer" do
    get partner_organization_campaign_url(organizations(:one), campaigns(:one))
    assert_select "h3", "Wishlists"
  end

  test "can manage a wishlist as admin" do
    get manage_admin_organization_campaign_wishlist_url(organizations(:one), campaigns(:one), wishlists(:one))
    assert_response :success
  end

  test "can manage a wishlist as volunteer" do
    get manage_partner_organization_campaign_wishlist_url(organizations(:one), campaigns(:one), wishlists(:one))
    assert_response :success
  end

  test "cannot see the list of wishlists as an inactive volunteer" do
    get partner_organization_campaign_url(organizations(:two), campaigns(:four))
    assert_equal 'There is an issue with the records you are trying to access. Contact the campaign administrator to make sure you were added to the campaign and marked as active.', flash[:notice]
  end

  test "cannot see the list of wishlists when not a volunteer" do
    get partner_organization_campaign_url(organizations(:three), campaigns(:five))
    assert_equal 'There is an issue with the records you are trying to access. Contact the campaign administrator to make sure you were added to the campaign and marked as active.', flash[:notice]
  end

  test "can create a wishlist as admin" do
    get new_admin_organization_campaign_wishlist_url(organizations(:one), campaigns(:one))
    assert_response :success

    post admin_organization_campaign_wishlists_url(organizations(:one), campaigns(:one)),
      params: { wishlist: { teacher: "Test Wishlist Teacher", reader_name: "Test Reader Create", reader_age: 12, reader_gender: 'M', reader_grade: '5th', external_id: '123SDF' } }
    assert_response :redirect
    follow_redirect!
    assert_response :success
    assert_select "h3", "Campaign Detail"
  end

  test "can create a wishlist as volunteer" do
    get new_partner_organization_campaign_wishlist_url(organizations(:one), campaigns(:one))
    assert_response :success

    post partner_organization_campaign_wishlists_url(organizations(:one), campaigns(:one)),
      params: { wishlist: { teacher: "Test Wishlist Teacher", reader_name: "Test Reader Create", reader_age: 12, reader_gender: 'M', reader_grade: '5th', external_id: '123SDF' } }
    assert_response :redirect
    follow_redirect!
    assert_response :success
    assert_select "h3", "Campaign Detail"
  end

  test "can edit a wishlist as admin" do
    get admin_organization_campaign_wishlist_url(organizations(:one), campaigns(:one), wishlists(:one))
    assert_response :success

    put admin_organization_campaign_wishlist_url(organizations(:one), campaigns(:one), wishlists(:one)),
      params: { wishlist: { teacher: "Test Wishlist Teacher", reader_name: "Test Reader Edit", reader_age: 12, reader_gender: 'M', reader_grade: '5th', external_id: '123SDF' } }
    assert_response :redirect
    follow_redirect!
    assert_response :success
    assert_select "h3", "Campaign Detail"
  end

  test "can edit a wishlist as volunteer" do
    get partner_organization_campaign_wishlist_url(organizations(:one), campaigns(:one), wishlists(:one))
    assert_response :success

    put partner_organization_campaign_wishlist_url(organizations(:one), campaigns(:one), wishlists(:one)),
      params: { wishlist: { teacher: "Test Wishlist Teacher", reader_name: "Test Reader Edit", reader_age: 12, reader_gender: 'M', reader_grade: '5th', external_id: '123SDF' } }
    assert_response :redirect
    follow_redirect!
    assert_response :success
    assert_select "h3", "Campaign Detail"
  end

  test "can delete a wishlist as admin" do
    delete admin_organization_campaign_wishlist_url(organizations(:one), campaigns(:three), wishlists(:three))
    assert_response :redirect
    follow_redirect!
    assert_response :success
    assert_select "h3", "Campaign Detail"
  end

  test "cannot delete a wishlist as volunteer" do
    assert_raise AbstractController::ActionNotFound do
      delete partner_organization_campaign_wishlist_url(organizations(:one), campaigns(:three), wishlists(:three))
    end
  end

end
